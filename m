Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1554 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3DOPU2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 11:20:28 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id r3FFKPHC088813
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 17:20:27 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 64F1A11E01E8
	for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 17:20:24 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] Two bug fixes and a MAINTAINERS update
Date: Mon, 15 Apr 2013 17:20:24 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304151720.24177.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It makes sense to get this in 3.10.

Regards,

	Hans

The following changes since commit 4c41dab4d69fb887884dc571fd70e4ddc41774fb:

  [media] rc: fix single line indentation of keymaps/Makefile (2013-04-14 22:51:41 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.10

for you to fetch changes up to c25adc4458686bbdbd643f50ea51fe21e98433c0:

  cx88: Fix unsafe locking in suspend-resume (2013-04-15 17:10:58 +0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      cx88: Fix unsafe locking in suspend-resume

Ismael Luceno (1):
      solo6x10: Update the encoder mode on VIDIOC_S_FMT

Lad, Prabhakar (1):
      MAINTAINERS: change entry for davinci media driver

 MAINTAINERS                                        |    5 ++---
 drivers/media/pci/cx88/cx88-mpeg.c                 |   10 ++++++----
 drivers/media/pci/cx88/cx88-video.c                |   10 ++++++----
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |    1 +
 4 files changed, 15 insertions(+), 11 deletions(-)
