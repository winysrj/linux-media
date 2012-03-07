Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46199 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754897Ab2CGTVM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Mar 2012 14:21:12 -0500
Received: by lahj13 with SMTP id j13so7644644lah.19
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2012 11:21:11 -0800 (PST)
Message-ID: <4F57B520.9070607@gmail.com>
Date: Wed, 07 Mar 2012 20:21:04 +0100
From: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add CI support to az6007 driver
References: <1577059.kW45pXQ20M@jar7.dominio> <4F552548.4000304@gmail.com> <1436129.Xg0ZNGxkxn@jar7.dominio>
In-Reply-To: <1436129.Xg0ZNGxkxn@jar7.dominio>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jose Alberto Reguero skrev 2012-03-06 00:23:
> On Lunes, 5 de marzo de 2012 21:42:48 Roger Mårtensson escribió:
>
> No. I tested the patch with DVB-T an watch encrypted channels with vdr without
> problems. I don't know why you can't. I don't know gnutv. Try with other
> software if you want.

I have done some more testing and it works.. Sort of. :-)

First let me walk through the dmesg.

First I reinsert the CAM-card:

Mar  7 20:12:36 tvpc kernel: [  959.717666] dvb_ca adapter 2: DVB CAM 
detected and initialised successfully

The next lines are when I start Kaffeine. Kaffeine gets a lock on the 
encrypted channel and starts viewing it.

Mar  7 20:13:02 tvpc kernel: [  986.359195] mt2063: detected a mt2063 B3
Mar  7 20:13:03 tvpc kernel: [  987.368964] drxk: SCU_RESULT_INVPAR 
while sending cmd 0x0203 with params:
Mar  7 20:13:03 tvpc kernel: [  987.368974] drxk: 02 00 00 00 10 00 05 
00 03 02                    ..........
Mar  7 20:13:06 tvpc kernel: [  990.286628] dvb_ca adapter 2: DVB CAM 
detected and initialised successfully

And now my "sort of"-comment. When I change the to another encrypted 
channel in kaffeine I get nothing. To be able to view this channel I 
need to restart kaffeine.

The only thing that seems different in the logs are that when restarting 
kaffeine I get the "CAM detected and initialised" but when changing 
channels I do not get that line.

Maybe there should be another reinit of the CAM somewhere? (just a guess)
