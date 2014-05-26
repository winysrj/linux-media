Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49557 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaEZTFw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:05:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH 0/6] Fix the format field order value for progressive subdevs
Date: Mon, 26 May 2014 21:05:59 +0200
Message-Id: <1401131165-3542-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set fixes five sensor drivers and one camera interface driver to
return a format field order value set to V4L2_FIELD_NONE instead of
V4L2_FIELD_ANY.

V4L2_FIELD_ANY is used by applications to notify the driver that they don't
care about the interlaced video field order. The value must never be returned
by drivers, they must instead select a default field order they support.

The six drivers fixed by this patch all forgot to initialize the field order,
resulting in V4L2_FIELD_ANY (=0) being returned. As all those drivers support
progressive video only, make them return V4L2_FIELD_NONE instead.

Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sangwook Lee <sangwook.lee@linaro.org>

Laurent Pinchart (6):
  v4l: noon010p30: Return V4L2_FIELD_NONE from pad-level set format
  v4l: s5k4ecgx: Return V4L2_FIELD_NONE from pad-level set format
  v4l: s5k5baf: Return V4L2_FIELD_NONE from pad-level set format
  v4l: s5k6a3: Return V4L2_FIELD_NONE from pad-level set format
  v4l: smiapp: Return V4L2_FIELD_NONE from pad-level get/set format
  v4l: s3c-camif: Return V4L2_FIELD_NONE from pad-level set format

 drivers/media/i2c/noon010pc30.c                  | 1 +
 drivers/media/i2c/s5k4ecgx.c                     | 1 +
 drivers/media/i2c/s5k5baf.c                      | 2 ++
 drivers/media/i2c/s5k6a3.c                       | 1 +
 drivers/media/i2c/smiapp/smiapp-core.c           | 3 +++
 drivers/media/platform/s3c-camif/camif-capture.c | 2 ++
 6 files changed, 10 insertions(+)

-- 
Regards,

Laurent Pinchart

