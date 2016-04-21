Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36139 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbcDUKLd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 06:11:33 -0400
Date: Thu, 21 Apr 2016 13:11:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mrechberger@gmail.com
Cc: linux-media@vger.kernel.org
Subject: re: [PATCH] v4l: 790: added support for terratec cinergy 250 usb
Message-ID: <20160421101121.GA712@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Markus Rechberger,

The patch e43f14af1439: "[PATCH] v4l: 790: added support for terratec
cinergy 250 usb" from Nov 8, 2005, leads to the following static
checker warning:

	drivers/media/usb/em28xx/em28xx-input.c:307 em28xx_i2c_ir_handle_key()
	error: uninitialized symbol 'protocol'.

drivers/media/usb/em28xx/em28xx-input.c
    84  static int em28xx_get_key_terratec(struct i2c_client *i2c_dev,
    85                                     enum rc_type *protocol, u32 *scancode)
    86  {
    87          unsigned char b;
    88  
    89          /* poll IR chip */
    90          if (1 != i2c_master_recv(i2c_dev, &b, 1))
    91                  return -EIO;
    92  
    93          /* it seems that 0xFE indicates that a button is still hold
    94             down, while 0xff indicates that no button is hold down. */
    95  
    96          if (b == 0xff)
    97                  return 0;
    98  
    99          if (b == 0xfe)
   100                  /* keep old data */
   101                  return 1;

This is only called from em28xx_i2c_ir_handle_key() and the "old data"
is uninitialized garbage.

   102  
   103          *protocol = RC_TYPE_UNKNOWN;
   104          *scancode = b;
   105          return 1;
   106  }

regards,
dan carpenter
