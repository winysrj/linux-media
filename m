Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51222 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbbKGVXO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2015 16:23:14 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 0/2] Add field support to libv4l2subdev
Date: Sat,  7 Nov 2015 23:22:19 +0200
Message-Id: <1446931341-29254-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

The first patch of the set is actually a bugfix, libv4l2subdev depends on
libmediactl but v4l2subdev.h cannot assume that media-ctl.h has been
included before it. Instead, it adds a forward declaration for struct
media_device.

The second patch implements field support in libv4l2subdev format parsing.
The media-ctl test program will get field support as well. I pondered for
a while which approach to take, and decided to adopt Laurent's preliminary
patch which keeps "field:" as separate from "fmt:". The patch has some
improvements over Laurent's original version.

-- 
Kind regards,
Sakari

