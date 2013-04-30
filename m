Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:65143 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3D3EVT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Apr 2013 00:21:19 -0400
Received: by mail-vb0-f54.google.com with SMTP id w16so78387vbf.27
        for <linux-media@vger.kernel.org>; Mon, 29 Apr 2013 21:21:18 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 30 Apr 2013 07:21:18 +0300
Message-ID: <CABuUpSUen2fsq_xFGxatBjEtxjNRNjWOK6LbG8RYjRweojUr9g@mail.gmail.com>
Subject: V4L2: Get device/input status
From: Vadim Golopupov <vgolopupov@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have plugged in usb digital camera (it has one input pin - 0).

I check input status every 5 seconds via structure: v4l2_input (here
is the example: http://pastebin.com/X9Z23DbZ), to process situation if
one of the flags is set (V4L2_IN_ST_NO_POWER or V4L2_IN_ST_NO_SIGNAL
or V4L2_IN_ST_NO_H_LOCK).

The problem is that even i unplug my usb digital camera, the input
status is always 0 (0x00).

Why the driver does not change input status flag when the device is unplugged?

Maybe it is possible to check device status not only input pin? If
yes, then which ioctl request should be set...?


Operating system: Linux 2.6.32-5-amd64 #1 SMP Mon Feb 25 00:26:11 UTC
2013 x86_64 GNU/Linux
