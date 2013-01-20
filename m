Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:56354 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab3ATVXB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jan 2013 16:23:01 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 0/4] saa7134: Add AverMedia A706 AverTV Satellite Hybrid+FM
Date: Sun, 20 Jan 2013 22:22:15 +0100
Message-Id: <1358716939-2133-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Add AverMedia AverTV Satellite Hybrid+FM (A706) card to saa7134 driver.

This requires some changes to tda8290 - disabling I2C gate control and
passing custom std_map to tda18271.
Also tuner-core needs to be changed because there's currently no way to pass
any complex configuration to analog tuners.

-- 
Ondrej Zary
