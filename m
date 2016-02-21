Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54812 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbcBUVcF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 16:32:05 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 0/4] List supported formats in libv4l2subdev
Date: Sun, 21 Feb 2016 23:29:43 +0200
Message-Id: <1456090187-1191-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've changed the patches according to comments from Laurent.

since v2:

- Remove the guardian (format code zero at the end of the list).

- v4l2_subdev_pixelcode_list() called only once pre printing the list.

-- 
Kind regards,
Sakari

