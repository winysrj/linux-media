Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56150 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729645AbeGaURl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 16:17:41 -0400
Date: Tue, 31 Jul 2018 21:35:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jacopo+renesas@jmondi.org
Cc: linux-media@vger.kernel.org
Subject: [bug report] media: i2c: Add driver for Aptina MT9V111
Message-ID: <20180731183554.wggi4jxrgrwfos64@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jacopo Mondi,

The patch aab7ed1c3927: "media: i2c: Add driver for Aptina MT9V111"
from Jul 25, 2018, leads to the following static checker warning:

drivers/media/i2c/mt9v111.c:1163 mt9v111_probe() warn: passing zero to 'PTR_ERR'
drivers/media/i2c/mt9v111.c:1173 mt9v111_probe() warn: passing zero to 'PTR_ERR'
drivers/media/i2c/mt9v111.c:1184 mt9v111_probe() warn: passing zero to 'PTR_ERR'
drivers/media/i2c/mt9v111.c:1194 mt9v111_probe() warn: passing zero to 'PTR_ERR'

drivers/media/i2c/mt9v111.c
  1155          v4l2_ctrl_handler_init(&mt9v111->ctrls, 5);
  1156  
  1157          mt9v111->auto_awb = v4l2_ctrl_new_std(&mt9v111->ctrls,
  1158                                                &mt9v111_ctrl_ops,
  1159                                                V4L2_CID_AUTO_WHITE_BALANCE,
  1160                                                0, 1, 1,
  1161                                                V4L2_WHITE_BALANCE_AUTO);
  1162          if (IS_ERR_OR_NULL(mt9v111->auto_awb)) {
  1163                  ret = PTR_ERR(mt9v111->auto_awb);

This just returns success because v4l2_ctrl_new_std() only return NULL
on error, it never returns error pointers.  I guess we should set ret to
EINVAL?

		if (!mt9v111->auto_awb) {
			ret = -EINVAL;
			goto error_free_ctrls;
		}

  1164                  goto error_free_ctrls;
  1165          }
  1166  
  1167          mt9v111->auto_exp = v4l2_ctrl_new_std_menu(&mt9v111->ctrls,
  1168                                                     &mt9v111_ctrl_ops,
  1169                                                     V4L2_CID_EXPOSURE_AUTO,
  1170                                                     V4L2_EXPOSURE_MANUAL,
  1171                                                     0, V4L2_EXPOSURE_AUTO);
  1172          if (IS_ERR_OR_NULL(mt9v111->auto_exp)) {
  1173                  ret = PTR_ERR(mt9v111->auto_exp);
  1174                  goto error_free_ctrls;
  1175          }
  1176  
  1177          /* Initialize timings */
  1178          mt9v111->hblank = v4l2_ctrl_new_std(&mt9v111->ctrls, &mt9v111_ctrl_ops,
  1179                                              V4L2_CID_HBLANK,
  1180                                              MT9V111_CORE_R05_MIN_HBLANK,
  1181                                              MT9V111_CORE_R05_MAX_HBLANK, 1,
  1182                                              MT9V111_CORE_R05_DEF_HBLANK);
  1183          if (IS_ERR_OR_NULL(mt9v111->hblank)) {
  1184                  ret = PTR_ERR(mt9v111->hblank);
  1185                  goto error_free_ctrls;
  1186          }
  1187  
  1188          mt9v111->vblank = v4l2_ctrl_new_std(&mt9v111->ctrls, &mt9v111_ctrl_ops,
  1189                                              V4L2_CID_VBLANK,
  1190                                              MT9V111_CORE_R06_MIN_VBLANK,
  1191                                              MT9V111_CORE_R06_MAX_VBLANK, 1,
  1192                                              MT9V111_CORE_R06_DEF_VBLANK);
  1193          if (IS_ERR_OR_NULL(mt9v111->vblank)) {
  1194                  ret = PTR_ERR(mt9v111->vblank);
  1195                  goto error_free_ctrls;
  1196          }
  1197  
  1198          /* PIXEL_RATE is fixed: just expose it to user space. */
  1199          v4l2_ctrl_new_std(&mt9v111->ctrls, &mt9v111_ctrl_ops,

regards,
dan carpenter
