Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBFBSl6o007974
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 06:28:47 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.238])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBFBSYvM004698
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 06:28:34 -0500
Received: by rv-out-0506.google.com with SMTP id f6so2769686rvb.51
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 03:28:33 -0800 (PST)
Message-ID: <aec7e5c30812150328t70117d7fp8eee31de4ac223ae@mail.gmail.com>
Date: Mon, 15 Dec 2008 20:28:33 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Kuninori Morimoto" <morimoto.kuninori@renesas.com>
In-Reply-To: <u3agtx39i.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <u3agtx39i.wl%morimoto.kuninori@renesas.com>
Cc: V4L-Linux <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH re-send v2] Add interlace support to
	sh_mobile_ceu_camera.c
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

On Fri, Dec 12, 2008 at 4:09 PM, Kuninori Morimoto
<morimoto.kuninori@renesas.com> wrote:
>
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
> This patch needs Magnus's "nv1x/nvx1 support for the sh_mobile_ceu driver" patch
>
> v1 -> v2
> fix wrong line
>
>  drivers/media/video/sh_mobile_ceu_camera.c |   46 ++++++++++++++++++++++------
>  1 files changed, 36 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 5701363..610d0f9 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -161,7 +162,7 @@ static void free_buffer(struct videobuf_queue *vq,
>  static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
>  {
>        struct soc_camera_device *icd = pcdev->icd;
> -       unsigned long phys_addr;
> +       unsigned long phys_addr_t, phys_addr_b = 0;

Can you please use the names phys_addr_top and phys_addr_bottom
instead? It may be strange to have phys_addr_t as variable name.

And regarding the initial setup of phys_addr_b, I don't think you need
it. I understand that you're working around a compiler warning, but
you can maybe rewrite your code a bit to avoid it too, see below.

> @@ -174,16 +175,25 @@ static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
>        if (!pcdev->active)
>                return;
>
> -       phys_addr = videobuf_to_dma_contig(pcdev->active);
> -       ceu_write(pcdev, CDAYR, phys_addr);
> +       phys_addr_t = videobuf_to_dma_contig(pcdev->active);
> +       ceu_write(pcdev, CDAYR, phys_addr_t);
> +       if (pcdev->is_interlace) {
> +               phys_addr_b = phys_addr_t + icd->width;
> +               ceu_write(pcdev, CDBYR, phys_addr_b);
> +       }
> +
>
>        switch (icd->current_fmt->fourcc) {
>        case V4L2_PIX_FMT_NV12:
>        case V4L2_PIX_FMT_NV21:
>        case V4L2_PIX_FMT_NV16:
>        case V4L2_PIX_FMT_NV61:
> -               phys_addr += (icd->width * icd->height);
> -               ceu_write(pcdev, CDACR, phys_addr);
> +               phys_addr_t += (icd->width * icd->height);
> +               ceu_write(pcdev, CDACR, phys_addr_t);
> +               if (pcdev->is_interlace) {
> +                       phys_addr_b += (icd->width * icd->height);
> +                       ceu_write(pcdev, CDBCR, phys_addr_b);
> +               }

The "phys_addr_b" code above changes the variable which may give you a
warning if your compiler is silly. If you change the code to
"phys_addr_b = phys_addr_t + icd->width" then you should get the same
result but will avoid the warning without the need for the dummy
initialization code.

> @@ -640,7 +658,15 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
>        f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
>
>        /* limit to sensor capabilities */
> -       return icd->ops->try_fmt(icd, f);
> +       ret = icd->ops->try_fmt(icd, f);
> +
> +       pcdev->is_interlace = 0;
> +       if (V4L2_FIELD_INTERLACED == f->fmt.pix.field) {
> +               pcdev->is_interlace = 1;
> +               f->fmt.pix.field = V4L2_FIELD_NONE;
> +       }

Like Guennadi mentioned, this is a bit fishy. But you guys are working
that out now, so that's all good.

I see that the vivi driver pass V4L2_FIELD_INTERLACED to the
videobuf_queue_xxx_init() function. I wonder if we need that too? I'm
not sure.

Thanks for your help!

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
