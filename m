Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50682 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754027AbaDLNYP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Apr 2014 09:24:15 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v3 00/11] Timestamp source and mem-to-mem device support
Date: Sat, 12 Apr 2014 16:23:52 +0300
Message-Id: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is the third version of the timestamp source and mem-to-mem device
support patchset.

Change since v2:

- struct device type remains enum v4l2_buf_type

- Added a struct which contains the 1:1 mapping between V4L2 buffer type,
  verbose textual representation of it (which already existed), and a
  command line option. A function for converting the former to the first is
  provided as well.

- struct device is no longer manipulated in main(), with the few exceptions
  that existed before the patchset. Instead, functions are provided to
  access it.

- -Q (--queue-type) has been replaced with -B (--buffer-type).

- Added a patch to shorten the timestamp type names.

- Added another patch to shorten the string printed for each dequeued
  buffer.

- Invalid buffer types are rejected now by yavta.

- Removed useless use of else.

-- 
Kind regards,
Sakari

