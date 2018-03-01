Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57782 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967186AbeCAKAG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 05:00:06 -0500
Date: Thu, 1 Mar 2018 12:59:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jacopo+renesas@jmondi.org
Cc: linux-media@vger.kernel.org
Subject: [bug report] media: i2c: Copy tw9910 soc_camera sensor driver
Message-ID: <20180301095954.GA12656@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[ I know you're just copying files, but you might have a fix for these
  since you're looking at the code.  - dan ]

Hello Jacopo Mondi,

The patch e0d76c3842ee: "media: i2c: Copy tw9910 soc_camera sensor
driver" from Feb 21, 2018, leads to the following static checker
warning:

    drivers/media/i2c/tw9910.c:395 tw9910_set_hsync()
    warn: odd binop '0x260 & 0x7'

    drivers/media/i2c/tw9910.c:396 tw9910_set_hsync()
    warn: odd binop '0x300 & 0x7'

    drivers/media/i2c/tw9910.c:538 tw9910_s_std()
    warn: odd binop '0x0 & 0xc'

drivers/media/i2c/tw9910.c
   374  static int tw9910_set_hsync(struct i2c_client *client)
   375  {
   376          struct tw9910_priv *priv = to_tw9910(client);
   377          int ret;
   378  
   379          /* bit 10 - 3 */
   380          ret = i2c_smbus_write_byte_data(client, HSBEGIN,
   381                                          (HSYNC_START & 0x07F8) >> 3);
   382          if (ret < 0)
   383                  return ret;
   384  
   385          /* bit 10 - 3 */
   386          ret = i2c_smbus_write_byte_data(client, HSEND,
   387                                          (HSYNC_END & 0x07F8) >> 3);
   388          if (ret < 0)
   389                  return ret;
   390  
   391          /* So far only revisions 0 and 1 have been seen */
   392          /* bit 2 - 0 */
   393          if (priv->revision == 1)
   394                  ret = tw9910_mask_set(client, HSLOWCTL, 0x77,
   395                                        (HSYNC_START & 0x0007) << 4 |
                                               ^^^^^^^^^^^^^^^^^^^^
   396                                        (HSYNC_END   & 0x0007));
                                               ^^^^^^^^^^^^^^^^^^^^
These always mask to zero.

   397  
   398          return ret;
   399  }

[ snip ]

   511  static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
   512  {
   513          struct i2c_client *client = v4l2_get_subdevdata(sd);
   514          struct tw9910_priv *priv = to_tw9910(client);
   515          const unsigned int hact = 720;
   516          const unsigned int hdelay = 15;
                                   ^^^^^^^^^^^
   517          unsigned int vact;
   518          unsigned int vdelay;
   519          int ret;
   520  
   521          if (!(norm & (V4L2_STD_NTSC | V4L2_STD_PAL)))
   522                  return -EINVAL;
   523  
   524          priv->norm = norm;
   525          if (norm & V4L2_STD_525_60) {
   526                  vact = 240;
   527                  vdelay = 18;
   528                  ret = tw9910_mask_set(client, VVBI, 0x10, 0x10);
   529          } else {
   530                  vact = 288;
   531                  vdelay = 24;
   532                  ret = tw9910_mask_set(client, VVBI, 0x10, 0x00);
   533          }
   534          if (!ret)
   535                  ret = i2c_smbus_write_byte_data(client, CROP_HI,
   536                                                  ((vdelay >> 2) & 0xc0) |
   537                          ((vact >> 4) & 0x30) |
   538                          ((hdelay >> 6) & 0x0c) |
                                  ^^^^^^^^^^^
15 >> 6 is zero.

   539                          ((hact >> 8) & 0x03));
   540          if (!ret)
   541                  ret = i2c_smbus_write_byte_data(client, VDELAY_LO,
   542                                                  vdelay & 0xff);
   543          if (!ret)
   544                  ret = i2c_smbus_write_byte_data(client, VACTIVE_LO,
   545                                                  vact & 0xff);
   546  
   547          return ret;
   548  }

regards,
dan carpenter
