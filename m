Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:37999 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbZCCXRB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 18:17:01 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
Date: Tue, 3 Mar 2009 17:16:47 -0600
Subject: RE: [RFC 0/5] Sensor drivers for OMAP3430SDP and LDP camera
Message-ID: <A24693684029E5489D1D202277BE89442E1D945C@dlee02.ent.ti.com>
In-Reply-To: <200903032347.19548.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Tuesday, March 03, 2009 4:47 PM
> To: Aguirre Rodriguez, Sergio Alberto
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Sakari Ailus;
> Tuukka.O Toivonen; Hiroshi DOYU; DongSoo(Nathaniel) Kim; MiaoStanley;
> Nagalla, Hari; Hiremath, Vaibhav; Lakhani, Amish; Menon, Nishanth
> Subject: Re: [RFC 0/5] Sensor drivers for OMAP3430SDP and LDP camera
> 
> On Tuesday 03 March 2009 21:44:12 Aguirre Rodriguez, Sergio Alberto wrote:
> > This patch series depends on the following patches:
> >
> >  - "Add TWL4030 registers", posted by Tuukka Toivonen on March 2nd.
> >  - "OMAP3 ISP and camera drivers" patch series, posted by Sakari Ailus
> on
> >    March 3rd. (Please follow his instructions to pull from gitorious.org
> > server)
> 
> Sergio, Sakari,
> 
> I'm feeling quite uncomfortable about this series with regards to the use
> of
> the v4l2-int API instead of v4l2_subdev. I know that it is on the TODO
> list, but every driver that is merged that uses v4l2-int will later mean
> extra work.
> 
> I and others have been working very hard to get the existing ioctl-based
> i2c
> modules converted in time for the 2.6.30 merge window. It looks like I'll
> be able to have it done in time (fingers crossed :-) ). So it is rather
> sad
> to see new modules that do not yet use it.
> 
> Right now the v4l2_device and v4l2_subdev framework is pretty basic and so
> the amount of work to do the conversion is still limited, but once I've
> finished my initial conversion I'll be adding lots more features, do
> cleanups, and generally improve the framework substantially. Any existing
> modules that use v4l2_device and v4l2_subdev will be updated by me. But
> I'm
> not going to do that for modules using v4l2-int, that will be the
> responsibility of the module's author when he converts it to v4l2_subdev.
> So the longer you wait, the more work that will be.
> 
> I *strongly* recommend that the conversion to the new framework is done
> first. I know it might delay inclusion of some drivers, but my expectation
> based on all the other conversions I've done until now is that it will
> actually simplify the drivers.
> 
> My experiences with it have been uniformly positive and it should be
> possible to use it as well with the ISP module or other logical
> sub-devices. There are lots of interesting possibilities there that you do
> not have with v4l2-int.

Hans,

I agree that we need to head for migration asap, but we hadn't had a chance to begin on this as some other higher priority issues were (and some still are) showing up.

Anyways, can you please point me to the latest version of the v4l2_subdev documentation so we can begin properly working on this?

Regards,
Sergio

