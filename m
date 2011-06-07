Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1725 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1FGKHa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 06:07:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [RFC/PATCH v3] v4l: add control definitions for codec devices.
Date: Tue, 7 Jun 2011 12:07:20 +0200
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	laurent.pinchart@ideasonboard.com, jtp.park@samsung.com
References: <1307026121-11016-1-git-send-email-k.debski@samsung.com> <201106051322.48033.hverkuil@xs4all.nl> <003d01cc24f9$4fe44b80$eface280$%debski@samsung.com>
In-Reply-To: <003d01cc24f9$4fe44b80$eface280$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106071207.21084.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, June 07, 2011 11:57:22 Kamil Debski wrote:
> Hi Hans,
> 
> > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > 
> > Hi Kamil!
> > 
> > On Thursday, June 02, 2011 16:48:41 Kamil Debski wrote:
> > > Hi,
> > >
> > > This is a third version of the patch that adds controls for the codec
> > family of
> > > devices. I have implemented the suggestions to v1 I got from Hans Verkuil
> > on the #v4l
> > > channel. Also I have addressed comments to v2 by Jeongtae Park.
> > >
> > > Changes from v2 to v3:
> > > - added MVC anc SVC profiles to H264
> > > - some fixes in in the documentation
> > > - remove V4L2_CID_MPEG_VIDEO_INTERLACE in favour of interlace v4l2_field
> > in v4l2_pix_format
> > >
> > > Changes from v1 to v2:
> > > - rename V4L2_CID_MIN_REQ_BUFS_(CAP/OUT) to
> > V4L2_CID_MIN_BUFFERS_FOR_(CAPTURE/OUTPUT)
> > > - use existing controls for GOP size, number of frames and GOP closure
> > > - remove frame rate controls (in favour of the S_PARM call)
> > > - split level into separate controls for MPEG4 and H264
> > >
> > > I would welcome further comments.
> > 
> > I have a number of comments below, but I will need to find the actual
> > standards
> > documents at work to verify some others parts of this RFC. So I'll get back
> > with
> > more comments, hopefully on Tuesday.
> > 
> > I also have a few more generic comments:
> > 
> > 1) I understand that the MFC supports H264, MPEG4 and H263, right? How does
> > one
> > select between them? I assume that V4L2_CID_MPEG_VIDEO_ENCODING should be
> > used
> > for that, but that is missing MPEG4 and H263.
> 
> The codec used is determined by the pixelformat of the capture queue. 
> So if it is V4L2_PIX_FMT_H264 then H264 elementary stream would be produced.
> This control would only be used for multiplexed streams - when the pixelformat
> is set to V4L2_PIX_FMT_MPEG.

Of course. It slipped my mind. This really needs to be documented better in
the spec.
 
> > 2) It is sometimes hard to figure out for which video encodings certain
> > controls
> > are valid. I think all the video controls should have a list of the video
> > encodings
> > for which that control is valid (except where the name of the control makes
> > it
> > unambiguous).
> 
> You mean the documentation, yes?

Yes, documentation.

> If so it is a good idea, I could add a list of
> supported video codecs for such controls.

Please do. That would make the spec much more precise.

> 
> > 3) Is there public documentation from Samsung regarding the MFC-specific
> > controls?
> > If so, then a link to that documentation would be very handy. If not, then I
> > think
> > some of the documentation for these controls should be extended.
> 
> I am not sure whether the documentation is available for download on the web.
> I actually doubt it... So I will think which controls should have
> more documentation.
> 
> > 
> > Note that this third version of the RFC looks much better than the earlier
> > ones.
> > I think we are close to finalizing this.
> 
> Thanks.
> 
> > 
> > >
> > > Best regards,
> > > Kamil Debski
> > >
> > > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > >  Documentation/DocBook/v4l/controls.xml |  774
> > ++++++++++++++++++++++++++++++++

> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_VUI_AR_IDC</constant>&nbsp;
> > </entry>
> > > +		<entry>integer</entry>
> > > +	      </row>
> > > +	      <row><entry spanname="descr">VUI aspect ratio IDC for H.264
> > encoding. The value is defined in VUI Table
> > > +E-1 in the standard.
> > 
> > What does IDC stand for? Shouldn't this be a menu control? How does this
> > compare
> > to V4L2_CID_MPEG_VIDEO_ASPECT?
> 
> IDC stands for 'indicator', this abbreviation is commonly used in the H264
> standard.
> If I understand correctly the meaning of this control is different than
> V4L2_CID_MPEG_VIDEO_ASPECT

It is indeed. I checked the H264 spec as well.

Regards,

	Hans
