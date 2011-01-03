Return-path: <mchehab@gaivota>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4928 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1ACKnA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 05:43:00 -0500
Received: from tschai.localnet (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id p03Agvdp023333
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 3 Jan 2011 11:42:58 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] Remove duplicate tda9875 subdev driver
Date: Mon, 3 Jan 2011 11:42:53 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101031142.53082.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

Since the tda9875 subdev driver was folded into tvaudio in 2009 and hasn't
been used since that time I think we should remove it. It serves no purpose
anymore.

Regards,

	Hans

The following changes since commit 187134a5875df20356f4dca075db29f294115a47:
  David Henningsson (1):
        [media] DVB: IR support for TechnoTrend CT-3650

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git tda9875

Hans Verkuil (2):
      tda9875: remove duplicate driver
      bttv: remove obsolete 'no_tda9875' field

 drivers/media/video/Kconfig            |    9 -
 drivers/media/video/Makefile           |    1 -
 drivers/media/video/bt8xx/bttv-cards.c |   39 ---
 drivers/media/video/bt8xx/bttv.h       |    1 -
 drivers/media/video/tda9875.c          |  411 --------------------------------
 5 files changed, 0 insertions(+), 461 deletions(-)
 delete mode 100644 drivers/media/video/tda9875.c

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
