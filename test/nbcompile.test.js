/* eslint-env jest */
import { exec } from 'child_process'

test(`Should exit if the current directory isn't a NetBeans project`, done => {
  exec('./bin/nbcompile.sh', (err, stdout) => {
    expect(err.code).toBe(1)
    expect(stdout).toMatchSnapshot()
    done()
  })
})

test(`Should compile java code and place it in the build folder`, done => {
  process.chdir('./test/project')
  exec('../../bin/nbcompile.sh', (err, stdout) => {
    expect(err).toBe(null)
    expect(stdout).toMatchSnapshot()
    done()
  })
})
