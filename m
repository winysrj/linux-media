Return-path: <linux-media-owner@vger.kernel.org>
Received: from hornet.asctec.de ([176.9.40.213]:40021 "EHLO hornet.asctec.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab3AQHio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 02:38:44 -0500
From: Jan Stumpf <Jan.Stumpf@asctec.de>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [cx231xx] Support for Arm / Omap working at all?
Date: Thu, 17 Jan 2013 07:31:50 +0000
Message-ID: <5AFD6ADC04BAC644902876711A98009E43BC3C18@ASCTECSBS2.asctec.local>
Content-Language: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I'm trying to get an Hauppauge Live Usb 2 video grabber to run on on Omap4 (Gumstix Duovero). I'm using Sakomans omap-3.6 head kernel sources from http://git.sakoman.com/git/gitweb.cgi?p=linux.git;a=summary . The hardware is successfully detected on the USB host port, the driver loads perfectly including the firmware. With v4l2-ctl --all I can see if thee video signal on the composite port is ok or if the sync is lost, but as soon as I use any v4l2 software (e.g. yavta) to grab some images the driver uses 100% of the cpu, returns the first image and after some seconds I see EPROTO (-71) errors in dmesg. First I get " cx231xx #0: can't change interface 3 alt. no to 0 (err=-71)" and then "UsbInterface::sendCommand, failed with status --71"

I did the following tests:

- checked that all patches I found (e.g from http://git.linuxtv.org/mchehab/cx231xx.git) are included in my kernel, including the URB DMA related patches and the timing patches
- tried the same on an Gumstix Overo (Overo Fire and Overo WarerStorm) on several different header boards.
- tried older kernels (3.2 and 2.6.32) with rougly the same results or known errors due to missing patches

Unfortunately I can't use other capture devices because the final hardware is custom made with the cx23102 chip :-( I could use an omap3 instead of an omap4, but omap4 is preferred.

My questions are: 

- Did anybody ever used the cx231xx driver with an omap3 or omap4 successfully? 
- If yes, could you let me know the kernel version and maybe the config? 
- Any hints what I could try? I'm an expirienced embedded C programmer but I dont have much expirience in USB kernel drivers. 

Any help is greatly appriciated!

Thanks in Advance!

Jan