Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35083 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbbKMD2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 22:28:47 -0500
Received: by pasz6 with SMTP id z6so88759521pas.2
        for <linux-media@vger.kernel.org>; Thu, 12 Nov 2015 19:28:47 -0800 (PST)
Received: from yeung-GA-880GM-D2H (183179224070.ctinets.com. [183.179.224.70])
        by smtp.gmail.com with ESMTPSA id kh9sm17378861pad.11.2015.11.12.19.28.46
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 12 Nov 2015 19:28:46 -0800 (PST)
Date: Fri, 13 Nov 2015 11:28:44 +0800
From: Walter Cheuk <wwycheuk@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] tv tuner max2165 driver: extend frequency range
Message-ID: <20151113112844.09c574d6@yeung-GA-880GM-D2H>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the frequency range to cover Hong Kong's digital TV broadcasting; RTHK TV uses 802MHz and is not covered now. Tested on my TV tuner card "MyGica X8558 Pro".

Signed-off-by: Walter Cheuk <wwycheuk@gmail.com>

---

--- media_build/media/drivers/media/tuners/max2165.c.orig	2015-10-22 12:01:24.867254181 +0800
+++ media_build/media/drivers/media/tuners/max2165.c	2015-11-13 00:31:59.220345032 +0800
@@ -385,7 +385,7 @@ static const struct dvb_tuner_ops max216
 	.info = {
 		.name           = "Maxim MAX2165",
 		.frequency_min  = 470000000,
-		.frequency_max  = 780000000,
+		.frequency_max  = 862000000,
 		.frequency_step =     50000,
 	},
 
