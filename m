Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f66.google.com ([209.85.212.66]:53661 "EHLO
	mail-vb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab3GaPzz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 11:55:55 -0400
Received: by mail-vb0-f66.google.com with SMTP id w16so329365vbb.9
        for <linux-media@vger.kernel.org>; Wed, 31 Jul 2013 08:55:52 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 31 Jul 2013 11:55:52 -0400
Message-ID: <CAJHRZ=K+oFtcTd-qCQexOZkdBwoYgL6mhmoQB0fxh0Z47nbpYg@mail.gmail.com>
Subject: 950Q CC Extraction (V4L2/VBI)
From: Trevor Anonymous <trevor.forums@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all, new to the list, hope this is an appropriate place to ask this.

Quick question:
I can extract NTSC analog closed captions with the Hauppauge 950Q as follows:
1. Run v4l2-ctl -i 1 ## Set input to composite
2. In a test application, open file /dev/video0
3. Read 1 byte from the file
** Note: This seems to be sufficient to "start" the device
** Calling VIDIOC_STREAMON ioctl is *not* sufficient
4. Run: zvbi-ntsc-cc -c -d /dev/vbi0 ## Prints the closed captions
5. Close file handle to /dev/video0 when finished. Device "stops".
My question: Is opening the device and reading 1 byte a good/ok way to
start the device? I'm only interested in closed captions, and want
this to be as small a footprint as possible. I'm worried that this
method may break in future driver versions.

-----


More details:
I'm involved in an automation project where we need to extract CEA-608
Closed Caption data (NTSC/VBI line 21) from an analog (RF and/or
composite) input stream.

I am evaluating the Hauppauge 950Q for this purpose. The one I've
received uses the xc5000c firmware.

I've found I can use mplayer/vlc to configure and start the device,
and zvbi-ntsc-cc to extract the data. But I need to make this as
simple and lightweight as possible (may want this to run with multiple
devices connected, or run on something like a Raspberry Pi). So I
figured out that reading 1 byte works as I detailed above works, just
not sure if this will suddenly break one day.
