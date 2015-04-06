Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37688 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751948AbbDFW7A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2015 18:59:00 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com
Subject: [PATCH v3 0/4] Add link-frequencies to struct v4l2_of_endpoint
Date: Tue,  7 Apr 2015 01:57:28 +0300
Message-Id: <1428361053-20411-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This set changes the interface which is used to parse the properties of the
endpoint for media devices.

changes since v2:

- Rebased on current media-tree

v2 can be found here:

http://www.spinics.net/lists/linux-media/msg88058.html

-- 
Regards,
Sakari

