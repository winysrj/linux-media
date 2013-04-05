Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:57871 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162429Ab3DEVbH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Apr 2013 17:31:07 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Subject: My patches for AverMedia A706
Date: Fri, 5 Apr 2013 23:30:22 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201304052330.23296.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
another month has passed and it seems that nothing has changed about my 
patches to support AverMedia A706 card. Is there anything I can do to help 
these patches to be merged?

Patch list:
tda8290: Allow disabling I2C gate
tda8290: Allow custom std_map for tda18271
tuner-core: Change config from unsigned int to void *
tda8290: change magic LNA config values to enum
saa7134: Add AverMedia A706 AverTV Satellite Hybrid+FM

-- 
Ondrej Zary
