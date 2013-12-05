Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2744 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab3LEHuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Dec 2013 02:50:05 -0500
Message-ID: <52A0301C.5050009@xs4all.nl>
Date: Thu, 05 Dec 2013 08:49:48 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Subject: [GIT PULL FOR v3.14] Add radio-bcm2048 staging driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch series adds support for the bcm2048 radio found in the Nokia N900.
It needs more work before it can be moved to media/radio, but it's OK for
staging.

Regards,

	Hans

The following changes since commit 3f823e094b935c1882605f8720336ee23433a16d:

  [media] exynos4-is: Simplify fimc-is hardware polling helpers (2013-12-04 15:54:19 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git bcm

for you to fetch changes up to a8cc848df020be03a3eaddca068ec1fb6816834e:

  bcm2048: add TODO file for this staging driver. (2013-12-05 08:44:25 +0100)

----------------------------------------------------------------
Hans Verkuil (2):
      This adds support for the BCM2048 radio module found in Nokia N900
      bcm2048: add TODO file for this staging driver.

 drivers/staging/media/Kconfig                 |    2 +
 drivers/staging/media/Makefile                |    1 +
 drivers/staging/media/bcm2048/Kconfig         |   13 +
 drivers/staging/media/bcm2048/Makefile        |    1 +
 drivers/staging/media/bcm2048/TODO            |   18 +
 drivers/staging/media/bcm2048/radio-bcm2048.c | 2745 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/bcm2048/radio-bcm2048.h |   30 +
 7 files changed, 2810 insertions(+)
 create mode 100644 drivers/staging/media/bcm2048/Kconfig
 create mode 100644 drivers/staging/media/bcm2048/Makefile
 create mode 100644 drivers/staging/media/bcm2048/TODO
 create mode 100644 drivers/staging/media/bcm2048/radio-bcm2048.c
 create mode 100644 drivers/staging/media/bcm2048/radio-bcm2048.h
