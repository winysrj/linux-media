Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:39937 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750738AbeC3HaI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Mar 2018 03:30:08 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: extended-controls.rst: transmitter -> receiver
Message-ID: <2520fc49-575b-b847-cb50-284630489a5e@xs4all.nl>
Date: Fri, 30 Mar 2018 09:30:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_CID_DV_RX_POWER_PRESENT refers to a receiver, not a transmitter.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index d5f3eb6e674a..03931f9b1285 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -3565,7 +3565,7 @@ enum v4l2_dv_it_content_type -
     HDMI carries 5V on one of the pins). This is often used to power an
     eeprom which contains EDID information, such that the source can
     read the EDID even if the sink is in standby/power off. Each bit
-    corresponds to an input pad on the transmitter. If an input pad
+    corresponds to an input pad on the receiver. If an input pad
     cannot detect whether power is present, then the bit for that pad
     will be 0. This read-only control is applicable to DVI-D, HDMI and
     DisplayPort connectors.
