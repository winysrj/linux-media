Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:64759 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab1FOIGB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 04:06:01 -0400
Received: from epcpsbgm1.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LMT00H9JNTQ28S0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Jun 2011 17:05:50 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LMT00KIUNTK77@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Jun 2011 17:05:49 +0900 (KST)
Date: Wed, 15 Jun 2011 10:05:42 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH 1/4 v9] v4l: add fourcc definitions for compressed formats.
In-reply-to: <201106150839.59635.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	laurent.pinchart@ideasonboard.com, jtp.park@samsung.com
Message-id: <005501cc2b33$099b4940$1cd1dbc0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-language: en-gb
Content-transfer-encoding: 7BIT
References: <1308069416-24723-1-git-send-email-k.debski@samsung.com>
 <1308069416-24723-2-git-send-email-k.debski@samsung.com>
 <201106150839.59635.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,


> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: 15 June 2011 08:40
> To: Kamil Debski
> Cc: linux-media@vger.kernel.org; m.szyprowski@samsung.com;
> kyungmin.park@samsung.com; jaeryul.oh@samsung.com;
> laurent.pinchart@ideasonboard.com; jtp.park@samsung.com
> Subject: Re: [PATCH 1/4 v9] v4l: add fourcc definitions for compressed
> formats.
> 
> On Tuesday, June 14, 2011 18:36:53 Kamil Debski wrote:
> > Add fourcc definitions and documentation for the following
> > compressed formats: H264, H264 without start codes,
> > MPEG1/2/4 ES, DIVX versions 3.11, 4, 5.0-5.0.2, 5.03 and up,
> > XVID, VC1 Annex G and Annex L compliant.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  Documentation/DocBook/media/v4l/controls.xml |    7 ++-
> >  Documentation/DocBook/media/v4l/pixfmt.xml   |   67
> +++++++++++++++++++++++++-
> >  include/linux/videodev2.h                    |   21 +++++++--
> >  3 files changed, 88 insertions(+), 7 deletions(-)
> >
> > diff --git a/Documentation/DocBook/media/v4l/controls.xml
> b/Documentation/DocBook/media/v4l/controls.xml

[snip]

> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 8a4c309..65bcb61 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -376,7 +376,20 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_MJPEG    v4l2_fourcc('M', 'J', 'P', 'G') /* Motion-
> JPEG   */
> >  #define V4L2_PIX_FMT_JPEG     v4l2_fourcc('J', 'P', 'E', 'G') /* JFIF
> JPEG     */
> >  #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /* 1394
> */
> > -#define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-
> 1/2/4    */
> > +#define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-
> 1/2/4 Multiplexed */
> > +#define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264
> with start codes */
> > +#define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264
> without start codes */
> > +#define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263
> */
> > +#define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1
> ES     */
> > +#define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2
> ES     */
> > +#define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4
> ES     */
> > +#define V4L2_PIX_FMT_DIVX3    v4l2_fourcc('D', 'I', 'V', '3') /* DivX
> 3.11     */
> > +#define V4L2_PIX_FMT_DIVX4    v4l2_fourcc('D', 'I', 'V', '4') /* DivX
> 4.12     */
> > +#define V4L2_PIX_FMT_DIVX500  v4l2_fourcc('D', 'X', '5', '0') /* DivX
> 5.00 - 5.02  */
> > +#define V4L2_PIX_FMT_DIVX5    v4l2_fourcc('D', 'I', 'V', '5') /* DivX
> 5.03 - x  */
> 
> Wasn't DIVX removed due to licensing issues?

The idea is to have a separate patch that will add DIVX support to the driver.
I thought that I could leave the pixel format definitions here - if any other
driver cares to use them.

There is no problem to remove it from videodev2.h also and have the DIVX patch
add it. Do you think we should do it this way?
 
> > +#define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid
> */
> > +#define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE
> 421M Annex G compliant stream */
> > +#define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE
> 421M Annex L compliant stream */
> 
> Just to verify: are all these formats actually used in the driver?

All but the DIVX and V4L2_PIX_FMT_H264_NO_SC pixel format.
V4L2_PIX_FMT_H264_NO_SC pixel format was requested by Laurent.

> >
> >  /*  Vendor-specific formats   */
> >  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1
> YUV */
> > @@ -1151,7 +1164,7 @@ enum v4l2_colorfx {
> >  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG |
> 0x900)
> >  #define V4L2_CID_MPEG_CLASS 			(V4L2_CTRL_CLASS_MPEG |
1)
> >
> > -/*  MPEG streams */
> > +/*  MPEG streams, specific to multiplexed streams */
> >  #define V4L2_CID_MPEG_STREAM_TYPE 		(V4L2_CID_MPEG_BASE+0)
> >  enum v4l2_mpeg_stream_type {
> >  	V4L2_MPEG_STREAM_TYPE_MPEG2_PS   = 0, /* MPEG-2 program stream */
> > @@ -1173,7 +1186,7 @@ enum v4l2_mpeg_stream_vbi_fmt {
> >  	V4L2_MPEG_STREAM_VBI_FMT_IVTV = 1,  /* VBI in private packets, IVTV
> format */
> >  };
> >
> > -/*  MPEG audio */
> > +/*  MPEG audio controls specific to multiplexed streams  */
> >  #define V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ 	(V4L2_CID_MPEG_BASE+100)
> >  enum v4l2_mpeg_audio_sampling_freq {
> >  	V4L2_MPEG_AUDIO_SAMPLING_FREQ_44100 = 0,
> > @@ -1289,7 +1302,7 @@ enum v4l2_mpeg_audio_ac3_bitrate {
> >  	V4L2_MPEG_AUDIO_AC3_BITRATE_640K = 18,
> >  };
> >
> > -/*  MPEG video */
> > +/*  MPEG video controls specific to multiplexed streams */
> 
> The 'multiplexed' part of this comment is only true for VIDEO_ENCODING. The
> other controls are valid for elementary streams as well.

Ok, I will remove this comment.

> 
> >  #define V4L2_CID_MPEG_VIDEO_ENCODING 		(V4L2_CID_MPEG_BASE+200)
> >  enum v4l2_mpeg_video_encoding {
> >  	V4L2_MPEG_VIDEO_ENCODING_MPEG_1     = 0,
> >
> 
> Regards,
> 
> 	Hans

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


