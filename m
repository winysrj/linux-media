Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:36830 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbZHWWaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 18:30:55 -0400
Subject: Re: [linux-dvb] Lifeview hybrid saa7134 driver not working anymore
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org, scoop_yo@freemail.gr
Cc: linux-dvb@linuxtv.org
In-Reply-To: <4a9157b68b09b3.99825026@freemail.gr>
References: <4a9157b68b09b3.99825026@freemail.gr>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 00:27:27 +0200
Message-Id: <1251066447.3244.5.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi scoop,

Am Sonntag, den 23.08.2009, 17:52 +0300 schrieb scoop_yo@freemail.gr:
> Hi, for a couple of days now, my lifeview PCI hybrid card that worked flawlessly for the last 2 years doesn't work. The problem is with the driver from what I understand from the logs.
> 
> Today 23/8/2009 I tried the drivers within vanilla kernel 2.6.30.5 (i386 and amd64) and then separately latest mercurial snapshot. I always use latest mercurial snapshot updating every time a new kernel is released.
> This card works within Windows XP. I also switched the PCI slot but that didn't help.
> 
> For the driver, I issued the command:
> 
> modprobe saa7134 i2c_debug=1 i2c_scan=1 disable_ir=1
> 
> I attached the log because it's kinda big for posting it on the message.
> For any ideas or suggestions I am here available for testing them. :)
> 

the report is at least fine.

An i2c device, working over years on 0x10, vanished mysteriously.

I guess you don't have much better options here than to try, if it comes
back with any combination of either most triggering it or not at all ...

Cheers,
Hermann


