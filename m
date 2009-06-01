Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f123.google.com ([209.85.216.123]:41155 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbZFAEyS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2009 00:54:18 -0400
Received: by pxi29 with SMTP id 29so2534569pxi.33
        for <linux-media@vger.kernel.org>; Sun, 31 May 2009 21:54:19 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 1 Jun 2009 13:54:19 +0900
Message-ID: <5e9665e10905312154g1f33ea9bl66d905bc8e3e06a8@mail.gmail.com>
Subject: Anyone working on MIPI CSI-2 device?
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: linux-media@vger.kernel.org
Cc: saaquirre@ti.com, dcurran@ti.com,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>,
	=?EUC-KR?B?uc66tMij?= <bhmin@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Is anybody working on MIPI CSI-2 device? which is the standard of
Camera Serial Interface.
I started working on a camera module and camera interface supporting
this feature and getting started with studying the specification of
CSI-2 and in the meantime I've got some decisions to be made.

First one is how to handle virtual channels in V4L2 aspect.
As far as I understand,  the virtual channel is to share bandwidth of
a serial channel with multiple data types (up-to 4) which could be
considered as multiple camera devices. And we need to configure the
"virtual ID" for each device using the serial interface which
representing their virtual channel identifier used to isolate the data
from other devices. So it means that if the image fetching and
processing H/W can process multiple camera devices at a time it could
be possible to consider that we have multiple input devices. But one
thing obviously different from the dual camera model is that these
identifiers are necessary only for sharing the bandwidth for
simultaneous accessing situation. I'm not sure whether the switching
input should be necessary or not, but we obviously have multiple
inputs.
Actually I have no idea about the usecase of this and asking you some
advise about how to build up the driver in V4L2 aspect if any of you
have experience on it.


Second one is about the necessity for user space to be aware of the
interface is parallel or serial.
The answer of this question should depend on the answer of the first
question because of the switching input thing. To make it easier to
understand, let me put an example in this way.
I have a couple of cameras devices attached with parallel interface
and I can use only one at a time, and I have couple of cameras
attached with CSI-2 interface but I can use both of them at the same
time. So, with this assumption I should have four v4l2 device nodes
but only two of them (CSI-2) can be accessed simultaneously and the
others should be handled with VIDIOC_S_INPUT which means "can't be
used simultaneously".
Confusing isn't it? There is no way to let user know about which one
is switchable and which one can be used at the same time.

I think OMAP3 from TI is supporting for MIPI CSI-2 interface, and
heard that driver is working properly by now. I wish I could have some
advise if I could. I think there are plenty of S/W API stuffs to be
generalized in common in camera area.
Cheers,

Nate

-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
