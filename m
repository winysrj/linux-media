Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1EBQgb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2011 12:36:31 -0400
Message-ID: <4DBEDD8B.7000905@redhat.com>
Date: Mon, 02 May 2011 13:36:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sensoray Linux Development <linux-dev@sensoray.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2][media] s2255drv: adding MJPEG format
References: <4D9A0AFA.7090202@sensoray.com>
In-Reply-To: <4D9A0AFA.7090202@sensoray.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 04-04-2011 15:16, Sensoray Linux Development escreveu:
> adding MJPEG format
> 

Please be careful when sending patches. I had to manually apply the hunks,
as whitespaces were completely wrong on this patchset.

> Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
> ---
>  drivers/media/video/s2255drv.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
> index b12e28e..38e5c4b 100644
> --- a/drivers/media/video/s2255drv.c
> +++ b/drivers/media/video/s2255drv.c
> @@ -428,6 +428,10 @@ static const struct s2255_fmt formats[] = {
>          .fourcc = V4L2_PIX_FMT_JPEG,
>          .depth = 24
>      }, {
> +        .name = "MJPG",
> +        .fourcc = V4L2_PIX_FMT_MJPEG,
> +        .depth = 24
> +    }, {
>          .name = "8bpp GREY",
>          .fourcc = V4L2_PIX_FMT_GREY,
>          .depth = 8
> @@ -648,6 +652,7 @@ static void s2255_fillbuff(struct s2255_channel *channel,
>              memcpy(vbuf, tmpbuf, buf->vb.width * buf->vb.height);
>              break;
>          case V4L2_PIX_FMT_JPEG:
> +        case V4L2_PIX_FMT_MJPEG:
>              buf->vb.size = jpgsize;
>              memcpy(vbuf, tmpbuf, buf->vb.size);
>              break;
> @@ -1032,6 +1037,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>          mode.color |= COLOR_Y8;
>          break;
>      case V4L2_PIX_FMT_JPEG:
> +    case V4L2_PIX_FMT_MJPEG:
>          mode.color &= ~MASK_COLOR;
>          mode.color |= COLOR_JPG;
>          mode.color |= (channel->jc.quality << 8);

