Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:40168 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2EINtL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 09:49:11 -0400
Received: from homiemail-a97.g.dreamhost.com (caiajhbdccac.dreamhost.com [208.97.132.202])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 46EB7179830
	for <linux-media@vger.kernel.org>; Wed,  9 May 2012 06:49:06 -0700 (PDT)
Received: from homiemail-a97.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a97.g.dreamhost.com (Postfix) with ESMTP id 9CB6D28606F
	for <linux-media@vger.kernel.org>; Wed,  9 May 2012 06:48:26 -0700 (PDT)
Received: from [10.0.0.26] (a95-93-70-140.cpe.netcabo.pt [95.93.70.140])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: bruno@skorzen.net)
	by homiemail-a97.g.dreamhost.com (Postfix) with ESMTPSA id 2A568286058
	for <linux-media@vger.kernel.org>; Wed,  9 May 2012 06:48:25 -0700 (PDT)
Message-ID: <4FAA75A7.5030807@skorzen.net>
Date: Wed, 09 May 2012 14:48:23 +0100
From: Bruno Martins <lists@skorzen.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Dazzle DVC80 under FC16
References: <4FAA57A3.2030701@skorzen.net>
In-Reply-To: <4FAA57A3.2030701@skorzen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello guys,

Has anyone ever got this to working under any Linux distro, including
Fedora?

I have just plugged it in and I get this on dmesg:

[ 1365.932522] usb 2-1.1: new full-speed USB device number 26 using
ehci_hcd
[ 1366.073145] usb 2-1.1: New USB device found, idVendor=07d0,
idProduct=0004
[ 1366.073153] usb 2-1.1: New USB device strings: Mfr=0, Product=0,
SerialNumber=0
[ 1366.091741] usbvision_probe: Dazzle Fusion Model DVC-80 Rev 1 (PAL)
found
[ 1366.092072] USBVision[0]: registered USBVision Video device video1
[v4l2]
[ 1366.092091] usbvision_probe: Dazzle Fusion Model DVC-80 Rev 1 (PAL)
found
[ 1366.092149] USBVision[1]: registered USBVision Video device video2
[v4l2]
[ 1366.092182] usbcore: registered new interface driver usbvision
[ 1366.092184] USBVision USB Video Device Driver for Linux : 0.9.11
[ 1366.189268] saa7115 15-0025: saa7113 found (1f7113d0e100000) @ 0x4a
(usbvision-2-1.1)
[ 1366.319647] usb 2-1.1: selecting invalid altsetting 1
[ 1366.319658] usb 2-1.1: cannot change alternate number to 1 (error=-22)

Device is recognized since it appears in lsusb:

[skorzen@g62 ~]$ lsusb | grep DVC
Bus 002 Device 026: ID 07d0:0004 Dazzle DVC-800 (PAL) Grabber

However, I cannot make it work (my goal is to capture video from a
camcorder).
I've tried using cheese for this, but it just crashes and ABRT
launches for me to fill a bug.

Any ideas?

Best regards,
