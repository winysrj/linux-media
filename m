Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:45709 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1046362AbdDXO2k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 10:28:40 -0400
Message-ID: <1493044118.2446.40.camel@pengutronix.de>
Subject: Re: [PATCH] V4L2 SDR: Add Real U8 format (V4L2_SDR_FMT_RU8)
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Bertold Van den Bergh <vandenbergh@bertold.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 24 Apr 2017 16:28:38 +0200
In-Reply-To: <1492987511-3900-1-git-send-email-vandenbergh@bertold.org>
References: <1492987511-3900-1-git-send-email-vandenbergh@bertold.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bertold,

On Mon, 2017-04-24 at 00:45 +0200, Bertold Van den Bergh wrote:
> This patch adds support for the Real U8 format to the V4L2 SDR framework.
> This will be used for a piece of hardware we are developing.
> 
> Signed-off-by: Bertold Van den Bergh <vandenbergh@bertold.org>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 1 +
>  include/uapi/linux/videodev2.h       | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index e5a2187..8b6e097 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1229,6 +1229,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  	case V4L2_SDR_FMT_CS8:		descr = "Complex S8"; break;
>  	case V4L2_SDR_FMT_CS14LE:	descr = "Complex S14LE"; break;
>  	case V4L2_SDR_FMT_RU12LE:	descr = "Real U12LE"; break;
> +	case V4L2_SDR_FMT_RU8:		descr = "Real U8"; break;
>  	case V4L2_TCH_FMT_DELTA_TD16:	descr = "16-bit signed deltas"; break;
>  	case V4L2_TCH_FMT_DELTA_TD08:	descr = "8-bit signed deltas"; break;
>  	case V4L2_TCH_FMT_TU16:		descr = "16-bit unsigned touch data"; break;
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 2b8feb8..50c3ef4 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -669,6 +669,7 @@ struct v4l2_pix_format {
>  #define V4L2_SDR_FMT_CS8          v4l2_fourcc('C', 'S', '0', '8') /* complex s8 */
>  #define V4L2_SDR_FMT_CS14LE       v4l2_fourcc('C', 'S', '1', '4') /* complex s14le */
>  #define V4L2_SDR_FMT_RU12LE       v4l2_fourcc('R', 'U', '1', '2') /* real u12le */
> +#define V4L2_SDR_FMT_RU8          v4l2_fourcc('R', 'U', '0', '8') /* real u8 */

When adding new SDR formats, could you also add an entry to
Documentation/media/uapi/v4l/sdr-formats.rst ? See for example
Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst.

Also maybe V4L2_SDR_FMT_RU8 should be ordered above V4L2_SDR_FMT_RU12LE?
I'm not sure from the context.

regards
Philipp
