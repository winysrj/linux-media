Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35464 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbaBJQRT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 11:17:19 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 0/6] SDR API - V4L implement needed controls and formats
Date: Mon, 10 Feb 2014 18:17:00 +0200
Message-Id: <1392049026-13398-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Split / group / merge changes as requested by Hans.

Implement needed V4L2 controls and V4L stream formats.

Antti

Antti Palosaari (6):
  v4l: add RF tuner gain controls
  v4l: add RF tuner channel bandwidth control
  v4l: reorganize RF tuner control ID numbers
  v4l: uapi: add SDR formats CU8 and CU16LE
  v4l: add enum_freq_bands support to tuner sub-device
  v4l: add control for RF tuner PLL lock flag

 drivers/media/v4l2-core/v4l2-ctrls.c | 24 ++++++++++++++++++++++++
 include/media/v4l2-subdev.h          |  1 +
 include/uapi/linux/v4l2-controls.h   | 14 ++++++++++++++
 include/uapi/linux/videodev2.h       |  4 ++++
 4 files changed, 43 insertions(+)

-- 
1.8.5.3

