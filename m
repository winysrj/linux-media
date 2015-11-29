Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39722 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752375AbbK2TWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2015 14:22:42 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v2 00/22] Unrestricted media entity ID range support
Date: Sun, 29 Nov 2015 21:20:01 +0200
Message-Id: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is the second version of the unrestricted media entity ID range
support patchset.

v1 of the set can be found here:

<URL:http://www.spinics.net/lists/linux-media/msg94425.html>

What has changed since v1:

- Updated documentation in Documentation/media-framework.txt (last patch).

- omap3isp: Moved entity enum cleanup from isp_video_streamon to
  isp_video_streamoff. This fixes memory-to-memory operation.

- Make media entity graph enumration API changes to davinci_vpfe staging
  driver as well.

- Document structs media_entity_enum, media_entity_graph and
  media_pipeline using KernelDoc.

-- 
Kind regards,
Sakari

