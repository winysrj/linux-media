Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12844 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab3C2RkC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Mar 2013 13:40:02 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MKF00EVUNOR0480@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 29 Mar 2013 17:39:59 +0000 (GMT)
Message-id: <5155D1EE.1020201@samsung.com>
Date: Fri, 29 Mar 2013 18:39:58 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Cc: Rob Herring <rob.herring@calxeda.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR 3.10] Media DT bindings and V4L2 OF parsing library
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

This includes two patches adding device tree support at the V4L2 API.
I added Rob and Grant at Cc in case they still wanted to comment on
those patches. Not sure what the exact policy is but I guess we need
an explicit DT maintainer's Ack on stuff like this.

These patches have been discussed quite extensively and first versions
appeared about 6 months ago. Now we need DT support at the media
subsystem since some SoCs are already starting to loose non-dt booting
support upstream. Without this most of our media drivers would have been
pretty useless.

Thanks,
Sylwester

The following changes since commit 9e7664e0827528701074875eef872f2be1dfaab8:

  [media] solo6x10: The size of the thresholds ioctls was too large (2013-03-29
08:34:23 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git v4l_devicetree

for you to fetch changes up to 27ab1e94d69d9139d530a661832c7b3a047a69e0:

  [media] Add a V4L2 OF parser (2013-03-29 17:34:55 +0100)

----------------------------------------------------------------
Guennadi Liakhovetski (2):
      [media] Add common video interfaces OF bindings documentation
      [media] Add a V4L2 OF parser

 .../devicetree/bindings/media/video-interfaces.txt |  228 +++++++++++++++++
 drivers/media/v4l2-core/Makefile                   |    3 +
 drivers/media/v4l2-core/v4l2-of.c                  |  267 ++++++++++++++++++++
 include/media/v4l2-of.h                            |  111 ++++++++
 4 files changed, 609 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/video-interfaces.txt
 create mode 100644 drivers/media/v4l2-core/v4l2-of.c
 create mode 100644 include/media/v4l2-of.h

