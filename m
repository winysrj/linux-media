Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm33-vm2.bullet.mail.ne1.yahoo.com ([98.138.229.66]:24794 "EHLO
	nm33-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179Ab3ERPXW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 May 2013 11:23:22 -0400
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com>
Message-ID: <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com>
Date: Sat, 18 May 2013 08:17:10 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
To: =?iso-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <519791E2.4080804@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

----- Original Message -----

>> Am 18.05.2013 15:57, schrieb Chris Rankin:
>> I have a PCTV 290e DVB2 adapter (em28xx, em28xx_dvb, em28xx_rc, cxd2820r), and I have just discovered that the IR remote control has stopped working with VDR when using a vanilla 3.9.2 kernel.
>> Downgrading the kernel to 3.8.12 fixes things again. (Switching to my old DVB NOVA-T2 device fixes things too, although it cannot receive HDTV channels, of course).

> Great. :( :( :(
> There have been several changes in the em28xx and core RC code between 3.8 and 3.9...
> I can't see anything obvious, the RC device seems to be registered correctly.
> Could you please bisect ?

Unfortunately, no I can't. (No git tree here - just a tarball downloaded via FTP). However, maybe I could out some printk() statements into the code if you could point out where the "hot-spots" might be, please?

Cheers,
Chris

