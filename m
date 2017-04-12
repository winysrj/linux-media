Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:40692 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752286AbdDLMq7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 08:46:59 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Helen Koike <helen.koike@collabora.co.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] Add vimc virtual test driver
Message-ID: <80c7b873-e8fe-c3e5-d414-4ef2a5257405@xs4all.nl>
Date: Wed, 12 Apr 2017 14:46:54 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Finally merge this for 4.12.

Regards,

	Hans

The following changes since commit 4aed35ca73f6d9cfd5f7089ba5d04f5fb8623080:

  [media] v4l2-tpg: don't clamp XV601/709 to lim range (2017-04-10 14:58:06 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vimc

for you to fetch changes up to 32d8d75a9af8c1169a33f8e1231f871459d1e4f0:

  vimc: Virtual Media Controller core, capture and sensor (2017-04-12 14:43:13 +0200)

----------------------------------------------------------------
Helen Koike (1):
      vimc: Virtual Media Controller core, capture and sensor

 MAINTAINERS                                |   8 +
 drivers/media/platform/Kconfig             |   2 +
 drivers/media/platform/Makefile            |   1 +
 drivers/media/platform/vimc/Kconfig        |  14 ++
 drivers/media/platform/vimc/Makefile       |   3 +
 drivers/media/platform/vimc/vimc-capture.c | 498 +++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/vimc/vimc-capture.h |  28 +++
 drivers/media/platform/vimc/vimc-core.c    | 695 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/vimc/vimc-core.h    | 112 ++++++++++
 drivers/media/platform/vimc/vimc-sensor.c  | 276 +++++++++++++++++++++++
 drivers/media/platform/vimc/vimc-sensor.h  |  28 +++
 11 files changed, 1665 insertions(+)
 create mode 100644 drivers/media/platform/vimc/Kconfig
 create mode 100644 drivers/media/platform/vimc/Makefile
 create mode 100644 drivers/media/platform/vimc/vimc-capture.c
 create mode 100644 drivers/media/platform/vimc/vimc-capture.h
 create mode 100644 drivers/media/platform/vimc/vimc-core.c
 create mode 100644 drivers/media/platform/vimc/vimc-core.h
 create mode 100644 drivers/media/platform/vimc/vimc-sensor.c
 create mode 100644 drivers/media/platform/vimc/vimc-sensor.h
