Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:28146 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbbIKKLQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 06:11:16 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [RFC 0/9] Unrestricted media entity ID range support
Date: Fri, 11 Sep 2015 13:09:03 +0300
Message-Id: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patchset adds an API for managing entity enumerations, i.e. storing a
bit of information per entity. The entity ID is no longer limited to small
integers (e.g. 31 or 63), but MEDIA_ENTITY_MAX_LOW_ID. The drivers are
also converted to use that instead of a fixed number.

If the number of entities in a real use case grows beyond the capabilities
of the approach, the algorithm may be changed. But most importantly, the
API is used to perform the same operation everywhere it's done.

I'm sending this for review only, the code itself is untested.

I haven't entirely made up my mind on the fourth patch. It could be
dropped, as it uses the API for a somewhat different purpose.

-- 
Kind regards,
Sakari

