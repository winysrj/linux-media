Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:47907 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727712AbeHCKyV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 06:54:21 -0400
Date: Fri, 3 Aug 2018 10:58:57 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: jacopo+renesas@jmondi.org, linux-media@vger.kernel.org
Subject: Re: [bug report] media: i2c: Add driver for Aptina MT9V111
Message-ID: <20180803085857.GD4528@w540>
References: <20180731183554.wggi4jxrgrwfos64@kili.mountain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tEFtbjk+mNEviIIX"
Content-Disposition: inline
In-Reply-To: <20180731183554.wggi4jxrgrwfos64@kili.mountain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tEFtbjk+mNEviIIX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Dan,
    thanks for noticing this,

On Tue, Jul 31, 2018 at 09:35:54PM +0300, Dan Carpenter wrote:
> Hello Jacopo Mondi,
>
> The patch aab7ed1c3927: "media: i2c: Add driver for Aptina MT9V111"
> from Jul 25, 2018, leads to the following static checker warning:
>
> drivers/media/i2c/mt9v111.c:1163 mt9v111_probe() warn: passing zero to 'PTR_ERR'
> drivers/media/i2c/mt9v111.c:1173 mt9v111_probe() warn: passing zero to 'PTR_ERR'
> drivers/media/i2c/mt9v111.c:1184 mt9v111_probe() warn: passing zero to 'PTR_ERR'
> drivers/media/i2c/mt9v111.c:1194 mt9v111_probe() warn: passing zero to 'PTR_ERR'
>
> drivers/media/i2c/mt9v111.c
>   1155          v4l2_ctrl_handler_init(&mt9v111->ctrls, 5);
>   1156
>   1157          mt9v111->auto_awb = v4l2_ctrl_new_std(&mt9v111->ctrls,
>   1158                                                &mt9v111_ctrl_ops,
>   1159                                                V4L2_CID_AUTO_WHITE_BALANCE,
>   1160                                                0, 1, 1,
>   1161                                                V4L2_WHITE_BALANCE_AUTO);
>   1162          if (IS_ERR_OR_NULL(mt9v111->auto_awb)) {
>   1163                  ret = PTR_ERR(mt9v111->auto_awb);
>
> This just returns success because v4l2_ctrl_new_std() only return NULL

Correct, sorry, I didn't notice that.

> on error, it never returns error pointers.  I guess we should set ret to
> EINVAL?
>
> 		if (!mt9v111->auto_awb) {
> 			ret = -EINVAL;
> 			goto error_free_ctrls;
> 		}
>

We can do even better than that.
The v4l2 control handler retains errors in a flag I can inspect after
having added/created all controls here and here below.

I can return that error flag if something goes wrong.

Thanks
   j

>   1164                  goto error_free_ctrls;
>   1165          }
>   1166
>   1167          mt9v111->auto_exp = v4l2_ctrl_new_std_menu(&mt9v111->ctrls,
>   1168                                                     &mt9v111_ctrl_ops,
>   1169                                                     V4L2_CID_EXPOSURE_AUTO,
>   1170                                                     V4L2_EXPOSURE_MANUAL,
>   1171                                                     0, V4L2_EXPOSURE_AUTO);
>   1172          if (IS_ERR_OR_NULL(mt9v111->auto_exp)) {
>   1173                  ret = PTR_ERR(mt9v111->auto_exp);
>   1174                  goto error_free_ctrls;
>   1175          }
>   1176
>   1177          /* Initialize timings */
>   1178          mt9v111->hblank = v4l2_ctrl_new_std(&mt9v111->ctrls, &mt9v111_ctrl_ops,
>   1179                                              V4L2_CID_HBLANK,
>   1180                                              MT9V111_CORE_R05_MIN_HBLANK,
>   1181                                              MT9V111_CORE_R05_MAX_HBLANK, 1,
>   1182                                              MT9V111_CORE_R05_DEF_HBLANK);
>   1183          if (IS_ERR_OR_NULL(mt9v111->hblank)) {
>   1184                  ret = PTR_ERR(mt9v111->hblank);
>   1185                  goto error_free_ctrls;
>   1186          }
>   1187
>   1188          mt9v111->vblank = v4l2_ctrl_new_std(&mt9v111->ctrls, &mt9v111_ctrl_ops,
>   1189                                              V4L2_CID_VBLANK,
>   1190                                              MT9V111_CORE_R06_MIN_VBLANK,
>   1191                                              MT9V111_CORE_R06_MAX_VBLANK, 1,
>   1192                                              MT9V111_CORE_R06_DEF_VBLANK);
>   1193          if (IS_ERR_OR_NULL(mt9v111->vblank)) {
>   1194                  ret = PTR_ERR(mt9v111->vblank);
>   1195                  goto error_free_ctrls;
>   1196          }
>   1197
>   1198          /* PIXEL_RATE is fixed: just expose it to user space. */
>   1199          v4l2_ctrl_new_std(&mt9v111->ctrls, &mt9v111_ctrl_ops,
>
> regards,
> dan carpenter

--tEFtbjk+mNEviIIX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbZBlRAAoJEHI0Bo8WoVY8ijEP/2x0RQOpZ+DJbz9YOmNivv7R
p/qFC7UUOcCrtQl/qRhQTpF2w459AiV45YSB3MotyoX0M83NOJWccVyOxb3ObzcU
YTbhLXlqv3MzPUFOwWqCoIc3xgub7ugBL0EErzWvpPzpzbrTby8rPUXWi8+M6Z29
dQTA+BNmOHnrIG4YQQX++MfT8RJbR5SS7BHQae+l2Ur3uZ6BybTA1mER8dmDI23d
Tnc2jjW1FA589ooi/qR1epl+dlq+xMbBowDqqv6jaYAs5+DFMDHTltaI/yo6oTiV
dnrZ++E4CdxTCLc2SZJPd8mKezCfu1MKXW4lDRXKwvmrzLjKXDQhuENs393WuWqF
GP+ZehXEyAXzWPkrQlQWYb1mdio2Gr7vCJoRCFmhkeEJjtcnk+e52OTGVRq7luZd
75i1mmwZTiKMfXnOJOcLe/2tdfEO2wYR02KtgYGdwOCUgqtQTA/OrYUjA4lDXlss
mYi5rjIou0XkIP5C2guPcTA8/YCdR/iMeWggPyIBrznIrGtk15Jmjwx5ylNw0bI5
IJ8w4D0nI+zZ5Iqpz4q8ySklqEHmnAScQK2t/1Czou/9hyadI8K6JJOCZpB5RnEn
v9c/LaYe7Jp49d1mgUjkYDV8aFXOpNK5lN/5AaI5ucswD2z0Dcv4O4E+cM60cNCr
Q12rZuPutIGRkX+To70m
=WGzb
-----END PGP SIGNATURE-----

--tEFtbjk+mNEviIIX--
