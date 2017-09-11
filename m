Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:56471 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751079AbdIKNDc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 09:03:32 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.15] tc358743: add CEC support
Message-ID: <7d713889-2a5d-2058-faf2-109239a52001@xs4all.nl>
Date: Mon, 11 Sep 2017 15:03:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add CEC support to the tc358743 HDMI-to-CSI bridge.

Tested with my Raspberry Pi 2B and an Auvidea B100 adapter.

Regards,

	Hans

The following changes since commit 1efdf1776e2253b77413c997bed862410e4b6aaf:

  media: leds: as3645a: add V4L2_FLASH_LED_CLASS dependency (2017-09-05 16:32:45 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tc358743

for you to fetch changes up to e7d5ffedee135e9bf63268f3fb259c2777ffe8c1:

  tc358743: add CEC support (2017-09-11 15:01:46 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      tc358743_regs.h: add CEC registers
      tc358743: add CEC support

 drivers/media/i2c/Kconfig         |   8 +++
 drivers/media/i2c/tc358743.c      | 205 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/media/i2c/tc358743_regs.h |  94 +++++++++++++++++++++++++++++++++-
 3 files changed, 299 insertions(+), 8 deletions(-)
