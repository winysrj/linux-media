Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40960 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbZBWLlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 06:41:35 -0500
Date: Mon, 23 Feb 2009 08:41:08 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: mercurial problems?
Message-ID: <20090223084108.1ce47193@pedra.chehab.org>
In-Reply-To: <200902221158.13783.hverkuil@xs4all.nl>
References: <200902221158.13783.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 22 Feb 2009 11:58:13 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi,
> 
> When I try to push changes to my tree I get these errors:
> 
> pushing to ssh://hverkuil@linuxtv.org/hg/~hverkuil/v4l-dvb-ng-ctrls
> searching for changes
> remote: ** unknown exception encountered, details follow
> remote: ** report bug details to http://www.selenic.com/mercurial/bts
> remote: ** or mercurial@selenic.com
> remote: ** Mercurial Distributed SCM (version 0.9.3)
> remote: Traceback (most recent call last):
> remote:   File "/usr/bin/hg.real", line 12, in ?
> remote:     commands.run()
> remote:   File "/usr/lib/python2.4/site-packages/mercurial/commands.py", 
> line 3000, in run
> remote:     sys.exit(dispatch(sys.argv[1:]))
> remote:   File "/usr/lib/python2.4/site-packages/mercurial/commands.py", 
> line 3223, in dispatch
> remote:     return d()
> remote:   File "/usr/lib/python2.4/site-packages/mercurial/commands.py", 
> line 3182, in <lambda>
> remote:     d = lambda: func(u, repo, *args, **cmdoptions)
> remote:   File "/usr/lib/python2.4/site-packages/mercurial/commands.py", 
> line 2291, in serve
> remote:     s.serve_forever()
> remote:   File "/usr/lib/python2.4/site-packages/mercurial/sshserver.py", 
> line 40, in serve_forever
> remote:     while self.serve_one(): pass
> remote:   File "/usr/lib/python2.4/site-packages/mercurial/sshserver.py", 
> line 47, in serve_one
> remote:     if impl: impl()
> remote:   File "/usr/lib/python2.4/site-packages/mercurial/sshserver.py", 
> line 201, in do_unbundle
> remote:     fp.close()
> remote: UnboundLocalError: local variable 'fp' referenced before assignment
> abort: unexpected response: empty string
> 
> And running hg-menu will result in this:
> 
> hg-menu
> /usr/local/bin/hg-menu: line 185: /tmp/dialog21904: Read-only file system
> Connection to linuxtv.org closed.

hg-menu is working here. Could you please check again?

Cheers,
Mauro
