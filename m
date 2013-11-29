Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:28761 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab3K2RSb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 12:18:31 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MX100DS3C2UIQ20@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 29 Nov 2013 12:18:30 -0500 (EST)
Date: Fri, 29 Nov 2013 15:18:25 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Geert Stappers <stappers@stappers.nl>, mjs <mjstork@gmail.com>
Subject: Re: [GIT PULL FIXES for 3.13] 2 small gspca and 2 small radio-shark
 fixes
Message-id: <20131129151825.659a8ca0@samsung.com>
In-reply-to: <5291FBF3.8060003@redhat.com>
References: <5291FBF3.8060003@redhat.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 24 Nov 2013 14:15:31 +0100
Hans de Goede <hdegoede@redhat.com> escreveu:

> Hi Mauro,
> 
> This is a resend of my pull-req from a few minutes ago. I had
> made an error in the Cc: stable (I used linux.org instead of kernel.org),
> this pull-req is for the fixed commit (up to commit id changed).
> 
> This pull-req supersedes my previous GIT PULL FIXES for 3.13, new
> in this pull-req is an additional usb-id for the gspca_sunplus
> driver.
> 
> Please pull from my tree for 4 small fixes for 3.13 :
> 
> The following changes since commit 80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:
> 
>    [media] media: st-rc: Add ST remote control driver (2013-10-31 08:20:08 -0200)
> 
> are available in the git repository at:
> 
>    git://linuxtv.org/hgoede/gspca.git media-for_v3.13
> 
> for you to fetch changes up to da7e5a168b689da740d7c63cb26cbb8a05a4fc5d:
> 
>    gspca_sunplus: Add new usb-id for 06d6:0041 (2013-11-24 14:12:18 +0100)
> 
> ----------------------------------------------------------------
> Geert Uytterhoeven (1):
>        radio-shark: Mark shark_resume_leds() inline to kill compiler warning
> 
> Hans de Goede (2):
>        radio-shark2: Mark shark_resume_leds() inline to kill compiler warning

Fixes for both above were already upstreamed (using #ifdefs). So, I'll
be applying those two for 3.14, removing the corresponding #ifdef/#endif blocks.

>        gspca_sunplus: Add new usb-id for 06d6:0041
> 
> Ondrej Zary (1):
>        gspca-stk1135: Add delay after configuring clock

Applied, thanks!
> 
>   drivers/media/radio/radio-shark.c  | 2 +-
>   drivers/media/radio/radio-shark2.c | 2 +-
>   drivers/media/usb/gspca/stk1135.c  | 3 +++
>   drivers/media/usb/gspca/sunplus.c  | 1 +
>   4 files changed, 6 insertions(+), 2 deletions(-)
> 
> Thanks & Regards,
> 
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
