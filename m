Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53884 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3ERQ6z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 May 2013 12:58:55 -0400
Received: by mail-ee0-f47.google.com with SMTP id t10so3096795eei.34
        for <linux-media@vger.kernel.org>; Sat, 18 May 2013 09:58:53 -0700 (PDT)
Message-ID: <5197B34A.8010700@googlemail.com>
Date: Sat, 18 May 2013 18:58:50 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com>
In-Reply-To: <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 18.05.2013 17:17, schrieb Chris Rankin:
> ----- Original Message -----
>
>>> Am 18.05.2013 15:57, schrieb Chris Rankin:
>>> I have a PCTV 290e DVB2 adapter (em28xx, em28xx_dvb, em28xx_rc, cxd2820r), and I have just discovered that the IR remote control has stopped working with VDR when using a vanilla 3.9.2 kernel.
>>> Downgrading the kernel to 3.8.12 fixes things again. (Switching to my old DVB NOVA-T2 device fixes things too, although it cannot receive HDTV channels, of course).
>> Great. :( :( :(
>> There have been several changes in the em28xx and core RC code between 3.8 and 3.9...
>> I can't see anything obvious, the RC device seems to be registered correctly.
>> Could you please bisect ?
> Unfortunately, no I can't. (No git tree here - just a tarball downloaded via FTP). However, maybe I could out some printk() statements into the code if you could point out where the "hot-spots" might be, please?
>

For the em28xx driver: em28xx-input.c:
em28xx_ir_work() is called every 100ms
     calls em28xx_ir_handle_key()
         - calls ir->get_key() which is em2874_polling_getkey() in case 
of your device
         - reports the detected key via rc_keydown() through the RC core

HTH,
Frank

