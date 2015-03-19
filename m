Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25943 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbbCSWiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 18:38:18 -0400
Date: Fri, 20 Mar 2015 01:38:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hamohammed.sa@gmail.com
Cc: linux-media@vger.kernel.org
Subject: re: Staging: media: replace pr_* with dev_*
Message-ID: <20150319223810.GA13745@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Haneen Mohammed,

The patch 2c9356d115c9: "Staging: media: replace pr_* with dev_*"
from Mar 18, 2015, leads to the following static checker warning:

	drivers/staging/media/lirc/lirc_sasem.c:176 delete_context()
	error: dereferencing freed memory 'context'

drivers/staging/media/lirc/lirc_sasem.c
   166  static void delete_context(struct sasem_context *context)
   167  {
   168          usb_free_urb(context->tx_urb);  /* VFD */
   169          usb_free_urb(context->rx_urb);  /* IR */
   170          lirc_buffer_free(context->driver->rbuf);
   171          kfree(context->driver->rbuf);
   172          kfree(context->driver);
   173          kfree(context);
                      ^^^^^^^
Free.

   174  
   175          if (debug)
   176                  dev_info(&context->dev->dev, "%s: context deleted\n",
                                  ^^^^^^^^^^^^^^^^^
Use after free.  We could go back to pr_info(), or move this in front of
the free or probably the best option is just to delete the printk.  It
doesn't look very useful.

   177                           __func__);
   178  }

regards,
dan carpenter
