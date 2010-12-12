Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1656 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab0LLRcG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:06 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1M8002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:02 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 00/19] Convert subdevs to the control fw and related fixes
Date: Sun, 12 Dec 2010 18:31:42 +0100
Message-Id: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch series converts a number of subdev drivers to use the control
framework. In addition, it also converts the cx18 and vivi drivers to the control
framework.

This has been tested with the vivi, cx18 and em28xx drivers.

As a result of these tests bugs relating to ENUM_INPUT/OUTPUT and some
incorrect checks in em28xx and the control framework were fixed.

It would be great if someone can check the tvaudio and tda drivers in
particular.

Regards,

	Hans

Hans Verkuil (19):
  cs5345: use the control framework
  tvaudio: use the control framework, fix vol/balance bugs
  cx18: Use the control framework.
  adv7343: use control framework
  bt819: use control framework
  ov7670: use the control framework
  saa7110: use control framework
  tda7432: use control framework
  tda9875: use control framework
  tlv320aic23b: use control framework
  tvp514x: use the control framework
  tvp5150: use the control framework
  vpx3220: use control framework
  tvp7002: use control framework
  v4l2-ctrls: use const char * const * for the menu arrays
  vivi: convert to the control framework and add test controls.
  v4l: fix handling of v4l2_input.capabilities
  em28xx: fix incorrect s_ctrl error code and wrong call to res_free
  v4l2-ctrls: only check def for menu, integer and boolean controls

 drivers/media/dvb/ttpci/av7110_v4l.c               |    4 +
 drivers/media/dvb/ttpci/budget-av.c                |    6 +-
 drivers/media/video/adv7343.c                      |  167 ++++-------
 drivers/media/video/adv7343_regs.h                 |    8 +-
 drivers/media/video/bt819.c                        |  129 ++++------
 drivers/media/video/cs5345.c                       |   87 ++++--
 drivers/media/video/cx18/cx18-av-audio.c           |   92 +------
 drivers/media/video/cx18/cx18-av-core.c            |  162 ++++-------
 drivers/media/video/cx18/cx18-av-core.h            |   12 +-
 drivers/media/video/cx18/cx18-cards.c              |    1 -
 drivers/media/video/cx18/cx18-controls.c           |  285 +++-----------------
 drivers/media/video/cx18/cx18-controls.h           |    7 +-
 drivers/media/video/cx18/cx18-driver.c             |   30 ++-
 drivers/media/video/cx18/cx18-driver.h             |    2 +-
 drivers/media/video/cx18/cx18-fileops.c            |   32 +--
 drivers/media/video/cx18/cx18-ioctl.c              |   24 +-
 drivers/media/video/cx18/cx18-mailbox.c            |    5 +-
 drivers/media/video/cx18/cx18-mailbox.h            |    5 -
 drivers/media/video/cx18/cx18-streams.c            |   16 +-
 drivers/media/video/cx2341x.c                      |    8 +-
 drivers/media/video/cx23885/cx23885-video.c        |    1 -
 drivers/media/video/em28xx/em28xx-video.c          |   14 +-
 drivers/media/video/et61x251/et61x251_core.c       |    1 +
 drivers/media/video/hexium_gemini.c                |   18 +-
 drivers/media/video/hexium_orion.c                 |   18 +-
 drivers/media/video/ivtv/ivtv-cards.c              |    2 -
 drivers/media/video/mxb.c                          |    8 +-
 drivers/media/video/ov7670.c                       |  296 ++++++++------------
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c         |    6 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    2 +-
 drivers/media/video/saa7110.c                      |  115 +++-----
 drivers/media/video/saa7134/saa7134-video.c        |    1 -
 drivers/media/video/sn9c102/sn9c102_core.c         |    1 +
 drivers/media/video/tda7432.c                      |  277 +++++++-----------
 drivers/media/video/tda9875.c                      |  192 ++++---------
 drivers/media/video/timblogiw.c                    |    1 -
 drivers/media/video/tlv320aic23b.c                 |   74 +++--
 drivers/media/video/tvaudio.c                      |  221 +++++----------
 drivers/media/video/tvp514x.c                      |  236 ++++------------
 drivers/media/video/tvp5150.c                      |  157 +++--------
 drivers/media/video/tvp7002.c                      |  117 +++-----
 drivers/media/video/v4l2-common.c                  |    6 +-
 drivers/media/video/v4l2-ctrls.c                   |   55 ++--
 drivers/media/video/vino.c                         |    3 -
 drivers/media/video/vivi.c                         |  228 +++++++++------
 drivers/media/video/vpx3220.c                      |  137 ++++------
 drivers/media/video/zoran/zoran_driver.c           |    6 -
 drivers/staging/cx25821/cx25821-video.c            |    2 -
 include/media/cx2341x.h                            |    2 +-
 include/media/v4l2-common.h                        |    6 +-
 include/media/v4l2-ctrls.h                         |    4 +-
 51 files changed, 1203 insertions(+), 2086 deletions(-)

