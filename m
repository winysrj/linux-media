Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:45693 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932465Ab1ERAUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 20:20:10 -0400
Subject: Re: [RFC] Standardize YUV support in the fbdev API
From: Andy Walls <awalls@md.metrocast.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
In-Reply-To: <201105180007.21173.laurent.pinchart@ideasonboard.com>
References: <201105180007.21173.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 20:21:07 -0400
Message-ID: <1305678067.2419.1.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-05-18 at 00:07 +0200, Laurent Pinchart wrote:
> Hi everybody,
> 
> I need to implement support for a YUV frame buffer in an fbdev driver. As the 
> fbdev API doesn't support this out of the box, I've spent a couple of days 
> reading fbdev (and KMS) code and thinking about how we could cleanly add YUV 
> support to the API. I'd like to share my findings and thoughts, and hopefully 
> receive some comments back.

I haven't looked at anything below, but I'll mention that the ivtv
driver presents an fbdev interface for the YUV output stream of the
CX23415.

It may be worth a look and asking Hans what are the short-comings.

-Andy


> The terms 'format', 'pixel format', 'frame buffer format' and 'data format' 
> will be used interchangeably in this e-mail. They all refer to the way pixels 
> are stored in memory, including both the representation of a pixel as integer 
> values and the layout of those integer values in memory.
> 
> 
> History and current situation
> -----------------------------
> 
> The fbdev API predates YUV frame buffers. In those old days developers only 
> cared (and probably thought) about RGB frame buffers, and they developed an 
> API that could express all kind of weird RGB layout in memory (such as R-
> GGGGGGGGGGG-BBBB for instance, I can't imagine hardware implementing that). 
> This resulted in individual bit field description for the red, green, blue and 
> alpha components:
> 
> struct fb_bitfield {
>         __u32 offset;                  /* beginning of bitfield        */
>         __u32 length;                  /* length of bitfield           */
>         __u32 msb_right;               /* != 0 : Most significant bit is */
>                                        /* right */
> };
> 
> Grayscale formats were pretty common, so a grayscale field tells color formats 
> (grayscale == 0) from grayscale formats (grayscale != 0).
> 
> People already realized that hardware developers were crazily inventive (the 
> word to remember here is crazily), and that non-standard formats would be 
> needed at some point. The fb_var_screeninfo ended up containing the following 
> format-related fields.
> 
> struct fb_var_screeninfo {
>         ...
>         __u32 bits_per_pixel;          /* guess what                   */
>         __u32 grayscale;               /* != 0 Graylevels instead of colors */
> 
>         struct fb_bitfield red;        /* bitfield in fb mem if true color, */
>         struct fb_bitfield green;      /* else only length is significant */
>         struct fb_bitfield blue;
>         struct fb_bitfield transp;     /* transparency                 */
> 
>         __u32 nonstd;                  /* != 0 Non standard pixel format */
>         ...
> };
> 
> Two bits have been specified for the nonstd field:
> 
> #define FB_NONSTD_HAM           1  /* Hold-And-Modify (HAM)        */
> #define FB_NONSTD_REV_PIX_IN_B  2  /* order of pixels in each byte is reversed 
> */
> 
> The FB_NONSTD_HAM bit is used by the video/amifb.c driver only to enable HAM 
> mode[1]. I very much doubt that any new hardware will implement HAM mode (and 
> I certainly hope none will).
> 
> The FB_NONSTD_REV_PIX_IN_B is used in video/fb_draw.h by the generic bitblit, 
> fillrect and copy area implementations, not directly by drivers.
> 
> A couple of drivers hardcode the nonstd field to 1 for some reason. Those are 
> video/arcfb.c (1bpp gray display), video/hecubafb.c (1bpp gray display) and 
> video/metronomefb.c (8bpp gray display).
> 
> The following drivers use nonstd for various other (and sometimes weird) 
> purposes:
> 
> video/arkfb.c
>         Used in 4bpp mode only, to control fb_setcolreg operation
> video/fsl-diu-fb.c
>         Set var->nonstd bits into var->sync (why?)
> video/pxafb.c
>         Encode frame buffer xpos and ypos in the nonstd field
> video/s3fb.c
>         Used in 4bpp mode only, to control fb_setcolreg operation
> video/vga16fb.c
>         When panning in non-8bpp, non-text mode, decrement xoffset
>         Do some other weird stuff when not 0
> video/i810/i810_main.c
>         Select direct color mode when set to 1 (truecolor otherwise)
> 
> Fast forward a couple of years, hardware provides support for YUV frame 
> buffers. Several drivers had to provide YUV format selection to applications, 
> without any standard API to do so. All of them used the nonstd field for that 
> purpose:
> 
> media/video/ivtv/
>         Enable YUV mode when set to 1
> video/pxafb.c
>         Encode pixel format in the nonstd field
> video/sh_mobile_lcdfb.c
>         If bpp == 12 and nonstd != 0, enable NV12 mode
>         If bpp == 16 or bpp == 24, ?
> video/omap/omapfb_main.c
>         Select direct color mode when set to 1 (depend on bpp otherwise)
>         Used as a pixel format identifier (YUV422, YUV420 or YUY422)
> video/omap2/omapfb/omapfb-main.c
>         Select direct color mode when set to 1 (depend on bpp otherwise)
>         Used as a pixel format identifier (YUV422 or YUY422)
> 
> Those drivers use the nonstd field in different, incompatible ways.
> 
> 
> Other related APIs
> ------------------
> 
> Beside the fbdev API, two other kernel/userspace APIs deal with video-related 
> modes and formats.
> 
> - Kernel Mode Setting (KMS)
> 
> The KMS API is similar in purpose to XRandR. Its main purpose is to provide a 
> kernel API to configure output video modes. As such, it doesn't care about 
> frame buffer formats, as they are irrelevant at the CRTC output.
> 
> In addition to handling video modes, the KMS API also provides support for 
> creating (and managing) frame buffer devices, as well as dumb scan-out 
> buffers. In-memory data format is relevant there, but KMS only handles width, 
> height, pitch, depth and bit-per-pixel information. The API doesn't care 
> whether the frame buffer or the dumb scan-out buffer contains RGB or YUV data.
> 
> An RFC[2] has recently been posted to the dri-devel mailing list to "add 
> overlays as first class KMS objects". The proposal includes explicit overlay 
> format support, and discussions have so far pushed towards reusing V4L format 
> codes for the KMS API.
> 
> - Video 4 Linux (V4L)
> 
> The V4L API version 2 (usually called V4L2) has since the beginning included 
> explicit support for data format, referred to as pixel formats.
> 
> Pixel formats are identified by a 32-bit number in the form of a four 
> characters code (4CC or FCC[3]). The list of FCCs defined by V4L2 is available 
> in [4].
> 
> A pixel format uniquely defines the layout of pixel data in memory, including 
> the format type (RGB, YUV, ...), number of bits per components, components 
> order and subsampling. It doesn't define the range of acceptable values for 
> pixel components (such as full-range YUV vs. BT.601[5]), which is carried 
> through a separate colorspace identifier[6].
> 
> 
> YUV support in the fbdev API
> ----------------------------
> 
> Experience with the V4L2 API, both for desktop and embedded devices, and the 
> KMS API, suggests that recent hardware tend to standardize on a relatively 
> small number of pixel formats that don't require bitfield-level descriptions. 
> A pixel format definition based on identifiers should thus fullfill the 
> hardware needs for the foreseeable future.
> 
> Given the overlap between the KMS, V4L2 and fbdev APIs, the need to share data 
> and buffers between those subsystems, and the planned use of V4L2 FCCs in the 
> KMS overlay API, I believe using V4L2 FCCs to identify fbdev formats would be 
> a wise decision.
> 
> To select a frame buffer YUV format, the fb_var_screeninfo structure will need 
> to be extended with a format field. The fbdev API and ABI must not be broken, 
> which prevents us from changing the current structure layout and replacing the 
> existing format selection mechanism (through the red, green, blue and alpha 
> bitfields) completely.
> 
> Several solutions exist to introduce a format field in the fb_var_screeninfo 
> structure.
> 
> - Use the nonstd field as a format identifier. Existing drivers that use the 
> nonstd field for other purposes wouldn't be able to implement the new API 
> while keeping their existing API. This isn't a show stopper for drivers using 
> the FB_NONSTD_HAM and FB_NONSTD_REV_PIX_IN_B bits, as they don't need to 
> support any non-RGB format.
> 
> Existing drivers that support YUV formats through the nonstd field would have 
> to select between the current and the new API, without being able to implement 
> both.
> 
> - Use one of the reserved fields as a format identifier. Applications are 
> supposed to zero the fb_var_screeninfo structure before passing it to the 
> kernel, but experience showed that many applications forget to do so. Drivers 
> would then be unable to find out whether applications request a particular 
> format, or just forgot to initialize the field.
> 
> - Add a new FB_NONSTD_FORMAT bit to the nonstd field, and pass the format 
> through a separate field. If an application sets the FB_NONSTD_FORMAT bit in 
> the nonstd field, drivers will ignore the red, green, blue, transp and 
> grayscale fields, and use the format identifier to configure the frame buffer 
> format. The grayscale field would then be unneeded and could be reused as a 
> format identifier. Alternatively, one of the reserved fields could be used for 
> that purpose.
> 
> Existing drivers that support YUV formats through the nonstd field don't use 
> the field's most significant bits. They could implement both their current API 
> and the new API if the FB_NONSTD_FORMAT bit is stored in one of the nonstd 
> MSBs.
> 
> - Other solutions are possible, such as adding new ioctls. Those solutions are 
> more intrusive, and require larger changes to both userspace and kernelspace 
> code.
> 
> 
> The third solution has my preference. Comments and feedback will be 
> appreciated. I will then work on a proof of concept and submit patches.
> 
> 
> [1] http://en.wikipedia.org/wiki/Hold_And_Modify
> [2] http://lwn.net/Articles/440192/
> [3] http://www.fourcc.org/
> [4] http://lxr.linux.no/linux+v2.6.38/include/linux/videodev2.h#L271
> [5] http://en.wikipedia.org/wiki/Rec._601
> [6] http://lxr.linux.no/linux+v2.6.38/include/linux/videodev2.h#L175
> 


