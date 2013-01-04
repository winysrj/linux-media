Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:41491 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3ADXQY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 18:16:24 -0500
Received: by mail-ee0-f52.google.com with SMTP id d17so7778705eek.25
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 15:16:23 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH RFC v1 0/2] Omnivision OV9650/52 sensor driver
Date: Sat,  5 Jan 2013 00:10:21 +0100
Message-Id: <1357341023-3202-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches add driver for OV9650/52 image sensor. The first one
introduces a header file containing definitions of standard image
resolutions. I have also prepared a few patches reworking existing
drivers to use this global definitions, but I thought I'll submit
those only after the header is accepted and merged to the media
staging tree.

Sylwester Nawrocki (2):
  [media] Add header file defining standard image sizes
  V4L: Add driver for OV9650/52 image sensors

 drivers/media/i2c/Kconfig   |    7 +
 drivers/media/i2c/Makefile  |    1 +
 drivers/media/i2c/ov9650.c  | 1684 +++++++++++++++++++++++++++++++++++++++++++
 include/media/image-sizes.h |   34 +
 include/media/ov9650.h      |   20 +
 5 files changed, 1746 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/i2c/ov9650.c
 create mode 100644 include/media/image-sizes.h
 create mode 100644 include/media/ov9650.h

--
1.7.4.1

