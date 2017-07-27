Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:53552 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750836AbdG0Jao (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 05:30:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 3/3] media/doc: improve the SMPTE 2084 documentation
Date: Thu, 27 Jul 2017 11:30:32 +0200
Message-Id: <20170727093032.12663-4-hverkuil@xs4all.nl>
In-Reply-To: <20170727093032.12663-1-hverkuil@xs4all.nl>
References: <20170727093032.12663-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Make note of the different luminance ranges between HDR and SDR.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 Documentation/media/uapi/v4l/colorspaces-details.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/media/uapi/v4l/colorspaces-details.rst b/Documentation/media/uapi/v4l/colorspaces-details.rst
index 47d7d1915284..b5d551b9cc8f 100644
--- a/Documentation/media/uapi/v4l/colorspaces-details.rst
+++ b/Documentation/media/uapi/v4l/colorspaces-details.rst
@@ -793,3 +793,15 @@ Transfer function:
 Inverse Transfer function:
     L = (max(L':sup:`1/m2` - c1, 0) / (c2 - c3 *
     L'\ :sup:`1/m2`))\ :sup:`1/m1`
+
+Take care when converting between this transfer function and non-HDR transfer
+functions: the linear RGB values [0…1] of HDR content map to a luminance range
+of 0 to 10000 cd/m\ :sup:`2` whereas the linear RGB values of non-HDR (aka
+Standard Dynamic Range or SDR) map to a luminance range of 0 to 100 cd/m\ :sup:`2`.
+
+To go from SDR to HDR you will have to divide L by 100 first. To go in the other
+direction you will have to multiply L by 100. Of course, this clamps all
+luminance values over 100 cd/m\ :sup:`2` to 100 cd/m\ :sup:`2`.
+
+There are better methods, see e.g. :ref:`colimg` for more in-depth information
+about this.
-- 
2.13.1
