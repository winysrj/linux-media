Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:42948 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab1I1NrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 09:47:07 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
CC: "Ravi, Deepthy" <deepthy.ravi@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Date: Wed, 28 Sep 2011 19:16:35 +0530
Subject: RE: [PATCH 4/8] ispvideo: Add support for G/S/ENUM_STD ioctl
Message-ID: <19F8576C6E063C45BE387C64729E739404ECA54E23@dbde02.ent.ti.com>
References: <1315488922-16152-1-git-send-email-deepthy.ravi@ti.com>
 <201109280041.29952.laurent.pinchart@ideasonboard.com>
 <4E82F002.4040401@infradead.org>
 <201109281529.17387.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201109281529.17387.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Wednesday, September 28, 2011 6:59 PM
> To: Mauro Carvalho Chehab
> Cc: Hiremath, Vaibhav; Ravi, Deepthy; linux-media@vger.kernel.org;
> g.liakhovetski@gmx.de; Sakari Ailus
> Subject: Re: [PATCH 4/8] ispvideo: Add support for G/S/ENUM_STD ioctl
> 
> Hi Mauro,
> 
> On Wednesday 28 September 2011 11:59:30 Mauro Carvalho Chehab wrote:
> > Em 27-09-2011 19:41, Laurent Pinchart escreveu:
> > > On Wednesday 28 September 2011 00:31:32 Mauro Carvalho Chehab wrote:
> > >> Em 19-09-2011 12:31, Hiremath, Vaibhav escreveu:
> > >>> On Friday, September 16, 2011 6:36 PM Laurent Pinchart wrote:
> > >>>> On Friday 16 September 2011 15:00:53 Ravi, Deepthy wrote:
> > >>>>> On Thursday, September 08, 2011 10:51 PM Laurent Pinchart wrote:
> > >>>>>> On Thursday 08 September 2011 15:35:22 Deepthy Ravi wrote:
> > >>>>>>> From: Vaibhav Hiremath <hvaibhav@ti.com>
> > >>>>>>>
> > >>>>>>> In order to support TVP5146 (for that matter any video decoder),
> > >>>>>>> it is important to support G/S/ENUM_STD ioctl on /dev/videoX
> > >>>>>>> device node.
> > >>>>>>
> > >>>>>> Why so ? Shouldn't it be queried on the subdev output pad
> directly ?
> > >>>>>
> > >>>>> Because standard v4l2 application for analog devices will call
> these
> > >>>>> std ioctls on the streaming device node. So it's done on
> /dev/video
> > >>>>> to make the existing apllication work.
> > >>>>
> > >>>> Existing applications can't work with the OMAP3 ISP (and similar
> > >>>> complex embedded devices) without userspace support anyway, either
> in
> > >>>> the form of a GStreamer element or a libv4l plugin. I still believe
> > >>>> that analog video standard operations should be added to the subdev
> > >>>> pad operations and exposed through subdev device nodes, exactly as
> > >>>> done with formats.
> > >>>
> > >>> I completely agree with your point that, existing application will
> not
> > >>> work without setting links properly. But I believe the assumption
> here
> > >>> is, media-controller should set the links (along with pad formants)
> and
> > >>> all existing application should work as is. Isn't it?
> > >>
> > >> Yes.
> > >>
> > >>> The way it is being done currently is, set the format at the pad
> level
> > >>> which is same as analog standard resolution and use existing
> > >>> application for streaming...
> > >>
> > >> Yes.
> > >>
> > >>> I am ok, if we add s/g/enum_std api support at sub-dev level but
> this
> > >>> should also be supported on streaming device node.
> > >>
> > >> Agreed. Standards selection should be done at device node, just like
> any
> > >> other device.
> > >
> > > No. Please see my reply to Vaibhav's e-mail. Standard selection should
> be
> > > done on the subdev pads, for the exact same reason why formats and
> > > selection rectangles are configured on subdev pads.
> >
> > NACK. Let's not reinvent the wheel. the MC should not replace the V4L2
> API.
> 
> I will NACK any patch that implements G/S/ENUM_STD in the OMAP3 ISP driver
> itself, so we got a deadlock here :-)
> 
> Maybe it would be easier to discuss this face to face in Prague ?
> 
[Hiremath, Vaibhav] I am surprised and afraid to say that, we are breaking
existing V4L2 standard applications. 

We are referring to libv4l, which anyway should follow (compliant to)
standard V4L2 spec; and for analog device interface we must support
G/S/ENUM_STD ioctl interface.

What if I don't want to use libv4l and writing my own application?
What if I only want to validate my driver (without libv4l) and the
underneath TVP5146 device is being used in both MC and non-MC compatible devices?

For example,

In my case, I have OMAP3 (with MC support) and AM3517 (without MC support),
And I do my whole testing with simple and plain C application which works on both without any change/issues. 
Streaming application is exactly same, only in case of OMAP3, I have to set the links with media-ctl before streaming.


I think we had enough discussion on this, and I don't see you are getting 
into alignment with this (I am surprised). I vote for F2F discussion, but
I will not be available. Hope you will update me on this.

Thanks,
Vaibhav

> --
> Regards,
> 
> Laurent Pinchart
