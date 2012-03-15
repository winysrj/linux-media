Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43646 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab2COReN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 13:34:13 -0400
Received: by mail-ee0-f46.google.com with SMTP id c41so1790074eek.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 10:34:12 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: crope@iki.fi, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 3/3] cxd2820r: delete unused function cxd2820r_init_t2
Date: Thu, 15 Mar 2012 18:33:49 +0100
Message-Id: <1331832829-4580-4-git-send-email-gennarone@gmail.com>
In-Reply-To: <1331832829-4580-1-git-send-email-gennarone@gmail.com>
References: <1331832829-4580-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Deleted unused declaration of function "cxd2820r_init_t2".

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/frontends/cxd2820r_priv.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r_priv.h b/drivers/media/dvb/frontends/cxd2820r_priv.h
index 9a9822c..568b996 100644
--- a/drivers/media/dvb/frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb/frontends/cxd2820r_priv.h
@@ -146,8 +146,6 @@ int cxd2820r_read_snr_t2(struct dvb_frontend *fe, u16 *snr);
 
 int cxd2820r_read_ucblocks_t2(struct dvb_frontend *fe, u32 *ucblocks);
 
-int cxd2820r_init_t2(struct dvb_frontend *fe);
-
 int cxd2820r_sleep_t2(struct dvb_frontend *fe);
 
 int cxd2820r_get_tune_settings_t2(struct dvb_frontend *fe,
-- 
1.7.5.4

