Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36208 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbaGQLYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 07:24:14 -0400
Received: from avalon.localnet (unknown [91.178.197.224])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id E74D4359FA
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 13:23:06 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.17] Replace V4L2_FIELD_ANY with V4L2_FIELD_NONE in subdev drivers
Date: Thu, 17 Jul 2014 13:24:17 +0200
Message-ID: <3263187.shyCyf3hmE@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 3c0d394ea7022bb9666d9df97a5776c4bcc3045c:

  [media] dib8000: improve the message that reports per-layer locks 
(2014-07-07 09:59:01 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/field

for you to fetch changes up to dce4c80f5842f80527c31b8a07e2910b5d489ee6:

  v4l: s3c-camif: Return V4L2_FIELD_NONE from pad-level set format (2014-07-17 
13:16:51 +0200)

----------------------------------------------------------------
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

