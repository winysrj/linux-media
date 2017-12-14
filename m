Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:9546 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754063AbdLNWB1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 17:01:27 -0500
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23090.62262.800851.660592@morden.metzler>
Date: Thu, 14 Dec 2017 22:55:02 +0100
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Subject: [bug report] drx: add initial drx-d driver
In-Reply-To: <20171214080316.nadtlgwyng3r7gro@mwanda>
References: <20171214080316.nadtlgwyng3r7gro@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Dan Carpenter,

Dan Carpenter writes:
 > Hello Ralph Metzler,
 > 
 > The patch 126f1e618870: "drx: add initial drx-d driver" from Mar 12,
 > 2011, leads to the following static checker warning:
 > 
 > 	drivers/media/dvb-frontends/drxd_hard.c:1305 SC_WaitForReady()
 > 	info: return a literal instead of 'status'
 > 
 > drivers/media/dvb-frontends/drxd_hard.c
 >   1298  static int SC_WaitForReady(struct drxd_state *state)
 >   1299  {
 >   1300          int i;
 >   1301  
 >   1302          for (i = 0; i < DRXD_MAX_RETRIES; i += 1) {
 >   1303                  int status = Read16(state, SC_RA_RAM_CMD__A, NULL, 0);
 >   1304                  if (status == 0)
 >   1305                          return status;
 >                                 ^^^^^^^^^^^^^
 > The register is set to zero when ready?  The answer should obviously be
 > yes, but it wouldn't totally surprise me if this function just always
 > looped 1000 times...  Few of the callers check the return.  Anyway, it's
 > more clear to just "return 0;"
 > 
 >   1306          }
 >   1307          return -1;
 >                        ^^
 > -1 is not a proper error code.
 > 
 >   1308  }
 > 
 > regards,
 > dan carpenter

I think I wrote the driver more than 10 years ago and somebody later submitted it
to the kernel.

I don't know if there is a anybody still maintaining this. Is it even used anymore?
I could write a patch but cannot test it (e.g. to see if it really always
loops 1000 times ...)


Regards,
Ralph Metzler

-- 
--
