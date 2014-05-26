Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2274 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaEZJRx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 05:17:53 -0400
Message-ID: <538306A0.4080402@xs4all.nl>
Date: Mon, 26 May 2014 11:17:20 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [GIT PULL FOR v3.16] Remaining two davinci patches, with commit log
 description
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are the remaining two davinci patches. Unchanges other than rebasing and
adding a proper log description to the first patch.

Regards,

	Hans

The following changes since commit f7a27ff1fb77e114d1059a5eb2ed1cffdc508ce8:

  [media] xc5000: delay tuner sleep to 5 seconds (2014-05-25 17:50:16 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git davinci

for you to fetch changes up to cd71039b7e3c6573fb6adbf22e9c04fd175bbede:

  media: davinci: vpif_capture: fix v4l-compliance issues (2014-05-26 11:14:11 +0200)

----------------------------------------------------------------
Lad, Prabhakar (2):
      media: davinci: vpif_capture: drop unneeded module params
      media: davinci: vpif_capture: fix v4l-compliance issues

 drivers/media/platform/davinci/vpif_capture.c | 245 ++++++++++++++++++------------------------------------------------------------
 drivers/media/platform/davinci/vpif_capture.h |  11 ----
 2 files changed, 55 insertions(+), 201 deletions(-)
