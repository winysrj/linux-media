Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51935 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbcDHTgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2016 15:36:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: javier@osg.samsung.com, sakari.ailus@iki.fi
Subject: [PATCH 0/3] raw2rgbpnm support for NV16/61, YUV420 and RGB332
Date: Fri,  8 Apr 2016 22:36:11 +0300
Message-Id: <1460144174-25569-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The subject says it all, please see individual patches.

Laurent Pinchart (3):
  Add support for NV16 and NV61 formats
  Add support for YUV420 format
  Add support for RGB332 format

 raw2rgbpnm.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

-- 
Regards,

Laurent Pinchart

