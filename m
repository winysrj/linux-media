Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43921 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbZJTIO5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:14:57 -0400
Message-Id: <20091020011215.647378847@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:20 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC/PATCH 10/14] uvcvideo: Fix extension units parsing
References: <20091020011210.623421213@ideasonboard.com>
Content-Disposition: inline; filename=uvc-fix-extension-unit-parsing.diff
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bNrInPins field is an 8 bit integer, not a 16 bit integer.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_driver.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/uvc/uvc_driver.c
+++ v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_driver.c
@@ -835,7 +835,7 @@ static int uvc_parse_vendor_control(stru
 		unit->type = UVC_VC_EXTENSION_UNIT;
 		memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
 		unit->extension.bNumControls = buffer[20];
-		unit->extension.bNrInPins = get_unaligned_le16(&buffer[21]);
+		unit->extension.bNrInPins = buffer[21];
 		unit->extension.baSourceID = (__u8 *)unit + sizeof *unit;
 		memcpy(unit->extension.baSourceID, &buffer[22], p);
 		unit->extension.bControlSize = buffer[22+p];
@@ -1099,7 +1099,7 @@ static int uvc_parse_standard_control(st
 		unit->type = buffer[2];
 		memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
 		unit->extension.bNumControls = buffer[20];
-		unit->extension.bNrInPins = get_unaligned_le16(&buffer[21]);
+		unit->extension.bNrInPins = buffer[21];
 		unit->extension.baSourceID = (__u8 *)unit + sizeof *unit;
 		memcpy(unit->extension.baSourceID, &buffer[22], p);
 		unit->extension.bControlSize = buffer[22+p];


