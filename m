Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:32016 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbbKIN0O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Nov 2015 08:26:14 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 0/4] List supported formats in libv4l2subdev
Date: Mon,  9 Nov 2015 15:25:21 +0200
Message-Id: <1447075525-32321-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This set moves libv4l2subdev to use media bus format definitions instead
of the old V4L2 mbus formats. In addition, support is added to all
existing formats, as the format list is generated instead of manually
adding formats to the list. The media-ctl test program is amended by the
list of the formats which media-ctl itself supports.

These patches go on the top of the previous set I posted ("[v4l-utils
PATCH 0/2] Add field support to libv4l2subdev").

-- 
Kind regards,
Sakari

