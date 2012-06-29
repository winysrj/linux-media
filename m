Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab2F2VwB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 17:52:01 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5TLq1lF024161
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 29 Jun 2012 17:52:01 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] drxk: use request_firmware_nowait()
Date: Fri, 29 Jun 2012 18:51:53 -0300
Message-Id: <1341006717-32373-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <20120629124719.2cf23f6b@endymion.delvare>
References: <20120629124719.2cf23f6b@endymion.delvare>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series should be applied after "i2c: Export an unlocked 
flavor of i2c_transfer". It converts the drxk driver to use
request_firmware_nowait() and prevents I2C bus usage during firmware
load.

If firmware load doesn't happen and the device cannot be reset due
to that, -ENODEV will be returned to all dvb callbacks.

Mauro Carvalho Chehab (4):
  [media] drxk: change it to use request_firmware_nowait()
  [media] drxk: pass drxk priv struct instead of I2C adapter to i2c
    calls
  [media] drxk: Lock I2C bus during firmware load
  [media] drxk: prevent doing something wrong when init is not ok

 drivers/media/dvb/frontends/drxk_hard.c |  228 +++++++++++++++++++++++--------
 drivers/media/dvb/frontends/drxk_hard.h |   16 ++-
 2 files changed, 187 insertions(+), 57 deletions(-)

-- 
1.7.10.2

