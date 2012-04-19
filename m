Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:23008 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab2DSRZR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 13:25:17 -0400
Date: Thu, 19 Apr 2012 20:25:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mchehab@redhat.com
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Subject: re: [media] fintek-cir: add support for newer chip version
Message-ID: <20120419172510.GA14649@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The patch 83ec8225b6ae: "[media] fintek-cir: add support for newer 
chip version" from Feb 14, 2012, leads to the following warning:
drivers/media/rc/fintek-cir.c:200 fintek_hw_detect()
	 warn: known condition '1032 != 2052'

drivers/media/rc/fintek-cir.c
   197          /*
   198           * Newer reviews of this chipset uses port 8 instead of 5
   199           */
   200          if ((chip != 0x0408) || (chip != 0x0804))
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
One of these conditions is always true.

Probably it should it be:
		if ((chip == 0x0408) || (chip == 0x0804))
or:
		if ((chip != 0x0408) && (chip != 0x0804))
depending one if those are the newer or the older chipsets.  I googled
for it a bit and then decided to just email you.  :P

   201                  fintek->logical_dev_cir = LOGICAL_DEV_CIR_REV2;
   202          else
   203                  fintek->logical_dev_cir = LOGICAL_DEV_CIR_REV1;
   204  

regards,
dan carpenter

