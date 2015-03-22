Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51579 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751890AbbCVVw2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 17:52:28 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	snawrocki@samsung.com
Subject: [PATCH v2 0/4] Add link-frequencies to struct v4l2_of_endpoint
Date: Sun, 22 Mar 2015 23:51:35 +0200
Message-Id: <1427061099-17438-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've split off the third and obviously somewhat problematic patch in the
set, and sent a pull req containing the first two patches and another
dependent patch:

<URL:http://www.spinics.net/lists/linux-media/msg88033.html>

The changes intend to address the review comments I gathered the last time.
The third patch of set 1 has been split into three, with the major
differences being that

- the interface functions are now called v4l2_of_alloc_parse_endpoint() and
  v4l2_of_free_endpoint(),

- v4l2_of_alloc_parse_endpoint() will allocate and return struct
  v4l2_of_endpoint. Correspondingly v4l2_of_free_endpoint() will release it,

- the usage pattern of existing users is unchanged, however new drivers are
  adviced to use the new interface. The old interface could be removed at
  some point when it no longer has users, however it is not urgent in any
  way.

v1 can be found here:

<URL:http://www.spinics.net/lists/linux-media/msg87479.html>

Comments are very welcome.

-- 
Kind regards,
Sakari

