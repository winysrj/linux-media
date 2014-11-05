Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58882 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbaKEIR7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 03:17:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/8] sp2: fix sparse warnings
Date: Wed,  5 Nov 2014 09:17:48 +0100
Message-Id: <1415175472-24203-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
References: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

sp2.c:272:5: warning: symbol 'sp2_init' was not declared. Should it be static?
sp2.c:354:5: warning: symbol 'sp2_exit' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/sp2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/sp2.c b/drivers/media/dvb-frontends/sp2.c
index 320cbe9..cc1ef96 100644
--- a/drivers/media/dvb-frontends/sp2.c
+++ b/drivers/media/dvb-frontends/sp2.c
@@ -269,7 +269,7 @@ int sp2_ci_poll_slot_status(struct dvb_ca_en50221 *en50221,
 	return s->status;
 }
 
-int sp2_init(struct sp2 *s)
+static int sp2_init(struct sp2 *s)
 {
 	int ret = 0;
 	u8 buf;
@@ -351,7 +351,7 @@ err:
 	return ret;
 }
 
-int sp2_exit(struct i2c_client *client)
+static int sp2_exit(struct i2c_client *client)
 {
 	struct sp2 *s;
 
-- 
2.1.1

