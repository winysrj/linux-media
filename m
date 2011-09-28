Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33805 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab1I1RGm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 13:06:42 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LS800KIVSV4ED60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Sep 2011 18:06:40 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LS800B9RSV4CA@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Sep 2011 18:06:40 +0100 (BST)
Date: Wed, 28 Sep 2011 19:06:34 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 0/2] Add v4l2 subdev driver for S5K6AAFX sensor
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	sw0312.kim@samsung.com, riverful.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1317229596-8140-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

The following change set is a third version of the subdev driver for S5K6AAFX sensor.

Changes since v2:
 - addressed Sakari's comments:
    use lower case used for all hexadecimal numbers,
    use usleep_range instead of udelay,
    move mirror flags to s5k6aa struct,
    remove static data from s5k6aa_preset struct
 - minimize I2C access in S_CTRL handler
 - return constant TRY format in subdev open()
 - added set_crop/get_crop ops 
 - fixed bugs in the internal PLL/clocks setup functions resulting
   in the firmware rejecting whole user configuration in some cases
 - added driver's private controls for RGB component gains
 - corrections per Hans' suggestions:
    removed unneeded v4l2_* subdev controls ops
 - patch 2/2 - no changes  	

Changes since v1:
 - improved s5k6aa_initialize_ctrls()
 - fixed pixel resolution update issue which resulted in cropping
   where scaling was expected
 - used V4L2_COLORFX_SKY_BLUE instead of V4L2_COLORFX_ALPHA   
 - dropped patch adding V4L2_COLORFX_AQUA entry for V4L2_CID_COLORFX control
 - patch 2/2 - no changes  	


Thanks again for all the review comments.

Sylwester Nawrocki (2):
  v4l: Add AUTO option for the V4L2_CID_POWER_LINE_FREQUENCY control
  v4l: Add v4l2 subdev driver for S5K6AAFX sensor

 Documentation/DocBook/media/v4l/controls.xml |    5 +-
 drivers/media/video/Kconfig                  |    7 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5k6aa.c                 | 1690 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |    1 +
 include/linux/videodev2.h                    |    1 +
 include/media/s5k6aa.h                       |   51 +
 7 files changed, 1754 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/video/s5k6aa.c
 create mode 100644 include/media/s5k6aa.h


Regards,
--
Sylwester Nawrocki
Samsung Poland R&D Center
