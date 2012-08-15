Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:26609 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab2HOOl2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 10:41:28 -0400
Date: Wed, 15 Aug 2012 17:41:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jarod@redhat.com
Cc: linux-media@vger.kernel.org
Subject: [bug report] buffer overflow in redrat3_transmit_ir()
Message-ID: <20120815144115.GA25050@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jarod Wilson,

The patch 2154be651b90: "[media] redrat3: new rc-core IR transceiver 
device driver" from May 4, 2011, leads to the following warning:
drivers/media/rc/redrat3.c:948 redrat3_transmit_ir()
	 error: buffer overflow 'sample_lens' 128 <= 254

drivers/media/rc/redrat3.c
   929          sample_lens = kzalloc(sizeof(int) * RR3_DRIVER_MAXLENS, GFP_KERNEL);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
sample_lens has space for 128 ints.

   930          if (!sample_lens) {
   931                  ret = -ENOMEM;
   932                  goto out;
   933          }
   934  
   935          for (i = 0; i < count; i++) {
   936                  for (lencheck = 0; lencheck < curlencheck; lencheck++) {
   937                          cur_sample_len = redrat3_us_to_len(txbuf[i]);
   938                          if (sample_lens[lencheck] == cur_sample_len)
   939                                  break;
   940                  }
   941                  if (lencheck == curlencheck) {
   942                          cur_sample_len = redrat3_us_to_len(txbuf[i]);
   943                          rr3_dbg(dev, "txbuf[%d]=%u, pos %d, enc %u\n",
   944                                  i, txbuf[i], curlencheck, cur_sample_len);
   945                          if (curlencheck < 255) {
                                    ^^^^^^^^^^^^^^^^^
curlencheck goes up  to 254.

   946                                  /* now convert the value to a proper
   947                                   * rr3 value.. */
   948                                  sample_lens[curlencheck] = cur_sample_len;
                                        ^^^^^^^^^^^^^^^^^^^^^^^^
overflow.

   949                                  curlencheck++;
   950                          } else {

regards,
dan carpenter

