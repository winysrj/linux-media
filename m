Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:43480 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030233AbaLLQqO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 11:46:14 -0500
Received: by mail-qg0-f41.google.com with SMTP id j5so5757400qga.28
        for <linux-media@vger.kernel.org>; Fri, 12 Dec 2014 08:46:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <548B1884.6090005@xs4all.nl>
References: <548AC061.3050700@xs4all.nl>
	<20141212104942.0ea3c1d7@recife.lan>
	<548AE5B2.1070306@xs4all.nl>
	<20141212111424.0595125b@recife.lan>
	<548B092F.2090803@osg.samsung.com>
	<548B09A5.80506@xs4all.nl>
	<CAGoCfiw1pdJGGfG5Gs-3Jf2e48buzwEA1O3+j-E+2Pjj657eEQ@mail.gmail.com>
	<548B1884.6090005@xs4all.nl>
Date: Fri, 12 Dec 2014 11:46:13 -0500
Message-ID: <CAGoCfiywSrq0f-L6a2LOS=ZS7xzfUJym46njesR8TkfoybQ5Pw@mail.gmail.com>
Subject: Re: [REVIEW] au0828-video.c
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> In short, that code cannot be removed.
>
> Sure it can. I just tried tvtime and you are right, it blocks the GUI.
> But the fix is very easy as well. So now I've updated tvtime so that
> it timeouts and gives the GUI time to update itself.

That's a nice change to tvtime and I'm sure it will make it more robust.

> No more need for such an ugly hack in au0828. The au0828 isn't the only
> driver that can block, others do as well. Admittedly, they aren't very
> common, but they do exist. So it is much better to fix the application
> than adding application workarounds in the kernel.

You're breaking the ABI.  You're making a change to the kernel that
causes existing applications to stop working.  Sure you can make the
argument that applications probably never should have expected such
behavior (even if it's relied on that behavior for 15+ years).  And
sure, you can make a change to the application in some random git
repository that avoids the issue, and that change might get sucked in
to the major distributions over the next couple of years.  That
doesn't change the fact that you're breaking the ABI and everybody who
has the existing application that updates their kernel will stop
working.

Please don't do this.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
