Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:44355 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbZCaEzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 00:55:15 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Koen Kooi <k.kooi@student.utwente.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"R, Sivaraj" <sivaraj@ti.com>, "Hadli, Manjunath" <mrh@ti.com>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"Kumar, Purushotam" <purushotam@ti.com>
Date: Tue, 31 Mar 2009 10:24:51 +0530
Subject: RE: [RFC] Stand-alone Resizer/Previewer Driver support under V4L2
 framework
Message-ID: <19F8576C6E063C45BE387C64729E73940427E3F7D3@dbde02.ent.ti.com>
References: <19F8576C6E063C45BE387C64729E73940427E3F70B@dbde02.ent.ti.com>
 <0835E36E-BB8D-4B15-BFD7-1430350B8E18@student.utwente.nl>
In-Reply-To: <0835E36E-BB8D-4B15-BFD7-1430350B8E18@student.utwente.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Koen Kooi [mailto:k.kooi@student.utwente.nl]
> Sent: Monday, March 30, 2009 8:54 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; Aguirre Rodriguez, Sergio Alberto;
> DongSoo(Nathaniel) Kim; Toivonen Tuukka.O (Nokia-D/Oulu); linux-
> omap@vger.kernel.org; Nagalla, Hari; Sakari Ailus; Hans Verkuil;
> Jadav, Brijesh R; R, Sivaraj; Hadli, Manjunath; Shah, Hardik; Kumar,
> Purushotam
> Subject: Re: [RFC] Stand-alone Resizer/Previewer Driver support
> under V4L2 framework
> 
> Op 30 mrt 2009, om 16:34 heeft Hiremath, Vaibhav het volgende
> geschreven:
> 
> > Hi,
> >
> > With reference to the mail-thread started by Sakari on Resizer
> > driver interface,
> >
> > http://marc.info/?l=linux-omap&m=123628392325716&w=2
> >
> > I would like to bring some issues and propose changes to adapt
> such
> > devices under V4L2 framework. Sorry for delayed response on this
> > mail-thread, actually I was on vacation.
> 
> I extracted a patch from that branch, but I can't figure out how to
> actually enable the resizer on beagleboard, overo and omapzoom,
> since
> the patches to do that seem to be missing from the branches of the
> ISP
> tree. Any clue where I can get those?

[Hiremath, Vaibhav] If I understand correctly, Sakari has removed stand-alone drivers (both resizer and previewer) from his patch-sets. I have ported it for our release. And this RFC is about supporting these drivers, since the current implementation has custom interface.

> Also, any test apps for the new code? AIUI dmai doesn't understand
> the
> new code yet.
> 
[Hiremath, Vaibhav] I can provide you the sample application, can you please provide me your code-base for ISP and resizer?

> regards,
> 
> Koen
