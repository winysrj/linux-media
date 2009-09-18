Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway11.websitewelcome.com ([67.18.94.11]:41027 "HELO
	gateway11.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932793AbZIRSaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 14:30:17 -0400
Received: from [66.15.212.169] (port=30685 helo=[10.140.5.16])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1Moi7L-0002p3-JS
	for linux-media@vger.kernel.org; Fri, 18 Sep 2009 13:23:35 -0500
Subject: [PATCH 9/9] go7007: sound needs compat.h
From: Pete <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 11:23:39 -0700
Message-Id: <1253298219.4314.573.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding include "compat.h"

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r 1cb2c7d3fa12 -r c0babe3ffa70 linux/drivers/staging/go7007/snd-go7007.c
--- a/linux/drivers/staging/go7007/snd-go7007.c	Fri Sep 18 10:59:26 2009 -0700
+++ b/linux/drivers/staging/go7007/snd-go7007.c	Fri Sep 18 11:02:41 2009 -0700
@@ -29,6 +29,7 @@
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <asm/system.h>
+#include "compat.h"
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/initval.h>


