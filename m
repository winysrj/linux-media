Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17747 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab3IBJUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Sep 2013 05:20:10 -0400
Date: Mon, 2 Sep 2013 12:20:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] cx23885-dvb: use a better approach to hook set_frontend
Message-ID: <20130902092006.GB30037@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro Carvalho Chehab,

This is a semi-automatic email about new static checker warnings.

The patch 15472faf1259: "[media] cx23885-dvb: use a better approach
to hook set_frontend" from Aug 9, 2013, leads to the following Smatch
complaint:

drivers/media/pci/cx23885/cx23885-dvb.c:790 dvb_register()
	 error: we previously assumed 'fe0->dvb.frontend' could be null (see line 784)

drivers/media/pci/cx23885/cx23885-dvb.c
   783						       &i2c_bus->i2c_adap);
   784			if (fe0->dvb.frontend != NULL) {
                            ^^^^^^^^^^^^^^^^^^^^^^^^^
Existing check.

   785				dvb_attach(tda18271_attach, fe0->dvb.frontend,
   786					   0x60, &dev->i2c_bus[1].i2c_adap,
   787					   &hauppauge_hvr127x_config);
   788			}
   789			if (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1275)
   790				cx23885_set_frontend_hook(port, fe0->dvb.frontend);
                                                                ^^^^^^^^^^^^^^^^^
Patch adds dereference.

   791			break;
   792		case CX23885_BOARD_HAUPPAUGE_HVR1255:

regards,
dan carpenter
