Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20820 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab3KAK20 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Nov 2013 06:28:26 -0400
Date: Fri, 1 Nov 2013 13:25:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] cx23885-dvb: use a better approach to hook set_frontend
Message-ID: <20131101102522.GF29795@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro Carvalho Chehab,

The patch 15472faf1259: "[media] cx23885-dvb: use a better approach
to hook set_frontend" from Aug 9, 2013, leads to the following
warning:
"drivers/media/pci/cx23885/cx23885-dvb.c:795 dvb_register()
	 error: we previously assumed 'fe0->dvb.frontend' could be null (see line 789)"

drivers/media/pci/cx23885/cx23885-dvb.c
   789                  if (fe0->dvb.frontend != NULL) {
                            ^^^^^^^^^^^^^^^^^^^^^^^^^
Null check.

   790                          dvb_attach(tda18271_attach, fe0->dvb.frontend,
   791                                     0x60, &dev->i2c_bus[1].i2c_adap,
   792                                     &hauppauge_hvr127x_config);
   793                  }
   794                  if (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1275)
   795                          cx23885_set_frontend_hook(port, fe0->dvb.frontend);
                                                                ^^^^^^^^^^^^^^^^^
New unchecked dereference.

   796                  break;

[snip]

  1138          case CX23885_BOARD_MYGICA_X8506:
  1139                  i2c_bus = &dev->i2c_bus[0];
  1140                  i2c_bus2 = &dev->i2c_bus[1];
  1141                  fe0->dvb.frontend = dvb_attach(lgs8gxx_attach,
  1142                          &mygica_x8506_lgs8gl5_config,
  1143                          &i2c_bus->i2c_adap);
  1144                  if (fe0->dvb.frontend != NULL) {
                            ^^^^^^^^^^^^^^^^^^^^^^^^^
check.

  1145                          dvb_attach(xc5000_attach,
  1146                                  fe0->dvb.frontend,
  1147                                  &i2c_bus2->i2c_adap,
  1148                                  &mygica_x8506_xc5000_config);
  1149                  }
  1150                  cx23885_set_frontend_hook(port, fe0->dvb.frontend);
                                                        ^^^^^^^^^^^^^^^^^
Dereference.
  1151                  break;


regards,
dan carpenter

