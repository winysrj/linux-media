Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42578 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3HWJfC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 05:35:02 -0400
Date: Fri, 23 Aug 2013 12:35:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: s.nawrocki@samsung.com
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: re: [media] s5p-csis: Add support for non-image data packets capture
Message-ID: <20130823093504.GJ31293@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sylwester Nawrocki,

I had a question about 36fa80927638: "[media] s5p-csis: Add support for
non-image data packets capture" from Sep 21, 2012.

S5PCSIS_INTSRC_NON_IMAGE_DATA is defined in mipi-csis.c:

#define S5PCSIS_INTSRC_NON_IMAGE_DATA   (0xff << 28)

And it's only used in one place.

drivers/media/platform/exynos4-is/mipi-csis.c
   692          u32 status;
   693  
   694          status = s5pcsis_read(state, S5PCSIS_INTSRC);
   695          spin_lock_irqsave(&state->slock, flags);
   696  
   697          if ((status & S5PCSIS_INTSRC_NON_IMAGE_DATA) && pktbuf->data) {
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"status" is a u32 so 0xff0000000 is 4 bits too much.  In other words,
the mask is effectively "(0xf << 28)".  Was that intended or should it
be (0xff << 24)?

   698                  u32 offset;
   699  
   700                  if (status & S5PCSIS_INTSRC_EVEN)
   701                          offset = S5PCSIS_PKTDATA_EVEN;

regards,
dan carpenter

