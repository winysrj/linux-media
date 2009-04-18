Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:1056 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbZDRPx7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Apr 2009 11:53:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [RFC] Stand-alone Resizer/Previewer Driver support under V4L2 framework
Date: Sat, 18 Apr 2009 17:53:47 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"R, Sivaraj" <sivaraj@ti.com>, "Hadli, Manjunath" <mrh@ti.com>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"Kumar, Purushotam" <purushotam@ti.com>
References: <19F8576C6E063C45BE387C64729E73940427E3F70B@dbde02.ent.ti.com> <200903301902.21783.hverkuil@xs4all.nl> <19F8576C6E063C45BE387C64729E73940427E3F8F1@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940427E3F8F1@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904181753.47515.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 31 March 2009 10:53:02 Hiremath, Vaibhav wrote:
> Thanks,
> Vaibhav Hiremath
>
> > > APPROACH 3 -
> > > ----------
> > >
> > > .....
> > >
> > > (Any other approach which I could not think of would be
> >
> > appreciated)
> >
> > > I would prefer second approach, since this will provide standard
> > > interface to applications independent on underneath hardware.
> > >
> > > There may be many number of such configuration parameters required
> >
> > for
> >
> > > different such devices, we need to work on this and come up with
> >
> > some
> >
> > > standard capability fields covering most of available devices.
> > >
> > > Does anybody have some other opinions on this?
> > > Any suggestions will be helpful here,
> >
> > FYI: I have very little time to look at this for the next 2-3 weeks.
> > As you
> > know I'm working on the last pieces of the v4l2_subdev conversion
> > for 2.6.30
> > that should be finished this week. After that I'm attending the
> > Embedded
> > Linux Conference in San Francisco.
> >
> > But I always thought that something like this would be just a
> > regular video
> > device that can do both 'output' and 'capture'. For a resizer I
> > would
> > expect that you set the 'output' size (the size of your source
> > image) and
> > the 'capture' size (the size of the resized image), then just send
> > the
> > frames to the device (== resizer) and get them back on the capture
> > side.
>
> [Hiremath, Vaibhav] Yes, it is possible to do that.
>
> Hans,
>
> I went through the link referred by Sergio and I think we should inherit
> some implementation for CODECs here for such devices.
>
> V4L2_BUF_TYPE_CODECIN - To access the input format.
> V4L2_BUF_TYPE_CODECOUT - To access the output format.
>
> It makes sense, since such memory-to-memory devices will mostly being
> used from codecs context. And this would be more clear from user
> application.

To be honest, I don't see the need for this. I think TYPE_VIDEO_CAPTURE and 
TYPE_VIDEO_OUTPUT are perfectly fine.

> And as acknowledged by you, we can use VIDIOC_S_FMT for setting
> parameters.
>
> One thing I am not able to convince myself is that, using "priv" field
> for custom configuration.

I agree. Especially since you cannot use it as a pointer to addition 
information.

> I would prefer and recommend capability based 
> interface, where application will query the capability of the device for
> luma enhancement, filter coefficients (number of coeff and depth),
> interpolation type, etc...
>
> This way we can make sure that, any such future devices can be adapted by
> this framework.

The big question is how many of these capabilities are 'generic' and how 
many are very much hardware specific. I am leaning towards using the 
extended control API for this. It's a bit awkward to implement in drivers 
at the moment, but that should improve in the future when a lot of the 
control handling code will move into the new core framework.

I really need to know more about the sort of features that omap/davinci 
offer (and preferably also for similar devices by other manufacturers).

>
>
> Hans,
> Have you get a chance to look at Video-Buf layer issues I mentioned in
> original draft?

I've asked Magnus Damm to take a look at this. I know he did some work in 
this area and he may have fixed some of these issues already. Very useful, 
that Embedded Linux conference...

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
