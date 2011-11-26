Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:53541 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1KZSnb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 13:43:31 -0500
Date: Sat, 26 Nov 2011 20:43:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: [RFC] JPEG encoders control class
Message-ID: <20111126184323.GD29805@valkosipuli.localdomain>
References: <4EBECD11.8090709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBECD11.8090709@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the RFC. I originally missed it; thanks for pointing to it!

On Sat, Nov 12, 2011 at 08:46:25PM +0100, Sylwester Nawrocki wrote:
> Hi all,
> 
> This RFC is discussing the current support of JPEG encoders in V4L2 and 
> a proposal of new JPEG control class.
> 
> 
> Motivation
> ==========
> 
> JPEG encoder control is also required at the sub-device level, but currently 
> there are only defined ioctls in regular V4L2 device API. It doesn't seem
> to make sense for these current ioctls to be inherited by sub-device nodes, 
> since they're not generic enough, incomplete and rather not compliant with
> JFIF JPEG standard [2], [3].
> 
> 
> Current implementation
> ======================
> 
> Currently two ioctls are available [4]:
> 
> #define VIDIOC_G_JPEGCOMP	 _IOR('V', 61, struct v4l2_jpegcompression)
> #define VIDIOC_S_JPEGCOMP	 _IOW('V', 62, struct v4l2_jpegcompression)
> 
> And the corresponding data structure is defined as:
> 
> struct v4l2_jpegcompression {
> 	int quality;
> 
> 	int  APPn;              /* Number of APP segment to be written,
> 				 * must be 0..15 */
> 	int  APP_len;           /* Length of data in JPEG APPn segment */
> 	char APP_data[60];      /* Data in the JPEG APPn segment. */
> 
> 	int  COM_len;           /* Length of data in JPEG COM segment */
> 	char COM_data[60];      /* Data in JPEG COM segment */
> 
> 	__u32 jpeg_markers;     /* Which markers should go into the JPEG
> 				 * output. Unless you exactly know what
> 				 * you do, leave them untouched.
> 				 * Inluding less markers will make the
> 				 * resulting code smaller, but there will
> 				 * be fewer applications which can read it.
> 				 * The presence of the APP and COM marker
> 				 * is influenced by APP_len and COM_len
> 				 * ONLY, not by this property! */
> 
> #define V4L2_JPEG_MARKER_DHT (1<<3)    /* Define Huffman Tables */
> #define V4L2_JPEG_MARKER_DQT (1<<4)    /* Define Quantization Tables */
> #define V4L2_JPEG_MARKER_DRI (1<<5)    /* Define Restart Interval */
> #define V4L2_JPEG_MARKER_COM (1<<6)    /* Comment segment */
> #define V4L2_JPEG_MARKER_APP (1<<7)    /* App segment, driver will
> 					* allways use APP0 */
> };
> 
> 
> What are the issues with such an implementation ?
> 
> These ioctls don't allow to re-program the quantization and Huffman tables 
> (DQT, DHT). Additionally, the standard valid segment length for the application
> defined APPn and the comment COM segment is 2...65535, while currently this is
> limited to 60 bytes.
> 
> Therefore APP_data and COM_data, rather than fixed size arrays, should be 
> pointers to a variable length buffer.
> 
> Only two drivers upstream really use VIDIOC_[S/G]_JPEGCOMP ioctls for anything
> more than compression quality query/control. It might make sense to create 
> separate control for image quality and to obsolete the v4l2_jpegcompressin::quality 
> field.
> 
> Below is a brief review of usage of VIDIOC_[S/G]_JPEGCOMP ioctls in current mainline 
> drivers. Listed are parts of struct v4l2_jpegcompression used in each case.
> 
> 
> cpia2
> -----
> 
> vidioc_g_jpegcomp, vidioc_s_jpegcomp
> - compression quality ignored, returns fixed value (80)
> - uses APP_data/len, COM_data/len
> - markers (only DHT can be disabled by the applications) 
> 
> 
> zoran
> -----
> 
> vidioc_g_jpegcomp, vidioc_s_jpegcomp
> - compression quality, values 5...100, used only to calculate buffer size
> - APP_data/len, COM_data/len
> - markers field used to control inclusion of selected JPEG markers
>   in the output buffer
> 
> 
> et61x251, sn9c102, s2255drv.c
> -----------------------------
> 
> vidioc_g_jpegcomp, vidioc_s_jpegcomp 
> - compression quality only, 
>   valid values: et61x251, sn9c102use - {0, 1}, s2255drv.c - (0..100)
> 
> 
> staging/media/go7007
> --------------------
> 
> vidioc_g_jpegcomp
> - only for reporting JPEG markers (_DHT and _DQT returned),
> - always returns fixed value of compression quality (50)
> 
> vidioc_s_jpegcomp
>  - does nothing, only returns error code when passed parameter
>    do not match the device capabilities
> 
> 
> drivers/media/video/gspca/conex.c  
> drivers/media/video/gspca/jeilinj.c
> drivers/media/video/gspca/mars.c
> drivers/media/video/gspca/ov519.c
> drivers/media/video/gspca/spca500.c
> drivers/media/video/gspca/stk014.c
> drivers/media/video/gspca/sunplus.c
> drivers/media/video/gspca/topro.c
> drivers/media/video/gspca/zc3xx.c
> ------------------------------------
> 
> vidioc_s_jpegcomp
> - compression quality
> 
> vidioc_g_jpegcomp
>  - compression quality, marker flags
> 
> 
> drivers/media/video/gspca/sonixj.c
> ------------------------------------
> 
> vidioc_g_jpegcomp
>  - compression quality, marker flags
>  
> --------------------------------------
> 
> The following is an initial draft of the new control class
> 
> o V4L2_CTRL_CLASS_JPEG
> 
> As not everything might be covered by the controls (the application data and comment
> segments, quantization and Huffman tables, etc.) the control class should probably
> just complement VIDIOC_[G/S]_JPEGCOMP ioctls, rather than entirely replacing them.

I wonder if there would be enough benefits in having blob controls. The
challenge is how to describe the format of the data in a standard and
flexible way and also what those bits actually signify. We will have lots of
table format data when the image processing functionality (much of which is
hardware-dependent) in ISPs get better supported.

FYI: you have over 80 characters per line. It's hard to read without
rewrapping.

> Proposed controls
> =================
> 
> 1. Chroma sub-sampling
> ---------------------
> 
> The subsampling factors describe how each component of an input image is sampled,
> in respect to maximum sample rate in each spatial dimension.
> More general description can be found in [2], clause A.1.1., "Dimensions and 
> sampling factors".
> 
> The chroma subsampling would describe how Cb, Cr components should be downsampled
> after coverting an input image from RGB to Y'CbCr color space.
> 
> o V4L2_CID_JPEG_CHROMA_SUBSAMPLING
> 
>   - V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY - only luminance component is present,
>   - V4L2_JPEG_CHROMA_SUBSAMPLING_410  - subsample Cr, Cb signals horizontally by
>                                         4 and vertically by 2
>   - V4L2_JPEG_CHROMA_SUBSAMPLING_411  - horizontally subsample Cr, Cb signals by
>                                         a factor of 4
>   - V4L2_JPEG_CHROMA_SUBSAMPLING_420  - subsample Cr, Cb signals horizontally and
>                                         vertically by 2
>   - V4L2_JPEG_CHROMA_SUBSAMPLING_422  - horizontally subsample Cr, Cb signals by
>                                         a factor of 2,
>   - V4L2_JPEG_CHROMA_SUBSAMPLING_444  - no chroma subsampling, each pixel has Y, 
>                                         Cr and Cb values.
> 
> Using no subsampling produces sharper colours, even with higher compression
> (in order to achieve similar file size) [7], thus it seems important to provide 
> the user with a method of precise subsampling control. 
> 
> 
> 2. Restart interval (DRI)
> -----------------------
> 
> o V4L2_CID_JPEG_RESTART_INTERVAL
> 
> The restart interval (DRI marker) determines the interval of inserting RSTm
> markers. The purpose of RSTm markers is to additionally reinitialize decoder 
> process' predictor with initial default value. For lossy compression processes
> the restart interval is expressed in MCU (Minimm Coded Unit).
> If restart interval value is 0 DRI and RSTm (m = 0..7) markers will not be 
> inserted. Consequently this control would make current V4L2_JPEG_MARKER_DRI 
> markers flag redundant. This control would be useful for S5P JPEG IP block [6].
> 
> 
> 3. Image quality
> ----------------
> 
> o V4L2_CID_JPEG_QUALITY	
> 
> Image quality is not defined in the standard but it is used as an intermediate 
> parameter by many encoders to control set of encoding parameters, which then 
> allow to obtain certain image quality and corresponding file size.
> IMHO it makes sense to add the quality control to the JPEG class as it's widely
> used, not only for webcams. 
> 
> As far as the value range is concerned, probably it's better to leave this driver
> specific. The applications would then be more aware of what is supported by 
> a device (min, max, step) and they could translate driver specific range into 
> standardised values (0..100) if needed. Still the drivers could do the translation
> themselves if required. The specification would only say the 0..100 range is 
> recommended.

I think it's best to leave this hardware specific. Granularity might matter
sometimes in the user space. As the step is enforced (which is correct), it
may be impossible to support the span 0--100 with desired granularity.

> 4. JPEG markers presence
> ------------------------
> 
> Markers serve as identifiers of various structural parts of compressed data 
> formats. All markers are assigned two-byte codes: an 0xFF byte followed by 
> a byte which is not equal to 0 or 0xFF. [2] Excluding the reserved ones there
> is 39 valid codes.
> 
> I'm not really sure how the markers inhibit feature is useful, but since some
> drivers use it let's assume it is needed. Likely a 32-bit bitmask control could
> be used for activating/deactivating markers, as it doesn't make sense for some 
> of markers to be freely discarded from the compressed data.
> 
> o V4L2_CID_JPEG_ACTIVE_MARKERS
> 
> Following markers might be covered by this control, listed in Table E.1, [2]: 
> APP0..15, COM, DHT, DQT, DAC and additionally DNL. 
> There is still room for 10 additional markers which might be added if required.
> 
> 
> The above list of controls is most likely not exhaustive, it's just an attempt
> to cover features available in the mainline drivers and the S5P SoC JPEG codec
> IP block [6].
> 
> In order to support reconfiguration of quantization and Huffman tables the 
> VIDIOC_[G/S]_JPEGCOMP probably need to be re-designed, but it's out of scope
> of this RFC. 

Is this something that a regular user might typically want to do?

Also, if you keep adding more functionality to a single structure like that
it forces user to get all the other parameters (s)he doesn't want to change
before issuing the set operation. I don't particularly like that idea.

> References
> ==========
> 
> [1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg01783.html
> 
> [2] http://www.w3.org/Graphics/JPEG/itu-t81.pdf
> 
> [3] http://www.w3.org/Graphics/JPEG/jfif3.pdf
> 
> [4] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-jpegcomp.html
> 
> [5] http://www.mail-archive.com/linux-media@vger.kernel.org/msg01784.html
> 
> [6] http://patchwork.linuxtv.org/patch/8197
> 
> [7] http://www.ampsoft.net/webdesign-l/jpeg-compression.html

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
