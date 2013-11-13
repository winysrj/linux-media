Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59270 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab3KMCqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Nov 2013 21:46:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Denis Carikli <denis@eukrea.com>,
	driverdev-devel@linuxdriverproject.org
Cc: Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Subject: Re: [PATCHv3 2/8] [media] v4l2: add new V4L2_PIX_FMT_RGB666 pixel format.
Date: Wed, 13 Nov 2013 03:47:27 +0100
Message-ID: <1980062.zhsfvmMMmI@avalon>
In-Reply-To: <1384274965-30549-2-git-send-email-denis@eukrea.com>
References: <1384274965-30549-1-git-send-email-denis@eukrea.com> <1384274965-30549-2-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Denis,

(Dropping the DT reviewers from the CC list to avoid spamming them)

Thank you for the patch.

On Tuesday 12 November 2013 17:49:19 Denis Carikli wrote:
> That new macro is needed by the imx_drm staging driver
>   for supporting the QVGA display of the eukrea-cpuimx51 board.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: devicetree@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: driverdev-devel@linuxdriverproject.org
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: linux-media@vger.kernel.org
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Eric Bénard <eric@eukrea.com>
> Signed-off-by: Denis Carikli <denis@eukrea.com>
> Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> ChangeLog v2->v3:
> - Added some interested people in the Cc list.
> - Added Mauro Carvalho Chehab's Ack.
> - Added documentation.
> ---
>  .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |   78
> ++++++++++++++++++++ include/uapi/linux/videodev2.h                     |  
>  1 +
>  2 files changed, 79 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml index
> 166c8d6..f6a3e84 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> @@ -279,6 +279,45 @@ colorspace
> <constant>V4L2_COLORSPACE_SRGB</constant>.</para> <entry></entry>
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
> @@ -781,6 +820,45 @@ defined in error. Drivers may interpret them as in
> <xref <entry></entry>
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
> index 437f1b0..e8ff410 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -294,6 +294,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_RGB555X v4l2_fourcc('R', 'G', 'B', 'Q') /* 16 
> RGB-5-5-5 BE  */ #define V4L2_PIX_FMT_RGB565X v4l2_fourcc('R', 'G', 'B',
> 'R') /* 16  RGB-5-6-5 BE  */ #define V4L2_PIX_FMT_BGR666  v4l2_fourcc('B',
> 'G', 'R', 'H') /* 18  BGR-6-6-6	  */ +#define V4L2_PIX_FMT_RGB666 
> v4l2_fourcc('R', 'G', 'B', 'H') /* 18  RGB-6-6-6	  */ #define
> V4L2_PIX_FMT_BGR24   v4l2_fourcc('B', 'G', 'R', '3') /* 24  BGR-8-8-8    
> */ #define V4L2_PIX_FMT_RGB24   v4l2_fourcc('R', 'G', 'B', '3') /* 24 
> RGB-8-8-8     */ #define V4L2_PIX_FMT_BGR32   v4l2_fourcc('B', 'G', 'R',
> '4') /* 32  BGR-8-8-8-8   */
-- 
Regards,

Laurent Pinchart

