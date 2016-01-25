Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10636 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435AbcAYMl6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 07:41:58 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH v3 0/4] List supported formats in libv4l2subdev
Date: Mon, 25 Jan 2016 14:39:41 +0200
Message-Id: <1453725585-4165-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Besides rebasing on:

[PATCH v2 1/1] v4l: libv4l2subdev: Precisely convert media bus string to code

- v4l2_subdev_pixelcode_list() now returns an entire array of pixel codes
  instead of a single code at a time and
- the set has been prepended by an additional patch to make the
  mbus_formats array const.

-- 
Kind regards,
Sakari

