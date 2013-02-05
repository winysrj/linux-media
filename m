Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30980 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab3BETAu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 14:00:50 -0500
Date: Tue, 5 Feb 2013 22:00:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: stoth@linuxtv.org
Cc: linux-media@vger.kernel.org
Subject: re: V4L/DVB (8986): cx24116: Adding DVB-S2 demodulator support
Message-ID: <20130205190032.GA17573@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Steven Toth,

The patch 0d46748c3f87: "V4L/DVB (8986): cx24116: Adding DVB-S2 
demodulator support" from Sep 4, 2008, leads to the following warning:
"drivers/media/dvb-frontends/cx24116.c:983 cx24116_send_diseqc_msg()
	 error: buffer overflow 'd->msg' 6 <= 23"

drivers/media/dvb-frontends/cx24116.c
   977          /* Validate length */
   978          if (d->msg_len > (CX24116_ARGLEN - CX24116_DISEQC_MSGOFS))
   979                  return -EINVAL;
   980  
   981          /* DiSEqC message */
   982          for (i = 0; i < d->msg_len; i++)
   983                  state->dsec_cmd.args[CX24116_DISEQC_MSGOFS + i] = d->msg[i];
   984  

The state->dsec_cmd.args[] array has 30 elements.  The d->msg[] array
has only 6 elements.  We check that we don't write past the end of the
bigger array, but we could read past the end of the smaller array.
d->msg_len comes from the user.

I don't know if this can result in an information leak?

It's weird that we're copying bogus data into the state->dsec_cmd.args[]
array.

regards,
dan carpenter

