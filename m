Return-path: <linux-media-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:52527 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbcAaUZN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2016 15:25:13 -0500
Received: from [192.168.1.104] (unknown [108.161.112.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(Client did not present a certificate)
	by mail.lockie.ca (Postfix) with ESMTPSA id A85E541EB6
	for <linux-media@vger.kernel.org>; Sun, 31 Jan 2016 14:07:31 -0500 (EST)
From: James <rjl@lockie.ca>
To: linux-media@vger.kernel.org
Subject: one channel has slow video
Message-ID: <56AE6B5B.1090308@lockie.ca>
Date: Sun, 31 Jan 2016 15:15:23 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a Hauppauge WinTV-HVR1250 and a GeForce GTX 650:
01:00.0 VGA compatible controller: NVIDIA Corporation GK107 [GeForce GTX 
650] (rev a1)
05:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI 
Video and Audio Decoder (rev 02)

I use vlc to play tv.
One of the channels I usually tune to stopped working.
I finally got around to looking at that.
I did another w_scan to make sure the frequency hadn't changed.
I then tried mplayer:

> Playing dvb://.
> dvb_tune Freq: 213000000
> Detected file format: TS
> VIDEO MPEG2(pid=49) AUDIO A52(pid=51) NO SUBS (yet)!  PROGRAM N. 0
> VIDEO:  MPEG2  1280x720  (aspect 3)  59.940 fps  15000.0 kbps (1875.0 
> kbyte/s)
> Failed to open VDPAU backend libvdpau_nouveau.so: cannot open shared 
> object file: No such file or directory
> [vdpau] Error when calling vdp_device_create_x11: 1
> [ass] auto-open
> Selected video codec: MPEG-2 video [libavcodec]
> Selected audio codec: ATSC A/52A (AC-3) [libavcodec]
> AUDIO: 48000 Hz, 2 ch, floatle, 384.0 kbit/12.50% (ratio: 48000->384000)
> AO: [pulse] 48000Hz 2ch floatle (4 bytes per sample)
> Starting playback...
> VIDEO:  1280x720  59.940 fps  15000.0 kbps (1875.0 kB/s)
> VO: [xv] 1280x720 => 1280x720 Planar YV12
> A:7392.1 V:7376.9 A-V: 15.171 ct:  0.000  53/ 53 20%  2% 2031.8% 50 0
>
>
>            ************************************************
>            **** Your system is too SLOW to play this!  ****
>            ************************************************
>
> A:7395.6 V:7377.1 A-V: 18.501 ct:  0.000  64/ 64 19%  1% 2005.9% 61 0

I got audio but the video was really lagged.

After about a minute, the video started working but these messages kept 
getting printed:
> Too many video packets in the buffer: (4096 in 124631948 bytes).
> Maybe you are playing a non-interleaved stream/file or the codec failed?
> For AVI files, try to force non-interleaved mode with the -ni option.

