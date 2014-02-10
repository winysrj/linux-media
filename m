Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48018 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbaBJQVe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 11:21:34 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 0/6] SDR API - V4L documentation
Date: Mon, 10 Feb 2014 18:21:13 +0200
Message-Id: <1392049279-13495-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Split / group / merge changes as requested by Hans.

That is last set of API changes itself. All the upcoming patches are
driver implementation. It will took a while to rebase those....

Antti

Antti Palosaari (6):
  DocBook: V4L: add V4L2_SDR_FMT_CU8 - 'CU08'
  DocBook: V4L: add V4L2_SDR_FMT_CU16LE - 'CU16'
  DocBook: document RF tuner gain controls
  DocBook: media: document V4L2_CTRL_CLASS_RF_TUNER
  DocBook: document RF tuner bandwidth controls
  DocBook: media: document PLL lock control

 Documentation/DocBook/media/v4l/controls.xml       | 119 +++++++++++++++++++++
 .../DocBook/media/v4l/pixfmt-sdr-cu08.xml          |  44 ++++++++
 .../DocBook/media/v4l/pixfmt-sdr-cu16le.xml        |  46 ++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |   3 +
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   7 +-
 5 files changed, 218 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml

-- 
1.8.5.3

