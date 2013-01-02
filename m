Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35029 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3ABJZY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 04:25:24 -0500
Received: by mail-wg0-f43.google.com with SMTP id e12so6456589wge.10
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 01:25:23 -0800 (PST)
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 2 Jan 2013 14:47:50 +0530
Message-ID: <CA+V-a8uK38_HrYa2ic5soLE=Ge0aK3=PObNCs_xMf=PAzcwBcg@mail.gmail.com>
Subject: DT bindings for subdevices
To: linux-media <linux-media@vger.kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is my first step towards DT support for media, Question might be
bit amateur :)

In the video pipeline there will be external devices (decoders/camera)
connected via
i2c, spi, csi. This sub-devices take platform data. So question is
moving ahead and
adding DT support for this subdevices how should this platform data be
passed through.
Should it be different properties for different devices.

For example the mt9t001 sensor takes following platform data:
struct mt9t001_platform_data {
	unsigned int clk_pol:1;
	unsigned int ext_clk;
};
similarly mt9p031 takes following platform data:

struct mt9p031_platform_data {
	int (*set_xclk)(struct v4l2_subdev *subdev, int hz);
	int reset;
	int ext_freq;
	int target_freq;
};

should this all be individual properties ?

Regards,
--Prabhakar
