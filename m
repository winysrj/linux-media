Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:41579 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756550Ab2ICUY6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Sep 2012 16:24:58 -0400
Subject: [GIT PATCHES] ivtv-alsa, ivtv: Add initial ivtv-alsa interface
 driver for ivtv
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mike Isely at pobox <isely@pobox.com>,
	Mike Isely <isely@isely.net>
Date: Mon, 03 Sep 2012 16:24:19 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1346703860.4874.11.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please pull this changeset which implements a basic ALSA interface for
the ivtv driver.

The changes are a modified cut and paste from cx18 and cx18-alsa.  It
inherets all the problems of the cx18-alsa driver: locking
inconsistencies, ALSA mixer interface is not enabled, hardcoded sample
rate of 48 ksps regardless of the real audio sample rate, etc.  However
in testing, it works well enough for userspace to get basic FM radio and
TV audio via ALSA. 

Regards,
Andy


The following changes since commit f9cd49033b349b8be3bb1f01b39eed837853d880:

  Merge tag 'v3.6-rc1' into staging/for_v3.6 (2012-08-03 22:41:33 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/awalls/media_tree.git ivtv-alsa

Andy Walls (3):
      ivtv, ivtv-alsa: Add initial ivtv-alsa interface driver for ivtv
      ivtv-alsa, ivtv: Connect ivtv PCM capture stream to ivtv-alsa interface driver
      ivtv-alsa: Remove EXPERIMENTAL from Kconfig and revise Kconfig help text

 drivers/media/video/ivtv/Kconfig           |   16 ++
 drivers/media/video/ivtv/Makefile          |    2 +
 drivers/media/video/ivtv/ivtv-alsa-main.c  |  303 +++++++++++++++++++++++
 drivers/media/video/ivtv/ivtv-alsa-mixer.c |  175 ++++++++++++++
 drivers/media/video/ivtv/ivtv-alsa-mixer.h |   23 ++
 drivers/media/video/ivtv/ivtv-alsa-pcm.c   |  357 ++++++++++++++++++++++++++++
 drivers/media/video/ivtv/ivtv-alsa-pcm.h   |   27 ++
 drivers/media/video/ivtv/ivtv-alsa.h       |   75 ++++++
 drivers/media/video/ivtv/ivtv-driver.c     |   37 +++
 drivers/media/video/ivtv/ivtv-driver.h     |   11 +
 drivers/media/video/ivtv/ivtv-fileops.c    |    4 +-
 drivers/media/video/ivtv/ivtv-fileops.h    |    4 +-
 drivers/media/video/ivtv/ivtv-irq.c        |   50 ++++
 drivers/media/video/ivtv/ivtv-streams.c    |    2 +
 14 files changed, 1083 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/video/ivtv/ivtv-alsa-main.c
 create mode 100644 drivers/media/video/ivtv/ivtv-alsa-mixer.c
 create mode 100644 drivers/media/video/ivtv/ivtv-alsa-mixer.h
 create mode 100644 drivers/media/video/ivtv/ivtv-alsa-pcm.c
 create mode 100644 drivers/media/video/ivtv/ivtv-alsa-pcm.h
 create mode 100644 drivers/media/video/ivtv/ivtv-alsa.h


