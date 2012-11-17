Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59184 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2KQMH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Nov 2012 07:07:27 -0500
MIME-Version: 1.0
In-Reply-To: <50A2CF95.4000202@gmail.com>
References: <CAA11ShCpH7Z8eLok=MEh4bcSb6XjtVFfLQEYh2icUtYc-j5hEQ@mail.gmail.com>
	<5096C561.5000108@gmail.com>
	<CAA11ShCKFfdmd_ydxxCYo9Sv0VhgZW9kCk_F7LAQDg3mr5prrw@mail.gmail.com>
	<5096E8D7.4070304@gmail.com>
	<CAA11ShDinm7oU4azQYPMrNDsqWPqw+vJNFPpBDNzV=dTeUdZzw@mail.gmail.com>
	<50979998.8090809@gmail.com>
	<CAA11ShD6Qug_=t8vGE5LwSpfXW2FsceTonxnF8aO6i2b=inibw@mail.gmail.com>
	<50983CFD.2030104@gmail.com>
	<CAA11ShDAscm8snYzjnC3Fe1MaVXc-FJqhWM677iJwgbgu2_J1Q@mail.gmail.com>
	<509AD957.5070301@gmail.com>
	<CAA11ShCn3S_nxXg5_pAsgcMsPFpER7XrHsvg71DrznAmONu7Lg@mail.gmail.com>
	<509CBB61.40206@gmail.com>
	<CAA11ShB1s6wSEEoVQ2_z4_BaGdM8f_F7ec_UrZzhcBgzoABAtQ@mail.gmail.com>
	<50A2CF95.4000202@gmail.com>
Date: Sat, 17 Nov 2012 15:07:26 +0300
Message-ID: <CAA11ShDL0xaZzr5bNW8edP9aqab8oymCYs_CrHvC646sJcM3XQ@mail.gmail.com>
Subject: Re: S3C244X/S3C64XX SoC camera host interface driver questions
From: Andrey Gusakov <dron0gus@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
	In-Bae Jeong <kukyakya@gmail.com>,
	=?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

Just have time to test. I apologize for delay.

> I'd like to squash all the s3c-camif patches before sending upstream,
> if you don't mind. And to add your Signed-off at the final patch.
Ok. Squash.

> I might have introduced bugs in the image effects handling, hopefully
> there is none. I couldn't test it though. Could you test that on your
> side with s3c64xx ?
Got some error. Seems effect updated only when I set new CrCb value.
Seems it's incorrect:
	case V4L2_CID_COLORFX:
		if (camif->ctrl_colorfx_cbcr->is_new) {
			camif->colorfx = camif->ctrl_colorfx->val;
			/* Set Cb, Cr */
			switch (ctrl->val) {
			case V4L2_COLORFX_SEPIA:
				camif->ctrl_colorfx_cbcr->val = 0x7391;
				break;
			case V4L2_COLORFX_SET_CBCR: /* noop */
				break;
			default:
				/* for V4L2_COLORFX_BW and others */
				camif->ctrl_colorfx_cbcr->val = 0x8080;
			}
		}
		camif->colorfx_cb = camif->ctrl_colorfx_cbcr->val & 0xff;
		camif->colorfx_cr = camif->ctrl_colorfx_cbcr->val >> 8;
		break;
Moving "camif->colorfx = camif->ctrl_colorfx->val;" out of condition
fixes the problem, but setting CrCb value control affect all effects
(sepia and BW), not only V4L2_COLORFX_SET_CBCR. Seems condition should
be removed and colorfx value should be checked set on every effect
change.

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c
b/drivers/media/platform/s3c-camif/camif-capture.c
index ceab03a..9c01f4f 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -1526,19 +1526,17 @@ static int s3c_camif_subdev_s_ctrl(struct
v4l2_ctrl *ctrl)

 	switch (ctrl->id) {
 	case V4L2_CID_COLORFX:
-		if (camif->ctrl_colorfx_cbcr->is_new) {
-			camif->colorfx = camif->ctrl_colorfx->val;
-			/* Set Cb, Cr */
-			switch (ctrl->val) {
-			case V4L2_COLORFX_SEPIA:
-				camif->ctrl_colorfx_cbcr->val = 0x7391;
-				break;
-			case V4L2_COLORFX_SET_CBCR: /* noop */
-				break;
-			default:
-				/* for V4L2_COLORFX_BW and others */
-				camif->ctrl_colorfx_cbcr->val = 0x8080;
-			}
+		camif->colorfx = camif->ctrl_colorfx->val;
+		/* Set Cb, Cr */
+		switch (ctrl->val) {
+		case V4L2_COLORFX_SEPIA:
+			camif->ctrl_colorfx_cbcr->val = 0x7391;
+			break;
+		case V4L2_COLORFX_SET_CBCR: /* noop */
+			break;
+		default:
+			/* for V4L2_COLORFX_BW and others */
+			camif->ctrl_colorfx_cbcr->val = 0x8080;
 		}
 		camif->colorfx_cb = camif->ctrl_colorfx_cbcr->val & 0xff;
 		camif->colorfx_cr = camif->ctrl_colorfx_cbcr->val >> 8;

With this modification got another issue: set CRCB effect, set CRCB
value, set BW effect, set CRCB effect back cause CRCB-value to be
reseted to default 0x8080. Is it correct?
