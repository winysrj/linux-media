Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4567 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab3AUJxu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 04:53:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jan Stumpf <Jan.Stumpf@asctec.de>
Subject: Re: [cx231xx] Support for Arm / Omap working at all?
Date: Mon, 21 Jan 2013 10:53:43 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <5AFD6ADC04BAC644902876711A98009E43BC3C18@ASCTECSBS2.asctec.local>
In-Reply-To: <5AFD6ADC04BAC644902876711A98009E43BC3C18@ASCTECSBS2.asctec.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301211053.43912.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu January 17 2013 08:31:50 Jan Stumpf wrote:
> Hi!
> 
> I'm trying to get an Hauppauge Live Usb 2 video grabber to run on on Omap4 (Gumstix Duovero). I'm using Sakomans omap-3.6 head kernel sources from http://git.sakoman.com/git/gitweb.cgi?p=linux.git;a=summary . The hardware is successfully detected on the USB host port, the driver loads perfectly including the firmware. With v4l2-ctl --all I can see if thee video signal on the composite port is ok or if the sync is lost, but as soon as I use any v4l2 software (e.g. yavta) to grab some images the driver uses 100% of the cpu, returns the first image and after some seconds I see EPROTO (-71) errors in dmesg. First I get " cx231xx #0: can't change interface 3 alt. no to 0 (err=-71)" and then "UsbInterface::sendCommand, failed with status --71"
> 
> I did the following tests:
> 
> - checked that all patches I found (e.g from http://git.linuxtv.org/mchehab/cx231xx.git) are included in my kernel, including the URB DMA related patches and the timing patches
> - tried the same on an Gumstix Overo (Overo Fire and Overo WarerStorm) on several different header boards.
> - tried older kernels (3.2 and 2.6.32) with rougly the same results or known errors due to missing patches
> 
> Unfortunately I can't use other capture devices because the final hardware is custom made with the cx23102 chip :-( I could use an omap3 instead of an omap4, but omap4 is preferred.
> 
> My questions are: 
> 
> - Did anybody ever used the cx231xx driver with an omap3 or omap4 successfully? 

I'm pretty sure the answer is that you're the first to try it.

> - If yes, could you let me know the kernel version and maybe the config? 
> - Any hints what I could try? I'm an expirienced embedded C programmer but I dont have much expirience in USB kernel drivers. 

A few months back I was working on improving this driver and I made a number
of fixes that are available in my git tree:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/cx231xx

In particular this patch might be relevant:

http://git.linuxtv.org/hverkuil/media_tree.git/commit/7bcf29cf460569c523b15d3c0dfed1397a7b770e

Regards,

	Hans

> 
> Any help is greatly appriciated!
> 
> Thanks in Advance!
> 
> Jan--
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
