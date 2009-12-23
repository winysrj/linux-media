Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.zhaw.ch ([160.85.104.51]:60615 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbZLWNAR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 08:00:17 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH 2/3] [V4L/DVB] dvb-usb-friio: Storage class should be before const qualifier
Date: Wed, 23 Dec 2009 13:53:13 +0100
Message-Id: <1261572794-8369-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <1261572794-8369-1-git-send-email-tklauser@distanz.ch>
References: <1261572794-8369-1-git-send-email-tklauser@distanz.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/media/dvb/dvb-usb/friio-fe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/friio-fe.c b/drivers/media/dvb/dvb-usb/friio-fe.c
index ebb7b9f..d14bd22 100644
--- a/drivers/media/dvb/dvb-usb/friio-fe.c
+++ b/drivers/media/dvb/dvb-usb/friio-fe.c
@@ -366,7 +366,7 @@ static u8 init_code[][2] = {
 	{0x76, 0x0C},
 };
 
-const static int init_code_len = sizeof(init_code) / sizeof(u8[2]);
+static const int init_code_len = sizeof(init_code) / sizeof(u8[2]);
 
 static int jdvbt90502_init(struct dvb_frontend *fe)
 {
-- 
1.6.3.3

