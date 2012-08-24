Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35022 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752610Ab2HXWvY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 18:51:24 -0400
Date: Sat, 25 Aug 2012 01:51:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, g.liakhovetski@gmx.de,
	kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 1/4] V4L: Add V4L2_CID_FRAMESIZE image source class
 control
Message-ID: <20120824225118.GM721@valkosipuli.retiisi.org.uk>
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
 <50363F19.5070607@samsung.com>
 <5036754C.4040501@iki.fi>
 <1479692.F6ROfrmgsS@avalon>
 <5037383E.3030109@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5037383E.3030109@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Fri, Aug 24, 2012 at 10:15:58AM +0200, Sylwester Nawrocki wrote:
> On 08/24/2012 12:41 AM, Laurent Pinchart wrote:
> > On Thursday 23 August 2012 21:24:12 Sakari Ailus wrote:
> >> Sylwester Nawrocki wrote:
> >>>> On Thu, Aug 23, 2012 at 11:51:26AM +0200, Sylwester Nawrocki wrote:
> >>>>> The V4L2_CID_FRAMESIZE control determines maximum number
> >>>>> of media bus samples transmitted within a single data frame.
> >>>>> It is useful for determining size of data buffer at the
> >>>>> receiver side.
> >>>>>
> >>>>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>>>> ---
> >>>>>
> >>>>>   Documentation/DocBook/media/v4l/controls.xml | 12 ++++++++++++
> >>>>>   drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
> >>>>>   include/linux/videodev2.h                    |  1 +
> >>>>>   3 files changed, 15 insertions(+)
> >>>>>
> >>>>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
> >>>>> b/Documentation/DocBook/media/v4l/controls.xml index 93b9c68..ad5d4e5
> >>>>> 100644
> >>>>> --- a/Documentation/DocBook/media/v4l/controls.xml
> >>>>> +++ b/Documentation/DocBook/media/v4l/controls.xml
> >>>>> @@ -4184,6 +4184,18 @@ interface and may change in the future.</para>
> >>>>>
> >>>>>   	    conversion.
> >>>>>   	    </entry>
> >>>>>   	  
> >>>>>   	  </row>
> >>>>>
> >>>>> +	  <row>
> >>>>> +	    <entry
> >>>>> spanname="id"><constant>V4L2_CID_FRAMESIZE</constant></entry>
> >>>>> +	    <entry>integer</entry>
> >>>>> +	  </row>
> >>>>> +	  <row>
> >>>>> +	    <entry spanname="descr">Maximum size of a data frame in media bus
> >>>>> +	      sample units. This control determines maximum number of samples
> >>>>> +	      transmitted per single compressed data frame. For generic raw
> >>>>> +	      pixel formats the value of this control is undefined. This is
> >>>>> +	      a read-only control.
> >>>>> +	    </entry>
> >>>>> +	  </row>
> >>>>>
> >>>>>   	  <row><entry></entry></row>
> >>>>>   	
> >>>>>   	</tbody>
> >>>>>   	
> >>>>>         </tgroup>
> >>>>>
> >>>>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> >>>>> b/drivers/media/v4l2-core/v4l2-ctrls.c index b6a2ee7..0043fd2 100644
> >>>>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> >>>>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> >>>>> @@ -727,6 +727,7 @@ const char *v4l2_ctrl_get_name(u32 id)
> >>>>>
> >>>>>   	case V4L2_CID_VBLANK:			return "Vertical Blanking";
> >>>>>   	case V4L2_CID_HBLANK:			return "Horizontal Blanking";
> >>>>>   	case V4L2_CID_ANALOGUE_GAIN:		return "Analogue Gain";
> >>>>>
> >>>>> +	case V4L2_CID_FRAMESIZE:		return "Maximum Frame Size";
> >>>>
> >>>> I would put this to the image processing class, as the control isn't
> >>>> related to image capture. Jpeg encoding (or image compression in
> >>>> general) after all is related to image processing rather than capturing
> >>>> it.
> >>>
> >>> All right, might make more sense that way. Let me move it to the image
> >>> processing class then. It probably also makes sense to name it
> >>> V4L2_CID_FRAME_SIZE, rather than V4L2_CID_FRAMESIZE.
> >>
> >> Hmm. While we're at it, as the size is maximum --- it can be lower ---
> >> how about V4L2_CID_MAX_FRAME_SIZE or V4L2_CID_MAX_FRAME_SAMPLES, as the
> >> unit is samples?
> >
> >> Does sample in this context mean pixels for uncompressed formats and
> >> bytes (octets) for compressed formats? It's important to define it as
> >> we're also using the term "sample" to refer to data units transferred
> >> over a parallel bus per a clock cycle.
> > 
> > I agree with Sakari here, I find the documentation quite vague, I wouldn't 
> > understand what the control is meant for from the documentation only.
> 
> I thought it was clear enough:
> 
> Maximum size of a data frame in media bus sample units.
>                              ^^^^^^^^^^^^^^^^^^^^^^^^^

Oops. I somehow managed to miss that. My mistake.

> So that means the unit is a number of bits clocked by a single clock
> pulse on parallel video bus... :) But how is media bus sample defined
> in case of CSI bus ? Looks like "media bus sample" is a useless term
> for our purpose.

The CSI2 transmitters and receivers, as far as I understand, want to know a
lot more about the data that I think would be necessary. This doesn't only
involve the bits per sample (e.g. pixel for raw bayer formats) but some
information on the media bus code, too. I.e. if you're transferring 11 bit
pixels the bus has to know that.

I think it would have been better to use different media bus codes for
serial busses than on parallel busses that transfer the sample on a single
clock cycle. But that's out of the scope of this patch.

In respect to this the CCP2 AFAIR works mostly the same way.

> I thought it was better than just 8-bit byte, because the data receiver
> (bridge) could layout data received from video bus in various ways in
> memory, e.g. add some padding. OTOH, would any padding make sense
> for compressed streams ? It would break the content, wouldn't it ?

I guess it't break if the padding is applied anywhere else than the end,
where I hope it's ok. I'm not that familiar with compressed formats, though.
The hardware typically has limitations on the DMA transaction width and that
can easily be e.g. 32 or 64 bytes, so some padding may easily be introduced
at the end of the compressed image.

> So I would propose to use 8-bit byte as a unit for this control and
> name it V4L2_CID_MAX_FRAME_SIZE. All in all it's not really tied
> to the media bus.

It took me quite a while toe remember what the control really was for. ;)

How about using bytes on video nodes and bus and media bus code specific
extended samples (or how we should call pixels in uncompressed formats and
units of data in compressed formats?) on subdevs? The information how the
former is derived from the latter resides in the driver controlling the DMA
anyway.

As you proposed originally, this control is more relevant to subdevs so we
could also not define it for video nodes at all. Especially if the control
isn't needed: the information should be available from VIDIOC_TRY_FMT.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
