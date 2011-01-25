Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48233 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab1AYCid (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 21:38:33 -0500
Date: Tue, 25 Jan 2011 11:38:25 +0900
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [RFC/PATCH v6 1/4] Changes in include/linux/videodev2.h for MFC 5.1
In-reply-to: <201101231828.23723.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>, pawel@osciak.com,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com
Message-id: <00b501cbbc38$f3b35dc0$db1a1940$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-gb
Content-transfer-encoding: 7BIT
References: <1294417534-3856-1-git-send-email-k.debski@samsung.com>
 <1294417534-3856-2-git-send-email-k.debski@samsung.com>
 <201101231828.23723.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

I am pretty busy with other work now. That's why I have little time to
work on the open source driver for the open source. I hope to have more
time soon.

> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> 
> Hi Kamil,
> 
> Here is a review of this patch. I didn't really look that closely at
> the others,
> other than noticing that they didn't use the control framework yet.
> 
> The main issue really is lack of documentation. It's hard to review
> something if
> you don't know what a new define stands for.

Yes, no control framework so far, but I understand this is high priority.
 
> On Friday, January 07, 2011 17:25:31 Kamil Debski wrote:
> > This patch adds fourcc values for compressed video stream formats and
> > V4L2_CTRL_CLASS_CODEC. Also adds controls used by MFC 5.1 driver.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  include/linux/videodev2.h |   45
> +++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 45 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index d30c98d..b8952fc 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -339,6 +339,14 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_NV16    v4l2_fourcc('N', 'V', '1', '6') /* 16
> Y/CbCr 4:2:2  */
> >  #define V4L2_PIX_FMT_NV61    v4l2_fourcc('N', 'V', '6', '1') /* 16
> Y/CrCb 4:2:2  */
> >
> > +/* two non contiguous planes -- one Y, one Cr + Cb interleaved  */
> > +#define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12
> Y/CbCr 4:2:0  */
> > +/* 12  Y/CbCr 4:2:0 64x32 macroblocks */
> > +#define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2')
> > +
> > +/* three non contiguous planes -- Y, Cb, Cr */
> > +#define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12
> YUV420 planar */
> > +
> 
> Don't forget to document these formats in the V4L2 spec.

Sylwester has described two of the formats.
You can find it here
http://linuxtv.org/downloads/v4l-dvb-apis/V4L2-PIX-FMT-YUV420M.html
or look at the patch here
http://git.linuxtv.org/media_tree.git?a=commit;h=8104f63b9af30c22530d1c5cea0
5d241566fad90

As to V4L2_PIX_FMT_NV12MT - this format is pretty complicated. The layout of
the macro blocks is non obvious. Actually, I have been
working on the documentation not long ago, but I have received some higher
priority work recently...

> 
> >  /* Bayer formats - see http://www.siliconimaging.com/RGB%20Bayer.htm
> */
> >  #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8
> BGBG.. GRGR.. */
> >  #define V4L2_PIX_FMT_SGBRG8  v4l2_fourcc('G', 'B', 'R', 'G') /*  8
> GBGB.. RGRG.. */
> > @@ -362,6 +370,18 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /*
> 1394          */
> >  #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /*
> MPEG-1/2/4    */
> >
> > +#define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /*
> H264    */
> > +#define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /*
> H263    */
> > +#define V4L2_PIX_FMT_MPEG12   v4l2_fourcc('M', 'P', '1', '2') /*
> MPEG-1/2  */
> > +#define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /*
> MPEG-4  */
> > +#define V4L2_PIX_FMT_DIVX     v4l2_fourcc('D', 'I', 'V', 'X') /*
> DivX  */
> > +#define V4L2_PIX_FMT_DIVX3    v4l2_fourcc('D', 'I', 'V', '3') /*
> DivX 3.11  */
> > +#define V4L2_PIX_FMT_DIVX4    v4l2_fourcc('D', 'I', 'V', '4') /*
> DivX 4.12  */
> > +#define V4L2_PIX_FMT_DIVX5    v4l2_fourcc('D', 'X', '5', '0') /*
> DivX 5  */
> > +#define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /*
> Xvid */
> > +#define V4L2_PIX_FMT_VC1      v4l2_fourcc('V', 'C', '1', 'A') /* VC-
> 1 */
> > +#define V4L2_PIX_FMT_VC1_RCV      v4l2_fourcc('V', 'C', '1', 'R') /*
> VC-1 RCV */
> > +
> 
> Ditto. Note: FMT_MPEG and FMT_MPEG12 and possibly FMT_MPEG4 seem to
> describe the
> same format. What's the difference? And do these formats describe raw
> video
> streams or program/transport streams? Can I just put in any old DivX
> file or
> does the hardware understand only a specific dialect or even a
> hardware-specific
> variation of the standard?

The idea was to choose the codec by using the pixel formats. The hardware
needs the application to specify what kind of stream it will deal with.
Hence the different pixel formats. I think that MPEG1, 2 and 4 may fall in
the V4L2_PIX_FMT_MPEG category. But when I look at the enum
v4l2_mpeg_stream_type
there is no value for MPEG4 value. In addition - for MPEG1 and 2 MFC accepts
elementary stream (ES) and I don't see it in the enum too.

It will accept only elementary stream. As to DivX one should select the
version and the hardware will support the features defined by the standard.
I think Jaeryul Oh could provide more information about DivX support.

In H264 you can have different profiles supported by hardware,
still I imagine that the drivers would use V4L2_PIX_FMT_H264.

> 
> Does the codec just go from compressed video to raw video? If it also
> goes in
> the other direction, how does one set bitrates, etc.?

This is the decoder only version of the driver. The hardware supports
also encoding and we are working at an updated driver. There will be
a set of controls for adjusting the encoding parameters.

> Does it accept multiplexed streams containing audio as well? If so,
> what does
> it do with the audio?

Only video elementary streams are supported.

> 
> >  /*  Vendor-specific formats   */
> >  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /*
> cpia1 YUV */
> >  #define V4L2_PIX_FMT_WNVA     v4l2_fourcc('W', 'N', 'V', 'A') /*
> Winnov hw compress */
> > @@ -972,6 +992,7 @@ struct v4l2_output {
> >  #define V4L2_OUTPUT_TYPE_ANALOG			2
> >  #define V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY	3
> >
> > +
> >  /* capabilities flags */
> >  #define V4L2_OUT_CAP_PRESETS		0x00000001 /* Supports
> S_DV_PRESET */
> >  #define V4L2_OUT_CAP_CUSTOM_TIMINGS	0x00000002 /* Supports
> S_DV_TIMINGS */
> > @@ -1009,6 +1030,7 @@ struct v4l2_ext_controls {
> >  #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression
> controls */
> >  #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class
> controls */
> >  #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control
> class */
> > +#define V4L2_CTRL_CLASS_CODEC 0x009c0000	/* Codec control class
> */
> >
> >  #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
> >  #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
> > @@ -1342,6 +1364,29 @@ enum
> v4l2_mpeg_cx2341x_video_median_filter_type {
> >  #define V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP
> 	(V4L2_CID_MPEG_CX2341X_BASE+10)
> >  #define V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS
> 	(V4L2_CID_MPEG_CX2341X_BASE+11)
> >
> > +/* For codecs */
> > +
> > +#define V4L2_CID_CODEC_BASE
(V4L2_CTRL_CLASS_CODEC
> | 0x900)
> > +#define V4L2_CID_CODEC_CLASS
(V4L2_CTRL_CLASS_CODEC
> | 1)
> > +
> > +/* For both decoding and encoding */
> > +
> > +/* For encoding */
> > +#define V4L2_CID_CODEC_LOOP_FILTER_H264
> 	(V4L2_CID_CODEC_BASE + 0)
> > +enum v4l2_cid_codec_loop_filter_h264 {
> > +	V4L2_CID_CODEC_LOOP_FILTER_H264_ENABLE = 0,
> > +	V4L2_CID_CODEC_LOOP_FILTER_H264_DISABLE = 1,
> > +	V4L2_CID_CODEC_LOOP_FILTER_H264_DISABLE_AT_BOUNDARY = 2,
> > +};
> > +
> > +/* For decoding */
> > +
> > +#define V4L2_CID_CODEC_LOOP_FILTER_MPEG4_ENABLE
> 	(V4L2_CID_CODEC_BASE + 1)
> > +#define V4L2_CID_CODEC_DISPLAY_DELAY		(V4L2_CID_CODEC_BASE
+
> 2)
> > +#define V4L2_CID_CODEC_REQ_NUM_BUFS		(V4L2_CID_CODEC_BASE
+
> 3)
> > +#define V4L2_CID_CODEC_SLICE_INTERFACE		(V4L2_CID_CODEC_BASE
+
> 4)
> > +#define V4L2_CID_CODEC_PACKED_PB		(V4L2_CID_CODEC_BASE + 5)
> > +
> 
> This needs to be documented in the spec as well.

Ok.
 
> It seems to me just looking at the names that these controls are highly
> hardware specific. If so, then these controls would have to be in the
> range
> of (V4L2_CTRL_CLASS_CODEC | 0x1000) and up and need the name of the
> chipset
> as part of their ID. Similar to the cx2341x specific controls (see
> V4L2_CID_MPEG_CX2341X_BASE in videodev2.h).

I think that DISPLAY_DELAY would be used by more than one codec. It may
be difficult to judge what is common until more chip vendors decide to
include drivers for their hardware codecs in the video4linux.

> Creating a CODEC control class seems sensible to me, so I'm fine with
> that.

That's good news.

> 
> >  /*  Camera class control IDs */
> >  #define V4L2_CID_CAMERA_CLASS_BASE 	(V4L2_CTRL_CLASS_CAMERA |
> 0x900)
> >  #define V4L2_CID_CAMERA_CLASS 		(V4L2_CTRL_CLASS_CAMERA | 1)
> >
> 

Thank you for your comments.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

