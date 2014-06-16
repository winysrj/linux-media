Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3759 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaFPKr4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 06:47:56 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id s5GAlrK2065053
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 12:47:55 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 64EFA2A1FCC
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 12:47:40 +0200 (CEST)
Message-ID: <539ECB4C.4050404@xs4all.nl>
Date: Mon, 16 Jun 2014 12:47:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.16] Two fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two bug fixes that should go to 3.16 (the dv-timings.c fix even for 3.12 and up).

Regards,

	Hans

The following changes since commit f7a27ff1fb77e114d1059a5eb2ed1cffdc508ce8:

  [media] xc5000: delay tuner sleep to 5 seconds (2014-05-25 17:50:16 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.16a

for you to fetch changes up to b3d14fb591e647056f111e1dabf13f542fdcc211:

  saa7134: use unlocked_ioctl instead of ioctl. (2014-06-16 12:37:41 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      saa7134: use unlocked_ioctl instead of ioctl.

Rickard Strandqvist (1):
      media: v4l2-core: v4l2-dv-timings.c: Cleaning up code wrong value used in aspect ratio.

 drivers/media/pci/saa7134/saa7134-empress.c | 2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)
