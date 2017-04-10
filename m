Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33497 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752099AbdDJUNn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 16:13:43 -0400
Received: by mail-oi0-f49.google.com with SMTP id b187so161555199oif.0
        for <linux-media@vger.kernel.org>; Mon, 10 Apr 2017 13:13:43 -0700 (PDT)
MIME-Version: 1.0
From: Patrick Doyle <wpdster@gmail.com>
Date: Mon, 10 Apr 2017 16:13:07 -0400
Message-ID: <CAF_dkJAwwj0mpOztkTNTrDC1YQkgh=HvZGh=tv3SYsuvUzTb+g@mail.gmail.com>
Subject: Looking for device driver advice
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am looking for advice regarding the construction of a device driver
for a MIPI CSI2 imager (a Sony IMX241) that is connected to a
MIPI<->Parallel converter (Toshiba TC358748) wired into a parallel
interface on a Soc (a Microchip/Atmel SAMAD2x device.)

The Sony imager is controlled and configured via I2C, as is the
Toshiba converter.  I could write a single driver that configures both
devices and treats them as a single device that just happens to use 2
i2c addresses.  I could use the i2c_new_dummy() API to construct the
device abstraction for the second physical device at probe time for
the first physical device.

Or I could do something smarter (or at least different), specifying
the two devices independently via my device tree file, perhaps linking
them together via "port" nodes.  Currently, I use the "port" node
concept to link an i2c imager to the Image System Controller (isc)
node in the SAMA5 device.  Perhaps that generalizes to a chain of
nodes linked together... I don't know.

I'm also not sure how these two devices might play into V4L2's
"subdev" concept.  Are they separate, independent sub devices of the
ISC, or are they a single sub device.

Any thoughts, intuition, pointers to existing code that addresses
questions such as these, would be welcome.

Thanks.

--wpd
