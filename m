Return-path: <linux-media-owner@vger.kernel.org>
Received: from webclient5.webclient5.de ([136.243.32.179]:43321 "EHLO
        webclient5.webclient5.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751717AbdDAP77 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Apr 2017 11:59:59 -0400
Received: from [192.168.42.193] (tmo-096-106.customers.d1-online.com [80.187.96.106])
        by webclient5.webclient5.de (Postfix) with ESMTPSA id 0D79B5583388
        for <linux-media@vger.kernel.org>; Sat,  1 Apr 2017 17:50:55 +0200 (CEST)
To: linux-media@vger.kernel.org
From: Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH] libdvbv5: T2 delivery descriptor: fix wrong size of bandwidth
 field
Message-ID: <dc2b16b2-7caa-6141-a983-c83631544f3e@ladisch.de>
Date: Sat, 1 Apr 2017 17:50:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ETSI EN 300 468 V1.11.1 § 6.4.4.2 defines the bandwith field as having
four bits.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- v4l-utils/lib/include/libdvbv5/desc_t2_delivery.h.orig
+++ v4l-utils/lib/include/libdvbv5/desc_t2_delivery.h
@@ -86,7 +86,7 @@ struct dvb_desc_t2_delivery {
 			uint16_t transmission_mode:3;
 			uint16_t guard_interval:3;
 			uint16_t reserved:2;
-			uint16_t bandwidth:3;
+			uint16_t bandwidth:4;
 			uint16_t SISO_MISO:2;
 		} __attribute__((packed));
 	} __attribute__((packed));
