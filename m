Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2891 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946079Ab3BHIkl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2013 03:40:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.8] Regression fix: cx18/ivtv: remove __init from a non-init function.
Date: Fri, 8 Feb 2013 09:40:27 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302080940.27735.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please fast-track this for 3.8. Yesterday I discovered that commits made earlier
for 3.8 kill ivtv and cx18 (as in: unable to boot, instant crash) since a
function was made __init that was actually called *after* initialization.

We are already at rc6 and this *must* make it for 3.8. Without this patch
anyone with a cx18/ivtv will crash immediately as soon as they upgrade to 3.8.

Regards,

	Hans

The following changes since commit 248ac368ce4b3cd36515122d888403909d7a2500:

  [media] s5p-fimc: Fix fimc-lite entities deregistration (2013-02-06 09:42:19 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git ivtv

for you to fetch changes up to ddf276062e68607323fca363b99bdf426dddad9b:

  cx18/ivtv: fix regression: remove __init from a non-init function. (2013-02-08 09:30:11 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      cx18/ivtv: fix regression: remove __init from a non-init function.

 drivers/media/pci/cx18/cx18-alsa-main.c |    2 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
