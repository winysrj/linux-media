Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4988 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318Ab1FVKko (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 06:40:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 2/4 v9] v4l: add control definitions for codec devices.
Date: Wed, 22 Jun 2011 12:40:35 +0200
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	laurent.pinchart@ideasonboard.com, jtp.park@samsung.com
References: <1308069416-24723-1-git-send-email-k.debski@samsung.com> <201106221025.53838.hverkuil@xs4all.nl> <00ac01cc30c7$754b5c40$5fe214c0$%debski@samsung.com>
In-Reply-To: <00ac01cc30c7$754b5c40$5fe214c0$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106221240.35784.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, June 22, 2011 12:30:45 Kamil Debski wrote:
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_RES</constant>&nb
> > sp;</entry>
> > > +		<entry>integer</entry>
> > > +	      </row><row><entry spanname="descr">vop_time_increment_resolution
> > value for MPEG4. Applicable to the MPEG4 encoder.</entry>
> > > +	      </row>
> > > +	      <row><entry></entry></row>
> > > +	      <row>
> > > +		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_INC</constant>&nb
> > sp;</entry>
> > > +		<entry>integer</entry>
> > > +	      </row><row><entry spanname="descr">vop_time_increment value for
> > MPEG4. Applicable to the MPEG4 encoder.</entry>
> > 
> > How should these two controls be used? Are you supposed to set them? Or do
> > they
> > have suitable default values?
> 
> They are used only in MPEG4 and are used instead of S_PARM to set fps.
> You are supposed to set them, but I think the driver could set a default value
> (such as vop_time_res = 30000 and vop_time_res_increment = 1000).

Hmm. Perhaps S_PARM should be used for this? I am not too keen on adding this
when it looks like it is exactly the same as the S_PARM functionality.

How do other codecs do this?

> > > +
> > <entry><constant>V4L2_MPEG_MFC51_FRAME_SKIP_MODE_DISABLED</constant>&nbsp;</
> > entry>
> > > +		      <entry>Frame skip mode is disabled.</entry>
> > > +		    </row>
> > > +		    <row>
> > > +
> > <entry><constant>V4L2_MPEG_MFC51_FRAME_SKIP_MODE_LEVEL_LIMIT</constant>&nbsp
> > ;</entry>
> > > +		      <entry>Frame skip mode enabled and buffer limit is set by
> > the chosen level.</entry>
> > 
> > With which control do I set that level?
> 
> *_MPEG4_LEVEL and *_H264_LEVEL, I will add some clarification.

Ah! That level :-)

Regards,

	Hans
