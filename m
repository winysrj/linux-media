Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27690 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbcCXShQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 14:37:16 -0400
Date: Thu, 24 Mar 2016 21:37:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] tw9910: init priv->scale and update standard
Message-ID: <20160324183705.GA9858@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans Verkuil,

The patch 1f3375e0b257: "[media] tw9910: init priv->scale and update
standard" from Jun 15, 2015, leads to the following static checker
warning:

	drivers/media/i2c/soc_camera/tw9910.c:536 tw9910_s_std()
	warn: odd binop '0x0 & 0xc'

drivers/media/i2c/soc_camera/tw9910.c
   509  static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
   510  {
   511          struct i2c_client *client = v4l2_get_subdevdata(sd);
   512          struct tw9910_priv *priv = to_tw9910(client);
   513          const unsigned hact = 720;
   514          const unsigned hdelay = 15;
                               ^^^^^^^^^^^
   515          unsigned vact;
   516          unsigned vdelay;
   517          int ret;
   518  
   519          if (!(norm & (V4L2_STD_NTSC | V4L2_STD_PAL)))
   520                  return -EINVAL;
   521  
   522          priv->norm = norm;
   523          if (norm & V4L2_STD_525_60) {
   524                  vact = 240;
   525                  vdelay = 18;
   526                  ret = tw9910_mask_set(client, VVBI, 0x10, 0x10);
   527          } else {
   528                  vact = 288;
   529                  vdelay = 24;
   530                  ret = tw9910_mask_set(client, VVBI, 0x10, 0x00);
   531          }
   532          if (!ret)
   533                  ret = i2c_smbus_write_byte_data(client, CROP_HI,
   534                          ((vdelay >> 2) & 0xc0) |
   535                          ((vact >> 4) & 0x30) |
   536                          ((hdelay >> 6) & 0x0c) |

15 >> 6 is zero.  It's not clear what was intended or why I'm only
seeing this warning now.

   537                          ((hact >> 8) & 0x03));
   538          if (!ret)
   539                  ret = i2c_smbus_write_byte_data(client, VDELAY_LO,
   540                          vdelay & 0xff);
   541          if (!ret)
   542                  ret = i2c_smbus_write_byte_data(client, VACTIVE_LO,
   543                          vact & 0xff);
   544  
   545          return ret;
   546  }

regards,
dan carpenter
