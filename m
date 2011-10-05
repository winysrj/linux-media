Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934402Ab1JETS2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Oct 2011 15:18:28 -0400
Message-ID: <4E8CAD7E.8020102@redhat.com>
Date: Wed, 05 Oct 2011 16:18:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Will Milspec <will.milspec@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: fm player for v4l2
References: <CANut7vBzVpOdqKHxWeZbV1r+9cfBJ3r01i6LKFCoTCTeu55Zpg@mail.gmail.com> <CAGoCfiyNekcUPM_pCn2Y0mf3tMMd=1nWJveP8DBibd53nZ7vJA@mail.gmail.com> <CANut7vAxNB3quqQbt-kHMVHxdvMy_p+woxNXMTS+wx9x=+3rnA@mail.gmail.com>
In-Reply-To: <CANut7vAxNB3quqQbt-kHMVHxdvMy_p+woxNXMTS+wx9x=+3rnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-10-2011 16:05, Will Milspec escreveu:
> Thanks for the summary.
>
> Any V4L2 fm-card app's working out there?

xawtv radio application works. Also, gnomeradio (at least, the one shipped
on Fedora - not sure if the V4L2 port were merged back upstream).

fmtools version 2 says:

2.0:

Sat Dec 12 21:18:52 PST 2009 / Ben Pfaff <blp@cs.stanford.edu>

- Rewrite to use video4linux2 API.

and a grep on its source code shows only V4L2 API ioctl's. So, all you
need is probably to upgrade it to a newer version.

>
> Also, I apologize in advance for the size of my v4l-info section in
> the email. I didn't realize its size until after i emailed.
>
>
> will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

