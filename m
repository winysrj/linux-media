Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:65058 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab3AaRTN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 12:19:13 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHI00CUN2RZWPB0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Feb 2013 02:19:11 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MHI00C3Z2RPHG80@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Feb 2013 02:19:11 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com, swarren@wwwdotorg.org,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, myungjoo.ham@samsung.com,
	sw0312.kim@samsung.com, prabhakar.lad@ti.com,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v5 0/2] V4L device tree bindings and OF helpers
Date: Thu, 31 Jan 2013 18:18:56 +0100
Message-id: <1359652738-1544-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This iteration mostly addresses comments from Laurent, regarding the
bindings documentation. It introduces a common 'ports' node grouping
all 'port' nodes, which could be used to resolve node addressing
conflict when a device has a bus with corresponding children nodes.

The changes in second patch are not significant, mostly rewrite
of v4l2_of_get_remote_parent() function.

Guennadi, I've added Samsung copyright notice in the parser code.
Please let me know if it is OK with you or not. If required I could
extract my changes into a separate patch.

I have also dropped the Reviewed-by/Acked-by tags, as the changes
this time were not trivial. If those still apply please reply and
I'll re-add them.

Guennadi Liakhovetski (2):
  [media] Add common video interfaces OF bindings documentation
  [media] Add a V4L2 OF parser

 .../devicetree/bindings/media/video-interfaces.txt |  216 +++++++++++++++++
 drivers/media/v4l2-core/Makefile                   |    3 +
 drivers/media/v4l2-core/v4l2-of.c                  |  251 ++++++++++++++++++++
 include/media/v4l2-of.h                            |   98 ++++++++
 4 files changed, 568 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/video-interfaces.txt
 create mode 100644 drivers/media/v4l2-core/v4l2-of.c
 create mode 100644 include/media/v4l2-of.h

--
1.7.9.5

