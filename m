Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40145 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaIXO0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 10:26:44 -0400
Date: Wed, 24 Sep 2014 17:26:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: yanguoxiong@huawei.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] rc: Introduce hix5hd2 IR transmitter driver
Message-ID: <20140924142626.GA25631@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Guoxiong Yan,

The patch a84fcdaa9058: "[media] rc: Introduce hix5hd2 IR transmitter
driver" from Aug 30, 2014, leads to the following static checker
warning:

	drivers/media/rc/ir-hix5hd2.c:111 hix5hd2_ir_config()
	warn: odd binop '0x3e80 & 0xffff0000'

drivers/media/rc/ir-hix5hd2.c
   109          /* Now only support raw mode, with symbol start from low to high */
   110          rate = DIV_ROUND_CLOSEST(priv->rate, 1000000);
   111          val = IR_CFG_SYMBOL_MAXWIDTH & IR_CFG_WIDTH_MASK << IR_CFG_WIDTH_SHIFT;
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   112          val |= IR_CFG_SYMBOL_FMT & IR_CFG_FORMAT_MASK << IR_CFG_FORMAT_SHIFT;
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

These seem like precedence bugs.  My guess is that the intent was:

		val =  (IR_CFG_SYMBOL_MAXWIDTH & IR_CFG_WIDTH_MASK) << IR_CFG_WIDTH_SHIFT;
		val |= (IR_CFG_SYMBOL_FMT & IR_CFG_FORMAT_MASK) << IR_CFG_FORMAT_SHIFT;

etc for the rest as well.

   113          val |= (IR_CFG_INT_THRESHOLD - 1) & IR_CFG_INT_LEVEL_MASK
   114                 << IR_CFG_INT_LEVEL_SHIFT;
   115          val |= IR_CFG_MODE_RAW;
   116          val |= (rate - 1) & IR_CFG_FREQ_MASK << IR_CFG_FREQ_SHIFT;
   117          writel_relaxed(val, priv->base + IR_CONFIG);

regards,
dan carpenter
