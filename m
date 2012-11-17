Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48060 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab2KQRYa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Nov 2012 12:24:30 -0500
Message-ID: <50A7C84A.4090804@gmail.com>
Date: Sat, 17 Nov 2012 18:24:26 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Andrey Gusakov <dron0gus@gmail.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	In-Bae Jeong <kukyakya@gmail.com>,
	=?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: S3C244X/S3C64XX SoC camera host interface driver questions
References: <CAA11ShCpH7Z8eLok=MEh4bcSb6XjtVFfLQEYh2icUtYc-j5hEQ@mail.gmail.com> <5096C561.5000108@gmail.com> <CAA11ShCKFfdmd_ydxxCYo9Sv0VhgZW9kCk_F7LAQDg3mr5prrw@mail.gmail.com> <5096E8D7.4070304@gmail.com> <CAA11ShDinm7oU4azQYPMrNDsqWPqw+vJNFPpBDNzV=dTeUdZzw@mail.gmail.com> <50979998.8090809@gmail.com> <CAA11ShD6Qug_=t8vGE5LwSpfXW2FsceTonxnF8aO6i2b=inibw@mail.gmail.com> <50983CFD.2030104@gmail.com> <CAA11ShDAscm8snYzjnC3Fe1MaVXc-FJqhWM677iJwgbgu2_J1Q@mail.gmail.com> <509AD957.5070301@gmail.com> <CAA11ShCn3S_nxXg5_pAsgcMsPFpER7XrHsvg71DrznAmONu7Lg@mail.gmail.com> <509CBB61.40206@gmail.com> <CAA11ShB1s6wSEEoVQ2_z4_BaGdM8f_F7ec_UrZzhcBgzoABAtQ@mail.gmail.com> <50A2CF95.4000202@gmail.com> <CAA11ShDL0xaZzr5bNW8edP9aqab8oymCYs_CrHvC646sJcM3XQ@mail.gmail.com>
In-Reply-To: <CAA11ShDL0xaZzr5bNW8edP9aqab8oymCYs_CrHvC646sJcM3XQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/17/2012 01:07 PM, Andrey Gusakov wrote:
> Hi.
>
> Just have time to test. I apologize for delay.

No problem, thanks for the feedback.

>> I'd like to squash all the s3c-camif patches before sending upstream,
>> if you don't mind. And to add your Signed-off at the final patch.
> Ok. Squash.
>
>> I might have introduced bugs in the image effects handling, hopefully
>> there is none. I couldn't test it though. Could you test that on your
>> side with s3c64xx ?
> Got some error. Seems effect updated only when I set new CrCb value.
> Seems it's incorrect:
> 	case V4L2_CID_COLORFX:
> 		if (camif->ctrl_colorfx_cbcr->is_new) {

Uh, copy/paste error, this should have been

		if (camif->ctrl_colorfx->is_new) {

> 			camif->colorfx = camif->ctrl_colorfx->val;
> 			/* Set Cb, Cr */
> 			switch (ctrl->val) {
> 			case V4L2_COLORFX_SEPIA:
> 				camif->ctrl_colorfx_cbcr->val = 0x7391;
> 				break;
> 			case V4L2_COLORFX_SET_CBCR: /* noop */
> 				break;
> 			default:
> 				/* for V4L2_COLORFX_BW and others */
> 				camif->ctrl_colorfx_cbcr->val = 0x8080;
> 			}
> 		}
> 		camif->colorfx_cb = camif->ctrl_colorfx_cbcr->val&  0xff;
> 		camif->colorfx_cr = camif->ctrl_colorfx_cbcr->val>>  8;
> 		break;
> Moving "camif->colorfx = camif->ctrl_colorfx->val;" out of condition
> fixes the problem, but setting CrCb value control affect all effects
> (sepia and BW), not only V4L2_COLORFX_SET_CBCR. Seems condition should
> be removed and colorfx value should be checked set on every effect
> change.
>
> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c
> b/drivers/media/platform/s3c-camif/camif-capture.c
> index ceab03a..9c01f4f 100644
> --- a/drivers/media/platform/s3c-camif/camif-capture.c
> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> @@ -1526,19 +1526,17 @@ static int s3c_camif_subdev_s_ctrl(struct
> v4l2_ctrl *ctrl)
>
>   	switch (ctrl->id) {
>   	case V4L2_CID_COLORFX:
> -		if (camif->ctrl_colorfx_cbcr->is_new) {
> -			camif->colorfx = camif->ctrl_colorfx->val;
> -			/* Set Cb, Cr */
> -			switch (ctrl->val) {
> -			case V4L2_COLORFX_SEPIA:
> -				camif->ctrl_colorfx_cbcr->val = 0x7391;
> -				break;
> -			case V4L2_COLORFX_SET_CBCR: /* noop */
> -				break;
> -			default:
> -				/* for V4L2_COLORFX_BW and others */
> -				camif->ctrl_colorfx_cbcr->val = 0x8080;
> -			}
> +		camif->colorfx = camif->ctrl_colorfx->val;
> +		/* Set Cb, Cr */
> +		switch (ctrl->val) {
> +		case V4L2_COLORFX_SEPIA:
> +			camif->ctrl_colorfx_cbcr->val = 0x7391;
> +			break;
> +		case V4L2_COLORFX_SET_CBCR: /* noop */
> +			break;
> +		default:
> +			/* for V4L2_COLORFX_BW and others */
> +			camif->ctrl_colorfx_cbcr->val = 0x8080;
>   		}
>   		camif->colorfx_cb = camif->ctrl_colorfx_cbcr->val&  0xff;
>   		camif->colorfx_cr = camif->ctrl_colorfx_cbcr->val>>  8;
>
> With this modification got another issue: set CRCB effect, set CRCB
> value, set BW effect, set CRCB effect back cause CRCB-value to be
> reseted to default 0x8080. Is it correct?

We could do better. The control values are already cached twice - in
struct v4l2_ctrl and struct camif_dev.

It seems more intuitive to save CB/CR coefficients for V4L2_COLORFX_SET_CBCR
and then restore them as needed. There is probably not much use of letting
user space know that the driver uses CBCR for V4L2_COLORFX_SEPIA and
V4L2_COLORFX_BW internally.

I propose change as below, it includes disabling the control for SoCs that
don't support it and a fixed cbcr order, to match documentation:

"V4L2_CID_COLORFX_CBCR	integer	Determines the Cb and Cr coefficients for
V4L2_COLORFX_SET_CBCR color effect. Bits [7:0] of the supplied 32 bit 
value are
interpreted as Cr component, bits [15:8] as Cb component and bits 
[31:16] must
be zero."

I have pushed it all to the testing/s3c-camif branch. Please let me know
if you find any further issues.

-----8<-------
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c 
b/drivers/media/platform/s3c-camif/camif-capture.c
index 6401fdb..b52cc59 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -1520,22 +1520,22 @@ static int s3c_camif_subdev_s_ctrl(struct 
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
+			camif->colorfx_cb = 115;
+			camif->colorfx_cr = 145;
+			break;
+		case V4L2_COLORFX_SET_CBCR:
+			camif->colorfx_cb = camif->ctrl_colorfx_cbcr->val >> 8;
+			camif->colorfx_cr = camif->ctrl_colorfx_cbcr->val & 0xff;
+			break;
+		default:
+			/* for V4L2_COLORFX_BW and others */
+			camif->colorfx_cb = 128;
+			camif->colorfx_cr = 128;
  		}
-		camif->colorfx_cb = camif->ctrl_colorfx_cbcr->val & 0xff;
-		camif->colorfx_cr = camif->ctrl_colorfx_cbcr->val >> 8;
  		break;
  	case V4L2_CID_TEST_PATTERN:
  		camif->test_pattern = camif->ctrl_test_pattern->val;
@@ -1603,6 +1603,10 @@ int s3c_camif_create_subdev(struct camif_dev *camif)

  	v4l2_ctrl_auto_cluster(2, &camif->ctrl_colorfx,
  			       V4L2_COLORFX_SET_CBCR, false);
+	if (!camif->variant->has_img_effect) {
+		camif->ctrl_colorfx->flags |= V4L2_CTRL_FLAG_DISABLED;
+		camif->ctrl_colorfx_cbcr->flags |= V4L2_CTRL_FLAG_DISABLED;
+	}
  	sd->ctrl_handler = handler;
  	v4l2_set_subdevdata(sd, camif);

----->8-------

Thanks,
Sylwester
