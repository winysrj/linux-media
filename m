Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64792 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3L3NfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 08:35:03 -0500
Received: by mail-ee0-f42.google.com with SMTP id e53so5109583eek.29
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 05:35:03 -0800 (PST)
Message-ID: <52C176CA.2080401@googlemail.com>
Date: Mon, 30 Dec 2013 14:36:10 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: xc2028 i2c errors
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

With the Hauppauge HVR900 (em2882/3 / xc2028 / tvp5150 / zl10353), I'm
getting lot's of i2c error messages for ages:

...
[   99.590735] xc2028 10-0061: Error on line 1299: -19
[   99.645650] usbcore: registered new interface driver snd-usb-audio
[   99.755362] xc2028 10-0061: Error on line 1299: -19
[   99.824744] xc2028 10-0061: attaching existing instance
[   99.824750] xc2028 10-0061: type set to XCeive xc2028/xc3028 tuner
...
[  141.885510] xc2028 10-0061: i2c input error: rc = -19 (should be 2)
[  141.886496] xc2028 10-0061: i2c input error: rc = -19 (should be 2)
...


The "line 1299" errors occurs because the xc2028 driver tries to power
down the tuner although it is already powered down (surprise !).
The input errors occur at the beginning of xc2028_signal() and
xc2028_get_afc() when the driver tries to read the sync lock state and
it causes both functions to fail.
This also happens only when the device sleeps.
When not powering down the tuner, everthing works fine and no i2c errors
occur.

With other words: xc2028 power state handling is broken.
I don't have the datasheets and I'm not familiar with this device, so I
don't know what's the best way to fix it.
So unless anyone comes up with a better solution, I suggest to disable
the power-down.
Patch follows.

Regards,
Frank
