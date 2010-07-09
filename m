Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41059 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab0GIKsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 06:48:20 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"matti.j.aaltonen@nokia.com" <matti.j.aaltonen@nokia.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"eduardo.valentin@nokia.com" <eduardo.valentin@nokia.com>
Date: Fri, 9 Jul 2010 16:18:04 +0530
Subject: RE: V4L2 radio drivers for TI-WL7
Message-ID: <19F8576C6E063C45BE387C64729E7394044EB96032@dbde02.ent.ti.com>
References: <594515.49257.qm@web94910.mail.in2.yahoo.com>
 <201007091240.40868.hverkuil@xs4all.nl>
In-Reply-To: <201007091240.40868.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



 
----------------
Thanks & Regards,
Pavan Savoy | x0099669
 
> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Friday, July 09, 2010 5:41 AM
> To: Savoy, Pavan
> Cc: linux-media@vger.kernel.org; matti.j.aaltonen@nokia.com; mchehab@infradead.org;
> eduardo.valentin@nokia.com
> Subject: Re: V4L2 radio drivers for TI-WL7
> 
> On Tuesday 06 July 2010 07:07:12 Pavan Savoy wrote:
> >
> > --- On Mon, 5/7/10, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > > From: Hans Verkuil <hverkuil@xs4all.nl>
> > > Subject: Re: V4L2 radio drivers for TI-WL7
> > > To: pavan_savoy@ti.com
> > > Cc: linux-media@vger.kernel.org, matti.j.aaltonen@nokia.com, mchehab@infradead.org, "pavan savoy"
> <pavan_savoy@yahoo.co.in>, eduardo.valentin@nokia.com
> > > Date: Monday, 5 July, 2010, 11:51 AM
> > > On Friday 02 July 2010 09:01:34 Pavan
> > > Savoy wrote:
> > > > Hi,
> > > >
> > > > We have/in process of developing a V4L2 driver for the
> > > FM Radio on the Texas Instruments WiLink 7 module.
> > > >
> > > > For transport/communication with the chip, we intend
> > > to use the shared transport driver currently staged in
> > > mainline at drivers/staging/ti-st/.
> > > >
> > > > To which tree should I generate patches against? is
> > > the tree
> > > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> > > > fine ? to be used with the v4l_for_2.6.35 branch ?
> > >
> > > You patch against git://git.linuxtv.org/v4l-dvb.git.
> > >
> > > >
> > > > Also, this is over the UART/TTY unlike the WL1273 i2c
> > > mfd driver...
> > >
> > > Is the WiLink 7 a platform device (i.e. an integral part of
> > > the CPU) or a separate
> > > chip that can be used with any hardware?
> > >
> > > Will the FM Radio always be controlled over a UART/TTY bus
> > > or is that specific
> > > to your development platform?
> >
> > WiLink 7 would be a peripheral which has 1 interface with apps processor being UART, more details at,
> >
> >
> http://www.google.co.in/url?sa=t&source=web&cd=3&ved=0CBQQFjAC&url=http%3A%2F%2Ffocus.ti.com%2Fgeneral%2Fdoc
> s%2Fwtbu%2Fwtbuproductcontent.tsp%3FtemplateId%3D6123%26navigationId%3D12859%26contentId%3D67453%26DCMP%3Dwt
> bu_wilink7_2010%26HQS%3DOther%2BPR%2Bwilink7videos&ei=d7kyTKPXMoTGlQfJ-7W-
> Cw&usg=AFQjCNEjN2jc9TdSDWDRtWcmbZn6Szhbug&sig2=DN4gAQls9AdOeHQhlPlvjA
> >
> > Since there exists only 1 interface for all BT/FM and GPS cores on chip, a shared transport driver has
> been developed and placed at drivers/staging/ti-st/
> 
> It sounds like this will be typically used in embedded systems and implemented as a
> platform device.

Yes it is. It is a two-faced device driver. It essentially is a TTY ldisc driver which is mainly used for the transport purposes, and has the overall context of a platform device driver.

> > Would it be suitable if we place the V4L2 FM driver at drivers/staging/ti-st/ to ? Since we don't have the
> common interface headers such as st.h in include/linux..
> 
> Staging is fine. This driver can still be merged through the v4l-dvb repositories,
> even if it is in staging.

Yes, Thanks on this one. However I am not sure how it would affect the current development of the 1273 drivers (from nokia), since the V4L2 driver which we have for 1283 - would essentially have the same sort of engine which forms the commands/interprets the responses, with the only difference being the transport (i2c vs. TTY).
Matti / Edurado  - Please comment ...

> Regards,
> 
>          Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
