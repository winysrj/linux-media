Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56370 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751800AbbCYW6g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 18:58:36 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 00/15] omap3isp driver DT support
Date: Thu, 26 Mar 2015 00:57:24 +0200
Message-Id: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

Here's an update to the omap3isp DT support patchset. v1 can be found here:

<URL:http://www.spinics.net/lists/linux-media/msg87733.html>

Changes since v1:

patch 10:

- Add Kconfig dependency to MFD_SYSCON

patch 12:

- Rename "lane-polarity" property as "lane-polarities"

patch 13:

- Add node name to warning print when there are too few lane polarities.

patch 14:

- Fix comment about sub-device node registration in isp_register_entities().

- Add endpoint name to a debug print in isp_of_parse_node().

- Rework isp_of_parse_nodes(). Fixed issue with putting the acquired nodes,
  and correctly register multiple async sub-devices.

- Rename rval as ret.

- Obtain syscon register index from DT.

Patch 15:

- Fix the number of users.

-- 
Kind regards,
Sakari

