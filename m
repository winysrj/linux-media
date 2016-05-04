Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61030 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbcEDL2m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 07:28:42 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [PATCH 0/3] Media device file handle support, prepare for requests
Date: Wed,  4 May 2016 14:25:30 +0300
Message-Id: <1462361133-23887-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

These patches add support for media device file handle and make it more
practical to have callback functions in the media device. Also pad
init_cfg() operation is called at sub-device open.

While not directly related to the request API, these will be needed, or
are at least beneficial in implementing it.

I believe we could merge them before the request API as I don't think they
contain controversial aspects (there will be enough of them in the request
API patches themselves) so we could better focus on the problem at hand.

The patches have been written by Laurent, I've rebased them and fixed
minor issues as well.

-- 
Kind regards,
Sakari

