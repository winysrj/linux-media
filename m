Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D6DBC43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 15:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D4AF2145D
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 15:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387958AbeLQPzG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 10:55:06 -0500
Received: from mga06.intel.com ([134.134.136.31]:50789 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbeLQPzG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 10:55:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2018 07:55:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,365,1539673200"; 
   d="scan'208";a="119514391"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga001.jf.intel.com with SMTP; 17 Dec 2018 07:55:02 -0800
Received: by stinkbox (sSMTP sendmail emulation); Mon, 17 Dec 2018 17:55:01 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 01/10] video/hdmi: Add an enum for HDMI packet types
Date:   Mon, 17 Dec 2018 17:54:49 +0200
Message-Id: <20181217155458.5503-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20181217155458.5503-1-ville.syrjala@linux.intel.com>
References: <20181217155458.5503-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

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
index d2bacf502429..ade19b0cf9d2 100644
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
2.18.1

