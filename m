Return-path: <mchehab@gaivota>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4847 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab0L2Rnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 12:43:31 -0500
Received: from durdane.localnet (marune.xs4all.nl [82.95.89.49])
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBTHhQ11069667
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 18:43:30 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.38] Various fixes
Date: Wed, 29 Dec 2010 18:43:26 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012291843.26676.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

A bunch of fixes that were pending in various git branches of mine.

Regards,

	Hans

The following changes since commit e017301e47ff356ed52a91259bfe4d200b8a628a:
  Jean-François Moine (1):
        [media] gspca - sonixj: Bad clock for om6802 in 640x480

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git fixes

Hans Verkuil (5):
      v4l2-ctrls: use const char * const * for the menu arrays
      v4l2-ctrls: only check def for menu, integer and boolean controls
      em28xx: fix incorrect s_ctrl error code and wrong call to res_free
      v4l: fix handling of v4l2_input.capabilities
      timblogiw: fix compile warning

 drivers/media/dvb/ttpci/av7110_v4l.c               |    4 ++
 drivers/media/dvb/ttpci/budget-av.c                |    6 ++-
 drivers/media/video/cx18/cx18-cards.c              |    1 -
 drivers/media/video/cx18/cx18-controls.c           |    2 +-
 drivers/media/video/cx2341x.c                      |    8 ++--
 drivers/media/video/cx23885/cx23885-video.c        |    1 -
 drivers/media/video/em28xx/em28xx-video.c          |   14 +++--
 drivers/media/video/et61x251/et61x251_core.c       |    1 +
 drivers/media/video/hexium_gemini.c                |   18 +++---
 drivers/media/video/hexium_orion.c                 |   18 +++---
 drivers/media/video/ivtv/ivtv-cards.c              |    2 -
 drivers/media/video/mxb.c                          |    8 ++--
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c         |    6 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    2 +-
 drivers/media/video/saa7134/saa7134-video.c        |    1 -
 drivers/media/video/sn9c102/sn9c102_core.c         |    1 +
 drivers/media/video/timblogiw.c                    |    5 +-
 drivers/media/video/v4l2-common.c                  |    6 +-
 drivers/media/video/v4l2-ctrls.c                   |   55 +++++++++++---------
 drivers/media/video/vino.c                         |    3 -
 drivers/media/video/zoran/zoran_driver.c           |    6 --
 drivers/staging/cx25821/cx25821-video.c            |    2 -
 include/media/cx2341x.h                            |    2 +-
 include/media/v4l2-common.h                        |    6 +-
 include/media/v4l2-ctrls.h                         |    4 +-
 25 files changed, 92 insertions(+), 90 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
