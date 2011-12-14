Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:45240 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662Ab1LNPIw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 10:08:52 -0500
Date: Wed, 14 Dec 2011 17:08:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, t.stanislaws@samsung.com,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl, dacohen@gmail.com,
	andriy.shevchenko@linux.intel.com
Subject: [RFC v2 0/3] SUBDEV_S/G_SELECTION IOCTLs
Message-ID: <20111214150846.GM1967@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This RFC discusses the SUBDEV_S_SELECTION/SUBDEV_G_SELECTION API which is
intended to amend and replace the existing SUBDEV_[SG]_CROP API. These
IOCTLs have previously been discussed in the Cambridge V4L2 brainstorming
meeting [0] and their intent is to provide more configurability for subdevs,
including cropping on the source pads and composing for a display.

The S_SELECTION patches for V4L2 nodes are available here [1] and the
existing documentation for the V4L2 subdev pad format configuration can be
found in [2].

SUBDEV_[SG]_SELECTION is intended to fully replace SUBDEV_[SG]_CROP in
drivers as the latter can be implemented in SUBDEV_[SG]_SELECTION using
active CROP target on sink pads. That can be done in v4l2-ioctl.c so drivers
only will need to implement SUBDEV_[SG]_SELECTION.

If someone is interested in the compose operation on the source pad, I'd
like to have better documentation on it. I don't fully understand that use
case since I don't use it myself.

The original RFC is available in [4].

Questions, comments and thoughts are most welcome.


References
==========

[0] http://www.mail-archive.com/linux-media@vger.kernel.org/msg35361.html

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg36206.html

[2] http://hverkuil.home.xs4all.nl/spec/media.html#subdev

[3] http://www.mail-archive.com/linux-media@vger.kernel.org/msg36203.html

[4] http://www.spinics.net/lists/linux-media/msg39888.html


-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
