Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32561 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaJPNv1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Oct 2014 09:51:27 -0400
Date: Thu, 16 Oct 2014 16:51:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org
Subject: re: V4L/DVB (7535): saa717x: add new audio/video decoder i2c driver
Message-ID: <20141016135113.GB27011@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans Verkuil,

The patch fb7b37cf913c: "V4L/DVB (7535): saa717x: add new audio/video
decoder i2c driver" from Apr 9, 2008, leads to the following static
checker warning:

	drivers/media/i2c/saa717x.c:155 saa717x_read()
	warn: right shifting more than type allows

drivers/media/i2c/saa717x.c
   133  static u32 saa717x_read(struct v4l2_subdev *sd, u32 reg)
   134  {
   135          struct i2c_client *client = v4l2_get_subdevdata(sd);
   136          struct i2c_adapter *adap = client->adapter;
   137          int fw_addr = (reg >= 0x404 && reg <= 0x4b8) || reg == 0x528;
   138          unsigned char mm1[2];
   139          unsigned char mm2[4] = { 0, 0, 0, 0 };
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   140          struct i2c_msg msgs[2];
   141          u32 value;
   142  
   143          msgs[0].flags = 0;
   144          msgs[1].flags = I2C_M_RD;
   145          msgs[0].addr = msgs[1].addr = client->addr;
   146          mm1[0] = (reg >> 8) & 0xff;
   147          mm1[1] = reg & 0xff;
   148          msgs[0].len = 2;
   149          msgs[0].buf = mm1;
   150          msgs[1].len = fw_addr ? 3 : 1; /* Multibyte Registers contains *only* 3 bytes */
   151          msgs[1].buf = mm2;
   152          i2c_transfer(adap, msgs, 2);
   153  
   154          if (fw_addr)
   155                  value = (mm2[2] & 0xff)  | ((mm2[1] & 0xff) >> 8) | ((mm2[0] & 0xff) >> 16);

The mask and shift doesn't make sense for chars  (also it's reversed).

   156          else
   157                  value = mm2[0] & 0xff;

My guess is the intention was:

        if (fw_addr)
                value = mm2[2] | mm2[1] | mm2[0];
        else
                value = mm2[0];

   158  
   159          v4l2_dbg(2, debug, sd, "read:  reg 0x%03x=0x%08x\n", reg, value);
   160          return value;
   161  }


regards,
dan carpenter
