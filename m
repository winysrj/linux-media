Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:53776 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1FCHeb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 03:34:31 -0400
Received: from epcpsbgm2.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LM700MKOECWAR10@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 03 Jun 2011 16:34:29 +0900 (KST)
Received: from jtppark (unknown [12.23.121.105])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LM7003TGEDGGKA0@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Fri, 03 Jun 2011 16:34:29 +0900 (KST)
Reply-to: jtp.park@samsung.com
From: Jeongtae Park <jtp.park@samsung.com>
To: 'Kamil Debski' <k.debski@samsung.com>, linux-media@vger.kernel.org
Cc: jaeryul.oh@samsung.com, june.bae@samsung.com,
	janghyuck.kim@samsung.com, kyungmin.park@samsung.com,
	younglak1004.kim@samsung.com,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
References: <1306832883-12352-1-git-send-email-k.debski@samsung.com>
 <001e01cc20f8$e4a441d0$adecc570$%park@samsung.com>
 <003c01cc2133$7e061bc0$7a125340$%debski@samsung.com>
In-reply-to: <003c01cc2133$7e061bc0$7a125340$%debski@samsung.com>
Subject: RE: [RFC/PATCH v2] v4l: add control definitions for codec devices.
Date: Fri, 03 Jun 2011 16:34:28 +0900
Message-id: <003801cc21c0$ac0aad00$04200700$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
Content-language: ko
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

> -----Original Message-----
> From: Kamil Debski [mailto:k.debski@samsung.com]
> Sent: Thursday, June 02, 2011 11:44 PM
> To: jtp.park@samsung.com; linux-media@vger.kernel.org
> Cc: jaeryul.oh@samsung.com; june.bae@samsung.com; janghyuck.kim@samsung.com; kyungmin.park@samsung.com;
> younglak1004.kim@samsung.com; 'Marek Szyprowski'
> Subject: RE: [RFC/PATCH v2] v4l: add control definitions for codec devices.
> 
> > From: Jeongtae Park [mailto:jtp.park@samsung.com]
> > Sent: 02 June 2011 09:44
> > To: 'Kamil Debski'; linux-media@vger.kernel.org
> > Cc: jaeryul.oh@samsung.com; june.bae@samsung.com; janghyuck.kim@samsung.com;
> > kyungmin.park@samsung.com; younglak1004.kim@samsung.com; 'Marek Szyprowski'
> > Subject: RE: [RFC/PATCH v2] v4l: add control definitions for codec devices.
> >
> > Hi,
> >
> > Thank you for your nice work. Here are my some comments.
> 
> Hi,
> 
> Thanks for your comments. I think I must have posted the wrong patch file...
> I will send the proper one, with some of your suggestion in a minute.
> 
> >
> > > -----Original Message-----
> > > From: Kamil Debski [mailto:k.debski@samsung.com]
> > > Sent: Tuesday, May 31, 2011 6:08 PM
> > > Cc: m.szyprowski@samsung.com; kyungmin.park@samsung.com;
> > k.debski@samsung.com; jaeryul.oh@samsung.com;
> > > hverkuil@xs4all.nl; laurent.pinchart@ideasonboard.com;
> > jtp.park@samsung.com
> > > Subject: [RFC/PATCH v2] v4l: add control definitions for codec devices.
> > >
> > > Hi,
> > >
> > > This is a second version of the patch that adds controls for the codec
> > family of
> > > devices. I have implemented the suggestions I got from Hans Verkuil on the
> > #v4l
> > > channel.
> > >
> > > Change log:
> > > - rename V4L2_CID_MIN_REQ_BUFS_(CAP/OUT) to
> > V4L2_CID_MIN_BUFFERS_FOR_(CAPTURE/OUTPUT)
> > > - use existing controls for GOP size, number of frames and GOP closure
> > > - remove frame rate controls (in favour of the S_PARM call)
> > > - split level into separate controls for MPEG4 and H264
> > >
> > > I would welcome further comments.
> > >
> > > Best regards,
> > > Kamil Debski
> > >
> > > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > >  Documentation/DocBook/v4l/controls.xml |  733
> > ++++++++++++++++++++++++++++++++
> > >  include/linux/videodev2.h              |  147 +++++++
> > >  2 files changed, 880 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/Documentation/DocBook/v4l/controls.xml
> > b/Documentation/DocBook/v4l/controls.xml
> > > index 6880798..7c2df42 100644
> > > --- a/Documentation/DocBook/v4l/controls.xml
> > > +++ b/Documentation/DocBook/v4l/controls.xml
> > > @@ -325,6 +325,22 @@ minimum value disables backlight
> > compensation.</entry>
> > >  <constant>V4L2_CID_ILLUMINATORS_2</constant> + 1).</entry>
> > >  	  </row>
> > >  	  <row>
> > > +
> 
> [snip]
> 
> > > +
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MAX_REF_PIC</constant>&nbsp;</en
> > try>
> > > +		<entry>boolean</entry>
> > > +	      </row>
> > > +	      <row><entry spanname="descr">The maximum number of reference
> > pictures used for encoding.</entry>
> > > +	      </row>
> >
> > Is it boolean type?
> 
> It is not, a copy-paste mistake on my side.
> 
> [snip]
> 
> > > +
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA</constant>
> > &nbsp;</entry>
> > > +		<entry>integer</entry>
> > > +	      </row>
> > > +	      <row><entry spanname="descr">Loop filter alpha coefficient,
> > defined in the standard.</entry>
> > > +	      </row>
> >
> > alpha -> beta.
> 
> I agree.
> 
> [snip]
> 
> > > +
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE</constant>&nbsp;
> > </entry>
> > > +		<entry>boolean</entry>
> > > +	      </row>
> > > +	      <row><entry spanname="descr">Padding enable - use a color
> > instead of repeating border pixels.</entry>
> > > +	      </row>
> >
> > The description may be wrong.
> 
> Thanks for pointing this out.
> 
> > > +
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_MB_RC_ENABLE</constant>&nbs
> > p;</entry>
> > > +		<entry>boolean</entry>
> > > +	      </row>
> > > +	      <row><entry spanname="descr">Macroblock level rate control
> > enable for H264.</entry>
> > > +	      </row>
> > > +
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_FRAME_RATE_NOMINATOR</constant>&
> > nbsp;</entry>
> > > +		<entry>integer</entry>
> > > +	      </row>
> > > +	      <row><entry spanname="descr">Frames per second -
> > nominator.</entry>
> > > +	      </row>
> >
> > Removed as you mentioned.
> 
> Yes, I think I had to mix up the patches that got sent.
> 
> > > +
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_FRAME_RATE_DENOMINATOR</constant
> > >&nbsp;</entry>
> > > +		<entry>integer</entry>
> > > +	      </row>
> > > +	      <row><entry spanname="descr">Frames per second -
> > denominator</entry>
> > > +	      </row>
> > > +
> >
> > Removed as you mentioned.
> 
> Ditto.
> 
> [snip]
> 
> > > +
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VBV_BUF_SIZE</constant>&nbsp;</e
> > ntry>
> > > +		<entry>integer</entry>
> > > +	      </row>
> > > +	      <row><entry spanname="descr">Quantization parameter for an P
> > frame.</entry>
> > > +	      </row>
> >
> > The description may be wrong, How about this?
> > 'The VBV buffer size in kilo bytes, it used as a limitation of frame skip'
> 
> I agree.
> 
> > > +
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_OPEN_GOP</constant>&nbsp;</
> > entry>
> > > +		<entry>boolean</entry>
> > > +	      </row>
> > > +	      <row><entry spanname="descr">Enable open GOP in H264.</entry>
> > > +	      </row>
> >
> > I cannot find V4L2_CID_MPEG_VIDEO_H264_OPEN_GOP definition at videodev2.h,
> > we will use V4L2_CID_MPEG_VIDEO_GOP_CLOSURE instead, right?
> 
> Yes, we've switched to GOP_CLOSURE.
> 
> > > +
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE</constant>&nbsp;
> > </entry>
> > > +		<entry>boolean</entry>
> > > +	      </row>
> > > +	      <row><entry spanname="descr">Frame level rate control
> > enable.</entry>
> > > +	      </row>
> >
> > I saw the same CID above, previous definition have to remove.
> 
> Agree.
> 
> > > +
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_MB_RC_ENABLE</constant>&nbs
> > p;</entry>
> > > +		<entry>boolean</entry>
> > > +	      </row>
> > > +	      <row><entry spanname="descr">Macroblock level rate control
> > enable.</entry>
> > > +	      </row>
> > > +
> > > +	    </tbody>
> > > +	  </tgroup>
> > > +	</table>
> > > +      </section>
> > > +
> > > +      <section>
> > > +	<title>MFC 5.1 MPEG Controls</title>
> > > +
> > > +	<para>The following MPEG class controls deal with MPEG
> > > +decoding and encoding settings that are specific to the MFC 5.1 device
> > present
> > > +in the S5P family of SoCs by Samsung.
> > > +</para>
> > > +
> > > +	<table pgwide="1" frame="none" id="mfc51-control-id">
> > > +	  <title>MFC 5.1 Control IDs</title>
> > > +	  <tgroup cols="4">
> > > +	    <colspec colname="c1" colwidth="1*" />
> > > +	    <colspec colname="c2" colwidth="6*" />
> > > +	    <colspec colname="c3" colwidth="2*" />
> > > +	    <colspec colname="c4" colwidth="6*" />
> > > +	    <spanspec namest="c1" nameend="c2" spanname="id" />
> > > +	    <spanspec namest="c2" nameend="c4" spanname="descr" />
> > > +	    <thead>
> > > +	      <row>
> > > +		<entry spanname="id" align="left">ID</entry>
> > > +		<entry align="left">Type</entry>
> > > +	      </row><row><entry spanname="descr"
> > align="left">Description</entry>
> > > +	      </row>
> > > +	    </thead>
> > > +	    <tbody valign="top">
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > >
> > spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_DECODER_MPEG4_DEBLOCK_FILT
> > ER</constant>&nbsp;</entry>
> > > +		<entry>boolean</entry>
> > > +	      </row><row><entry spanname="descr">Enabled the deblocking post
> > processing filter for MPEG4
> > > decoder.</entry>
> > > +	      </row>
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > >
> > spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY
> > _ENABLE</constant>&nbsp;</entry>
> > > +		<entry>integer</entry>
> > > +	      </row><row><entry spanname="descr">If the display delay is
> > enabled then the decoder has to return an
> > > +CAPTURE buffer after processing a certain number of OUTPUT buffers. If
> > this number is low, then it may result in
> > > +buffers not being dequeued in display order. In addition hardware may
> > still use those buffers as reference, thus
> > > +application should not write to those buffers. This feature can be used
> > for example for generating thumbnails of
> > > videos.
> > > +	      </entry>
> > > +	      </row>
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > >
> > spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY
> > </constant>&nbsp;</entry>
> > > +		<entry>integer</entry>
> > > +	      </row><row><entry spanname="descr">Display delay value for H264
> > decoder.</entry>
> > > +	      </row>
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_NUM_REF_PIC_FOR_P</constan
> > t>&nbsp;</entry>
> > > +		<entry>integer</entry>
> > > +	      </row><row><entry spanname="descr">The number of reference
> > pictures used for encoding a P
> > > picture.</entry>
> > > +	      </row>
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V;4L2_CID_MPEG_MFC51_VIDEO_PADDING</constant>&nbsp;<
> > /entry>
> >
> > There is a miss typing(;).
> 
> Thanks.
> 
> [snip]
> 
> > <entry><constant>V4L2_MPEG_MFC51_FRAME_SKIP_MODE_VBV_LIMIT</constant>&nbsp;<
> > /entry>
> > > +		      <entry>Frame skip mode enabled and buffer limit is set by
> > the VBV buffer size control.</entry>
> > > +		    </row>
> > > +		  </tbody>
> > > +		</entrytbl>
> > > +	      </row>
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_RC_FIXED_TARGET_BIT</const
> > ant>&nbsp;</entry>
> > > +		<entry>integer</entry>
> > > +	      </row><row><entry spanname="descr"></entry>
> >
> > How about below description?
> > ' Enable rate-control with fixed target bit. If enabled encoder targets
> > bitrate in GOP, else try to meet average bitrate.'
> 
> Thanks.
> 
> [snip]
> 
> > > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > > index 6168da0..5ec2aba 100644
> > > --- a/include/linux/videodev2.h
> > > +++ b/include/linux/videodev2.h
> > > @@ -1157,6 +1157,10 @@ enum v4l2_colorfx {
> > >  /* last CID + 1 */
> > >  #define V4L2_CID_LASTP1                         (V4L2_CID_BASE+39)
> > >
> > > +/* Minimum number of buffer neede by the device */
> > > +#define V4L2_CID_MIN_BUFFERS_FOR_CAPTURE	(V4L2_CID_BASE+40)
> > > +#define V4L2_CID_MIN_BUFFERS_FOR_OUTPUT		(V4L2_CID_BASE+41)
> > > +
> > >  /*  MPEG-class control IDs defined by V4L2 */
> > >  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG |
> > 0x900)
> > >  #define V4L2_CID_MPEG_CLASS 			(V4L2_CTRL_CLASS_MPEG |
> 1)
> > > @@ -1328,6 +1332,118 @@ enum v4l2_mpeg_video_bitrate_mode {
> > >  #define V4L2_CID_MPEG_VIDEO_MUTE 		(V4L2_CID_MPEG_BASE+210)
> > >  #define V4L2_CID_MPEG_VIDEO_MUTE_YUV 		(V4L2_CID_MPEG_BASE+211)
> > >
> > > +#define V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE
> > 	(V4L2_CID_MPEG_BASE+212)
> > > +#define V4L2_CID_MPEG_VIDEO_H264_VUI_AR_ENABLE
> > 	(V4L2_CID_MPEG_BASE+213)
> > > +#define V4L2_CID_MPEG_VIDEO_H264_VUI_AR_IDC
> > 	(V4L2_CID_MPEG_BASE+214)
> > > +#define V4L2_CID_MPEG_VIDEO_H264_EXT_SAR_WIDTH
> > 	(V4L2_CID_MPEG_BASE+215)
> > > +#define V4L2_CID_MPEG_VIDEO_H264_EXT_SAR_HEIGHT
> > 	(V4L2_CID_MPEG_BASE+216)
> > > +#define V4L2_CID_MPEG_VIDEO_H264_LEVEL
> > 	(V4L2_CID_MPEG_BASE+217)
> > > +enum v4l2_mpeg_video_h264_level {
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_1_0	= 0,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_1B	= 1,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_1_1	= 2,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_1_2	= 3,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_1_3	= 4,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_2_0	= 5,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_2_1	= 6,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_2_2	= 7,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_3_0	= 8,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_3_1	= 9,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_3_2	= 10,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_4_0	= 11,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_4_1	= 12,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_4_2	= 13,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_5_0	= 14,
> > > +	V4L2_MPEG_VIDEO_H264_LEVEL_5_1	= 15,
> > > +};
> > > +#define V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL
> > 	(V4L2_CID_MPEG_BASE+218)
> > > +enum v4l2_mpeg_video_mpeg4_level {
> > > +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_0	= 0,
> > > +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_0B	= 1,
> > > +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_1	= 2,
> > > +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_2	= 3,
> > > +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_3	= 4,
> > > +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_3B	= 5,
> > > +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_4	= 6,
> > > +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_5	= 7,
> > > +};
> > > +#define V4L2_CID_MPEG_VIDEO_H264_PROFILE	(V4L2_CID_MPEG_BASE+219)
> > > +enum v4l2_mpeg_video_h264_profile {
> > > +	V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE			= 0,
> > > +	V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE	= 1,
> > > +	V4L2_MPEG_VIDEO_H264_PROFILE_MAIN			= 2,
> > > +	V4L2_MPEG_VIDEO_H264_PROFILE_EXTENDED			= 3,
> > > +	V4L2_MPEG_VIDEO_H264_PROFILE_HIGH			= 4,
> > > +	V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_10			= 5,
> > > +	V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_422			= 6,
> > > +	V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_444_PREDICTIVE	= 7,
> > > +	V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_10_INTRA		= 8,
> > > +	V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_422_INTRA		= 9,
> > > +	V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_444_INTRA		= 10,
> > > +	V4L2_MPEG_VIDEO_H264_PROFILE_CAVLC_444_INTRA		= 11,
> > > +};
> >
> > How about include SVC, MVC extension profiles?
> 
> Yes, it wasn't present in the standard definition I have used, but I have a
> newer version of that document with the SVC and MVC added.
> 
> [snip]
> 
> > > +#define V4L2_CID_MPEG_VIDEO_INTERLACE		(V4L2_CID_MPEG_BASE+231)
> >
> > MFC encoder supports only H.264 the interlace encoding, and
> > how about use v4l2_field in struct v4l2_pix_format_mplane with VIDIOC_*_FMT
> > ioctl?
> 
> Yes, that is a good idea. I think we have discussed this earlier, but I forgot to
> send it in this patch - I had posted the wrong file...
> 
>  > > +#define V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM
> > 	(V4L2_CID_MPEG_BASE+232)
> > > +#define V4L2_CID_MPEG_VIDEO_INTRA_REFRESH_MB	(V4L2_CID_MPEG_BASE+233)
> > > +#define V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE	(V4L2_CID_MPEG_BASE+234)
> > > +#define V4L2_CID_MPEG_VIDEO_H264_MB_RC_ENABLE
> > 	(V4L2_CID_MPEG_BASE+235)
> > > +#define V4L2_CID_MPEG_VIDEO_RC_BITRATE		(V4L2_CID_MPEG_BASE+236)
> >
> > How about use V4L2_CID_MPEG_VIDEO_BITRATE?
> 
> Good catch, it means the same.
> 
> > > +#define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG_BASE+237)
> > > +#define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP	(V4L2_CID_MPEG_BASE+238)
> > > +#define V4L2_CID_MPEG_VIDEO_H263_MIN_QP
> > 	(V4L2_CID_MPEG_BASE+239)
> > > +#define V4L2_CID_MPEG_VIDEO_H263_MAX_QP
> > 	(V4L2_CID_MPEG_BASE+240)
> > > +#define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP	(V4L2_CID_MPEG_BASE+241)
> > > +#define V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP	(V4L2_CID_MPEG_BASE+242)
> > > +#define V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP	(V4L2_CID_MPEG_BASE+243)
> > > +#define V4L2_CID_MPEG_VIDEO_H264_MIN_QP
> > 	(V4L2_CID_MPEG_BASE+244)
> > > +#define V4L2_CID_MPEG_VIDEO_H264_MAX_QP
> > 	(V4L2_CID_MPEG_BASE+245)
> > > +#define V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP	(V4L2_CID_MPEG_BASE+246)
> > > +#define V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP	(V4L2_CID_MPEG_BASE+247)
> > > +#define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP	(V4L2_CID_MPEG_BASE+248)
> > > +#define V4L2_CID_MPEG_VIDEO_MPEG4_MIN_QP	(V4L2_CID_MPEG_BASE+249)
> > > +#define V4L2_CID_MPEG_VIDEO_MPEG4_MAX_QP	(V4L2_CID_MPEG_BASE+250)
> > > +#define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP	(V4L2_CID_MPEG_BASE+251)
> > > +#define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP	(V4L2_CID_MPEG_BASE+252)
> >
> > There are only V4L2_CID_MPEG_VIDEO_[I,P,B]_FRAME_QP descriptions in
> > controls.xml.
> 
> I have also added this in the next patch.
> 
> >
> > > +#define V4L2_CID_MPEG_VIDEO_VBV_BUF_SIZE	(V4L2_CID_MPEG_BASE+253)
> > > +#define V4L2_CID_MPEG_VIDEO_H264_I_PERIOD	(V4L2_CID_MPEG_BASE+255)
> > > +#define V4L2_CID_MPEG_VIDEO_HEADER_MODE
> > 	(V4L2_CID_MPEG_BASE+256)
> > > +enum v4l2_mpeg_video_header_mode {
> > > +	V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE			= 0,
> > > +	V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME	= 1,
> > > +
> > > +};
> > > +
> > >  /*  MPEG-class control IDs specific to the CX2341x driver as defined by
> > V4L2 */
> > >  #define V4L2_CID_MPEG_CX2341X_BASE
> > 	(V4L2_CTRL_CLASS_MPEG | 0x1000)
> > >  #define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE
> > 	(V4L2_CID_MPEG_CX2341X_BASE+0)
> > > @@ -1369,6 +1485,37 @@ enum v4l2_mpeg_cx2341x_video_median_filter_type {
> > >  #define V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP
> > 	(V4L2_CID_MPEG_CX2341X_BASE+10)
> > >  #define V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS
> > 	(V4L2_CID_MPEG_CX2341X_BASE+11)
> > >
> > > +/*  MPEG-class control IDs specific to the Samsung MFC 5.1 driver as
> > defined by V4L2 */
> > > +#define V4L2_CID_MPEG_MFC51_BASE 			(V4L2_CTRL_CLASS_MPEG
> > | 0x1000)
> > > +
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER
> > 	(V4L2_CID_MPEG_MFC51_BASE+0)
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY
> > 	(V4L2_CID_MPEG_MFC51_BASE+1)
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE
> > 	(V4L2_CID_MPEG_MFC51_BASE+2)
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_NUM_REF_PIC_FOR_P
> > 	(V4L2_CID_MPEG_MFC51_BASE+3)
> >
> > Support in H.264 only.
> 
> Right, this is a MFC 5.1 specific control, so it can have the H264 in the name.
> 
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_PADDING
> > 	(V4L2_CID_MPEG_MFC51_BASE+4)
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_PADDING_YUV
> > 	(V4L2_CID_MPEG_MFC51_BASE+5)
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_RC_REACTION_COEFF
> > 	(V4L2_CID_MPEG_MFC51_BASE+8)
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_DARK
> > 	(V4L2_CID_MPEG_MFC51_BASE+9)
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_SMOOTH
> > 	(V4L2_CID_MPEG_MFC51_BASE+10)
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC
> > 	(V4L2_CID_MPEG_MFC51_BASE+11)
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_ACTIVITY
> > 	(V4L2_CID_MPEG_MFC51_BASE+12)
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE
> > 	(V4L2_CID_MPEG_MFC51_BASE+13)
> > > +enum v4l2_mpeg_mfc51_video_frame_skip_mode {
> > > +	V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_DISABLED		= 0,
> > > +	V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_LEVEL_LIMIT	= 1,
> > > +	V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_VBV_LIMIT		= 2,
> > > +};
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_RC_FIXED_TARGET_BIT
> > 	(V4L2_CID_MPEG_MFC51_BASE+14)
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_MPEG4_VOP_TIME_RES
> > 	(V4L2_CID_MPEG_MFC51_BASE+15)
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_MPEG4_VOP_FRAME_DELTA
> > 	(V4L2_CID_MPEG_MFC51_BASE+16)
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE
> > 	(V4L2_CID_MPEG_MFC51_BASE+17)
> > > +enum v4l2_mpeg_mfc51_video_force_frame_type {
> > > +	V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_DISABLED		= 0,
> > > +	V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_I_FRAME		= 1,
> > > +	V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_NOT_CODED	= 2,
> > > +};
> > > +#define V4L2_CID_MPEG_MFC51_VIDEO_FRAME_TAG
> (V4L2_CID_MPEG_MFC51_BASE+18)
> > > +
> >
> > I remember that you try to add extra frame type(SKIPPED or NOT_CODED) to
> > V4L2_BUF_FLAG_*.
> > How is it going?
> >
> 
> As you can see there was no discussion so far on the list about it.
> 
> Now my priority is merging the driver in the mainline. So I have focused on
> adding
> new pixel formats and the necessary controls. After the driver gets merged it is
> still possible to add new code and extend functionality.
> 
> Pixel formats are already discussed and discussion of controls is (hopefully)
> close
> to the end. Adding another topic will last weeks, and will delay merging.
> 
> Let's get the driver merged with basic functionality and then extend it,
> otherwise
> it will be delayed again and again.

I can't agree with you anymore. I hope MFC driver would be merge ASAP too.

> 
> 
> Best regards,
> --
> Kamil Debski
> Linux Platform Group
> Samsung Poland R&D Center

Best regards

/jtpark

