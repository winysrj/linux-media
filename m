Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40361 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759618Ab1CDQi2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 11:38:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [RFC/PATCH v7 1/5] Changes in include/linux/videodev2.h for MFC 5.1
Date: Fri, 4 Mar 2011 17:38:43 +0100
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	jaeryul.oh@samsung.com, kgene.kim@samsung.com
References: <1299237982-31687-1-git-send-email-k.debski@samsung.com> <1299237982-31687-2-git-send-email-k.debski@samsung.com>
In-Reply-To: <1299237982-31687-2-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103041738.43558.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday 04 March 2011 12:26:18 Kamil Debski wrote:
> This patch adds fourcc values for compressed video stream formats and
> V4L2_CTRL_CLASS_CODEC. Also adds controls used by MFC 5.1 driver.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  include/linux/videodev2.h |   39 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 39 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index a94c4d5..a48a42e 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -369,6 +369,19 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /* 1394 */
>  #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4 */
> 
> +#define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 */
> +#define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263 */
> +#define V4L2_PIX_FMT_MPEG12   v4l2_fourcc('M', 'P', '1', '2') /* MPEG-1/2  */
> +#define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4  */
> +#define V4L2_PIX_FMT_DIVX     v4l2_fourcc('D', 'I', 'V', 'X') /* DivX  */
> +#define V4L2_PIX_FMT_DIVX3    v4l2_fourcc('D', 'I', 'V', '3') /* DivX 3.11 */
> +#define V4L2_PIX_FMT_DIVX4    v4l2_fourcc('D', 'I', 'V', '4') /* DivX 4.12 */
> +#define V4L2_PIX_FMT_DIVX500  v4l2_fourcc('D', 'X', '5', '2') /* DivX 5.00 - 5.02 */
> +#define V4L2_PIX_FMT_DIVX503  v4l2_fourcc('D', 'X', '5', '3') /* DivX 5.03 - x */
> +#define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid */
> +#define V4L2_PIX_FMT_VC1      v4l2_fourcc('V', 'C', '1', 'A') /* VC-1 */
> +#define V4L2_PIX_FMT_VC1_RCV  v4l2_fourcc('V', 'C', '1', 'R') /* VC-1 RCV */
> +

Hans, you mentioned some time ago that you were against ading H.264 or MPEG4
fourccs, and that drivers should use the MPEG controls instead. Could you
clarify your current position on this ?

-- 
Regards,

Laurent Pinchart
