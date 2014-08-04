Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2439 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaHDFjs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 01:39:48 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s745djDO047279
	for <linux-media@vger.kernel.org>; Mon, 4 Aug 2014 07:39:47 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 91C782A2651
	for <linux-media@vger.kernel.org>; Mon,  4 Aug 2014 07:39:41 +0200 (CEST)
Message-ID: <53DF1C9D.4070300@xs4all.nl>
Date: Mon, 04 Aug 2014 07:39:41 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.17] vb2: one fix and adding comments
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'd like to get this in for 3.17: the first patch fixes a BUG_ON due to a wrong
gfp_flags value, the second adds comments before two WARN_ONs that are triggered
fairly often due to buggy drivers and that point the driver developer into the
right direction on how to solve it.

Regards,

	Hans

The following changes since commit 0f3bf3dc1ca394a8385079a5653088672b65c5c4:

  [media] cx23885: fix UNSET/TUNER_ABSENT confusion (2014-08-01 15:30:59 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.17i

for you to fetch changes up to 4778bc67ba7a97e35a5f3c7159444fe5e44154f9:

  videobuf2-core: add comments before the WARN_ON (2014-08-04 07:33:53 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      videobuf2-dma-sg: fix for wrong GFP mask to sg_alloc_table_from_pages
      videobuf2-core: add comments before the WARN_ON

 drivers/media/v4l2-core/videobuf2-core.c   | 12 ++++++++++++
 drivers/media/v4l2-core/videobuf2-dma-sg.c |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)
