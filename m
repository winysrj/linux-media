Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:49993 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759192Ab2FUKCU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 06:02:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: extend v4l2_mbus_framefmt
Date: Thu, 21 Jun 2012 12:02:16 +0200
Cc: Scott Jiang <scott.jiang.linux@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>,
	uclinux-dist-devel@blackfin.uclinux.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <CAHG8p1AW6577=oGPo3o8S0LgF2p8_cfmLLnvYbikk7kEaYdxzw@mail.gmail.com> <201206201300.34614.hverkuil@xs4all.nl> <20120621065324.GN12505@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120621065324.GN12505@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206211202.16752.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 21 June 2012 08:53:25 Sakari Ailus wrote:
> Hi Hans,
> 
> On Wed, Jun 20, 2012 at 01:00:34PM +0200, Hans Verkuil wrote:
> > On Wed 20 June 2012 12:25:09 Sakari Ailus wrote:
> > > Hi Scott,
> > > 
> > > Scott Jiang wrote:
> > > >>>>>> I would expect that the combination of v4l2_mbus_framefmt +
> > > >>>>>> v4l2_dv_timings
> > > >>>>>> gives you the information you need.
> > > >>>>>>
> > > >>>>> I can solve this problem in HD, but how about SD? Add a fake
> > > >>>>> dv_timings ops in SD decoder driver?
> > > >>>>>
> > > >>>>
> > > >>>> No, you add g/s_std instead. SD timings are set through that API. It is
> > > >>>> not so
> > > >>>> much that you give explicit timings, but that you give the SD standard.
> > > >>>> And from
> > > >>>> that you can derive the timings (i.e., one for 60 Hz formats, and one for
> > > >>>> 50 Hz
> > > >>>> formats).
> > > >>>>
> > > >>> Yes, it's a solution for decoder. I can convert one by one. But how
> > > >>> about sensors?They can output VGA, QVGA or any manual resolution.
> > > >>> My question is why we can't add these blanking details in
> > > >>> v4l2_mbus_framefmt? This structure is used to describe frame format on
> > > >>> media bus. And I believe blanking data also transfer on this bus. I
> > > >>> know most hardwares don't care about blanking areas, but some hardware
> > > >>> such as PPI does. PPI can capture ancillary data both in herizontal
> > > >>> and vertical interval. Even it works in active video only mode, it
> > > >>> expects to get total timing info.
> > > >>
> > > >>
> > > >> Since I don't know what you are trying to do, it is hard for me to give
> > > >> a good answer.
> > > >>
> > > >> So first I'd like to know if this is related to the adv7842 chip? I think
> > > >> you are talking about how this is done in general, and not specifically in
> > > >> relationship to the adv7842. At least, I can't see how/why you would
> > > >> hook up a sensor to the adv7842.
> > > > Yes, I want to have a general solution.
> > > >
> > > >>
> > > >> Sensor configuration is a separate topic, and something I am not an
> > > >> expert on. People like Sakari Ailus and Laurent Pinchart know much
> > > >> more about that than I do.
> > > >>
> > > >> I know that there is some support for blanking through low-level image
> > > >> source
> > > >> controls:
> > > >>
> > > >> http://hverkuil.home.xs4all.nl/spec/media.html#image-source-controls
> > > >>
> > > >> This is experimental and if this is insufficient for your requirements than
> > > >> I suggest posting a message where you explain what you need, CC-ing the
> > > >> people
> > > >> I mentioned,
> > > >>
> > > >> Most of these APIs are quite new and by marking them as experimental we can
> > > >> make changes later if it turns out it is not good enough.
> > > > I remember I have discussed this topic with Sakari before but without
> > > > working out a solution.
> > > > In conclusion, my current solution is:
> > > > if (HD)
> > > >      dv_timings
> > > > else if (SD)
> > > >      fill in according to PAL/NTSC timings
> > > > else
> > > >      get control of V4L2_CID_HBLANK/V4L2_CID_VBLANK
> > > >
> > > > I guess this can solve my problem. But it's a bit complicated. If
> > > > v4l2_mbus_framefmt contains thes members, it's convenient and simple.
> > > 
> > > Adding horizontal and vertical blanking as fields to struct 
> > > v4l2_mbus_framefmt was discussed long ago --- I even sent a patch doing 
> > > that AFAIR. It'd have been a simple solution, yes. The resulting 
> > > discussion concluded, however, that as the horizontal or vertical 
> > > blanking are not really a property of the image format, and generally 
> > > only affect timing (frame rate, they do not belong to this struct.
> > > 
> > > Also changing them while streaming is almost always possible (except in 
> > > your case, I believe) whereas the rest of the fields are considered 
> > > static. It'd be difficult for the user to know which fields can be 
> > > actually changed while streamon, and which can't.
> > > 
> > > For these reasons (AFAIR) we chose to use controls instead.
> > > 
> > > I think the right solution to the problem when it comes to sensors, is 
> > > to mark these controls busy from the bridge driver if the bridge 
> > > hardware can't cope with changes in blanking. The control framework 
> > > doesn't support this currently but it might not be that much of work to 
> > > implement it. Such feature would definitely have to be used with care.
> > > 
> > > Hans, what do you think?
> > 
> > That's already supported for a long time. If the control flag V4L2_CTRL_FLAG_GRABBED
> > is set, then the control is marked busy.
> > 
> > There aren't many drivers that use this flag, but some do.
> 
> The problem is it's a flag. In this case the driver marking the control busy
> would be a different driver from the one that implements it, and I don't
> think we could trust only one of the drivers will want to modify it. So it'd
> have to be a counter instead.

Why would another driver than the bridge driver want to change this?

Right now it is no problem for the bridge driver to change the grabbed flag of
a control of a subdev driver.

If this would have to be implemented as a counter, then that would make things
more complicated. But I'd like to see an actual need for that before I would
consider implementing this.

> That could still require special handling in some cases so we could specify
> which controls may be grabbed by other drivers and when as the drivers may
> want to modify the controls themselves, too.

Well, if someone grabbed the control, then no driver or application should be
able to modify it until it is 'ungrabbed'.

Regards,

	Hans
