Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:39623 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753630AbeGFOfG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jul 2018 10:35:06 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] Various fixes
Message-ID: <f786d856-f6e4-bf05-1ae9-fd687bbeb0de@xs4all.nl>
Date: Fri, 6 Jul 2018 16:35:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 666e994aa2278e948e2492ee9d81b4df241e7222:

  media: platform: s5p-mfc: simplify getting .drvdata (2018-07-04 11:45:40 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.19i

for you to fetch changes up to 894d81fed117fc49906e64b085f3607cf694de92:

  media: v4l2-ctrls.h: fix v4l2_ctrl field description typos (2018-07-06 15:48:16 +0200)

----------------------------------------------------------------
Baruch Siach (1):
      media: v4l2-ctrls.h: fix v4l2_ctrl field description typos

Hugues Fruchet (1):
      MAINTAINERS: Add entry for STM32 DCMI media driver

Julia Lawall (1):
      gspca_kinect: cast sizeof to int for comparison

Krzysztof Ha?asa (1):
      tw686x: Fix oops on buffer alloc failure

Matt Ranostay (1):
      media: video-i2c: add hwmon support for amg88xx

Philipp Zabel (4):
      media: coda: move framebuffer size calculation out of loop
      media: coda: streamline framebuffer size calculation a bit
      media: coda: use encoder crop rectangle to set visible width and height
      media: coda: add missing h.264 levels

 MAINTAINERS                               |  8 +++++++
 drivers/media/i2c/Kconfig                 |  1 +
 drivers/media/i2c/video-i2c.c             | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/pci/tw686x/tw686x-video.c   | 11 ++++++---
 drivers/media/platform/coda/coda-bit.c    | 45 ++++++++++++++++------------------
 drivers/media/platform/coda/coda-common.c | 45 ++++++++++++++++++++++++++++++----
 drivers/media/platform/coda/coda-h264.c   |  3 +++
 drivers/media/usb/gspca/kinect.c          |  2 +-
 include/media/v4l2-ctrls.h                |  4 ++--
 9 files changed, 165 insertions(+), 35 deletions(-)
