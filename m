Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44306 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753290AbeEURBm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:01:42 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v10 03/16] hackrf: group device capabilities
Date: Mon, 21 May 2018 13:59:33 -0300
Message-Id: <20180521165946.11778-4-ezequiel@collabora.com>
In-Reply-To: <20180521165946.11778-1-ezequiel@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Instead of putting V4L2_CAP_STREAMING and V4L2_CAP_READWRITE
everywhere, set device_caps earlier with these values.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/usb/hackrf/hackrf.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 7eb53517a82f..6d692fb3e8dd 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -909,18 +909,15 @@ static int hackrf_querycap(struct file *file, void *fh,
 
 	dev_dbg(&intf->dev, "\n");
 
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
 	if (vdev->vfl_dir == VFL_DIR_RX)
-		cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER |
-				   V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
-
+		cap->device_caps |= V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER;
 	else
-		cap->device_caps = V4L2_CAP_SDR_OUTPUT | V4L2_CAP_MODULATOR |
-				   V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		cap->device_caps |= V4L2_CAP_SDR_OUTPUT | V4L2_CAP_MODULATOR;
 
 	cap->capabilities = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER |
 			    V4L2_CAP_SDR_OUTPUT | V4L2_CAP_MODULATOR |
-			    V4L2_CAP_STREAMING | V4L2_CAP_READWRITE |
-			    V4L2_CAP_DEVICE_CAPS;
+			    V4L2_CAP_DEVICE_CAPS | cap->device_caps;
 	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
 	strlcpy(cap->card, dev->rx_vdev.name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
-- 
2.16.3
