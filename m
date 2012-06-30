Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45588 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752068Ab2F3RFL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 13:05:11 -0400
Date: Sat, 30 Jun 2012 20:05:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
Subject: [PATCH v5 0/8] V4L2 and V4L2 subdev selection target and flag
 changes
Message-ID: <20120630170506.GE19384@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Changed since the last time:

- Added V4L2 subdev backward compatibility definitions for *_ACTUAL
  targets (patch 2) and flags (patch 5). These are needed since the changes
  won't make it to 3.5.
- Added Sylwester's patch for feature removal documentation (patch 7).

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
