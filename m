Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3679 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbaIHImY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Sep 2014 04:42:24 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id s888gK70025581
	for <linux-media@vger.kernel.org>; Mon, 8 Sep 2014 10:42:22 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 074D02A03DA
	for <linux-media@vger.kernel.org>; Mon,  8 Sep 2014 10:42:19 +0200 (CEST)
Message-ID: <540D6BEA.6080606@xs4all.nl>
Date: Mon, 08 Sep 2014 10:42:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.17] Two fixes for 3.17
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One missing header, one incorrect condition. The second one is CC-ed to stable
for kernels 3.7 and up.

Regards,

	Hans

The following changes since commit 89fffac802c18caebdf4e91c0785b522c9f6399a:

  [media] drxk_hard: fix bad alignments (2014-09-03 19:19:18 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.17j

for you to fetch changes up to d31b7360e3ef0ce26370ba1e2e962c5f1d8bf289:

  media/radio: fix radio-miropcm20.c build with io.h header file (2014-09-08 10:17:13 +0200)

----------------------------------------------------------------
Randy Dunlap (1):
      media/radio: fix radio-miropcm20.c build with io.h header file

Zhaowei Yuan (1):
      vb2: fix plane index sanity check in vb2_plane_cookie()

 drivers/media/radio/radio-miropcm20.c    | 1 +
 drivers/media/v4l2-core/videobuf2-core.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)
