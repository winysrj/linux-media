Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:11054 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbcBXQ1i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 11:27:38 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH v5 0/4] List supported formats in libv4l2subdev
Date: Wed, 24 Feb 2016 18:25:24 +0200
Message-Id: <1456331128-7036-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

since v4:

- Refactor the loop to print supported formats (4th patch),

- Call the option to list the supported formats --known-mbus-fmts instead
  of adding a help topic.

-- 
Kind regards,
Sakari

