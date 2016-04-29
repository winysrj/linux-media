Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27598 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbcD2IqU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 04:46:20 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: [PATCH 0/3] Refactor media IOCTL handling
Date: Fri, 29 Apr 2016 11:43:17 +0300
Message-Id: <1461919400-2658-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A number of years ago when someone (read: Laurent) added a new IOCTL to
the MC interface, I wanted IOCTL handling to be refactored. That wasn't
done however, so here are patches to do just that: there are too many
IOCTLs that copy the argument struct from the user and back.

The changes will also make the request API patches a little bit cleaner as
the argument copying is removed there. I'll post an RFC set on those in
the near future.

-- 
Kind regards,
Sakari

