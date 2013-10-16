Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:61835 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759727Ab3JPAKC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 20:10:02 -0400
Received: by mail-la0-f48.google.com with SMTP id er20so4318lab.35
        for <linux-media@vger.kernel.org>; Tue, 15 Oct 2013 17:10:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381707800.1875.63.camel@palomino.walls.org>
References: <CAFoaQoAK85BVE=eJG+JPrUT5wffnx4hD2N_xeG6cGbs-Vw6xOg@mail.gmail.com>
	<1381371651.1889.21.camel@palomino.walls.org>
	<CAFoaQoBiLUK=XeuW31RcSeaGaX3VB6LmAYdT9BoLsz9wxReYHQ@mail.gmail.com>
	<1381620192.22245.18.camel@palomino.walls.org>
	<1381668541.2209.14.camel@palomino.walls.org>
	<CAFoaQoAaGhDycKfGhD2m-OSsbhxtxjbbWfj5uidJ0zMpEWQNtw@mail.gmail.com>
	<1381707800.1875.63.camel@palomino.walls.org>
Date: Wed, 16 Oct 2013 01:10:00 +0100
Message-ID: <CAFoaQoAjjj=nxKwWET9a5oe1JeziOz40Uc54v4hg_QB-FU-7xw@mail.gmail.com>
Subject: Re: ivtv 1.4.2/1.4.3 broken in recent kernels?
From: Rajil Saraswat <rajil.s@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was finally able to carry out a git bisect. Had to do a git pull on
a fast internet hooked machine and ftp the files over to the remote
machine.

I started with 'git bisect bad v2.6.36.4' and 'git bisect good v2.6.35.10'.

And the result was:

5aa9ae5ed5d449a85fbf7aac3d1fdc241c542a79 is the first bad commit
commit 5aa9ae5ed5d449a85fbf7aac3d1fdc241c542a79
Author: Hans Verkuil <hverkuil@xs4all.nl>
Date:   Sat Apr 24 08:23:53 2010 -0300

    V4L/DVB: wm8775: convert to the new control framework

    Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

:040000 040000 37847ffe592f255c6a9d9daedaf7bbfd3cd7b055
2f094df6f65d7fb296657619c1ad6f93fe085a75 M    drivers

I then removed the patch from linux-2.6.36-gentoo-r8 which are gentoo
sources, and confirmed that video/audio now works fine on v4l2-ctl -d
/dev/video1 --set-input 4

I wasnt able to remove the patch in 3.10.7 which is gentoo stable
kernel. Any idea how can i do that?

Regards
Rajil
