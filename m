Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20745 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727171AbeIUAg7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 20:36:59 -0400
From: Ville Syrjala <ville.syrjala@linux.intel.com>
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 05/18] video/hdmi: Add an enum for HDMI packet types
Date: Thu, 20 Sep 2018 21:51:32 +0300
Message-Id: <20180920185145.1912-6-ville.syrjala@linux.intel.com>
In-Reply-To: <20180920185145.1912-1-ville.syrjala@linux.intel.com>
References: <20180920185145.1912-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

We'll be wanting to send more than just infoframes over HDMI. So add an
enum for other packet types.

TODO: Maybe just include the infoframe types in the packet type enum
      and get rid of the infoframe type enum?

Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 include/linux/hdmi.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
index c76b50a48e48..80521d9591a1 100644
--- a/include/linux/hdmi.h
+++ b/include/linux/hdmi.h
@@ -27,6 +27,21 @@
 #include <linux/types.h>
 #include <linux/device.h>
 
+enum hdmi_packet_type {
+	HDMI_PACKET_TYPE_NULL = 0x00,
+	HDMI_PACKET_TYPE_AUDIO_CLOCK_REGEN = 0x01,
+	HDMI_PACKET_TYPE_AUDIO_SAMPLE = 0x02,
+	HDMI_PACKET_TYPE_GENERAL_CONTROL = 0x03,
+	HDMI_PACKET_TYPE_AUDIO_CP = 0x04,
+	HDMI_PACKET_TYPE_ISRC1 = 0x05,
+	HDMI_PACKET_TYPE_ISRC2 = 0x06,
+	HDMI_PACKET_TYPE_ONE_BIT_AUDIO_SAMPLE = 0x07,
+	HDMI_PACKET_TYPE_DST_AUDIO = 0x08,
+	HDMI_PACKET_TYPE_HBR_AUDIO_STREAM = 0x09,
+	HDMI_PACKET_TYPE_GAMUT_METADATA = 0x0a,
+	/* + enum hdmi_infoframe_type */
+};
+
 enum hdmi_infoframe_type {
 	HDMI_INFOFRAME_TYPE_VENDOR = 0x81,
 	HDMI_INFOFRAME_TYPE_AVI = 0x82,
-- 
2.16.4
