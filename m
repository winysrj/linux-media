Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:45251 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbaAFQP0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 11:15:26 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYZ00BJKMHPGB80@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Jan 2014 11:15:25 -0500 (EST)
Date: Mon, 06 Jan 2014 14:15:20 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/2] tuner-xc2028: Fix xc3028 timeouts
Message-id: <20140106141520.4dbc5184@samsung.com>
In-reply-to: <1389002493-20134-1-git-send-email-m.chehab@samsung.com>
References: <1389002493-20134-1-git-send-email-m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 06 Jan 2014 08:01:31 -0200
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> When xc2028/3028 is powered down, it won't response to any command, until
> a firmware is loaded. That means that reading frontend status will fail
> with a timeout.
> 
> Also, any trial to put the device to sleep twice will fail.
> 
> This small series fix those two bugs.
> 
> Mauro Carvalho Chehab (2):
>   tuner-xc2028: Don't try to sleep twice
>   tuner-xc2028: Don't read status if device is powered down
> 
>  drivers/media/tuners/tuner-xc2028.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
> 


It turns that the errors I was experiencing with tvp5150 on HVR-950 seem
to be a reflex of the xc3028 errors, as they disappeared after this fix.

I suspect that the tvp5150 reads were sent too fast to em28xx, while it 
was still trying to do a read on the powered down xc3028.

That could likely mean that the code at em28xx I2C read would need to
wait for a longer time, or that we may need to send an ACK to em28xx
I2C, via register 0x06 bit 7.

Anyway, as everything is working fine, I'm just dropping the I2C
retry logic. I don't intend to work on any other fixup patch for I2C.

However, as the bug seems to still be hidden somewhere there, better to
have an option to turn on debug messages for timeouts.

Regards,
Mauro
