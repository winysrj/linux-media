Return-path: <mchehab@gaivota>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:32969 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1EINdX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2011 09:33:23 -0400
Received: by qyk7 with SMTP id 7so929076qyk.19
        for <linux-media@vger.kernel.org>; Mon, 09 May 2011 06:33:22 -0700 (PDT)
Message-ID: <4DC7ED1F.7040306@laptop.org>
Date: Mon, 09 May 2011 09:33:19 -0400
From: "Richard A. Smith" <richard@laptop.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: hdpvr flakyness. (complete this time)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

My apologies on the last message.  It somehow slipped out of my drafts 
folder before I was finished.

I've been tyring to use the hdpvr to digitize some old VHS tapes to and 
I'm having a few issues that I'd like to get some more information on. 
Perhaps there are workarounds.

I'm running the a recent media-build on a 2.6.38.4 kernel.  I've not 
been able to run the latest media-build for the last week or so due to 
compile errors.  But looking at the repository I don't see any changes 
to hdpvr so I believe I'm running the latest driver and the hdpvr device 
has been upgraded to the latest firmware.

The first item is that if there is not a video signal present at the 
current active input then the driver returns an open error.  This trips 
up pretty much every application that I've tried to use with the hdpvr. 
  They all want to open the device first and then set the information. 
So they complain that the device isn't valid.  Is this intentional?

The only thing I've found that works is setting the parameters with 
v4l2-ctl and then using 'cat /dev/video1' to get the output.  This seems 
to work fine as long as the video source never stops.  If for some 
reason the analog input stops (Say if I hit stop on the VCR) without 
doing a ctrl-c to stop the cat from running then the hardware seems to 
lock up requiring a power cycle of the dhpvr to recover.

The kernel log below shows the debug output for the loss-of-signal-gack 
scenario.

I'll be happy to provide more debug output on request and I can try out 
patches.

Thanks.

===============================================
May  5 10:48:11 engine36 kernel: [389385.964042] usb 1-5: new high speed 
USB device using ehci_hcd and address 24
May  5 10:48:12 engine36 kernel: [389386.326958] hdpvr 1-5:1.0: firmware 
version 0x15 dated Jun 17 2010 09:26:53
May  5 10:48:12 engine36 kernel: [389386.513242] hdpvr 1-5:1.0: device 
now attached to video1
....

[ Start recording with 'cat /dev/video1' and  video signal stops ]

May  5 10:56:13 engine36 kernel: [389867.803740] hdpvr 1-5:1.0: 
hdpvr_submit_buffers:210 buffer stat: 0 free, 64 proc
May  5 10:56:13 engine36 kernel: [389867.905290] hdpvr 1-5:1.0: 
hdpvr_read:502 buffer stat: 1 free, 63 proc
May  5 10:56:13 engine36 kernel: [389867.905330] hdpvr 1-5:1.0: 
hdpvr_submit_buffers:210 buffer stat: 0 free, 64 proc
May  5 10:56:19 engine36 kernel: [389874.120097] hdpvr 1-5:1.0: config 
call request for value 0x800 returned 1
May  5 10:56:19 engine36 kernel: [389874.120124] hdpvr 1-5:1.0: transmit 
worker exited
May  5 10:56:20 engine36 kernel: [389874.296177] hdpvr 1-5:1.0: used 0 
urbs to empty device buffers
May  5 10:56:31 engine36 kernel: [389885.588728] hdpvr 1-5:1.0: video 
signal: 720x480@30hz
May  5 10:56:31 engine36 kernel: [389885.592116] hdpvr 1-5:1.0: encoder 
start control request returned 0
May  5 10:56:41 engine36 kernel: [389895.592192] hdpvr 1-5:1.0: config 
call request for value 0x700 returned -110
May  5 10:56:41 engine36 kernel: [389895.592208] hdpvr 1-5:1.0: 
streaming started
May  5 10:56:41 engine36 kernel: [389895.592225] hdpvr 1-5:1.0: 
hdpvr_read:442 buffer stat: 64 free, 0 proc
May  5 10:56:41 engine36 kernel: [389895.592312] hdpvr 1-5:1.0: 
hdpvr_submit_buffers:210 buffer stat: 0 free, 64 proc
May  5 10:57:18 engine36 kernel: [389932.736086] hdpvr 1-5:1.0: config 
call request for value 0x800 returned -110
May  5 10:57:18 engine36 kernel: [389932.736114] hdpvr 1-5:1.0: transmit 
worker exited
May  5 10:57:18 engine36 kernel: [389932.932162] hdpvr 1-5:1.0: used 0 
urbs to empty device buffers

[ Device is now gacked.]

May  5 11:00:47 engine36 kernel: [390141.316026] hdpvr 1-5:1.0: no video 
signal at input 2
May  5 11:00:47 engine36 kernel: [390141.316034] hdpvr 1-5:1.0: 
start_streaming failed
May  5 11:00:52 engine36 kernel: [390147.120024] hdpvr 1-5:1.0: no video 
signal at input 2
May  5 11:00:52 engine36 kernel: [390147.120031] hdpvr 1-5:1.0: 
start_streaming failed
May  5 11:01:46 engine36 kernel: [390201.152026] hdpvr 1-5:1.0: no video 
signal at input 2
May  5 11:01:46 engine36 kernel: [390201.152033] hdpvr 1-5:1.0: 
start_streaming failed

[ Unloading and reloading the module has no effect. Nor does a USB plug 
unplug.  You have to power cycle the hdpvr ]

May  5 11:06:16 engine36 kernel: [390470.360051] usbcore: deregistering 
interface driver hdpvr
May  5 11:06:33 engine36 kernel: [390487.543294] hdpvr 1-5:1.0: Non-NULL 
drvdata on register
May  5 11:06:43 engine36 kernel: [390497.540144] hdpvr 1-5:1.0: 
unexpected answer of status request, len -110
May  5 11:06:43 engine36 kernel: [390497.540152] hdpvr 1-5:1.0: device 
init failed
May  5 11:06:43 engine36 kernel: [390497.540214] hdpvr: probe of 1-5:1.0 
failed with error -12
May  5 11:06:43 engine36 kernel: [390497.540294] usbcore: registered new 
interface driver hdpvr


-- 
Richard A. Smith
One Laptop per Child


