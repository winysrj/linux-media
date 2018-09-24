Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.intenta.de ([178.249.25.132]:35156 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbeIXQRV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Sep 2018 12:17:21 -0400
Received: from [10.10.16.42] (port=19784 helo=ICSMA001.intenta.de)
        by mail.intenta.de with esmtps (TLSv1.2:AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <Helmut.Grohne@intenta.de>)
        id 1g4NuD-0004lT-2s
        for linux-media@vger.kernel.org; Mon, 24 Sep 2018 12:15:53 +0200
Date: Mon, 24 Sep 2018 12:15:53 +0200
From: Helmut Grohne <helmut.grohne@intenta.de>
To: <linux-media@vger.kernel.org>
Subject: Use of V4L2_SEL_TGT_CROP_DEFAULT in i2c subdev drivers
Message-ID: <20180924101551.ijcyykf244sb6c4m@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Documentation/media/uapi/v4l/v4l2-selection-targets.rst says that
V4L2_SEL_TGT_CROP_DEFAULT is not valid for subdev drivers. Looking into
drivers/media/i2c (which contains only subdev drivers except for
video-i2c.c), the following drivers implement V4L2_SEL_TGT_CROP_DEFAULT:

ak881x.c
mt9m111.c
mt9t112.c
ov2640.c
ov6650.c
ov772x.c
rj54n1cb0c.c
soc_camera/mt9m001.c
soc_camera/mt9t112.c
soc_camera/mt9v022.c
soc_camera/ov5642.c
soc_camera/ov772x.c
soc_camera/ov9640.c
soc_camera/ov9740.c
soc_camera/rj54n1cb0c.c
tvp5150.c

The majority of drivers behave equally for V4L2_SEL_TGT_CROP_DEFAULT and
V4L2_SEL_TGT_CROP_BOUNDS. The only exceptions are mt9t112.c and
soc_camera/mt9t112.c. Actually these two look very similar. A
significant fraction of differences is white space, case and operand
order.

Is this a bug in 16 drivers? Is this a documentation bug? Am I getting
something wrong?

Helmut
