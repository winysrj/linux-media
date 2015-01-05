Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbbAEXu0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jan 2015 18:50:26 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH 0/2] Data prefix writing fixes
Date: Tue,  6 Jan 2015 01:50:13 +0200
Message-Id: <1420501815-3684-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Just a small fix (and a better name) for the --buffer-prefix option
implementation. The original patch didn't quite work as intended.

-- 
Kind regards,
Sakari

