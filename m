Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:35448 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2JJHQ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 03:16:56 -0400
Date: Wed, 10 Oct 2012 10:16:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: liplianin@me.by
Cc: linux-media@vger.kernel.org
Subject: re: V4L/DVB (13678): Add support for yet another DvbWorld, TeVii and
 Prof USB devices
Message-ID: <20121010071647.GA26117@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Igor M. Liplianin,

The patch 141cc35e2d29: "V4L/DVB (13678): Add support for yet another
DvbWorld, TeVii and Prof USB devices" from Nov 27, 2009, leads to the
following Sparse warning:

	drivers/media/usb/dvb-usb/dw2102.c:288:36: error: bad constant
	expression

  CHECK   drivers/media/usb/dvb-usb/dw2102.c
drivers/media/usb/dvb-usb/dw2102.c:288:36: error: bad constant expression
drivers/media/usb/dvb-usb/dw2102.c:305:44: error: bad constant expression
drivers/media/usb/dvb-usb/dw2102.c:315:44: error: bad constant expression
drivers/media/usb/dvb-usb/dw2102.c:381:53: error: bad constant expression
drivers/media/usb/dvb-usb/dw2102.c:410:52: error: bad constant expression
drivers/media/usb/dvb-usb/dw2102.c:443:36: error: bad constant expression
drivers/media/usb/dvb-usb/dw2102.c:461:44: error: bad constant expression
drivers/media/usb/dvb-usb/dw2102.c:543:47: error: bad constant expression
drivers/media/usb/dvb-usb/dw2102.c:570:52: error: bad constant expression
drivers/media/usb/dvb-usb/dw2102.c:582:52: error: bad constant expression
  CC [M]  drivers/media/usb/dvb-usb/dw2102.o


   284          switch (num) {
   285          case 2: {
   286                  /* read */
   287                  /* first write first register number */
   288                  u8 ibuf[msg[1].len + 2], obuf[3];
                                ^^^^^^^^^^^^^^
The kernel has an 8k stack so the worry is that len could larger than
that.

   289                  obuf[0] = msg[0].addr << 1;
   290                  obuf[1] = msg[0].len;
   291                  obuf[2] = msg[0].buf[0];
   292                  dw210x_op_rw(d->udev, 0xc2, 0, 0,
   293                                  obuf, msg[0].len + 2, DW210X_WRITE_MSG);
   294                  /* second read registers */
   295                  dw210x_op_rw(d->udev, 0xc3, 0xd1 , 0,
   296                                  ibuf, msg[1].len + 2, DW210X_READ_MSG);
   297                  memcpy(msg[1].buf, ibuf + 2, msg[1].len);
   298  
   299                  break;
   300          }

regards,
dan carpenter

