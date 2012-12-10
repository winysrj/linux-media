Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17084 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2LJTl5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 14:41:57 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
	thomas.abraham@linaro.org, t.figa@samsung.com,
	sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 00/13] Common video input interfaces bindings and V4L2 OF
 helpers
Date: Mon, 10 Dec 2012 20:41:26 +0100
Message-id: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This series is an update of work on common bindings for video capture
interfaces [1], [2] originally started by Guennadi. I took the liberty
of resending the original patches and adding my changes on top of it.

I just noticed there were some comments to the v5 of the bindings
documentation and the example. I might have addressed them in next
iteration, unless the author prefers to take care of that himself.

This series adds a bunch of empty function/macro definitions for
when CONFIG_OF(_DEVICE) is disabled, video capture interfaces common
bindings documentation, related OF helpers and some corrections/
enhancements of them.

Full tree containing this patch series can be browsed at [3].

[1] http://www.spinics.net/lists/linux-sh/msg13391.html
[2] http://www.spinics.net/lists/linux-sh/msg13111.html
[3] http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/v3.7-rc8-pq-camera-dt

Guennadi Liakhovetski (6):
  i2c: add dummy inline functions for when CONFIG_OF_I2C(_MODULE) isn't
    defined
  of: add a dummy inline function for when CONFIG_OF is not defined
  OF: define of_*_cmp() macros also if CONFIG_OF isn't set
  OF: make a function pointer argument const
  media: add V4L2 DT binding documentation
  media: add a V4L2 OF parser

Sylwester Nawrocki (7):
  of: Add empty for_each_available_child_of_node() macro definition
  of: Add empty of_find_device_by_node() function definition
  of: Add empty of_get_next_child() function definition
  v4l2-of: Support variable length of data-lanes property
  v4l2-of: Add v4l2_of_parse_data_lanes() function
  v4l2-of: Corrected v4l2_of_parse_link() function declaration
  v4l2-of: Replace "remote" property with "remote-endpoint"

 Documentation/devicetree/bindings/media/v4l2.txt |  162 ++++++++++++++++
 drivers/media/v4l2-core/Makefile                 |    3 +
 drivers/media/v4l2-core/v4l2-of.c                |  217 ++++++++++++++++++++++
 drivers/of/base.c                                |    4 +-
 include/linux/of.h                               |   36 +++-
 include/linux/of_i2c.h                           |   12 ++
 include/linux/of_platform.h                      |    7 +
 include/media/v4l2-of.h                          |   80 ++++++++
 8 files changed, 509 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/v4l2.txt
 create mode 100644 drivers/media/v4l2-core/v4l2-of.c
 create mode 100644 include/media/v4l2-of.h

--
1.7.9.5

