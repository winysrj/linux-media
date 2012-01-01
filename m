Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:51513 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2AAL5h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jan 2012 06:57:37 -0500
Date: Sun, 1 Jan 2012 13:57:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: v4l: how to get blanking clock count?
Message-ID: <20120101115731.GF3677@valkosipuli.localdomain>
References: <CAHG8p1Ao8UDuCytunFjvGZ1Ugd_xVU9cf_iXv6YjcRD41aMYtw@mail.gmail.com>
 <20111230213301.GA3677@valkosipuli.localdomain>
 <CAHG8p1ACi7CGFEBVaSr5G1cUMqtH8wX2mRY6n1yKF8TqgJ0oYw@mail.gmail.com>
 <20111231113529.GC3677@valkosipuli.localdomain>
 <4EFEFA08.805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EFEFA08.805@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Syöweser,

On Sat, Dec 31, 2011 at 01:03:20PM +0100, Sylwester Nawrocki wrote:
> On 12/31/2011 12:35 PM, Sakari Ailus wrote:
> > On Sat, Dec 31, 2011 at 02:57:31PM +0800, Scott Jiang wrote:
> >> 2011/12/31 Sakari Ailus <sakari.ailus@iki.fi>:
> >>> On Fri, Dec 30, 2011 at 03:20:43PM +0800, Scott Jiang wrote:
> >>>> Our bridge driver needs to know line clock count including active
> >>>> lines and blanking area.
> >>>> I can compute active clock count according to pixel format, but how
> >>>> can I get this in blanking area in current framework?
> >>>
> >>> Such information is not available currently over the V4L2 subdev interface.
> >>> Please see this patchset:
> >>>
> >>> <URL:http://www.spinics.net/lists/linux-media/msg41765.html>
> >>>
> >>> Patches 7 and 8 are probably the most interesting for you. This is an RFC
> >>> patchset so the final implementation could well still change.
> >>>
> >> Hi Sakari,
> >>
> >> Thanks for your reply. Your patch added VBLANK and HBLANK control, but
> >> my case isn't a user control.
> >> That is to say, you can't specify a blanking control value for sensor.
> > 
> > I the case of your bridge, that may not be possible, but that's the only one
> > I've heard of so I think it's definitely a special case. In that case the
> > sensor driver can't be allowed to change the blanking periods while
> > streaming is ongoing.
> 
> I agree, it's just a matter of adding proper logic at the sensor driver.
> However it might be a bit tricky, the bridge would have to validate blanking
> values before actually enabling streaming.

I'd rather add a way to the control framework to set controls busy. The
busy state would likely need to be a count, since the driver itself also
must be able to set controls busy. It could also keep track of who did set
those controls busy to ease debugging.

The sensor driver also must set dependent controls busy.

> > framesamples proposed by Sylwester for v4l2_mbus_framefmt could, and
> > probably should, be exposed as a control with similar property.
> 
> Yeah, I'm going to try to add it to your proposed image source control
> class.

Sounds good to me.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
