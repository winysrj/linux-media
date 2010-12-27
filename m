Return-path: <mchehab@gaivota>
Received: from mailout4.samsung.com ([203.254.224.34]:27632 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0L0Q2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 11:28:08 -0500
Date: Mon, 27 Dec 2010 17:27:59 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH 1/9] media: Changes in include/linux/videodev2.h for MFC 5.1
In-reply-to: <201012221342.03713.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Jeongtae Park' <jtp.park@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	jaeryul.oh@samsung.com, kgene.kim@samsung.com, ben-linux@fluff.org,
	jonghun.han@samsung.com
Message-id: <003701cba5e3$097f7ba0$1c7e72e0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-gb
Content-transfer-encoding: 7BIT
References: <1293018885-15239-1-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-2-git-send-email-jtp.park@samsung.com>
 <201012221342.03713.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: 22 December 2010 13:42
> To: Jeongtae Park
> Cc: linux-media@vger.kernel.org; linux-samsung-soc@vger.kernel.org;
> k.debski@samsung.com; jaeryul.oh@samsung.com; kgene.kim@samsung.com;
> ben-linux@fluff.org; jonghun.han@samsung.com
> Subject: Re: [PATCH 1/9] media: Changes in include/linux/videodev2.h
> for MFC 5.1

<snip>
 
> >  #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /*
> 1394          */
> >  #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /*
> MPEG-1/2/4    */
> >
> > +
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
> > +#define V4L2_PIX_FMT_DIVX500    v4l2_fourcc('D', 'X', '5', '2') /*
> DivX 5.00 - 5.02  */
> > +#define V4L2_PIX_FMT_DIVX503    v4l2_fourcc('D', 'X', '5', '3') /*
> DivX 5.03 - x  */
> > +#define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /*
> Xvid */
> > +#define V4L2_PIX_FMT_VC1      v4l2_fourcc('V', 'C', '1', 'A') /* VC-
> 1 */
> > +#define V4L2_PIX_FMT_VC1_RCV      v4l2_fourcc('V', 'C', '1', 'R') /*
> VC-1 RCV */
> 
> What do these formats describe? Are these container formats or the
> actual
> compressed video stream that is normally packaged inside a container?

Apart from VC-1 RCV those are elementary streams. If I understand correctly 
RCV is a simple semi-container that contains necessary information to play
the ES. I have asked a person from HW team if all those fourccs are
necessary.
I am waiting for reply.

The idea was to have a fourcc for each supported codec (by this I mean the
elementary stream).

> 
> > +
> > +
> >  /*  Vendor-specific formats   */
> >  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /*
> cpia1 YUV */
> >  #define V4L2_PIX_FMT_WNVA     v4l2_fourcc('W', 'N', 'V', 'A') /*
> Winnov hw compress */
> > @@ -1009,6 +1034,7 @@ struct v4l2_ext_controls {
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
> > @@ -1342,6 +1368,150 @@ enum
> v4l2_mpeg_cx2341x_video_median_filter_type {
> >  #define V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP
> 	(V4L2_CID_MPEG_CX2341X_BASE+10)
> >  #define V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS
> 	(V4L2_CID_MPEG_CX2341X_BASE+11)
> >
> > +/* For codecs */
> > +#define V4L2_CID_CODEC_BASE
(V4L2_CTRL_CLASS_CODEC
> | 0x900)
> > +#define V4L2_CID_CODEC_CLASS
(V4L2_CTRL_CLASS_CODEC
> | 1)
> > +
> > +/* For decoding */
> > +#define V4L2_CID_CODEC_LOOP_FILTER_MPEG4_ENABLE
> 	(V4L2_CID_CODEC_BASE + 110)
> > +#define V4L2_CID_CODEC_DISPLAY_DELAY		(V4L2_CID_CODEC_BASE
+
> 137)
> > +#define V4L2_CID_CODEC_REQ_NUM_BUFS		(V4L2_CID_CODEC_BASE
+
> 140)
> > +#define V4L2_CID_CODEC_SLICE_INTERFACE		(V4L2_CID_CODEC_BASE
+
> 141)
> > +#define V4L2_CID_CODEC_PACKED_PB		(V4L2_CID_CODEC_BASE + 142)
> 
> ??? Weird CODEC_BASE offsets?
> 
> Are all these codec controls above general? I.e., applicable to any
> codec? What
> do they mean?

My mistake - I forgot to tidy up the offsets. It is difficult for me to
say which of those controls are MFC specific as I have little experience
with other codecs. 

Currently PACKED_PB has been replaced with a simple mechanism that can
detect
if the stream has packed PB frames. You can read more about such streams
here:
http://itsjustonesandzeros.blogspot.com/2007/01/what-is-packed-bitstream.htm
l
First approach required the application to set if the stream contained
packed-PB
Frames. Now the driver detects it the stream contains packed-PB frames.
Another
approach would require the stream parser to detect those frames and divide
them
into two buffers queued to MFC.

DISPLAY_DELAY is a number of frames that should be decoded before the first
frame is
returned to the application. It is valid for H264 streams.

REQ_NUM_BUFS is the minimum number of CAPTURE buffers required for MFC
decoder to work.
This is a read-only control, by reading this value the application can
adjust count when
doing REQBUFS. If the application needs 3 dequeued CAPTURE buffers for
processing it
should set count when doing REQBUFS to the value of REQ_NUM_BUFS + 3.

When SLICE_INTERFACE the codec expects compressed slices in OUTPUT buffers
instead of
full frames.

LOOP_FILTER_MPEG4_ENABLE controls deblocking filter for MPEG4 codec. You are
right that
name this should be more general and name is not intuitive.
DECODING_DEBLOCK_FILTER
would be way better, as more codec can have this option.

I think that DECODING_DEBLOCK_FILTER (LOOP_FILTER_MPEG4_ENABLE),
SLICE_INTERFACE and 
DISPLAY_DELAY should be general. Here I would really welcome comment from
other
developers working on codec v4l2 drivers.

> 
> > +
> > +/* For encoding */
> > +#define V4L2_CID_CODEC_LOOP_FILTER_H264
> 	(V4L2_CID_CODEC_BASE + 9)
> > +enum v4l2_cid_codec_loop_filter_h264 {
> > +	V4L2_CID_CODEC_LOOP_FILTER_H264_ENABLE = 0,
> > +	V4L2_CID_CODEC_LOOP_FILTER_H264_DISABLE = 1,
> > +	V4L2_CID_CODEC_LOOP_FILTER_H264_DISABLE_AT_BOUNDARY = 2,
> > +};
> > +
> > +/* Codec class control IDs specific to the MFC51 driver */
> > +#define V4L2_CID_CODEC_MFC51_BASE		(V4L2_CTRL_CLASS_CODEC
> | 0x1000)
> 
> It's probably a good idea to only add this BASE define to videodev2.h
> (please include a comment describing the control range reserved for the
> MFC51).
> All others should go to a public mfc51 header. Which should include
> documentation
> for these controls as well.

Great idea.

> 
> > +
> > +/* common */
> > +enum v4l2_codec_mfc5x_enc_switch {
> > +	V4L2_CODEC_MFC51_ENC_SW_DISABLE	= 0,
> > +	V4L2_CODEC_MFC51_ENC_SW_ENABLE	= 1,
> > +};
> > +enum v4l2_codec_mfc5x_enc_switch_inv {
> > +	V4L2_CODEC_MFC51_ENC_SW_INV_ENABLE	= 0,
> > +	V4L2_CODEC_MFC51_ENC_SW_INV_DISABLE	= 1,
> > +};
> > +#define V4L2_CID_CODEC_MFC51_ENC_GOP_SIZE
> 	(V4L2_CID_CODEC_MFC51_BASE+300)
> 
> Why the +300?

This is question should be answered by Jeongtae Park, as he did the encoding
part. Unfortunately our patches got mixed up.

I can only guess that this offset was added to distinguish between decoding
and encoding.

<snip>

-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

