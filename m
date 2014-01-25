Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34965 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaAYDHT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 22:07:19 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFCv1] SDR API - RF tuner gain controls
Date: Sat, 25 Jan 2014 05:06:56 +0200
Message-Id: <1390619217-2272-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modern silicon RF tuners used nowadays has many controllable gain
stages on signal path. Usually, but not always, there is at least
3 gain stages. Also on some cases there could be multiple gain
stages within the ones specified here. However, I think that having
these three controllable gain stages offers enough fine-tuning for
real use cases.

1) LNA gain. That is first gain just after antenna input.
2) Mixer gain. It is located quite middle of the signal path, where
RF signal is down-converted to IF/BB.
3) IF gain. That is last gain in order to adjust output signal level
to optimal level for receiving party (usually demodulator ADC).

Each gain stage could be set rather often both manual or automatic
(AGC) mode. Due to that add separate controls for controlling
operation mode.

Antti Palosaari (1):
  v4l: add RF tuner gain controls

 drivers/media/v4l2-core/v4l2-ctrls.c | 15 +++++++++++++++
 include/uapi/linux/v4l2-controls.h   | 11 +++++++++++
 2 files changed, 26 insertions(+)

-- 
1.8.5.3

