Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47126 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdLNIJc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 03:09:32 -0500
Date: Thu, 14 Dec 2017 11:03:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: rjkm@metzlerbros.de
Cc: linux-media@vger.kernel.org
Subject: [bug report] drx: add initial drx-d driver
Message-ID: <20171214080316.nadtlgwyng3r7gro@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Ralph Metzler,

The patch 126f1e618870: "drx: add initial drx-d driver" from Mar 12,
2011, leads to the following static checker warning:

	drivers/media/dvb-frontends/drxd_hard.c:1305 SC_WaitForReady()
	info: return a literal instead of 'status'

drivers/media/dvb-frontends/drxd_hard.c
  1298  static int SC_WaitForReady(struct drxd_state *state)
  1299  {
  1300          int i;
  1301  
  1302          for (i = 0; i < DRXD_MAX_RETRIES; i += 1) {
  1303                  int status = Read16(state, SC_RA_RAM_CMD__A, NULL, 0);
  1304                  if (status == 0)
  1305                          return status;
                                ^^^^^^^^^^^^^
The register is set to zero when ready?  The answer should obviously be
yes, but it wouldn't totally surprise me if this function just always
looped 1000 times...  Few of the callers check the return.  Anyway, it's
more clear to just "return 0;"

  1306          }
  1307          return -1;
                       ^^
-1 is not a proper error code.

  1308  }

regards,
dan carpenter
