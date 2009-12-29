Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out10.libero.it ([212.52.84.110]:42085 "EHLO
	cp-out10.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbZL2SrX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 13:47:23 -0500
Received: from [151.81.53.78] (151.81.53.78) by cp-out10.libero.it (8.5.107)
        id 4B326F69006BEECE for linux-media@vger.kernel.org; Tue, 29 Dec 2009 19:47:22 +0100
Subject: [PATCH] IR: Fix sysfs attributes declaration
From: Francesco Lavra <francescolavra@interfree.it>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 29 Dec 2009 19:48:04 +0100
Message-Id: <1262112484.2707.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
This patch fixes the declaration of the sysfs attributes for IR's, which
must be a NULL-terminated array of struct attribute *.
Without this patch, my machine crashes when inserting a DVB card.
I'm using a 2.6.32 kernel.
Regards,
Francesco

Signed-off-by: Francesco Lavra <francescolavra@interfree.it>

--- a/linux/drivers/media/IR/ir-sysfs.c	2009-12-29 19:36:04.000000000 +0100
+++ b/linux/drivers/media/IR/ir-sysfs.c	2009-12-29 19:36:49.000000000 +0100
@@ -127,6 +127,7 @@ static DEVICE_ATTR(current_protocol, S_I
 
 static struct attribute *ir_dev_attrs[] = {
 	&dev_attr_current_protocol.attr,
+	NULL,
 };
 
 /**


