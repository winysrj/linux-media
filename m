Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43944 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab1GYInX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 04:43:23 -0400
Received: by vws1 with SMTP id 1so2804170vws.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jul 2011 01:43:23 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 25 Jul 2011 16:43:21 +0800
Message-ID: <CAOy7-nMnE6_z4pAmw+Jc1riYSeCWwiNS2=_Ya==+7q5=bNrWuw@mail.gmail.com>
Subject: Parallel CMOS Image Sensor with UART Control Interface
From: James <angweiyang@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

Does anyone came across a v4l2 Linux Device Driver for an Image Sensor
that uses Parallel CMOS H/V and can only be control by UART interface
instead of the common I2C or SPI interface?

A similar sensor is the STMicroelectronics VL5510 Image Sensor
although it support all 3 types of control interface.
(http://www.st.com/internet/automotive/product/178477.jsp)

Most or all the drivers found I found under drivers/media/video uses
the I2C or SPI interface instead

I'm new to writing driver and need a reference v4l2 driver for this
type of image sensor to work with OMAP3530 ISP port on Gumstix's Overo
board.

I just need a very simple v4l2 driver that can extract the image from
the sensor and control over it via the UART control interface.

Any help is very much appreciated.

Thanks in adv.

-- 
Regards,
James
