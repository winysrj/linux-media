Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46856 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934875Ab3DIJFB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 05:05:01 -0400
Date: Tue, 9 Apr 2013 12:02:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sean@mess.org
Cc: linux-media@vger.kernel.org
Subject: re: [media] redrat3: remove memcpys and fix unaligned memory access
Message-ID: <20130409090259.GA1544@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

I had a question about 4c055a5ae94c: "[media] redrat3: remove memcpys
and fix unaligned memory access" from Feb 16, 2013.

drivers/media/rc/redrat3.c
   619          /* grab the Length and type of transfer */
   620          pktlen = be16_to_cpu(header->length);
   621          pkttype = be16_to_cpu(header->transfer_type);
   622  
   623          if (pktlen > sizeof(rr3->irdata)) {
   624                  dev_warn(rr3->dev, "packet length %u too large\n", pktlen);
   625                  return;
   626          }
   627  
   628          switch (pkttype) {
   629          case RR3_ERROR:
   630                  if (len >= sizeof(struct redrat3_error)) {
   631                          struct redrat3_error *error = rr3->bulk_in_buf;
   632                          unsigned fw_error = be16_to_cpu(error->fw_error);
   633                          redrat3_dump_fw_error(rr3, fw_error);
   634                  }
   635                  break;
   636  
   637          case RR3_MOD_SIGNAL_IN:
   638                  memcpy(&rr3->irdata, rr3->bulk_in_buf, len);
                                                               ^^^
   639                  rr3->bytes_read = len;
                                          ^^^
   640                  rr3_dbg(rr3->dev, "bytes_read %d, pktlen %d\n",
   641                          rr3->bytes_read, pktlen);
                                                 ^^^^^^
Should we be copying "pktlen" bytes on the line before?  It seems
inconsistent that it doesn't match the debug code.

My main concern is that we limit the size of "pktlen" but then we only
use it for debug output.

   642                  break;

regards,
dan carpenter

