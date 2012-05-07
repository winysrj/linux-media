Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2467 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab2EGP3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 11:29:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 1/1] v4l2: use __u32 rather than enums in ioctl() structs
Date: Mon, 7 May 2012 17:28:52 +0200
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, remi@remlab.net
References: <1336400869-32421-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1336400869-32421-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205071728.52329.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon May 7 2012 16:27:49 Sakari Ailus wrote:
> From: R�mi Denis-Courmont <remi@remlab.net>
> 
> V4L2 uses the enum type in IOCTL arguments in IOCTLs that were defined until
> the use of enum was considered less than ideal. Recently R�mi Denis-Courmont
> brought up the issue by proposing a patch to convert the enums to unsigned:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg46167.html>
> 
> This sparked a long discussion where another solution to the issue was
> proposed: two sets of IOCTL structures, one with __u32 and the other with
> enums, and conversion code between the two:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg47168.html>
> 
> Both approaches implement a complete solution that resolves the problem. The
> first one is simple but requires assuming enums and __u32 are the same in
> size (so we won't break the ABI) while the second one is more complex and
> less clean but does not require making that assumption.
> 
> The issue boils down to whether enums are fundamentally different from __u32
> or not, and can the former be substituted by the latter. During the
> discussion it was concluded that the __u32 has the same size as enums on all
> archs Linux is supported: it has not been shown that replacing those enums
> in IOCTL arguments would break neither source or binary compatibility. If no
> such reason is found, just replacing the enums with __u32s is the way to go.
> 
> This is what this patch does. This patch is slightly different from Remi's
> first RFC (link above): it uses __u32 instead of unsigned and also changes
> the arguments of VIDIOC_G_PRIORITY and VIDIOC_S_PRIORITY.
> 
> Signed-off-by: R�mi Denis-Courmont <remi@remlab.net>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
> Changes since v1:
> 
> - Fixes according to comments by Hans Verkuil:
>   - Update documentation
>   - Also remove enums in compat32 code
> 
>  Documentation/DocBook/media/v4l/io.xml             |   12 +++--
>  .../DocBook/media/v4l/vidioc-create-bufs.xml       |   10 +++--
>  Documentation/DocBook/media/v4l/vidioc-cropcap.xml |    4 +-
>  .../DocBook/media/v4l/vidioc-enum-fmt.xml          |    4 +-
>  Documentation/DocBook/media/v4l/vidioc-g-crop.xml  |    4 +-
>  Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |    2 +-
>  .../DocBook/media/v4l/vidioc-g-frequency.xml       |    6 +-
>  Documentation/DocBook/media/v4l/vidioc-g-parm.xml  |    5 +-
>  .../DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml  |    2 +-
>  Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |    2 +-
>  .../DocBook/media/v4l/vidioc-queryctrl.xml         |    2 +-
>  Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |    7 ++-
>  .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |    5 +-
>  drivers/media/video/v4l2-compat-ioctl32.c          |   12 +++---
>  include/linux/videodev2.h                          |   46 ++++++++++----------
>  15 files changed, 65 insertions(+), 58 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index b815929..fd6aca2 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -543,12 +543,13 @@ and can range from zero to the number of buffers allocated
>  with the &VIDIOC-REQBUFS; ioctl (&v4l2-requestbuffers; <structfield>count</structfield>) minus one.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>&v4l2-buf-type;</entry>
> +	    <entry>__u32</entry>

The problem with replacing &v4l2-buf-type; by __u32 is that you loose the link
to the v4l2-buf-type enum.

>  	    <entry><structfield>type</structfield></entry>
>  	    <entry></entry>
>  	    <entry>Type of the buffer, same as &v4l2-format;

I would change this to something like:

Type of the buffer (see enum &v4l2-buf-type;), same as...

Same for all the other similar cases. Annoying, I know, but I believe it is
important to have these links available.

... cut ...

> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 5a09ac3..585e4b4 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -292,10 +292,10 @@ struct v4l2_pix_format {
>  	__u32         		width;
>  	__u32			height;
>  	__u32			pixelformat;
> -	enum v4l2_field  	field;
> +	__u32			field;

Same here: you need a comment like "/* see enum v4l2_field */" to keep the
association between the field and the possible value.

Regards,

	Hans

>  	__u32            	bytesperline;	/* for padding, zero if unused */
>  	__u32          		sizeimage;
> -	enum v4l2_colorspace	colorspace;
> +	__u32			colorspace;
>  	__u32			priv;		/* private data, depends on pixelformat */
>  };
>  
> @@ -432,7 +432,7 @@ struct v4l2_pix_format {
>   */
>  struct v4l2_fmtdesc {
>  	__u32		    index;             /* Format number      */
> -	enum v4l2_buf_type  type;              /* buffer type        */
> +	__u32		    type;              /* buffer type        */
>  	__u32               flags;
>  	__u8		    description[32];   /* Description string */
>  	__u32		    pixelformat;       /* Format fourcc      */
> @@ -573,8 +573,8 @@ struct v4l2_jpegcompression {
>   */
>  struct v4l2_requestbuffers {
>  	__u32			count;
> -	enum v4l2_buf_type      type;
> -	enum v4l2_memory        memory;
> +	__u32			type;
> +	__u32			memory;
>  	__u32			reserved[2];
>  };
>  
> @@ -636,16 +636,16 @@ struct v4l2_plane {
>   */
>  struct v4l2_buffer {
>  	__u32			index;
> -	enum v4l2_buf_type      type;
> +	__u32			type;
>  	__u32			bytesused;
>  	__u32			flags;
> -	enum v4l2_field		field;
> +	__u32			field;
>  	struct timeval		timestamp;
>  	struct v4l2_timecode	timecode;
>  	__u32			sequence;
>  
>  	/* memory location */
> -	enum v4l2_memory        memory;
> +	__u32			memory;
>  	union {
>  		__u32           offset;
>  		unsigned long   userptr;
> @@ -708,7 +708,7 @@ struct v4l2_clip {
>  
>  struct v4l2_window {
>  	struct v4l2_rect        w;
> -	enum v4l2_field  	field;
> +	__u32			field;
>  	__u32			chromakey;
>  	struct v4l2_clip	__user *clips;
>  	__u32			clipcount;
> @@ -745,14 +745,14 @@ struct v4l2_outputparm {
>   *	I N P U T   I M A G E   C R O P P I N G
>   */
>  struct v4l2_cropcap {
> -	enum v4l2_buf_type      type;
> +	__u32			type;
>  	struct v4l2_rect        bounds;
>  	struct v4l2_rect        defrect;
>  	struct v4l2_fract       pixelaspect;
>  };
>  
>  struct v4l2_crop {
> -	enum v4l2_buf_type      type;
> +	__u32			type;
>  	struct v4l2_rect        c;
>  };
>  
> @@ -1157,7 +1157,7 @@ enum v4l2_ctrl_type {
>  /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
>  struct v4l2_queryctrl {
>  	__u32		     id;
> -	enum v4l2_ctrl_type  type;
> +	__u32		     type;
>  	__u8		     name[32];	/* Whatever */
>  	__s32		     minimum;	/* Note signedness */
>  	__s32		     maximum;
> @@ -1792,7 +1792,7 @@ enum v4l2_jpeg_chroma_subsampling {
>  struct v4l2_tuner {
>  	__u32                   index;
>  	__u8			name[32];
> -	enum v4l2_tuner_type    type;
> +	__u32			type;
>  	__u32			capability;
>  	__u32			rangelow;
>  	__u32			rangehigh;
> @@ -1842,14 +1842,14 @@ struct v4l2_modulator {
>  
>  struct v4l2_frequency {
>  	__u32		      tuner;
> -	enum v4l2_tuner_type  type;
> +	__u32		      type;
>  	__u32		      frequency;
>  	__u32		      reserved[8];
>  };
>  
>  struct v4l2_hw_freq_seek {
>  	__u32		      tuner;
> -	enum v4l2_tuner_type  type;
> +	__u32		      type;
>  	__u32		      seek_upward;
>  	__u32		      wrap_around;
>  	__u32		      spacing;
> @@ -2060,7 +2060,7 @@ struct v4l2_sliced_vbi_cap {
>  				 (equals frame lines 313-336 for 625 line video
>  				  standards, 263-286 for 525 line standards) */
>  	__u16   service_lines[2][24];
> -	enum v4l2_buf_type type;
> +	__u32	type;
>  	__u32   reserved[3];    /* must be 0 */
>  };
>  
> @@ -2150,8 +2150,8 @@ struct v4l2_pix_format_mplane {
>  	__u32				width;
>  	__u32				height;
>  	__u32				pixelformat;
> -	enum v4l2_field			field;
> -	enum v4l2_colorspace		colorspace;
> +	__u32				field;
> +	__u32				colorspace;
>  
>  	struct v4l2_plane_pix_format	plane_fmt[VIDEO_MAX_PLANES];
>  	__u8				num_planes;
> @@ -2169,7 +2169,7 @@ struct v4l2_pix_format_mplane {
>   * @raw_data:	placeholder for future extensions and custom formats
>   */
>  struct v4l2_format {
> -	enum v4l2_buf_type type;
> +	__u32	 type;
>  	union {
>  		struct v4l2_pix_format		pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
>  		struct v4l2_pix_format_mplane	pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
> @@ -2183,7 +2183,7 @@ struct v4l2_format {
>  /*	Stream type-dependent parameters
>   */
>  struct v4l2_streamparm {
> -	enum v4l2_buf_type type;
> +	__u32	 type;
>  	union {
>  		struct v4l2_captureparm	capture;
>  		struct v4l2_outputparm	output;
> @@ -2303,7 +2303,7 @@ struct v4l2_dbg_chip_ident {
>  struct v4l2_create_buffers {
>  	__u32			index;
>  	__u32			count;
> -	enum v4l2_memory        memory;
> +	__u32			memory;
>  	struct v4l2_format	format;
>  	__u32			reserved[8];
>  };
> @@ -2360,8 +2360,8 @@ struct v4l2_create_buffers {
>  #define VIDIOC_TRY_FMT      	_IOWR('V', 64, struct v4l2_format)
>  #define VIDIOC_ENUMAUDIO	_IOWR('V', 65, struct v4l2_audio)
>  #define VIDIOC_ENUMAUDOUT	_IOWR('V', 66, struct v4l2_audioout)
> -#define VIDIOC_G_PRIORITY        _IOR('V', 67, enum v4l2_priority)
> -#define VIDIOC_S_PRIORITY        _IOW('V', 68, enum v4l2_priority)
> +#define VIDIOC_G_PRIORITY	 _IOR('V', 67, __u32)
> +#define VIDIOC_S_PRIORITY	 _IOW('V', 68, __u32)
>  #define VIDIOC_G_SLICED_VBI_CAP _IOWR('V', 69, struct v4l2_sliced_vbi_cap)
>  #define VIDIOC_LOG_STATUS         _IO('V', 70)
>  #define VIDIOC_G_EXT_CTRLS	_IOWR('V', 71, struct v4l2_ext_controls)
> 
