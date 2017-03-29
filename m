Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:46673 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754235AbdC2H7P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 03:59:15 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] video.rst: a sensor is also considered to be a physical input
Message-ID: <d845d325-ce26-b7da-5c84-2ee898792454@xs4all.nl>
Date: Wed, 29 Mar 2017 09:59:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the line "Camera sensors are also considered to be a video input."

In practice all non-MC drivers for sensors support the input ioctls, and the
compliance test actually tests for the presence of these ioctls. So clarify
the documentation by explicitly mentioning sensors.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/video.rst b/Documentation/media/uapi/v4l/video.rst
index a205fb87d566..d2bc06b064ad 100644
--- a/Documentation/media/uapi/v4l/video.rst
+++ b/Documentation/media/uapi/v4l/video.rst
@@ -8,9 +8,10 @@ Video Inputs and Outputs

 Video inputs and outputs are physical connectors of a device. These can
 be for example RF connectors (antenna/cable), CVBS a.k.a. Composite
-Video, S-Video or RGB connectors. Video and VBI capture devices have
-inputs. Video and VBI output devices have outputs, at least one each.
-Radio devices have no video inputs or outputs.
+Video, S-Video and RGB connectors. Camera sensors are also considered to
+be a video input. Video and VBI capture devices have inputs. Video and
+VBI output devices have outputs, at least one each. Radio devices have
+no video inputs or outputs.

 To learn about the number and attributes of the available inputs and
 outputs applications can enumerate them with the
