Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:52875 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750934Ab1HZRHI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 13:07:08 -0400
Message-ID: <4E57D2B5.7020604@gmx.de>
Date: Fri, 26 Aug 2011 17:07:01 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	magnus.damm@gmail.com
Subject: Re: [PATCH/RFC v2 1/3] fbdev: Add FOURCC-based format configuration
 API
References: <1313746626-23845-1-git-send-email-laurent.pinchart@ideasonboard.com> <1313746626-23845-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1313746626-23845-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

hope we're close to the final thing now. Just a few minor issues.

On 08/19/2011 09:37 AM, Laurent Pinchart wrote:
> This API will be used to support YUV frame buffer formats in a standard
> way.
> 
> Last but not least, create a much needed fbdev API documentation and
> document the format setting APIs.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/fb/api.txt |  299 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fb.h       |   27 ++++-
>  2 files changed, 320 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/fb/api.txt
> 

> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index 1d6836c..c6baf28 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -69,6 +69,7 @@
>  #define FB_VISUAL_PSEUDOCOLOR		3	/* Pseudo color (like atari) */
>  #define FB_VISUAL_DIRECTCOLOR		4	/* Direct color */
>  #define FB_VISUAL_STATIC_PSEUDOCOLOR	5	/* Pseudo color readonly */
> +#define FB_VISUAL_FOURCC		6	/* Visual identified by a V4L2 FOURCC */
>  
>  #define FB_ACCEL_NONE		0	/* no hardware accelerator	*/
>  #define FB_ACCEL_ATARIBLITT	1	/* Atari Blitter		*/
> @@ -154,6 +155,8 @@
>  
>  #define FB_ACCEL_PUV3_UNIGFX	0xa0	/* PKUnity-v3 Unigfx		*/
>  
> +#define FB_CAP_FOURCC		1	/* Device supports FOURCC-based formats */
> +
>  struct fb_fix_screeninfo {
>  	char id[16];			/* identification string eg "TT Builtin" */
>  	unsigned long smem_start;	/* Start of frame buffer mem */
> @@ -171,7 +174,8 @@ struct fb_fix_screeninfo {
>  	__u32 mmio_len;			/* Length of Memory Mapped I/O  */
>  	__u32 accel;			/* Indicate to driver which	*/
>  					/*  specific chip/card we have	*/
> -	__u16 reserved[3];		/* Reserved for future compatibility */
> +	__u16 capabilities;		/* see FB_CAP_*			*/
> +	__u16 reserved[2];		/* Reserved for future compatibility */
>  };
>  
>  /* Interpretation of offset for color fields: All offsets are from the right,
> @@ -246,12 +250,23 @@ struct fb_var_screeninfo {
>  	__u32 yoffset;			/* resolution			*/
>  
>  	__u32 bits_per_pixel;		/* guess what			*/
> -	__u32 grayscale;		/* != 0 Graylevels instead of colors */
>  
> -	struct fb_bitfield red;		/* bitfield in fb mem if true color, */
> -	struct fb_bitfield green;	/* else only length is significant */
> -	struct fb_bitfield blue;
> -	struct fb_bitfield transp;	/* transparency			*/	
> +	union {
> +		struct {		/* Legacy format API		*/
> +			__u32 grayscale; /* != 0 Graylevels instead of colors */

You should adjust the comment as well, to avoid misleading crazy people ;)
Needs also be fixed in the documentation at some places.

> +			/* bitfields in fb mem if true color, else only */
> +			/* length is significant			*/
> +			struct fb_bitfield red;
> +			struct fb_bitfield green;
> +			struct fb_bitfield blue;
> +			struct fb_bitfield transp;	/* transparency	*/
> +		};
> +		struct {		/* FOURCC-based format API	*/
> +			__u32 fourcc;		/* FOURCC format	*/
> +			__u32 colorspace;

So we have again fields that are not always used. Okay, as we still have 11 left
that shouldn't be a big problem, I think.

> +			__u32 reserved[11];
> +		} format;

Ugh, if you want this union to have a name I suggest 'fourcc' and not 'format'
as the other struct contains format information as well and who knows, maybe in
10 or 20 years we'll have yet another format description that can do things none
of the existing can do.

> +	};
>  
>  	__u32 nonstd;			/* != 0 Non standard pixel format */
>  


Thanks,

Florian Tobias Schandinat
