Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1287 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZDTTcx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 15:32:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [RFC] Stand-alone Resizer/Previewer Driver support under V4L2 framework
Date: Mon, 20 Apr 2009 21:32:40 +0200
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
References: <19F8576C6E063C45BE387C64729E73940427E3F70B@dbde02.ent.ti.com> <200904181753.47515.hverkuil@xs4all.nl> <19F8576C6E063C45BE387C64729E739404280C5B5E@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404280C5B5E@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904202132.40347.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 20 April 2009 12:31:53 Hiremath, Vaibhav wrote:
> Thanks,
> Vaibhav Hiremath
>
> > -----Original Message-----
> > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > Sent: Saturday, April 18, 2009 9:24 PM
> > To: Hiremath, Vaibhav
> > Cc: linux-media@vger.kernel.org; Aguirre Rodriguez, Sergio Alberto;
> > DongSoo(Nathaniel) Kim; Toivonen Tuukka.O (Nokia-D/Oulu); linux-
> > omap@vger.kernel.org; Nagalla, Hari; Sakari Ailus; Jadav, Brijesh R;
> > R, Sivaraj; Hadli, Manjunath; Shah, Hardik; Kumar, Purushotam
> > Subject: Re: [RFC] Stand-alone Resizer/Previewer Driver support
> > under V4L2 framework
> >
> > On Tuesday 31 March 2009 10:53:02 Hiremath, Vaibhav wrote:
> > > Thanks,
> > > Vaibhav Hiremath
> > >
> > > > > APPROACH 3 -
> > > > > ----------
> > > > >
> > > > > .....
> > >
> > > It makes sense, since such memory-to-memory devices will mostly
> >
> > being
> >
> > > used from codecs context. And this would be more clear from user
> > > application.
> >
> > To be honest, I don't see the need for this. I think
> > TYPE_VIDEO_CAPTURE and
> > TYPE_VIDEO_OUTPUT are perfectly fine.
>
> [Hiremath, Vaibhav] Agreed, and you will also find implementation of
> driver aligned to this which I have shared with you.
>
> > > And as acknowledged by you, we can use VIDIOC_S_FMT for setting
> > > parameters.
> > >
> > > One thing I am not able to convince myself is that, using "priv"
> >
> > field
> >
> > > for custom configuration.
> >
> > I agree. Especially since you cannot use it as a pointer to addition
> > information.
> >
> > > I would prefer and recommend capability based
> > > interface, where application will query the capability of the
> >
> > device for
> >
> > > luma enhancement, filter coefficients (number of coeff and depth),
> > > interpolation type, etc...
> > >
> > > This way we can make sure that, any such future devices can be
> >
> > adapted by
> >
> > > this framework.
> >
> > The big question is how many of these capabilities are 'generic' and
> > how
> > many are very much hardware specific. I am leaning towards using the
> > extended control API for this. It's a bit awkward to implement in
> > drivers
> > at the moment, but that should improve in the future when a lot of
> > the
> > control handling code will move into the new core framework.
> >
> > I really need to know more about the sort of features that
> > omap/davinci
> > offer (and preferably also for similar devices by other
> > manufacturers).
>
> [Hiremath, Vaibhav] Hans, Can we have IRC session for this? We will
> discuss this in detail and try to get closure on it.
>
> Again I would request you to join me and mauro on IRC chat, I will be
> staying online tomorrow.

No problem (assuming we don't have another major network outage as we had 
today at work). It would be helpful if you could mail a summary of the 
capabilities that are needed but are not yet in the API. Also note that I 
have to leave at 16:15 (UTC+2).

Magnus, does the SuperH also have resizing/previewer capabilities? And if 
so, is there a datasheet available with detailed information?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
