Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f182.google.com ([209.85.221.182]:55810 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab0AMWKZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 17:10:25 -0500
Received: by qyk12 with SMTP id 12so5402332qyk.21
        for <linux-media@vger.kernel.org>; Wed, 13 Jan 2010 14:10:25 -0800 (PST)
Message-ID: <4B4E4365.5020307@gmail.com>
Date: Wed, 13 Jan 2010 17:04:21 -0500
From: TJ <one.timothy.jones@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Jarod Wilson <jarod@wilsonet.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: go7007 driver -- which program you use for capture
References: <4B47828B.9050000@gmail.com> <be3a4a1001081217s1bec67c8odb26bb793700242b@mail.gmail.com> <4B47B0EB.6000102@gmail.com> <4B4E34D2.8090202@redhat.com>
In-Reply-To: <4B4E34D2.8090202@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> TJ wrote:
>> jelle, that you?
>>
>> Here's the patch against go7007 driver in 2.6.32 kernel (run with -p1).
>>
>> The main purpose of the patch is to include support for ADS Tech DVD Xpress DX2
>> usb capture card and make it usable with v4l2-ctl utility.
>>
>> I also did a general clean-up in a few areas and *temporarily* added back in
>> proprietary go7007 ioctls, so current mythtv users can take advantage of it and
>> to make the gorecord program from wis-go7007 package now work again.
>>
>> Also attached is a stripped down version of gorecord from which I removed all
>> parameter-setting stuff. This version is meant to be used in conjunction with
>> v4l2-ctl or other means of configuring capture parameters.
>>
>> I will try to do mythtv patches next so that it starts using standard v4l2 ioctl
>> calls and we can drop all proprietary stuff in the driver.
>>
>> Please try it and lemme know if it works for you. I've run into a few Ubuntuers
>> as well who were trying to get their boards working as well.
> 
> The patch doesn't apply on the latest -hg version:
> patching file drivers/staging/go7007/Kconfig
> patching file drivers/staging/go7007/go7007-driver.c
> Hunk #2 succeeded at 225 (offset 1 line).
> Hunk #3 succeeded at 285 (offset 1 line).
> patching file drivers/staging/go7007/go7007-usb.c
> patching file drivers/staging/go7007/go7007-v4l2.c
> Hunk #1 FAILED at 43.
> Hunk #2 succeeded at 425 with fuzz 2 (offset 8 lines).
> Hunk #4 succeeded at 578 (offset 8 lines).
> Hunk #6 FAILED at 993.
> Hunk #7 succeeded at 1078 with fuzz 1 (offset -8 lines).
> Hunk #8 FAILED at 1538.
> Hunk #9 succeeded at 1672 (offset -18 lines).
> Hunk #10 succeeded at 1764 (offset -8 lines).
> 3 out of 10 hunks FAILED -- saving rejects to file drivers/staging/go7007/go7007-v4l2.c.rej
> patching file drivers/staging/go7007/s2250-board.c
> Hunk #1 FAILED at 357.
> 1 out of 1 hunk FAILED -- saving rejects to file drivers/staging/go7007/s2250-board.c.rej
> patching file drivers/staging/go7007/wis-i2c.h
> patching file drivers/staging/go7007/wis-saa7113.c
> patching file drivers/staging/go7007/wis-saa7115.c
> patching file drivers/staging/go7007/wis-tw2804.c
> patching file drivers/staging/go7007/wis-tw9903.c
> Hunk #1 FAILED at 152.
> 1 out of 1 hunk FAILED -- saving rejects to file drivers/staging/go7007/wis-tw9903.c.rej
> patching file drivers/staging/go7007/wis-tw9906.c
> Patch doesn't apply

Mauro, brother, this patch is for in-kernel go7007 driver. It has to be run
against kernel source 2.6.32. (IIRC it will also run against 2.6.31)

It won't run against current v4l-dvb tree, as Pete has done quite a few changes
since then. When I get a chance, I will start working against current version.

> 
> Also, you shouldn't re-add the proprietary API but, instead, to port it to use the
> API support for compressed stuff.

I did add support for standard vidioc_s/g_ext_ctrls API stuff and that's what I
am actually using currently. I merely kept the proprietary ioctls so that mythtv
users can start using the driver as well until somebody (me?) patches mythtv to
use the standard APIs. -TJ

> Cheers,
> Mauro.
> 

