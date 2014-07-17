Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2420 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaGQK7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 06:59:52 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6HAxm9H051254
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 12:59:51 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id D109C2A1FD1
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 12:59:46 +0200 (CEST)
Message-ID: <53C7ACA2.9020106@xs4all.nl>
Date: Thu, 17 Jul 2014 12:59:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.17] Three trivial davinci patches
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3c0d394ea7022bb9666d9df97a5776c4bcc3045c:

  [media] dib8000: improve the message that reports per-layer locks (2014-07-07 09:59:01 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git davinci

for you to fetch changes up to 5588d119ac994cc8929e0fa5d0655811ee02df3a:

  davinci: vpfe: dm365: remove duplicate RSZ_LPF_INT_MASK (2014-07-17 12:58:57 +0200)

----------------------------------------------------------------
Dan Carpenter (1):
      davinci: vpfe: dm365: remove duplicate RSZ_LPF_INT_MASK

Lad, Prabhakar (2):
      staging: media: davinci_vpfe: fix checkpatch warning
      media: davinci_vpfe: dm365_resizer: fix sparse warning

 drivers/staging/media/davinci_vpfe/dm365_ipipe.c    | 2 ++
 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.h | 1 -
 drivers/staging/media/davinci_vpfe/dm365_resizer.c  | 4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)
