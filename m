Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1611 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030208Ab2HQIBr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 04:01:47 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id q7H81i7V086126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 10:01:46 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.186])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id DB5B035E00A5
	for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 10:01:42 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] V4L2: add missing pieces to support HDMI et al and add adv7604/ad9389b drivers
Date: Fri, 17 Aug 2012 10:01:43 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208171001.43445.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

There have been no comments since RFCv3 of this patch series, so this is the
final pull request.

RFCv3 is here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg50265.html

Changes since RFCv3:

Changed the ioctl numbers for the SUBDEV_G/S_EDID ioctls to unused numbers from
videodev2.h to prevent potential clashes.

Regards,

	Hans

The following changes since commit 88f8472c9fc6c08f5113887471f1f4aabf7b2929:

  [media] Fix some Makefile rules (2012-08-16 19:55:03 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git hdmi3

for you to fetch changes up to eed20bebd69e227595ccda188826d016a26bb7aa:

  ad9389b: driver for the Analog Devices AD9389B video encoder. (2012-08-17 09:55:54 +0200)

----------------------------------------------------------------
Hans Verkuil (8):
      v4l2 core: add the missing pieces to support DVI/HDMI/DisplayPort.
      V4L2 spec: document the new DV controls and ioctls.
      v4l2-subdev: add support for the new edid ioctls.
      v4l2-ctrls.c: add support for the new DV controls.
      v4l2-common: add v4l_match_dv_timings.
      v4l2-common: add CVT and GTF detection functions.
      adv7604: driver for the Analog Devices ADV7604 video decoder.
      ad9389b: driver for the Analog Devices AD9389B video encoder.

 Documentation/DocBook/media/v4l/biblio.xml    |   40 ++
 Documentation/DocBook/media/v4l/controls.xml  |  161 +++++++
 Documentation/DocBook/media/v4l/v4l2.xml      |    1 +
 drivers/media/i2c/Kconfig                     |   23 +
 drivers/media/i2c/Makefile                    |    2 +
 drivers/media/i2c/ad9389b.c                   | 1328 +++++++++++++++++++++++++++++++++++++++++++++++++++++                           
 drivers/media/i2c/adv7604.c                   | 1959 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
 drivers/media/v4l2-core/v4l2-common.c         |  358 +++++++++++++++                                                                 
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   57 +++                                                                             
 drivers/media/v4l2-core/v4l2-ctrls.c          |   39 ++                                                                              
 drivers/media/v4l2-core/v4l2-ioctl.c          |   13 +                                                                               
 drivers/media/v4l2-core/v4l2-subdev.c         |    6 +                                                                               
 include/linux/v4l2-subdev.h                   |   10 +                                                                               
 include/linux/videodev2.h                     |   23 +                                                                               
 include/media/ad9389b.h                       |   49 ++                                                                              
 include/media/adv7604.h                       |  153 +++++++                                                                         
 include/media/v4l2-chip-ident.h               |    6 +                                                                               
 include/media/v4l2-common.h                   |   13 +                                                                               
 include/media/v4l2-subdev.h                   |    2 +                                                                               
 19 files changed, 4243 insertions(+)                                                                                                 
 create mode 100644 drivers/media/i2c/ad9389b.c                                                                                       
 create mode 100644 drivers/media/i2c/adv7604.c                                                                                       
 create mode 100644 include/media/ad9389b.h                                                                                           
 create mode 100644 include/media/adv7604.h
