Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:26339
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422713Ab3FUPsm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 11:48:42 -0400
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: media: i2c: mt9p031: HFLIP/VFLIP changes format
Date: Fri, 21 Jun 2013 15:48:25 +0000
Message-ID: <6EE9CD707FBED24483D4CB0162E8546745F4218E@AMSPRD0711MB532.eurprd07.prod.outlook.com>
Content-Language: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

In the mt9p031 driver, the picture can be flipped either horizontally
or vertically by using the according V4L2 controls. This can be done
at runtime.
I have noticed, that flipping the picture will change the bayer-pattern.
So if I flip horizontally and vertically to get a 180 degree rotation
the bayer pattern changes from
V4L2_MBUS_FMT_SGRBG12_1X12
to
V4L2_MBUS_FMT_SGBRG12_1X12
I'm not sure how the patch should look like...
The format code could be adapted accordingly to the flipping, but
how does the userspace notices this change? The user could issue
another get_format. But what about the omap3isp-pipe?
Concrete:
What should I do to configure a streaming pipe with a flipped image?
Flip the image on the v4l-subdev and then build the pipe?
Is there a chance to propagate the format change through the pipe
during streaming?

Thanks for your clarification!

Regards,
Florian

