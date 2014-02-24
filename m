Return-path: <linux-media-owner@vger.kernel.org>
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:31055
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbaBXCPM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 21:15:12 -0500
Date: Mon, 24 Feb 2014 10:15:30 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Denis Carikli <denis@eukrea.com>
CC: Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Troy Kisky <troy.kisky@boundarydevices.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCHv7][ 1/7] [media] v4l2: add new V4L2_PIX_FMT_RGB666 pixel
 format.
Message-ID: <20140224021529.GD25011@S2101-09.ap.freescale.net>
References: <1392991205-25371-1-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1392991205-25371-1-git-send-email-denis@eukrea.com>
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 21, 2014 at 02:59:58PM +0100, Denis Carikli wrote:
> That new macro is needed by the imx_drm staging driver
>   for supporting the QVGA display of the eukrea-cpuimx51 board.
> 
> Cc: Eric Bénard <eric@eukrea.com>
> CC: Troy Kisky <troy.kisky@boundarydevices.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Denis Carikli <denis@eukrea.com>
> Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Denis,

I'm only responsible for taking arch/arm/boot/dts/imx* changes, and
other changes should be sent to subsystem maintainers.

Shawn

> ---
> ChangeLog v6->v7:
> - Shrinked even more the Cc list.
> ChangeLog v5->v6:
> - Remove people not concerned by this patch from the Cc list.
> 
> ChangeLog v3->v4:
> - Added Laurent Pinchart's Ack.
> 
> ChangeLog v2->v3:
> - Added some interested people in the Cc list.
> - Added Mauro Carvalho Chehab's Ack.
> - Added documentation.
> ---
>  .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |   78 ++++++++++++++++++++
>  include/uapi/linux/videodev2.h                     |    1 +
>  2 files changed, 79 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> index 166c8d6..f6a3e84 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> @@ -279,6 +279,45 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
>  	    <entry></entry>
>  	    <entry></entry>
>  	  </row>
> +	  <row id="V4L2-PIX-FMT-RGB666">
> +	    <entry><constant>V4L2_PIX_FMT_RGB666</constant></entry>
> +	    <entry>'RGBH'</entry>
> +	    <entry></entry>
> +	    <entry>r<subscript>5</subscript></entry>
> +	    <entry>r<subscript>4</subscript></entry>
> +	    <entry>r<subscript>3</subscript></entry>
> +	    <entry>r<subscript>2</subscript></entry>
> +	    <entry>r<subscript>1</subscript></entry>
> +	    <entry>r<subscript>0</subscript></entry>
> +	    <entry>g<subscript>5</subscript></entry>
> +	    <entry>g<subscript>4</subscript></entry>
> +	    <entry></entry>
> +	    <entry>g<subscript>3</subscript></entry>
> +	    <entry>g<subscript>2</subscript></entry>
> +	    <entry>g<subscript>1</subscript></entry>
> +	    <entry>g<subscript>0</subscript></entry>
> +	    <entry>b<subscript>5</subscript></entry>
> +	    <entry>b<subscript>4</subscript></entry>
> +	    <entry>b<subscript>3</subscript></entry>
> +	    <entry>b<subscript>2</subscript></entry>
> +	    <entry></entry>
> +	    <entry>b<subscript>1</subscript></entry>
> +	    <entry>b<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	  </row>
>  	  <row id="V4L2-PIX-FMT-BGR24">
>  	    <entry><constant>V4L2_PIX_FMT_BGR24</constant></entry>
>  	    <entry>'BGR3'</entry>
> @@ -781,6 +820,45 @@ defined in error. Drivers may interpret them as in <xref
>  	    <entry></entry>
>  	    <entry></entry>
>  	  </row>
> +	  <row><!-- id="V4L2-PIX-FMT-RGB666" -->
> +	    <entry><constant>V4L2_PIX_FMT_RGB666</constant></entry>
> +	    <entry>'RGBH'</entry>
> +	    <entry></entry>
> +	    <entry>r<subscript>5</subscript></entry>
> +	    <entry>r<subscript>4</subscript></entry>
> +	    <entry>r<subscript>3</subscript></entry>
> +	    <entry>r<subscript>2</subscript></entry>
> +	    <entry>r<subscript>1</subscript></entry>
> +	    <entry>r<subscript>0</subscript></entry>
> +	    <entry>g<subscript>5</subscript></entry>
> +	    <entry>g<subscript>4</subscript></entry>
> +	    <entry></entry>
> +	    <entry>g<subscript>3</subscript></entry>
> +	    <entry>g<subscript>2</subscript></entry>
> +	    <entry>g<subscript>1</subscript></entry>
> +	    <entry>g<subscript>0</subscript></entry>
> +	    <entry>b<subscript>5</subscript></entry>
> +	    <entry>b<subscript>4</subscript></entry>
> +	    <entry>b<subscript>3</subscript></entry>
> +	    <entry>b<subscript>2</subscript></entry>
> +	    <entry></entry>
> +	    <entry>b<subscript>1</subscript></entry>
> +	    <entry>b<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	  </row>
>  	  <row><!-- id="V4L2-PIX-FMT-BGR24" -->
>  	    <entry><constant>V4L2_PIX_FMT_BGR24</constant></entry>
>  	    <entry>'BGR3'</entry>
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 6ae7bbe..3051d67 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -294,6 +294,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_RGB555X v4l2_fourcc('R', 'G', 'B', 'Q') /* 16  RGB-5-5-5 BE  */
>  #define V4L2_PIX_FMT_RGB565X v4l2_fourcc('R', 'G', 'B', 'R') /* 16  RGB-5-6-5 BE  */
>  #define V4L2_PIX_FMT_BGR666  v4l2_fourcc('B', 'G', 'R', 'H') /* 18  BGR-6-6-6	  */
> +#define V4L2_PIX_FMT_RGB666  v4l2_fourcc('R', 'G', 'B', 'H') /* 18  RGB-6-6-6	  */
>  #define V4L2_PIX_FMT_BGR24   v4l2_fourcc('B', 'G', 'R', '3') /* 24  BGR-8-8-8     */
>  #define V4L2_PIX_FMT_RGB24   v4l2_fourcc('R', 'G', 'B', '3') /* 24  RGB-8-8-8     */
>  #define V4L2_PIX_FMT_BGR32   v4l2_fourcc('B', 'G', 'R', '4') /* 32  BGR-8-8-8-8   */
> -- 
> 1.7.9.5
> 

