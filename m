Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:33714 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753185AbdGTNHN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 09:07:13 -0400
Subject: Re: [Patch v5 06/12] [media] v4l2-ioctl: add HEVC format description
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1497849055-26583-1-git-send-email-smitha.t@samsung.com>
 <CGME20170619052507epcas1p406fa9f6d84baa9c11050b1998021788a@epcas1p4.samsung.com>
 <1497849055-26583-7-git-send-email-smitha.t@samsung.com>
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e6e75cae-f195-af56-652e-37c3e51ad70f@xs4all.nl>
Date: Thu, 20 Jul 2017 15:07:09 +0200
MIME-Version: 1.0
In-Reply-To: <1497849055-26583-7-git-send-email-smitha.t@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/06/17 07:10, Smitha T Murthy wrote:
> HEVC is a video coding format
> 
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index e5a2187..4f6f8d9 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1257,6 +1257,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  		case V4L2_PIX_FMT_VC1_ANNEX_L:	descr = "VC-1 (SMPTE 412M Annex L)"; break;
>  		case V4L2_PIX_FMT_VP8:		descr = "VP8"; break;
>  		case V4L2_PIX_FMT_VP9:		descr = "VP9"; break;
> +		case V4L2_PIX_FMT_HEVC:		descr = "HEVC"; break;

Add a little comment at the end of the line: /* aka H.265 */

After that you can add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

>  		case V4L2_PIX_FMT_CPIA1:	descr = "GSPCA CPiA YUV"; break;
>  		case V4L2_PIX_FMT_WNVA:		descr = "WNVA"; break;
>  		case V4L2_PIX_FMT_SN9C10X:	descr = "GSPCA SN9C10X"; break;
> 
