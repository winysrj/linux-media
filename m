Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA4MhaNd027948
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 17:43:36 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mA4MhNIH026456
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 17:43:24 -0500
Date: Tue, 4 Nov 2008 23:43:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <1225835978-14548-1-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0811042342100.8208@axis700.grange>
References: <87bpwvyx19.fsf@free.fr>
	<1225835978-14548-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, Michael Schimek <mschimek@gmx.at>
Subject: Re: [PATCH] Add new pixel format VYUY 16 bits wide.
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

On Tue, 4 Nov 2008, Robert Jarzmik wrote:

> There were already 3 YUV formats defined :
>  - YUYV
>  - YVYU
>  - UYVY
> The only left combination is VYUY, which is added in this
> patch.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

We have to ask the fourcc maintainer: Michael? Would you accept this?

Thanks
Guennadi

> ---
>  include/linux/videodev2.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 4669d7e..ec311d4 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -293,6 +293,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_YVU420  v4l2_fourcc('Y', 'V', '1', '2') /* 12  YVU 4:2:0     */
>  #define V4L2_PIX_FMT_YUYV    v4l2_fourcc('Y', 'U', 'Y', 'V') /* 16  YUV 4:2:2     */
>  #define V4L2_PIX_FMT_UYVY    v4l2_fourcc('U', 'Y', 'V', 'Y') /* 16  YUV 4:2:2     */
> +#define V4L2_PIX_FMT_VYUY    v4l2_fourcc('V', 'Y', 'U', 'Y') /* 16  YUV 4:2:2     */
>  #define V4L2_PIX_FMT_YUV422P v4l2_fourcc('4', '2', '2', 'P') /* 16  YVU422 planar */
>  #define V4L2_PIX_FMT_YUV411P v4l2_fourcc('4', '1', '1', 'P') /* 16  YVU411 planar */
>  #define V4L2_PIX_FMT_Y41P    v4l2_fourcc('Y', '4', '1', 'P') /* 12  YUV 4:1:1     */
> -- 
> 1.5.6.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
