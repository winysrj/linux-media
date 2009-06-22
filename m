Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:44357 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbZFVVNV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 17:13:21 -0400
Received: by bwz9 with SMTP id 9so3499935bwz.37
        for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 14:13:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <88b49f150906221001i7d8eb7c5x2af79452398c5c9e@mail.gmail.com>
References: <88b49f150906211444u39a8eae1v77a15f32e4062775@mail.gmail.com>
	 <d9def9db0906212339k3af44f3dg80fe119784391dfe@mail.gmail.com>
	 <88b49f150906220027n17820baaxd4d4f63238a18de8@mail.gmail.com>
	 <88b49f150906221001i7d8eb7c5x2af79452398c5c9e@mail.gmail.com>
Date: Mon, 22 Jun 2009 21:13:23 +0000
Message-ID: <d9def9db0906221413s2619dfaew440747836f65671b@mail.gmail.com>
Subject: Re: [linux-dvb] Kworld DVB-T 323UR problems
From: Markus Rechberger <mrechberger@gmail.com>
To: Laszlo Kustan <lkustan@gmail.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 22, 2009 at 5:01 PM, Laszlo Kustan<lkustan@gmail.com> wrote:
> Hi again,
> Here is the correct dmesg output when my usb port is recognized
> properly The output is kind of weird, because this tuner does not have
> radio but according to dmesg it is switching the device to FM mode...
>
> [  550.908041] usb 1-4: new high speed USB device using ehci_hcd and address 6
> [  551.075241] usb 1-4: configuration #1 chosen from 1 choice
> [  551.075525] em28xx: new video device (eb1a:e323): interface 0, class 255
> [  551.075530] em28xx: device is attached to a USB 2.0 bus
> [  551.075536] em28xx #0: Alternate settings: 8
> [  551.075540] em28xx #0: Alternate setting 0, max size= 0
> [  551.075544] em28xx #0: Alternate setting 1, max size= 0
> [  551.075548] em28xx #0: Alternate setting 2, max size= 1448
> [  551.075553] em28xx #0: Alternate setting 3, max size= 2048
> [  551.075557] em28xx #0: Alternate setting 4, max size= 2304
> [  551.075561] em28xx #0: Alternate setting 5, max size= 2580
> [  551.075565] em28xx #0: Alternate setting 6, max size= 2892
> [  551.075569] em28xx #0: Alternate setting 7, max size= 3072
> [  551.658207] attach_inform: tvp5150 detected.
> [  551.720539] tvp5150 5-005c: tvp5150am1 detected.
> [  553.360916] successfully attached tuner
> [  553.368599] em28xx #0: V4L2 VBI device registered as /dev/vbi0
> [  553.389033] em28xx #0: V4L2 device registered as /dev/video0
> [  553.389041] em28xx-audio.c: probing for em28x1 non standard usbaudio
> [  553.389045] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> [  553.421218] em2880-dvb.c: DVB Init
> [  554.076418] DVB: registering new adapter (em2880 DVB-T)
> [  554.076431] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
> [  554.081209] em28xx #0: Found KWorld E323
> [  554.410650] opening radio device and trying to acquire exclusive lock
> [  554.410661] switching device to FM mode
>

true, I'm updating the driver this weekend then the latest version
will be online again.
I have the device here too but haven't used it for ages...

Markus
