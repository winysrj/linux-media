Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1130 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab0C0C2B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Mar 2010 22:28:01 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mark McClelland <mmcclell@bigfoot.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 4/9] drivers/media: Fix continuation lines
Date: Fri, 26 Mar 2010 19:27:53 -0700
Message-Id: <7f93502db8067b13d82ab858b7b6ededd9cf38da.1269655208.git.joe@perches.com>
In-Reply-To: <cover.1269655208.git.joe@perches.com>
References: <cover.1269655208.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/ov511.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index e0bce8d..c34325c 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -57,8 +57,8 @@
 #define DRIVER_VERSION "v1.64 for Linux 2.5"
 #define EMAIL "mark@alpha.dyndns.org"
 #define DRIVER_AUTHOR "Mark McClelland <mark@alpha.dyndns.org> & Bret Wallach \
-	& Orion Sky Lawlor <olawlor@acm.org> & Kevin Moore & Charl P. Botha \
-	<cpbotha@ieee.org> & Claudio Matsuoka <claudio@conectiva.com>"
+& Orion Sky Lawlor <olawlor@acm.org> & Kevin Moore & Charl P. Botha \
+<cpbotha@ieee.org> & Claudio Matsuoka <claudio@conectiva.com>"
 #define DRIVER_DESC "ov511 USB Camera Driver"
 
 #define OV511_I2C_RETRIES 3
-- 
1.7.0.14.g7e948

