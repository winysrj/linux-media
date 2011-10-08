Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56982 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1JHKcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Oct 2011 06:32:55 -0400
Received: by bkbzt4 with SMTP id zt4so5957402bkb.19
        for <linux-media@vger.kernel.org>; Sat, 08 Oct 2011 03:32:53 -0700 (PDT)
Message-ID: <4E9026CD.1030200@gmail.com>
Date: Sat, 08 Oct 2011 12:32:45 +0200
From: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Stream degrades when going through CAM
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hej(Hello)!

I'm the one that posted about non responding CAM earlier. I got another 
CAM I had laying around to work but now it's different problems.

With this SMIT Conax CAM(Earlier it was a Dilog Conax) I can decode but 
the resulting mpg-stream degrades fast to something unwatchable.

The testprogram I'm using is gnutv:
$ gnutv -channels ~/my-channels-v4.conf -timeout 30 -out file t.mpg SVT1
Using frontend "Philips TDA10023 DVB-C", type DVB-C
status SCVYL | signal f0f0 | snr f3f3 | ber 000fffff | unc 000000ec | 
FE_HAS_LOCK
CAM Application type: 01
CAM Application manufacturer: cafe
CAM Manufacturer code: babe
CAM Menu string: Conax Conditional Access
CAM supports the following ca system ids:
   0x0b00
Received new PMT - sending to CAM...

The recording always starts up nice but after some time it gets blocky 
artifacts and mplayer starts outputing errors. These artifacts increases 
almost exponential making this 30 second recording unwatchable very fast.
This of course does not happen when the CAM isn't inserted.

So my question is. Is there something in the driver talking with the CAM 
that degrades the stream?

It's almost like when the errors starts displaying it gets more worse by 
the second.

Other "errors" I see with this CAM inserted are PMT/NIT/STD filter 
timeouts when scanning with w_scan and filter timeouts(one or many pids) 
with scan resulting in channels not being found. Other runs may find the 
missing channels but then others are missing. Sometimes a run completes 
without errors and all channels are found.

If the CAM is not inserted then I do not see these errors.
All tests done with the same non-encrypted channel. (encrypted channels 
show the same problems. HD Channels degrades faster than SD.)

If someone with knowledge could help me it would be great. I sure do 
want to get this working. It is working, sort of. I does decode so 
something is getting through the CAM but not for long.

I did try to search the "web" and mailing list and I did find people 
with similar errors all the way back to 2006.

The hardware I got is a mystique DVB-C Card but it seems to a KNC1 
TV-Station MK3 clone.
08:01.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 
[1131:7146] (rev 01)
         Subsystem: KNC One Device [1894:0028]
         Flags: bus master, medium devsel, latency 64, IRQ 16
         Memory at fbeffc00 (32-bit, non-prefetchable) [size=512]
         Kernel driver in use: budget_av
         Kernel modules: budget-av

The CAM is a SMIT CONAX.

Kernel Used: 2.6.38(2.6.38-11-generic. Ubuntu 11.04 SMP)

Drivers tested: from latest media_build git
