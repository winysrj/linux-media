Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:59264 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbbFGI6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 04:58:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCHv2 00/11] sh-vou: fixes, conversion to vb2
Date: Sun,  7 Jun 2015 10:57:54 +0200
Message-Id: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver no longer works and uses old v4l2 frameworks. This patch series
updates the driver so it is once again working and is up to date.

It now passes the v4l2-compliance tests as well.

This has been tested with my Renesas R0P7724LC0011/21RL development board.

Changes since v1:

- Split up the clock fix from the 'use resource managed calls' patch.
- Just changed the clock name as suggested by Geert Uytterhoeven.
- No need to enable the clock explicitly, it is done by pm_runtime_get_sync().
- Fixed the sh_vou_release() function which didn't reset the status to
  SH_VOU_INITIALISING. Also make sure the _vb2_fop_release() is called before
  pm_runtime_put is called in case _vb2_fop_release() still needs access to
  the clock.

Note that patches 3-10 are identical to patches 2-9 from v1. Only patches 1, 2
and 11 are changed and patch 11 only changed the sh_vou_release() function.

Regards,

	Hans

Hans Verkuil (11):
  clock-sh7724.c: fix sh-vou clock identifier
  sh-vou: use resource managed calls
  sh-vou: fix querycap support
  sh-vou: use v4l2_fh
  sh-vou: support compulsory G/S/ENUM_OUTPUT ioctls
  sh-vou: fix incorrect initial pixelformat.
  sh-vou: replace g/s_crop/cropcap by g/s_selection
  sh-vou: add support for log_status
  sh-vou: let sh_vou_s_fmt_vid_out call sh_vou_try_fmt_vid_out
  sh-vou: fix bytesperline
  sh-vou: convert to vb2

 arch/sh/kernel/cpu/sh4a/clock-sh7724.c |   2 +-
 drivers/media/platform/sh_vou.c        | 818 +++++++++++++++------------------
 2 files changed, 373 insertions(+), 447 deletions(-)

-- 
2.1.4

