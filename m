Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:34828 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031024AbaLLRqG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 12:46:06 -0500
Received: by mail-qc0-f176.google.com with SMTP id i17so5971548qcy.35
        for <linux-media@vger.kernel.org>; Fri, 12 Dec 2014 09:46:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141212153638.6ecb9664@recife.lan>
References: <548AC061.3050700@xs4all.nl>
	<20141212104942.0ea3c1d7@recife.lan>
	<548AE5B2.1070306@xs4all.nl>
	<20141212111424.0595125b@recife.lan>
	<548B092F.2090803@osg.samsung.com>
	<548B09A5.80506@xs4all.nl>
	<CAGoCfiw1pdJGGfG5Gs-3Jf2e48buzwEA1O3+j-E+2Pjj657eEQ@mail.gmail.com>
	<548B1884.6090005@xs4all.nl>
	<CAGoCfiywSrq0f-L6a2LOS=ZS7xzfUJym46njesR8TkfoybQ5Pw@mail.gmail.com>
	<20141212153638.6ecb9664@recife.lan>
Date: Fri, 12 Dec 2014 12:46:05 -0500
Message-ID: <CAGoCfiz0x4Ymj=CO4WbJm-tqvQWz-nNbYaq4xEeioQ+CKJLb5w@mail.gmail.com>
Subject: Re: [REVIEW] au0828-video.c
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> As we've discussed on IRC channel, it would be good to add support
> for format enumeration on it, but the changes don't seem to be
> trivial. I'm not willing to do it, due to my lack of time, but,
> if someone steps up for doing that, then we can wait for those
> patches before bumping the version.

I agree that format enumeration will be a PITA - I looked at doing it
myself a couple of years ago.  Much of the problems are related to
limitations in the home-grown widget toolkit that tvtime uses.  I've
also got patches to support HD resolutions (i.e. HDMI capture) which
we use internally, but haven't felt they were worthwhile to upstream
since they don't depend on the ENUM_FRAMESIZES/FRAMEINTERVALS.  If
somebody feels the urge to put some time into it, I can make available
the patches.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
