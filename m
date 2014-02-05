Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37082 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151AbaBEAFx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Feb 2014 19:05:53 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH v2] DVB tuner use v4l2 controls
Date: Wed,  5 Feb 2014 02:05:33 +0200
Message-Id: <1391558734-26237-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Split .s_ctrl logic according to Hans comments.

regards
Antti

Antti Palosaari (1):
  e4000: implement controls via v4l2 control framework

 drivers/media/tuners/e4000.c      | 210 +++++++++++++++++++++++++++++++++++++-
 drivers/media/tuners/e4000.h      |  14 +++
 drivers/media/tuners/e4000_priv.h |  12 +++
 3 files changed, 235 insertions(+), 1 deletion(-)

-- 
1.8.5.3

