Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:40201 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZDTKcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 06:32:05 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
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
Date: Mon, 20 Apr 2009 16:01:53 +0530
Subject: RE: [RFC] Stand-alone Resizer/Previewer Driver support under V4L2
 framework
Message-ID: <19F8576C6E063C45BE387C64729E739404280C5B5E@dbde02.ent.ti.com>
References: <19F8576C6E063C45BE387C64729E73940427E3F70B@dbde02.ent.ti.com>
 <200903301902.21783.hverkuil@xs4all.nl>
 <19F8576C6E063C45BE387C64729E73940427E3F8F1@dbde02.ent.ti.com>
 <200904181753.47515.hverkuil@xs4all.nl>
In-Reply-To: <200904181753.47515.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Saturday, April 18, 2009 9:24 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; Aguirre Rodriguez, Sergio Alberto;
> DongSoo(Nathaniel) Kim; Toivonen Tuukka.O (Nokia-D/Oulu); linux-
> omap@vger.kernel.org; Nagalla, Hari; Sakari Ailus; Jadav, Brijesh R;
> R, Sivaraj; Hadli, Manjunath; Shah, Hardik; Kumar, Purushotam
> Subject: Re: [RFC] Stand-alone Resizer/Previewer Driver support
> under V4L2 framework
> 
> On Tuesday 31 March 2009 10:53:02 Hiremath, Vaibhav wrote:
> > Thanks,
> > Vaibhav Hiremath
> >
> > > > APPROACH 3 -
> > > > ----------
> > > >
> > > > .....
> > It makes sense, since such memory-to-memory devices will mostly
> being
> > used from codecs context. And this would be more clear from user
> > application.
> 
> To be honest, I don't see the need for this. I think
> TYPE_VIDEO_CAPTURE and
> TYPE_VIDEO_OUTPUT are perfectly fine.
> 
[Hiremath, Vaibhav] Agreed, and you will also find implementation of driver aligned to this which I have shared with you.

> > And as acknowledged by you, we can use VIDIOC_S_FMT for setting
> > parameters.
> >
> > One thing I am not able to convince myself is that, using "priv"
> field
> > for custom configuration.
> 
> I agree. Especially since you cannot use it as a pointer to addition
> information.
> 
> > I would prefer and recommend capability based
> > interface, where application will query the capability of the
> device for
> > luma enhancement, filter coefficients (number of coeff and depth),
> > interpolation type, etc...
> >
> > This way we can make sure that, any such future devices can be
> adapted by
> > this framework.
> 
> The big question is how many of these capabilities are 'generic' and
> how
> many are very much hardware specific. I am leaning towards using the
> extended control API for this. It's a bit awkward to implement in
> drivers
> at the moment, but that should improve in the future when a lot of
> the
> control handling code will move into the new core framework.
> 
> I really need to know more about the sort of features that
> omap/davinci
> offer (and preferably also for similar devices by other
> manufacturers).
> 
[Hiremath, Vaibhav] Hans, Can we have IRC session for this? We will discuss this in detail and try to get closure on it.

Again I would request you to join me and mauro on IRC chat, I will be staying online tomorrow.

> >
> 
> Regards,
> 
> 	Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG

