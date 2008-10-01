Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from h69-129-7-18.nwblwi.dedicated.static.tds.net ([69.129.7.18]
	helo=www.curtronics.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Curt.Blank@curtronics.com>) id 1Kl3ZX-0000kM-9K
	for linux-dvb@linuxtv.org; Wed, 01 Oct 2008 17:25:04 +0200
Received: from [192.168.10.120] (winprtsrv.curtronics.com [192.168.10.120])
	by www.curtronics.com (8.14.1/8.14.1/SuSE Linux 0.8) with ESMTP id
	m91FOrAQ010047
	for <linux-dvb@linuxtv.org>; Wed, 1 Oct 2008 10:24:55 -0500
Message-ID: <48E39647.5000005@curtronics.com>
Date: Wed, 01 Oct 2008 10:24:55 -0500
From: Curt Blank <Curt.Blank@curtronics.com>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] hg clone http://linuxtv.org/hg/v4l-dvb problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Trying to get the latest code and I'm getting this:

# hg clone http://linuxtv.org/hg/v4l-dvb
destination directory: v4l-dvb
requesting all changes
adding changesets
transaction abort!
rollback completed
** unknown exception encountered, details follow
** report bug details to http://www.selenic.com/mercurial/bts
** or mercurial@selenic.com
** Mercurial Distributed SCM (version 1.0)
Traceback (most recent call last):
  File "/usr/bin/hg", line 20, in <module>
    mercurial.dispatch.run()
  File "/usr/lib64/python2.5/site-packages/mercurial/dispatch.py", line 20, in run
    sys.exit(dispatch(sys.argv[1:]))
  File "/usr/lib64/python2.5/site-packages/mercurial/dispatch.py", line 29, in dispatch
    return _runcatch(u, args)
  File "/usr/lib64/python2.5/site-packages/mercurial/dispatch.py", line 45, in _runcatch
    return _dispatch(ui, args)
  File "/usr/lib64/python2.5/site-packages/mercurial/dispatch.py", line 364, in _dispatch
    ret = _runcommand(ui, options, cmd, d)
  File "/usr/lib64/python2.5/site-packages/mercurial/dispatch.py", line 417, in _runcommand
    return checkargs()
  File "/usr/lib64/python2.5/site-packages/mercurial/dispatch.py", line 373, in checkargs
    return cmdfunc()
  File "/usr/lib64/python2.5/site-packages/mercurial/dispatch.py", line 358, in <lambda>
    d = lambda: func(ui, *args, **cmdoptions)
  File "/usr/lib64/python2.5/site-packages/mercurial/commands.py", line 532, in clone
    update=not opts['noupdate'])
  File "/usr/lib64/python2.5/site-packages/mercurial/hg.py", line 230, in clone
    dest_repo.clone(src_repo, heads=revs, stream=stream)
  File "/usr/lib64/python2.5/site-packages/mercurial/localrepo.py", line 2124, in clone
    return self.pull(remote, heads)
  File "/usr/lib64/python2.5/site-packages/mercurial/localrepo.py", line 1484, in pull
    return self.addchangegroup(cg, 'pull', remote.url())
  File "/usr/lib64/python2.5/site-packages/mercurial/localrepo.py", line 1992, in addchangegroup
    if cl.addgroup(chunkiter, csmap, trp, 1) is None and not emptyok:
  File "/usr/lib64/python2.5/site-packages/mercurial/revlog.py", line 1199, in addgroup
    textlen = mdiff.patchedsize(textlen, delta)
mpatch.mpatchError: patch cannot be decoded



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
