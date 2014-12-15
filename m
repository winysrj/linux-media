Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57042 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaLOQ3r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 11:29:47 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v2 0/3] Support data_offset and 10-bit packed raw bayer formats
Date: Mon, 15 Dec 2014 18:26:46 +0200
Message-Id: <1418660809-30548-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Compared to v1, a field remaining from the single plane data_offset support
patch has been removed. Also the kernel headers have been updated with the
10-bit packed raw bayer pixel format definitions.

-- 
Kind regards,
Sakari

