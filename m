Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50128 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1JIMzF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Oct 2011 08:55:05 -0400
Received: by bkbzt4 with SMTP id zt4so7178652bkb.19
        for <linux-media@vger.kernel.org>; Sun, 09 Oct 2011 05:55:03 -0700 (PDT)
Message-ID: <4E91999B.7050307@gmail.com>
Date: Sun, 09 Oct 2011 14:54:51 +0200
From: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Stream degrades when going through CAM
References: <4E9026CD.1030200@gmail.com>
In-Reply-To: <4E9026CD.1030200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Roger Mårtensson skrev 2011-10-08 12:32:
> Hej(Hello)!
>
> The hardware I got is a mystique DVB-C Card but it seems to a KNC1 
> TV-Station MK3 clone.
> 08:01.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 
> [1131:7146] (rev 01)
>         Subsystem: KNC One Device [1894:0028]
>         Flags: bus master, medium devsel, latency 64, IRQ 16
>         Memory at fbeffc00 (32-bit, non-prefetchable) [size=512]
>         Kernel driver in use: budget_av
>         Kernel modules: budget-av
>
> The CAM is a SMIT CONAX.
>
> Kernel Used: 2.6.38(2.6.38-11-generic. Ubuntu 11.04 SMP)
>
> Drivers tested: from latest media_build git
I noticed now that my board seems to be using a tda10024. It's wired the 
same as a tda10023 in the code so it seems compatible to 10023?

Whenever I insert the cam and starts a capture I get this error in the 
dmesg:
[    8.019398] budget_av: cam inserted A
[    8.689753] dvb_ca adapter 0: DVB CAM detected and initialised 
successfully
[   15.061237] eth0: no IPv6 routers present
[   92.831735] budget_av: cam inserted A
[   92.832713] DVB: TDA10023(0): tda10023_writereg, writereg error (reg 
== 0x2a, val == 0x02, ret == -121)
[   93.499511] dvb_ca adapter 0: DVB CAM detected and initialised 
successfully
[  161.695810] budget_av: cam ejected 5

This is after a reboot and one capture with gnutv.
If I unplug the CAM the error does not show.

Can it be related to the corrupt mpg-stream I see whenever the CAM is 
inserted?
