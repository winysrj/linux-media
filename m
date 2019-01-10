Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CE1C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 21:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C64120657
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 21:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfAJVOw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 16:14:52 -0500
Received: from mga12.intel.com ([192.55.52.136]:8350 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbfAJVOw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 16:14:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2019 13:14:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,462,1539673200"; 
   d="scan'208";a="124974467"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by FMSMGA003.fm.intel.com with SMTP; 10 Jan 2019 13:14:49 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 10 Jan 2019 23:14:48 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 01/10] video/hdmi: Add an enum for HDMI packet types
Date:   Thu, 10 Jan 2019 23:14:36 +0200
Message-Id: <20190110211445.24177-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190110211445.24177-1-ville.syrjala@linux.intel.com>
References: <20190110211445.24177-1-ville.syrjala@linux.intel.com>
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

v2: s/AUDIO_CP/ACP/ (Shashank)

Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Reviewed-by: Shashank Sharma <shashank.sharma@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 include/linux/hdmi.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
index d2bacf502429..927ad6451105 100644
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
+	HDMI_PACKET_TYPE_ACP = 0x04,
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
2.19.2

