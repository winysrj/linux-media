Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:46407 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1FVKax (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 06:30:53 -0400
Received: from epcpsbgm2.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LN6008XET7E7EI0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 19:30:51 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LN6001JPT7ALJ@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 19:30:51 +0900 (KST)
Date: Wed, 22 Jun 2011 12:30:45 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH 2/4 v9] v4l: add control definitions for codec devices.
In-reply-to: <201106221025.53838.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	laurent.pinchart@ideasonboard.com, jtp.park@samsung.com
Message-id: <00ac01cc30c7$754b5c40$5fe214c0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-language: en-gb
Content-transfer-encoding: 7BIT
References: <1308069416-24723-1-git-send-email-k.debski@samsung.com>
 <1308069416-24723-3-git-send-email-k.debski@samsung.com>
 <201106221025.53838.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: 22 June 2011 10:26
> To: Kamil Debski
> Cc: linux-media@vger.kernel.org; m.szyprowski@samsung.com;
> kyungmin.park@samsung.com; jaeryul.oh@samsung.com;
> laurent.pinchart@ideasonboard.com; jtp.park@samsung.com
> Subject: Re: [PATCH 2/4 v9] v4l: add control definitions for codec devices.
> 
> On Tuesday, June 14, 2011 18:36:54 Kamil Debski wrote:
> > Add control definitions and documentation for controls
> > specific to codec devices.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  Documentation/DocBook/media/v4l/controls.xml |  958
> ++++++++++++++++++++++++++
> >  include/linux/videodev2.h                    |  171 +++++
> >  2 files changed, 1129 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/DocBook/media/v4l/controls.xml
> b/Documentation/DocBook/media/v4l/controls.xml
> > index 6880798..6b0d06a 100644
> > --- a/Documentation/DocBook/media/v4l/controls.xml
> > +++ b/Documentation/DocBook/media/v4l/controls.xml
> > @@ -325,6 +325,22 @@ minimum value disables backlight
> compensation.</entry>
> >  <constant>V4L2_CID_ILLUMINATORS_2</constant> + 1).</entry>
> >  	  </row>
> >  	  <row>
> > +

...

> > +
> > +
> > +	      <row><entry></entry></row>
> > +	      <row>
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE</constan
> t>&nbsp;</entry>
> > +		<entry>boolean</entry>
> > +	      </row>
> > +	      <row><entry spanname="descr">If enabled the decoder expects a
> single slice in one OUTPUT buffer, otherwise
> > +the decoder expects a single frame in one input buffer. Applicable to the
> decoder, all codecs.
> 
> 'in one OUTPUT buffer' vs 'in one input buffer'. Perhaps rewriting it like
> this is better:
> 
> 	      <row><entry spanname="descr">If enabled the decoder expects to
> receive a single slice per buffer, otherwise
> the decoder expects a single frame in per buffer. Applicable to the decoder,
> all codecs.
> 
> BTW: 'all codecs'? Your decoder hardware can handle e.g. MPEG-2 sliced input?
> I thought slices were specific to e.g. MPEG4/H264? Just checking...

I've checked the H263 spec and it mentions slice, same for MPEG2
(this site http://goo.gl/vXUEb mentions slices). It could be better to explicitly
list the codecs, as there might be a codec that doesn't support slices.

> 
> > +</entry>
> > +	      </row>
> > +
> > +	      <row><entry></entry></row>
> > +	      <row>
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE</constant>&n
> bsp;</entry>
> > +		<entry>boolean</entry>
> > +	      </row>
> > +	      <row><entry spanname="descr">Enable writing sample aspect ratio
> in the Video Usability Information.
> > +Applicable to the H264 encoder.</entry>
> > +	      </row>
> > +

...

> > +
> > +	      <row><entry></entry></row>
> > +	      <row>
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP</constant>&nbsp;
> </entry>
> > +		<entry>integer</entry>
> > +	      </row>
> > +	      <row><entry spanname="descr">Quantization parameter for an I
> frame for H263. Valid range: from 1 to 31.</entry>
> 
> Is this range defined by the H263 standard? If not, then you shouldn't
> mention
> the range as it is hardware dependent.

Yes it is defined in the standard.

> 
> > +	      </row>
> > +
> > +	      <row><entry></entry></row>
> > +	      <row>
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H263_MIN_QP</constant>&nbsp;</en
> try>

....

> > +
> > +	      <row><entry></entry></row>
> > +	      <row>
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VBV_SIZE</constant>&nbsp;</entry
> >
> > +		<entry>integer</entry>
> > +	      </row>
> > +	      <row><entry spanname="descr">The Video Buffer Verifier size in
> kilobytes, it used as a limitation of frame skip.
> 
> Typo: 'it used' -> 'it is used'
> 
> I think it would be good to either give some background information here, or
> refer
> to the standard for that information.

Ok, will do.
 
> > +Applicable to the MPEG1, MPEG2, MPEG4 encoders.</entry>
> > +	      </row>
> > +
> > +	      <row><entry></entry></row>
> > +	      <row>
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE</constant>&nbsp;</
> entry>
> > +		<entry>integer</entry>
> > +	      </row>
> > +	      <row><entry spanname="descr">The Coded Picture Buffer size in
> kilobytes, it used as a limitation of frame skip.
> 
> Same typo.
> 
> > +Applicable to the H264 encoder.</entry>
> > +	      </row>
> > +
> > +	      <row><entry></entry></row>
> > +	      <row>
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_I_PERIOD</constant>&nbsp;</
> entry>
> > +		<entry>integer</entry>
> > +	      </row>
> > +	      <row><entry spanname="descr">Period between I-frames in the open
> GOP for H264. In case of an open GOP
> > +this is the period between two I-frames. The period between IDR
> (Instantaneous Decoding Refresh) frames is taken from the GOP_SIZE control.
> > +An IDR frame, which stands for Instantaneous Decoding Refresh is an I-
> frame after which no prior frames are
> > +referenced. This means that a stream can be restarted from an IDR frame
> without the need to store or decode any
> > +previous frames. Applicable to the H264 encoder.</entry>
> > +	      </row>
> > +

...

> > +	      <row>
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_RES</constant>&nb
> sp;</entry>
> > +		<entry>integer</entry>
> > +	      </row><row><entry spanname="descr">vop_time_increment_resolution
> value for MPEG4. Applicable to the MPEG4 encoder.</entry>
> > +	      </row>
> > +	      <row><entry></entry></row>
> > +	      <row>
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_INC</constant>&nb
> sp;</entry>
> > +		<entry>integer</entry>
> > +	      </row><row><entry spanname="descr">vop_time_increment value for
> MPEG4. Applicable to the MPEG4 encoder.</entry>
> 
> How should these two controls be used? Are you supposed to set them? Or do
> they
> have suitable default values?

They are used only in MPEG4 and are used instead of S_PARM to set fps.
You are supposed to set them, but I think the driver could set a default value
(such as vop_time_res = 30000 and vop_time_res_increment = 1000).

> > +	      </row>
> > +
> > +	    </tbody>
> > +	  </tgroup>
> > +	</table>
> > +      </section>
> > +

...

> > +	      <row><entry></entry></row>
> > +	      <row>
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY
> </constant>&nbsp;</entry>
> > +		<entry>integer</entry>
> > +	      </row><row><entry spanname="descr">Display delay value for H264
> decoder.</entry>
> 
> What's the unit of this control? Frames? Slices? Buffers?

It is expressed in frames, I will add it to the documentation.
 
> > +	      </row>
> > +	      <row><entry></entry></row>
> > +	      <row>
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P</co
> nstant>&nbsp;</entry>
> > +		<entry>integer</entry>
> > +	      </row><row><entry spanname="descr">The number of reference
> pictures used for encoding a P picture.
> > +Applicable to the H264 encoder.</entry>
> > +	      </row>
> > +	      <row><entry></entry></row>
> > +	      <row>

...

> > +
> <entry><constant>V4L2_MPEG_MFC51_FRAME_SKIP_MODE_DISABLED</constant>&nbsp;</
> entry>
> > +		      <entry>Frame skip mode is disabled.</entry>
> > +		    </row>
> > +		    <row>
> > +
> <entry><constant>V4L2_MPEG_MFC51_FRAME_SKIP_MODE_LEVEL_LIMIT</constant>&nbsp
> ;</entry>
> > +		      <entry>Frame skip mode enabled and buffer limit is set by
> the chosen level.</entry>
> 
> With which control do I set that level?

*_MPEG4_LEVEL and *_H264_LEVEL, I will add some clarification.

> > +		    </row>
> > +		    <row>
> > +
> <entry><constant>V4L2_MPEG_MFC51_FRAME_SKIP_MODE_VBV_LIMIT</constant>&nbsp;<
> /entry>
> > +		      <entry>Frame skip mode enabled and buffer limit is set by
> the VBV buffer size control.</entry>
> 
> VBV or H264_CPB. Perhaps this should be renamed SKIP_MODE_BUF_LIMIT with
> references
> to the VBV and H264_CPB controls.

Yes, it is a good idea to rename the control.
 
> > +		    </row>
> > +		  </tbody>
> > +		</entrytbl>
> > +	      </row>
> > +	      <row><entry></entry></row>
> > +	      <row>
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_RC_FIXED_TARGET_BIT</const
> ant>&nbsp;</entry>

...

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

