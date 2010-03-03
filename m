Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f212.google.com ([209.85.218.212]:56598 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0CCMpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Mar 2010 07:45:04 -0500
MIME-Version: 1.0
Date: Wed, 3 Mar 2010 13:45:00 +0100
Message-ID: <1820d69d1003030445n18b35839r407d4d277b1bf48d@mail.gmail.com>
Subject: Gspca USB driver zc3xx and STV06xx probe the same device ..
From: Gabriel C <nix.or.die@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I own a QuickCam Messanger webcam.. I didn't used it in ages but today
I plugged it in..
( Device 002: ID 046d:08da Logitech, Inc. QuickCam Messanger )

Now zc3xx and stv06xx are starting both to probe the device .. In
2.6.33 that result in a not working webcam.
( rmmod both && modprobe zc3xx one seems to fix that )

On current git head zc3xx works fine even when both are probing the device.

Also I noticed stv06xx fails anyway for my webcam with this error:
....

[  360.910243] STV06xx: Configuring camera
[  360.910244] STV06xx: st6422 sensor detected
[  360.910245] STV06xx: Initializing camera
[  361.161948] STV06xx: probe of 6-1:1.0 failed with error -32
[  361.161976] usbcore: registered new interface driver STV06xx
[  361.161978] STV06xx: registered
.....

Next thing is stv06xx tells it is an st6422 sensor and does not work
with it while zc3xx tells it is an HV7131R(c) sensor and works fine
with it.

What is right ?


Best Regards,

Gabriel C
