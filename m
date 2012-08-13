Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:43217 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab2HMQ6W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 12:58:22 -0400
Date: Mon, 13 Aug 2012 19:58:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] lmedm04: fix build
Message-ID: <20120813165811.GB5363@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro Carvalho Chehab,

The patch db6651a9ebb3: "[media] lmedm04: fix build" from Aug 12, 
2012, leads to the following warning:
drivers/media/dvb/dvb-usb-v2/lmedm04.c:769 lme2510_download_firmware()
	 error: usb_control_msg() 'data' too small (128 vs 265)

   737          data = kzalloc(128, GFP_KERNEL);
                               ^^^
data is 128 bytes.

   738          if (!data) {
   739                  info("FRM Could not start Firmware Download"\
   740                          "(Buffer allocation failed)");
   741                  return -ENOMEM;
   742          }
   743  

[snip]

   768  
   769          usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
   770                          0x06, 0x80, 0x0200, 0x00, data, 0x0109, 1000);
                                                                ^^^^^^

Smatch expects this parameter to equal to sizeof(data) or smaller
instead of 265.

regards,
dan carpenter

