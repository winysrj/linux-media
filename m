Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:59716 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab1KXJHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 04:07:25 -0500
Date: Thu, 24 Nov 2011 12:06:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch 2/2] staging/media: lirc_imon: remove unused definitions
Message-ID: <20111124090648.GB22994@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't have these functions any more now we have module_usb_driver().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I don't know if this goes in through USB or the media tree.

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index f682180..c3eae4d 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -70,10 +70,6 @@ static ssize_t vfd_write(struct file *file, const char *buf,
 static int ir_open(void *data);
 static void ir_close(void *data);
 
-/* Driver init/exit prototypes */
-static int __init imon_init(void);
-static void __exit imon_exit(void);
-
 /*** G L O B A L S ***/
 #define IMON_DATA_BUF_SZ	35
 
