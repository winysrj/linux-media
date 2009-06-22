Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f224.google.com ([209.85.220.224]:50924 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZFVRB6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 13:01:58 -0400
Received: by fxm24 with SMTP id 24so859747fxm.37
        for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 10:02:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <88b49f150906220027n17820baaxd4d4f63238a18de8@mail.gmail.com>
References: <88b49f150906211444u39a8eae1v77a15f32e4062775@mail.gmail.com>
	 <d9def9db0906212339k3af44f3dg80fe119784391dfe@mail.gmail.com>
	 <88b49f150906220027n17820baaxd4d4f63238a18de8@mail.gmail.com>
Date: Mon, 22 Jun 2009 20:01:59 +0300
Message-ID: <88b49f150906221001i7d8eb7c5x2af79452398c5c9e@mail.gmail.com>
Subject: Fwd: [linux-dvb] Kworld DVB-T 323UR problems
From: Laszlo Kustan <lkustan@gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again,
Here is the correct dmesg output when my usb port is recognized
properly The output is kind of weird, because this tuner does not have
radio but according to dmesg it is switching the device to FM mode...

[  550.908041] usb 1-4: new high speed USB device using ehci_hcd and address 6
[  551.075241] usb 1-4: configuration #1 chosen from 1 choice
[  551.075525] em28xx: new video device (eb1a:e323): interface 0, class 255
[  551.075530] em28xx: device is attached to a USB 2.0 bus
[  551.075536] em28xx #0: Alternate settings: 8
[  551.075540] em28xx #0: Alternate setting 0, max size= 0
[  551.075544] em28xx #0: Alternate setting 1, max size= 0
[  551.075548] em28xx #0: Alternate setting 2, max size= 1448
[  551.075553] em28xx #0: Alternate setting 3, max size= 2048
[  551.075557] em28xx #0: Alternate setting 4, max size= 2304
[  551.075561] em28xx #0: Alternate setting 5, max size= 2580
[  551.075565] em28xx #0: Alternate setting 6, max size= 2892
[  551.075569] em28xx #0: Alternate setting 7, max size= 3072
[  551.658207] attach_inform: tvp5150 detected.
[  551.720539] tvp5150 5-005c: tvp5150am1 detected.
[  553.360916] successfully attached tuner
[  553.368599] em28xx #0: V4L2 VBI device registered as /dev/vbi0
[  553.389033] em28xx #0: V4L2 device registered as /dev/video0
[  553.389041] em28xx-audio.c: probing for em28x1 non standard usbaudio
[  553.389045] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[  553.421218] em2880-dvb.c: DVB Init
[  554.076418] DVB: registering new adapter (em2880 DVB-T)
[  554.076431] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[  554.081209] em28xx #0: Found KWorld E323
[  554.410650] opening radio device and trying to acquire exclusive lock
[  554.410661] switching device to FM mode

Laszlo

---------- Forwarded message ----------
From: Laszlo Kustan <lkustan@gmail.com>
Date: Mon, Jun 22, 2009 at 10:27 AM
Subject: Re: [linux-dvb] Kworld DVB-T 323UR problems
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org


Hi Markus,
Sorry, it seems that sometimes my usb is not recognized as 2.0, I
wonder why this happens.
Anyway, I'll send you in the afternoon a correct dmesg output, but the
results are the same: same problems with analog routing and no remote.
After I installed your tvtime version (had to install the deb version
as the sources are not available on your site (internal server
error)), there were some problems with libswscale (the link had other
name than tvtime was looking for), I renamed the link and that's how I
ended up with the error message I already wrote:
Access type not available

Any idea how to get rid of this or any feasible solution for the analog audio?

Thanks, Laszlo

>
> please pay attention to that line... it probably will not work with usb 1.0.
>
> Markus
