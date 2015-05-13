Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50987 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048AbbEMLLo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 07:11:44 -0400
Date: Wed, 13 May 2015 14:11:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: crope@iki.fi
Cc: linux-media@vger.kernel.org
Subject: re: rtl2832_sdr: move from staging to media
Message-ID: <20150513111127.GA29021@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Antti Palosaari,

The patch 77bbb2b049c1: "rtl2832_sdr: move from staging to media"
from Jul 15, 2014, leads to the following static checker warning:

	drivers/media/dvb-frontends/rtl2832_sdr.c:1265 rtl2832_sdr_s_ctrl()
	warn: test_bit() bitwise op in bit number

This is harmless but messy.

drivers/media/dvb-frontends/rtl2832_sdr.c
   109  
   110  struct rtl2832_sdr_dev {
   111  #define POWER_ON           (1 << 1)
   112  #define URB_BUF            (1 << 2)

We were supposed to use these to set ->flags on the next line.

   113          unsigned long flags;
   114  
   115          struct platform_device *pdev;
   116  
   117          struct video_device vdev;
   118          struct v4l2_device v4l2_dev;
   119  

[ snip ]

   389                  dev_dbg(&pdev->dev, "alloc buf=%d %p (dma %llu)\n",
   390                          dev->buf_num, dev->buf_list[dev->buf_num],
   391                          (long long)dev->dma_addr[dev->buf_num]);
   392                  dev->flags |= USB_STATE_URB_BUF;
                                      ^^^^^^^^^^^^^^^^^
But we use USB_STATE_URB_BUF (0x1) instead of URB_BUF.

   393          }

[ snip ]

  1263                  c->bandwidth_hz = dev->bandwidth->val;
  1264  
  1265                  if (!test_bit(POWER_ON, &dev->flags))
                                      ^^^^^^^^
The original intent of the code was we test "if (dev->flags & POWER_ON)"
but really what this is doing is "if (dev->flags & (1 << POWER_ON))"
which is fine because we do it consistently, but it's not pretty and it
causes static checkers to complain (and rightfully so).

  1266                          return 0;
  1267  
  1268                  if (fe->ops.tuner_ops.set_params)
  1269                          ret = fe->ops.tuner_ops.set_params(fe);
  1270                  else
  1271                          ret = 0;
  1272                  break;
  1273          default:

regards,
dan carpenter
