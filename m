Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:54075 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab3LVPzi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Dec 2013 10:55:38 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY700GCITKOEN40@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sun, 22 Dec 2013 10:55:37 -0500 (EST)
Date: Sun, 22 Dec 2013 13:55:31 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Palosaari <crope@iki.fi>, LMML <linux-media@vger.kernel.org>,
	Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Subject: Re: em28xx list_add corruption reported by list debug
Message-id: <20131222135531.6af60f77@samsung.com>
In-reply-to: <20131222130600.652f468a@samsung.com>
References: <52B615C9.8040806@iki.fi> <20131222130600.652f468a@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 22 Dec 2013 13:06:00 -0200
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Em Sun, 22 Dec 2013 00:27:21 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
> 
> > I ran also this kind of bug. Device was PCTV 290e, which has that video 
> > unused. I have no any analog em28xx webcam to test if that happens here too.
> > 
> > Fortunately I found one video device which does not crash nor dump debug 
> > bug warnings. It is some old gspca webcam. Have to look example how 
> > those videobuf callbacks are implemented there..
> > 
> > regards
> > Antti
> > 
> > 
> > [crope@localhost linux]$ cat /dev/video0
> > cat: /dev/video0: Invalid argument
> > [crope@localhost linux]$ cat /dev/video0
> > cat: /dev/video0: Device or resource busy
> > [crope@localhost linux]$
> > 
> > 
> > joulu 22 00:08:24 localhost.localdomain kernel: em28174 #0: no endpoint 
> > for analog mode and transfer type 0
> 
> It seems that there's something bad on em28174 registration: it should not
> be creating a v4l2 device, if the device is DVB only.
> 
> The thing is that, when this driver was created, all devices were either
> analog only or hybrid. Only very recently, pure DVB devices got added.
> 
> It shouldn't be that hard to split em28xx_init_dev() into a few routines
> that would only register v4l2 if the device has analog support.
> 
> Again, this changeset:
> 	https://patchwork.linuxtv.org/patch/17967/
> 
> Seems to be part of such solution, as it already splits the v4l2
> register logic into a separate function. 

Ok, if I didn't make any mistake, this changeset should do the trick:
	https://patchwork.linuxtv.org/patch/21282/

Please notice that this is compile-tested only.

Regards,
Mauro
-- 

Cheers,
Mauro
