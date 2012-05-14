Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1949 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2ENSvu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 14:51:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.5] More old driver cleanups
Date: Mon, 14 May 2012 20:51:41 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205142051.41871.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I'd almost forgotten that I had these done as well.
These are all trivial, but nobody is able to test it since nobody has the
hardware.

Regards,

	Hans

The following changes since commit 152a3a7320d1582009db85d8be365ce430d079af:

  [media] v4l2-dev: rename two functions (2012-05-14 15:06:50 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git easy

for you to fetch changes up to d91593bf09bff27657a9dc1e7d4560fbb9eaac6d:

  w9966: convert to the latest frameworks. (2012-05-14 20:48:37 +0200)

----------------------------------------------------------------
Hans Verkuil (4):
      bw-qcam: update to latest frameworks.
      c-qcam: convert to the latest frameworks.
      arv: use latest frameworks.
      w9966: convert to the latest frameworks.

 drivers/media/video/arv.c     |    7 +++++-
 drivers/media/video/bw-qcam.c |  132 ++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------
 drivers/media/video/c-qcam.c  |  137 +++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------
 drivers/media/video/w9966.c   |   94 +++++++++++++++++++++++++++++++++++--------------------------------------------
 4 files changed, 174 insertions(+), 196 deletions(-)
