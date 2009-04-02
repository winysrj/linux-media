Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:21355 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbZDBFQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 01:16:51 -0400
Received: by qw-out-2122.google.com with SMTP id 8so490793qwh.37
        for <linux-media@vger.kernel.org>; Wed, 01 Apr 2009 22:16:48 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 2 Apr 2009 00:16:48 -0500
Message-ID: <e3538fbd0904012216g48da5006hb170974530bdcea3@mail.gmail.com>
Subject: Broken ioctls for the mpeg encoder on the HVR-1800
From: Joseph Yasi <joe.yasi@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

With the cx23885 driver that shipped with 2.6.29, as well as the
latest hg driver, the analog mpeg encoder device for the HVR-1800 does
not respond to the VIDIOC_QUERYCAP ioctl, returning ENOTTY.  This
ioctl previously worked with the driver in 2.6.28.  The preview device
does respond to the ioctl properly, and I am able to tune and set the
input via the preview device.  I can also capture MPEG using a simple
cat /dev/video1 > out.mpg.  Are the ioctls supposed to work on the
mpeg device, or should it be tuned via the preview device only?

Thanks,
Joe Yasi
