Return-path: <linux-media-owner@vger.kernel.org>
Received: from dzilna.latnet.lv ([92.240.66.75]:50558 "EHLO dzilna.latnet.lv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbZKPPn3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 10:43:29 -0500
Received: from localhost (localhost [127.0.0.1])
	by dzilna.latnet.lv (Postfix) with ESMTP id 3BADEB3CE3
	for <linux-media@vger.kernel.org>; Mon, 16 Nov 2009 17:36:00 +0200 (EET)
Received: from dzilna.latnet.lv ([127.0.0.1])
	by localhost (dzilna.latnet.lv [127.0.0.1]) (amavisd-new, port 11141)
	with ESMTP id 2NUknqf0dlT3 for <linux-media@vger.kernel.org>;
	Mon, 16 Nov 2009 17:35:53 +0200 (EET)
Received: from localhost (clients.latnet.lv [92.240.64.12])
	by dzilna.latnet.lv (Postfix) with ESMTP id 80CBFB3C2C
	for <linux-media@vger.kernel.org>; Mon, 16 Nov 2009 17:19:12 +0200 (EET)
Message-ID: <1258384752.4b016d7078962@online.sigmanet.lv>
Date: Mon, 16 Nov 2009 17:19:12 +0200
From: Agris =?windows-1257?b?UHVk4m5z?= <agris.pudans@latnet.lv>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] kworld 380u, qt1010, em28xx
References: <1258384425.4b016c29afaf2@online.sigmanet.lv>
In-Reply-To: <1258384425.4b016c29afaf2@online.sigmanet.lv>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1257
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Forwarded from linux-dvb to linux-media.

Citçju blondais@latnet.lv:

> Hi,
>
> There's a lot of mails can be found on internet about my problem but hardly
> any
> gives answer for subj.
> Year ago, this was ok, there where ~mrec dvb-kernel available. Now it is
> gone,
> and my problem raised again - cannot find the way to get my kworld 380u to
> work
> properly, even by changing idProduct=e359 for somehow working kworld355u in
> file
> linux/drivers/media/video/em28xx/em28xx-cards.c:
> ==
> 	{ USB_DEVICE(0xeb1a, 0xe359),
> 			.driver_info = EM2870_BOARD_KWORLD_355U },
> ==
>
> Can anyone lead me where to look or change next?
>
>
> Specs:
> Box: Slackware 13.0, Linux 2.6.29.6-smp.
> Item: Kworld 380U DVB-T USB stick
> Dmesg before compiling dvb kernel from linuxtv.org:
> Nov 16 16:54:04 dtv kernel: usb 1-1: new high speed USB device using ehci_hcd
> and address 4
> Nov 16 16:54:04 dtv kernel: usb 1-1: New USB device found, idVendor=eb1a,
> idProduct=e359
> Nov 16 16:54:04 dtv kernel: usb 1-1: New USB device strings: Mfr=0,
> Product=1,
> SerialNumber=0
> Nov 16 16:54:04 dtv kernel: usb 1-1: Product: USB 2870 Device
> Nov 16 16:54:04 dtv kernel: usb 1-1: configuration #1 chosen from 1 choice
>
>
> Modules made from http://linuxtv.org/hg/v4l-dvb/ do not create devices in
> /dev/dvb/ probably because of qt1010 firmware?
>
>

