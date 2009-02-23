Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4049 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZBWLsJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 06:48:09 -0500
Message-ID: <7387.62.70.2.252.1235389642.squirrel@webmail.xs4all.nl>
Date: Mon, 23 Feb 2009 12:47:22 +0100 (CET)
Subject: Re: mercurial problems?
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Sun, 22 Feb 2009 11:58:13 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> Hi,
>>
>> When I try to push changes to my tree I get these errors:
>>
>> pushing to ssh://hverkuil@linuxtv.org/hg/~hverkuil/v4l-dvb-ng-ctrls
>> searching for changes
>> remote: ** unknown exception encountered, details follow
>> remote: ** report bug details to http://www.selenic.com/mercurial/bts
>> remote: ** or mercurial@selenic.com
>> remote: ** Mercurial Distributed SCM (version 0.9.3)
>> remote: Traceback (most recent call last):
>> remote:   File "/usr/bin/hg.real", line 12, in ?
>> remote:     commands.run()
>> remote:   File "/usr/lib/python2.4/site-packages/mercurial/commands.py",
>> line 3000, in run
>> remote:     sys.exit(dispatch(sys.argv[1:]))
>> remote:   File "/usr/lib/python2.4/site-packages/mercurial/commands.py",
>> line 3223, in dispatch
>> remote:     return d()
>> remote:   File "/usr/lib/python2.4/site-packages/mercurial/commands.py",
>> line 3182, in <lambda>
>> remote:     d = lambda: func(u, repo, *args, **cmdoptions)
>> remote:   File "/usr/lib/python2.4/site-packages/mercurial/commands.py",
>> line 2291, in serve
>> remote:     s.serve_forever()
>> remote:   File
>> "/usr/lib/python2.4/site-packages/mercurial/sshserver.py",
>> line 40, in serve_forever
>> remote:     while self.serve_one(): pass
>> remote:   File
>> "/usr/lib/python2.4/site-packages/mercurial/sshserver.py",
>> line 47, in serve_one
>> remote:     if impl: impl()
>> remote:   File
>> "/usr/lib/python2.4/site-packages/mercurial/sshserver.py",
>> line 201, in do_unbundle
>> remote:     fp.close()
>> remote: UnboundLocalError: local variable 'fp' referenced before
>> assignment
>> abort: unexpected response: empty string
>>
>> And running hg-menu will result in this:
>>
>> hg-menu
>> /usr/local/bin/hg-menu: line 185: /tmp/dialog21904: Read-only file
>> system
>> Connection to linuxtv.org closed.
>
> hg-menu is working here. Could you please check again?
>
> Cheers,
> Mauro
>

Johannes reported that there where harddisk problems and at the time the
harddisk was undergoing an fsck, so it was read-only. Hence the problems I
experienced.

It's working now.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

