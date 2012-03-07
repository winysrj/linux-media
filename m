Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40513 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2CGKKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 05:10:48 -0500
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M0I00CLPEXRK3S0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Mar 2012 19:10:47 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M0I00GQCEXT2W70@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Wed, 07 Mar 2012 19:10:47 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>, jtp.park@samsung.com
Cc: linux-media@vger.kernel.org, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, Marek Szyprowski <m.szyprowski@samsung.com>
References: <007101ccf81a$a507c610$ef175230$%park@samsung.com>
 <201203020913.14834.hverkuil@xs4all.nl>
In-reply-to: <201203020913.14834.hverkuil@xs4all.nl>
Subject: RE: [PATCH 1/3] v4l: add contorl definitions for codec devices.
Date: Wed, 07 Mar 2012 11:10:40 +0100
Message-id: <002901ccfc4a$9041c2b0$b0c54810$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, hi Jeongtae,

> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: 02 March 2012 09:13
> 
> Hi Jeongtae!
> 
> Some review notes below...
> 
> On Friday, March 02, 2012 03:17:40 Jeongtae Park wrote:
> > Add control definitions for controls specific to codec devices.
> >
> > Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Cc: Kamil Debski <k.debski@samsung.com>
> > ---
> >  include/linux/videodev2.h |   51
> ++++++++++++++++++++++++++++++++++++++++++--
> >  1 files changed, 48 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index b739d7d..a19512a 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -359,7 +359,9 @@ struct v4l2_pix_format {
> >
> >  /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
> >  #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12
> Y/CbCr 4:2:0  */
> > +#define V4L2_PIX_FMT_NV21M   v4l2_fourcc('N', 'M', '2', '1') /* 21
> Y/CrCb 4:2:0  */
> >  #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12
> Y/CbCr 4:2:0 64x32 macroblocks */
> > +#define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V', 'M', '1', '2') /* 12
> Y/CbCr 4:2:0 16x16 macroblocks */
> >
> >  /* three non contiguous planes - Y, Cb, Cr */
> >  #define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12
> YUV420 planar */
> > @@ -392,6 +394,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-
> 1/2/4 Multiplexed */
> >  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264
> with start codes */
> >  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264
> without start codes */
> > +#define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 MVC
> */
> >  #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263
> */
> >  #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1
> ES     */
> >  #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2
> ES     */
> > @@ -399,6 +402,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid
> */
> >  #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE
> 421M Annex G compliant stream */
> >  #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE
> 421M Annex L compliant stream */
> > +#define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
> 
> Note that these new formats need to be documented in the spec as well.
> 
> >
> >  /*  Vendor-specific formats   */
> >  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1
> YUV */
> > @@ -1458,17 +1462,18 @@ enum v4l2_mpeg_video_header_mode {
> >  };
> >  #define V4L2_CID_MPEG_VIDEO_MAX_REF_PIC
> 	(V4L2_CID_MPEG_BASE+217)
> >  #define V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE
> 	(V4L2_CID_MPEG_BASE+218)
> > -#define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES
> 	(V4L2_CID_MPEG_BASE+219)
> > +#define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BITS
> 	(V4L2_CID_MPEG_BASE+219)
> 
> Why change from bytes to bits? That changes the meaning of this control.

We had a discussion about this on irc with Hans. Let me paste a snippet:

Jun 08 09:58:36 <kdebski>	hverkuil: in the first email you have wrote that you would like to add some more comments on the codec controls after you get yourself familiar with the standard. any progress on that?
Jun 08 10:06:17 <hverkuil>	kdebski: yes, I want to go through the docbook patch again and check each item against the standard docs I have.
Jun 08 10:06:48 <hverkuil>	I'll just make notes here as I go along and you can comment on it.
Jun 08 10:08:02 <hverkuil>	I want to finish my review today if possible.
Jun 08 10:10:12 <hverkuil>	kdebski: VIDEO_MAX_REF_PIC: is this H264 specific or is it also valid for MPEG4?
Jun 08 10:18:36 <hverkuil>	kdebski: VIDEO_MULTI_SLICE_MODE: MAX_BITS: is this specific to your encoder, or is this part of the standard? And why is it in bits instead of bytes?
Jun 08 10:22:01 <kdebski>	I have had a look at the most recent documentation for MFC and MAX_REF_PIC disappeared, previously I have categorised it as H264 only
Jun 08 10:24:15 <kdebski>	in ffmpeg documentation it seems as a control that can be used in other codecs as well
Jun 08 10:25:37 <kdebski>	VIDEO_MULTI_SLICE_MODE: MAX_BITS it can be set in x264 with --slice-max-size (it is in bytes there)
Jun 08 10:26:10 <hverkuil>	Ah, so that slice mode is for x264, not h264?
Jun 08 10:26:33 <kdebski>	hverkuil: for MFC it is bits
Jun 08 10:26:56 <kdebski>	x264 is an open source h264 encoder
Jun 08 10:28:20 <hverkuil>	so with MAX_BITS you can get variable number of MBs per slice, right?
Jun 08 10:28:56 <kdebski>	yes
Jun 08 10:29:00 <hverkuil>	I think I'd call it MAX_BYTES.

Although I wasn't too convinced whether it should be BITS or BYTES we have made a choice. It is in the mainline kernel. It is part of the API - changing it now could and probably will brake existing applications.
The idea was to model the controls on the arguments/parameters used by existing open source codecs, such as x264.
 
[snip]

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

