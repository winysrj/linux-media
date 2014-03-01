Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45699 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752207AbaCANN6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Mar 2014 08:13:58 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, k.debski@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: [PATCH v6 00/10] Fix buffer timestamp documentation, add new timestamp flags
Date: Sat,  1 Mar 2014 15:16:57 +0200
Message-Id: <1393679828-25878-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the 6th and hopefully the final version of the set.

What has changed since v5.2:
- Got a patch from Hans to fix timestamp issues in vb2 (1st one). That's
  unchanged.
- Renamed the vb2_queue.timestamp_type field as timestamp_flags (patch 4).
- Add a note that on mem-to-mem devices the timestamp source may vary from
  buffer to buffer (patch 10).
- Copy timestamp source from source buffers to destination (patch 6).

Testing has been done on uvc and mem2mem_testdev.

Unless something serious is found I'll send a pull request tomorrow.

-- 
Kind regards,
Sakari


