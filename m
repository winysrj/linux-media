Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45187 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2IYLne (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 07:43:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, a.hajda@samsung.com,
	sakari.ailus@iki.fi, hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: [PATCH RFC 2/5] V4L: Add V4L2_PIX_FMT_S5C_UYVY_JPG fourcc definition
Date: Tue, 25 Sep 2012 13:44:10 +0200
Message-ID: <2113003.Cq6nRq7Zuu@avalon>
In-Reply-To: <1348498546-2652-3-git-send-email-s.nawrocki@samsung.com>
References: <1348498546-2652-1-git-send-email-s.nawrocki@samsung.com> <1348498546-2652-3-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Monday 24 September 2012 16:55:43 Sylwester Nawrocki wrote:
> The V4L2_PIX_FMT_S5C_UYVY_JPG is a two-plane image format used by
> Samsung S5C73M3 camera. The first plane contains interleaved UYVY
> and JPEG data, followed by meta-data in form of offsets to the UYVU
> data blocks.
> 
> The second plane contains additional meta-data needed for extracting
> JPEG and UYVY data stream from the first plane, in particular an
> offset to the first entry of an array of data offsets in the first
> plane. The offsets are expressed as 4-byte unsigned integers.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/pixfmt.xml | 9 +++++++++
>  include/linux/videodev2.h                  | 1 +
>  2 files changed, 10 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml
> b/Documentation/DocBook/media/v4l/pixfmt.xml index 1ddbfab..9caed9b 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -996,6 +996,15 @@ the other bits are set to 0.</entry>
>  	    <entry>Old 6-bit greyscale format. Only the most significant 6 bits 
of
> each byte are used, the other bits are set to 0.</entry>
>  	  </row>
> +	  <row id="V4L2-PIX-FMT-JPG-YUYV-S5C">
> +	    <entry><constant>V4L2_PIX_FMT_S5C_YUYV_JPG</constant></entry>
> +	    <entry>'S5CJ'</entry>
> +	    <entry>Two-planar format used by Samsung S5C73MX cameras.The first
> +plane contains interleaved JPEG and YUYV data, followed by meta data
> describing +layout of the YUYV and JPEG data blocks. The second plane
> contains additional +information about data layout in the first plane, like
> an offset to the array +of offsets to YUVY data chunks.</entry>
> +	  </row>

I think you need to be a bit more precise here. You should document the format 
of the meta data, as that's required for applications to use the format.

>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 4862165..aa6fb4d 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -435,6 +435,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_KONICA420  v4l2_fourcc('K', 'O', 'N', 'I') /* YUV420
> planar in blocks of 256 pixels */ #define
> V4L2_PIX_FMT_JPGL	v4l2_fourcc('J', 'P', 'G', 'L') /* JPEG-Lite */ #define
> V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu
> compressed rgb */ +#define V4L2_PIX_FMT_S5C_UYVY_JPG v4l2_fourcc('S', '5',
> 'C', 'J') /* S5C73M3 interleaved YUYV/JPEG */
> 
>  /*
>   *	F O R M A T   E N U M E R A T I O N
-- 
Regards,

Laurent Pinchart

