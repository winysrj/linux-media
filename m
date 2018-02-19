Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48876 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753485AbeBSSgu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 13:36:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andi Shyti <andi.shyti@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Utkin <andrey_utkin@fastmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Brian Johnson <brijohn@gmail.com>,
        Christoph =?ISO-8859-1?Q?B=F6hmwalder?=
        <christoph@boehmwalder.at>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Daniele Nicolodi <daniele@grinta.net>,
        David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        Devendra Sharma <devendra.sharma9091@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Inki Dae <inki.dae@samsung.com>, Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Mike Isely <isely@pobox.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Sean Young <sean@mess.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Shyam Saini <mayhs11saini@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] [media] Use common error handling code in 20 functions
Date: Mon, 19 Feb 2018 20:37:29 +0200
Message-ID: <3895609.4O6dNuP5Wm@avalon>
In-Reply-To: <227d2d7c-5aee-1190-1624-26596a048d9c@users.sourceforge.net>
References: <227d2d7c-5aee-1190-1624-26596a048d9c@users.sourceforge.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Markus,

On Monday, 19 February 2018 20:11:56 EET SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 19 Feb 2018 18:50:40 +0100
>=20
> Adjust jump targets so that a bit of exception handling can be better
> reused at the end of these functions.
>=20
> This issue was partly detected by using the Coccinelle software.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>=20
> v2:
> Hans Verkuil insisted on patch squashing. Thus several changes
> were recombined based on source files from Linux next-20180216.
>=20
> The implementation of the function "tda8261_set_params" was improved
> after a notification by Christoph B=F6hmwalder on 2017-09-26.
>=20
>  drivers/media/dvb-core/dmxdev.c                    | 16 ++++----
>  drivers/media/dvb-frontends/tda1004x.c             | 20 ++++++----
>  drivers/media/dvb-frontends/tda8261.c              | 19 ++++++----
>  drivers/media/pci/bt8xx/dst.c                      | 19 ++++++----
>  drivers/media/pci/bt8xx/dst_ca.c                   | 30 +++++++--------
>  drivers/media/pci/cx88/cx88-input.c                | 17 +++++----
>  drivers/media/platform/omap3isp/ispvideo.c         | 29 +++++++--------
>  .../media/platform/qcom/camss-8x16/camss-csid.c    | 20 +++++-----
>  drivers/media/tuners/tuner-xc2028.c                | 30 +++++++--------
>  drivers/media/usb/cpia2/cpia2_usb.c                | 13 ++++---
>  drivers/media/usb/gspca/gspca.c                    | 17 +++++----
>  drivers/media/usb/gspca/sn9c20x.c                  | 17 +++++----
>  drivers/media/usb/pvrusb2/pvrusb2-ioread.c         | 10 +++--
>  drivers/media/usb/tm6000/tm6000-cards.c            |  7 ++--
>  drivers/media/usb/tm6000/tm6000-dvb.c              | 11 ++++--
>  drivers/media/usb/tm6000/tm6000-video.c            | 13 ++++---
>  drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  | 13 +++----
>  drivers/media/usb/ttusb-dec/ttusb_dec.c            | 43 +++++++---------=
=2D--
>  drivers/media/usb/uvc/uvc_v4l2.c                   | 13 ++++---
>  19 files changed, 180 insertions(+), 177 deletions(-)

[snip]

> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index
> a751c89a3ea8..2ddcac736402 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -1315,14 +1315,12 @@ static int isp_video_open(struct file *file)
>  	/* If this is the first user, initialise the pipeline. */
>  	if (omap3isp_get(video->isp) =3D=3D NULL) {
>  		ret =3D -EBUSY;
> -		goto done;
> +		goto delete_fh;
>  	}
>=20
>  	ret =3D v4l2_pipeline_pm_use(&video->video.entity, 1);
> -	if (ret < 0) {
> -		omap3isp_put(video->isp);
> -		goto done;
> -	}
> +	if (ret < 0)
> +		goto put_isp;
>=20
>  	queue =3D &handle->queue;
>  	queue->type =3D video->type;
> @@ -1335,10 +1333,8 @@ static int isp_video_open(struct file *file)
>  	queue->dev =3D video->isp->dev;
>=20
>  	ret =3D vb2_queue_init(&handle->queue);
> -	if (ret < 0) {
> -		omap3isp_put(video->isp);
> -		goto done;
> -	}
> +	if (ret < 0)
> +		goto put_isp;
>=20
>  	memset(&handle->format, 0, sizeof(handle->format));
>  	handle->format.type =3D video->type;
> @@ -1346,14 +1342,15 @@ static int isp_video_open(struct file *file)
>=20
>  	handle->video =3D video;
>  	file->private_data =3D &handle->vfh;
> +	goto exit;

No need for a goto here, you can just return 0.

>=20
> -done:
> -	if (ret < 0) {
> -		v4l2_fh_del(&handle->vfh);
> -		v4l2_fh_exit(&handle->vfh);
> -		kfree(handle);
> -	}
> -
> +put_isp:
> +	omap3isp_put(video->isp);
> +delete_fh:
> +	v4l2_fh_del(&handle->vfh);
> +	v4l2_fh_exit(&handle->vfh);
> +	kfree(handle);

Please prefix the error labels with error_.

> +exit:
>  	return ret;
>  }
>=20

Otherwise the changes to omap3isp look OK to me.

[snip]

> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index a13ad4e178be..f64c851adea2 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -994,10 +994,8 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file,
> void *fh, struct v4l2_queryctrl qc =3D { .id =3D ctrl->id };
>=20
>  			ret =3D uvc_query_v4l2_ctrl(chain, &qc);
> -			if (ret < 0) {
> -				ctrls->error_idx =3D i;
> -				return ret;
> -			}
> +			if (ret < 0)
> +				goto set_index;
>=20
>  			ctrl->value =3D qc.default_value;
>  		}
> @@ -1013,14 +1011,17 @@ static int uvc_ioctl_g_ext_ctrls(struct file *fil=
e,
> void *fh, ret =3D uvc_ctrl_get(chain, ctrl);
>  		if (ret < 0) {
>  			uvc_ctrl_rollback(handle);
> -			ctrls->error_idx =3D i;
> -			return ret;
> +			goto set_index;
>  		}
>  	}
>=20
>  	ctrls->error_idx =3D 0;
>=20
>  	return uvc_ctrl_rollback(handle);
> +
> +set_index:
> +	ctrls->error_idx =3D i;
> +	return ret;
>  }

=46or uvcvideo I find this to hinder readability without adding much added=
=20
value. Please drop the uvcvideo change from this patch.

>=20
>  static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,

=2D-=20
Regards,

Laurent Pinchart
