Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:38930 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbZCEIrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 03:47:25 -0500
Date: Thu, 5 Mar 2009 00:47:22 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
cc: ext Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"camera@ok.research.nokia.com" <camera@ok.research.nokia.com>
Subject: Re: identifying camera sensor
In-Reply-To: <200903050946.47565.tuukka.o.toivonen@nokia.com>
Message-ID: <Pine.LNX.4.58.0903050044280.24268@shell2.speakeasy.net>
References: <63862.62.70.2.252.1236178340.squirrel@webmail.xs4all.nl>
 <200903050946.47565.tuukka.o.toivonen@nokia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Tuukka.O Toivonen wrote:
> On Wednesday 04 March 2009 16:52:20 ext Hans Verkuil wrote:
> > > Alternatively, VIDIOC_QUERYCAP could be used to identify the sensor.
> > > Would it make more sense if it would return something like
> > >   capability.card:  `omap3/smia-sensor-12-1234-5678//'
> > > where 12 would be manufacturer_id, 1234 model_id, and
> > > 5678 revision_number?
> >
> > Yuck :-)
>
> Agreed :)
>
> Also, if there are many slaves, the length of the capability.card
> field is not sufficient.
>
> From: Trent Piepho <xyzzy@speakeasy.org>
> > You could always try to decode the manufacturer name and maybe even the
> > model name.  After all, pretty much every other driver does this.
>
> That would be possible, but the driver would then need a device name table
> which would need to be modified whenever a new chip comes up :(

Pretty much every single driver does this, so it's apparently not that
hard.

Another thing to consider, is that if the sensor has certain properties
that you want to know in user space, maybe the driver could provide those
properties drectly, instead of providing the sensor id and letting user
space app figure the properties from the id.
