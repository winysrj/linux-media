Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63046 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbaKCTnq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 14:43:46 -0500
Date: Tue, 4 Nov 2014 03:43:32 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: [PATCH linus] sp2: sp2_init() can be static
Message-ID: <20141103194332.GA40215@lkp-sb04.lkp.intel.com>
References: <201411040318.niuibqCw%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201411040318.niuibqCw%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/sp2.c:269:5: sparse: symbol 'sp2_init' was not declared. Should it be static?
drivers/media/dvb-frontends/sp2.c:351:5: sparse: symbol 'sp2_exit' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 sp2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/sp2.c b/drivers/media/dvb-frontends/sp2.c
index 9b684d5..15bf431 100644
--- a/drivers/media/dvb-frontends/sp2.c
+++ b/drivers/media/dvb-frontends/sp2.c
@@ -266,7 +266,7 @@ int sp2_ci_poll_slot_status(struct dvb_ca_en50221 *en50221,
 	return s->status;
 }
 
-int sp2_init(struct sp2 *s)
+static int sp2_init(struct sp2 *s)
 {
 	int ret = 0;
 	u8 buf;
@@ -348,7 +348,7 @@ err:
 	return ret;
 }
 
-int sp2_exit(struct i2c_client *client)
+static int sp2_exit(struct i2c_client *client)
 {
 	struct sp2 *s;
 
