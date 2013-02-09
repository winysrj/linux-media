Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2869 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3BIItT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 03:49:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.8] Regression fix: cx18/ivtv: remove __init from a non-init function.
Date: Sat, 9 Feb 2013 09:49:13 +0100
Cc: Andy Walls <awalls@md.metrocast.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302090949.13780.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please fast-track this for 3.8. Two days ago I discovered that commits made
earlier for 3.8 kill ivtv and cx18 (as in: unable to boot, instant crash) since
a function was made __init that was actually called after initialization.

We are already at rc7 and this should make it for 3.8 if at all possible.
Without this patch anyone with a cx18/ivtv will crash immediately as soon
as they upgrade to 3.8.

This second version of the pull request also corrects two headers where __init
was present for the snd_cx18/ivtv_pcm_create function. The function in the C
source didn't have that annotation, so the first version of my fix worked fine,
it just generated false warnings which are now fixed as well.

Regards,

      Hans

The following changes since commit 4880f56438ef56457edd5548b257382761591998:

  [media] stv0900: remove unnecessary null pointer check (2013-02-08 18:05:48 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git ivtv2

for you to fetch changes up to 6a2f1a23e007690d498f7a904bc9fc408f0afc5f:

  cx18/ivtv: fix regression: remove __init from a non-init function. (2013-02-09 09:40:10 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      cx18/ivtv: fix regression: remove __init from a non-init function.

 drivers/media/pci/cx18/cx18-alsa-main.c |    2 +-
 drivers/media/pci/cx18/cx18-alsa-pcm.h  |    2 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c |    2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.h  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)
