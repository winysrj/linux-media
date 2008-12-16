Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBG9rIXk005636
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 04:53:18 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBG9r55G015564
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 04:53:05 -0500
Received: by wf-out-1314.google.com with SMTP id 25so2831575wfc.6
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 01:53:04 -0800 (PST)
Message-ID: <aec7e5c30812160153m7a906d2eu8a7f5b1019ab144d@mail.gmail.com>
Date: Tue, 16 Dec 2008 18:53:04 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Kuninori Morimoto" <morimoto.kuninori@renesas.com>
In-Reply-To: <uljughnao.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <uljughnao.wl%morimoto.kuninori@renesas.com>
Cc: V4L-Linux <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3] Add interlace support to sh_mobile_ceu_camera.c
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Morimoto-san,

On Tue, Dec 16, 2008 at 11:09 AM, Kuninori Morimoto
<morimoto.kuninori@renesas.com> wrote:
>
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
> v2 -> v3
>
> o rename phys_addr_t -> phys_addr_top
> o fix phys_addr_bottom calculation method. thank you Magnus
> o fix check method about f->fmt.pix.field

This patch looks much better. I still have two things to ask you
though, sorry for not commenting on this earlier.

> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -467,10 +476,16 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
>                cdwdr_width = buswidth == 16 ? width * 2 : width;
>        }
>
> +       height = icd->height;
> +       if (pcdev->is_interlace) {
> +               height      /= 2;

Please just use a single space between "height" and "/=".

> @@ -646,7 +663,25 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
>        f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
>
>        /* limit to sensor capabilities */
> -       return icd->ops->try_fmt(icd, f);
> +       ret = icd->ops->try_fmt(icd, f);
> +       if (ret < 0)
> +               return ret;
> +
> +       switch (f->fmt.pix.field) {
> +       case V4L2_FIELD_INTERLACED:
> +               pcdev->is_interlace = 1;
> +               break;
> +       case V4L2_FIELD_ANY:
> +               f->fmt.pix.field = V4L2_FIELD_NONE;

Here it would be good to insert a "fall-through" comment here to show
that the missing "break" is intentional.

> +       case V4L2_FIELD_NONE:
> +               pcdev->is_interlace = 0;
> +               break;
> +       default:
> +               ret = -EINVAL;
> +               break;
> +       }
> +
> +       return ret;
>  }
>
>  static int sh_mobile_ceu_reqbufs(struct soc_camera_file *icf,
> --
> 1.5.6.3

Please fix up these two things and repost. Thank you!

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
