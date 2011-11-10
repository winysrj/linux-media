Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1465 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab1KJJ0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 04:26:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: soc_camera.h compiler warning: should be fixed
Date: Thu, 10 Nov 2011 10:26:47 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111101026.47226.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

The daily build gives these compiler warnings when compiling on a 64-bit
platform:

In file included from drivers/media/video/imx074.c:19:0:
include/media/soc_camera.h: In function ‘soc_camera_i2c_to_vdev’:
include/media/soc_camera.h:257:34: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
In file included from drivers/media/video/mt9m111.c:18:0:
include/media/soc_camera.h: In function ‘soc_camera_i2c_to_vdev’:
include/media/soc_camera.h:257:34: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

(and a whole bunch more of these warnings).

The culprit is this inline function:

static inline struct video_device *soc_camera_i2c_to_vdev(const struct i2c_client *client)
{
        struct v4l2_subdev *sd = i2c_get_clientdata(client);
        struct soc_camera_device *icd = (struct soc_camera_device *)sd->grp_id;
        return icd ? icd->vdev : NULL;
}

sd->grp_id is a u32, so obviously this will fail on a 64-bit arch.

Since ARM is moving to 64-bits as well we should fix this.

Instead of abusing grp_id it is better to use the relatively new v4l2_subdev
'host_priv' field. This is a proper void pointer, and can be used by the host
driver as it pleases.

Can you make a patch for this? It would be nice to get rid of these warnings.

Regards,

	Hans
