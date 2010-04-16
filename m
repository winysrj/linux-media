Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:27179 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab0DPIpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Apr 2010 04:45:11 -0400
Message-ID: <4BC81EEF.3000107@hni.uni-paderborn.de>
Date: Fri, 16 Apr 2010 10:25:19 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: pxa_camera + ov9655: image shifted on first capture after reset
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have updated my ov9655 driver to kernel 2.6.33 and
did some test regarding the image shift problem on pxa.
(http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/10773/focus=11810)

- The image was shifted 32 pixels (64 bytes) to the right
  or rather the first 32 pixels belongs to the previous image.
- The image was only shifted on the first capture after reset.
   It doesn't matter whether I previous change the resolution with v4l2-ctl.
- On big images (1280 x 1024) the shift disappears after some images,
   but not on small images (320 x 240).

It looks like the FIFO was not cleared at start capture.

Regards,
    Stefan
