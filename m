Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33013 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbbFEK7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 06:59:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 00/10] sh-vou: fixes, convert to vb2
Date: Fri,  5 Jun 2015 12:59:16 +0200
Message-Id: <1433501966-30176-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver no longer works and uses old v4l2 frameworks. This patch series
updates the driver so it is once again working and is up to date.

It now passes the v4l2-compliance tests as well.

This has been tested with my Renesas development board.

Regards,

	Hans

Hans Verkuil (10):
  sh-vou: hook up the clock correctly
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
 drivers/media/platform/sh_vou.c        | 825 +++++++++++++++------------------
 2 files changed, 381 insertions(+), 446 deletions(-)

-- 
2.1.4

