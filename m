Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:53451 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755597AbdKORLP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 12:11:15 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC v5 02/11] [media] vivid: add the V4L2_CAP_ORDERED capability
Date: Wed, 15 Nov 2017 15:10:48 -0200
Message-Id: <20171115171057.17340-3-gustavo@padovan.org>
In-Reply-To: <20171115171057.17340-1-gustavo@padovan.org>
References: <20171115171057.17340-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

vivid guarantees the ordering of buffer when processing then, so add the
V4L2_CAP_ORDERED capability to inform userspace of that.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/platform/vivid/vivid-core.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 5f316a5e38db..f19391fa2d6a 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -801,7 +801,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		dev->vid_cap_caps = dev->multiplanar ?
 			V4L2_CAP_VIDEO_CAPTURE_MPLANE :
 			V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OVERLAY;
-		dev->vid_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		dev->vid_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE |
+				     V4L2_CAP_ORDERED;
 		if (dev->has_audio_inputs)
 			dev->vid_cap_caps |= V4L2_CAP_AUDIO;
 		if (in_type_counter[TV])
@@ -814,7 +815,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 			V4L2_CAP_VIDEO_OUTPUT;
 		if (dev->has_fb)
 			dev->vid_out_caps |= V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
-		dev->vid_out_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		dev->vid_out_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE |
+				     V4L2_CAP_ORDERED;
 		if (dev->has_audio_outputs)
 			dev->vid_out_caps |= V4L2_CAP_AUDIO;
 	}
@@ -822,7 +824,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		/* set up the capabilities of the vbi capture device */
 		dev->vbi_cap_caps = (dev->has_raw_vbi_cap ? V4L2_CAP_VBI_CAPTURE : 0) |
 				    (dev->has_sliced_vbi_cap ? V4L2_CAP_SLICED_VBI_CAPTURE : 0);
-		dev->vbi_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		dev->vbi_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE |
+				     V4L2_CAP_ORDERED;
 		if (dev->has_audio_inputs)
 			dev->vbi_cap_caps |= V4L2_CAP_AUDIO;
 		if (in_type_counter[TV])
@@ -832,24 +835,26 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		/* set up the capabilities of the vbi output device */
 		dev->vbi_out_caps = (dev->has_raw_vbi_out ? V4L2_CAP_VBI_OUTPUT : 0) |
 				    (dev->has_sliced_vbi_out ? V4L2_CAP_SLICED_VBI_OUTPUT : 0);
-		dev->vbi_out_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		dev->vbi_out_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE |
+				     V4L2_CAP_ORDERED;
 		if (dev->has_audio_outputs)
 			dev->vbi_out_caps |= V4L2_CAP_AUDIO;
 	}
 	if (dev->has_sdr_cap) {
 		/* set up the capabilities of the sdr capture device */
 		dev->sdr_cap_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER;
-		dev->sdr_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		dev->sdr_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE |
+				     V4L2_CAP_ORDERED;
 	}
 	/* set up the capabilities of the radio receiver device */
 	if (dev->has_radio_rx)
 		dev->radio_rx_caps = V4L2_CAP_RADIO | V4L2_CAP_RDS_CAPTURE |
 				     V4L2_CAP_HW_FREQ_SEEK | V4L2_CAP_TUNER |
-				     V4L2_CAP_READWRITE;
+				     V4L2_CAP_READWRITE | V4L2_CAP_ORDERED;
 	/* set up the capabilities of the radio transmitter device */
 	if (dev->has_radio_tx)
 		dev->radio_tx_caps = V4L2_CAP_RDS_OUTPUT | V4L2_CAP_MODULATOR |
-				     V4L2_CAP_READWRITE;
+				     V4L2_CAP_READWRITE | V4L2_CAP_ORDERED;
 
 	ret = -ENOMEM;
 	/* initialize the test pattern generator */
-- 
2.13.6
