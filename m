Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4111 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab2ENNIk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 09:08:40 -0400
Received: from alastor.dyndns.org (189.80-203-102.nextgentel.com [80.203.102.189] (may be forged))
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id q4ED8bjP082667
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 14 May 2012 15:08:38 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id A3C8E199C0088
	for <linux-media@vger.kernel.org>; Mon, 14 May 2012 15:08:36 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.5] saa7146 clean ups/fixes
Date: Mon, 14 May 2012 15:08:36 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205141508.36083.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Since this is your last day of merges I'd thought I'd put this in your queue
as well.

This patch series cleans up saa7146, mxb, hexium-orion, hexium-gemini and
av7110. These drivers now all pass the v4l2-compliance tests.

I've tested with all of these cards, the only driver I was unable to test is the
budget driver as I don't have hardware for it.

All changes only apply to the V4L2 side of these drivers.

Two patches relate to vivi: I've extended the number of supported pixelformats.
This makes it easier to test the various variants.

Regards,

	Hans

The following changes since commit e89fca923f32de26b69bf4cd604f7b960b161551:

  [media] gspca - ov534: Add Hue control (2012-05-14 09:48:00 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git saa7146

for you to fetch changes up to 34893ef0d80aa888e1bb93efdde1d3e615bf53d6:

  av7110: fix v4l2_compliance test issues. (2012-05-14 14:58:05 +0200)

----------------------------------------------------------------
Hans Verkuil (19):
      mxb/saa7146: first round of cleanups.
      mxb: fix initial audio + ntsc/secam support.
      mxb: fix audio handling.
      mxb: simplify a line that was too long.
      tda9840: fix setting of the audio mode.
      mxb: fix audio and standard handling.
      saa7146: move overlay information from saa7146_fh into saa7146_vv
      saa7146: move video_fmt from saa7146_fh to saa7146_vv.
      saa7146: move vbi fields from saa7146_fh to saa7146_vv
      saa7146: remove the unneeded type field from saa7146_fh
      saa7146: rename vbi/video_q to vbi/video_dmaq.
      saa7146: support control events and priority handling.
      saa7146: fix querycap, vbi/video separation and g/s_register
      fixes and add querystd support to mxb.
      hexium-gemini: remove B&W control, fix input table.
      hexium-orion: fix incorrect input table.
      vivi: add more pixelformats.
      vivi: add the alpha component control.
      av7110: fix v4l2_compliance test issues.

 drivers/media/common/saa7146_fops.c  |  122 +++++++++++++++++++++++++++++-------
 drivers/media/common/saa7146_hlp.c   |   23 +++----
 drivers/media/common/saa7146_vbi.c   |   54 ++++++----------
 drivers/media/common/saa7146_video.c |  367 +++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------
 drivers/media/dvb/ttpci/av7110_v4l.c |   72 +++++++++++++++------
 drivers/media/dvb/ttpci/budget-av.c  |    6 +-
 drivers/media/video/hexium_gemini.c  |  129 ++++----------------------------------
 drivers/media/video/hexium_orion.c   |   24 +++----
 drivers/media/video/mxb.c            |  351 ++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------
 drivers/media/video/mxb.h            |   42 -------------
 drivers/media/video/tda9840.c        |   75 ++++++++++++----------
 drivers/media/video/vivi.c           |  188 ++++++++++++++++++++++++++++++++++++++++++++-----------
 include/media/saa7146.h              |    4 +-
 include/media/saa7146_vv.h           |   25 ++++----
 14 files changed, 736 insertions(+), 746 deletions(-)
 delete mode 100644 drivers/media/video/mxb.h
