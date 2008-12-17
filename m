Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBH5HsVE026639
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 00:17:54 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBH5Hfrs014867
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 00:17:41 -0500
Received: by rv-out-0506.google.com with SMTP id f6so3809491rvb.51
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 21:17:40 -0800 (PST)
Message-ID: <aec7e5c30812162117t320608b1v78e0eb0fd4e8fc90@mail.gmail.com>
Date: Wed, 17 Dec 2008 14:17:40 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Kuninori Morimoto" <morimoto.kuninori@renesas.com>
In-Reply-To: <uhc53h880.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <uhc53h880.wl%morimoto.kuninori@renesas.com>
Cc: V4L-Linux <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Change V4L2 filed to ANY from NONE on
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

On Wed, Dec 17, 2008 at 10:39 AM, Kuninori Morimoto
<morimoto.kuninori@renesas.com> wrote:
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/sh_mobile_ceu_camera.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index fcefd24..5dd49c0 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -741,7 +741,7 @@ static void sh_mobile_ceu_init_videobuf(struct videobuf_queue *q,
>                                       &sh_mobile_ceu_videobuf_ops,
>                                       &ici->dev, &pcdev->lock,
>                                       V4L2_BUF_TYPE_VIDEO_CAPTURE,
> -                                      V4L2_FIELD_NONE,
> +                                      V4L2_FIELD_ANY,
>                                       sizeof(struct sh_mobile_ceu_buffer),
>                                       icd);
>  }

This change is ok with me. Maybe I even asked about this in some
earlier email? =)

Please make sure that the regular ov772x camera still works with this
change. If all ok and Guennadi is happny then maybe this change should
be rolled into a new version of the interlace patch? Please keep my
Signed-off-by for the new interlace version patch.

Thanks,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
