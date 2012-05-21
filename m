Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:24869 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab2EUN6P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 May 2012 09:58:15 -0400
Date: Mon, 21 May 2012 16:58:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mkrufky@linuxtv.org
Cc: linux-media@vger.kernel.org
Subject: re: [media] DVB: add support for the LG2160 ATSC-MH demodulator
Message-ID: <20120521135801.GA21460@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

I have a question about e26f2ae4527b: "[media] DVB: add support for the
LG2160 ATSC-MH demodulator" from Jan 29, 2012.

   122  static int lg216x_write_regs(struct lg216x_state *state,
   123                               struct lg216x_reg *regs, int len)
   124  {
   125          int i, ret;
   126  
   127          lg_reg("writing %d registers...\n", len);
   128  
   129          for (i = 0; i < len - 1; i++) {
                            ^^^^^^^^^^^
Shouldn't this just be i < len?  Why do we skip the last element in the
array?

   130                  ret = lg216x_write_reg(state, regs[i].reg, regs[i].val);
   131                  if (lg_fail(ret))
   132                          return ret;
   133          }
   134          return 0;
   135  }

This function is called like:
	ret = lg216x_write_regs(state, lg2160_init, ARRAY_SIZE(lg2160_init));

The last element of the lg2160_init[] array looks useful.

regards,
dan carpenter

