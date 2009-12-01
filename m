Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbZLAP3y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 10:29:54 -0500
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nB1FU05L006794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Dec 2009 10:30:00 -0500
Received: from patchwork.usersys.redhat.com (dell-pe1800-02.lab.bos.redhat.com [10.16.42.196])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id nB1FU0C9018525
	for <linux-media@vger.kernel.org>; Tue, 1 Dec 2009 10:30:00 -0500
Date: Tue, 1 Dec 2009 10:31:39 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] bttv: fix MODULE_PARM_DESC for i2c_debug and i2c_hw
Message-ID: <20091201153139.GA10871@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, i2c_debug shows up w/o a desc in modinfo, and i2c_hw shows
up with i2c_debug's desc. Fix that.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

diff -r e0cd9a337600 linux/drivers/media/video/bt8xx/bttv-i2c.c
--- a/linux/drivers/media/video/bt8xx/bttv-i2c.c	Sun Nov 29 12:08:02 2009 -0200
+++ b/linux/drivers/media/video/bt8xx/bttv-i2c.c	Tue Dec 01 10:23:54 2009 -0500
@@ -40,7 +40,7 @@
 static int i2c_hw;
 static int i2c_scan;
 module_param(i2c_debug, int, 0644);
-MODULE_PARM_DESC(i2c_hw,"configure i2c debug level");
+MODULE_PARM_DESC(i2c_debug,"configure i2c debug level");
 module_param(i2c_hw,    int, 0444);
 MODULE_PARM_DESC(i2c_hw,"force use of hardware i2c support, "
 			"instead of software bitbang");
