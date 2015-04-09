Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40197 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753385AbbDIV0E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 17:26:04 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com
Subject: [PATCH v4 0/4] Add link-frequencies to struct v4l2_of_endpoint
Date: Fri, 10 Apr 2015 00:25:02 +0300
Message-Id: <1428614706-8367-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

Here's the fourth version of the link-frequencies patchset, which also
changes how the v4l2_of_endpoint is used.

Since v3:

patch 2:

- Use "zero" when referring to zeroing memory instead of clean.

patch 3:

- Fix interface documentation language.

v3 is available here:

<URL:http://www.spinics.net/lists/linux-media/msg88466.html>

-- 
Kind regards,
Sakari

