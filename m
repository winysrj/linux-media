Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48319 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab1IFGxU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 02:53:20 -0400
Date: Tue, 6 Sep 2011 09:53:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Bastian Hecht <hechtb@googlemail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH] media: Add camera controls for the ov5642 driver
Message-ID: <20110906065313.GB1393@valkosipuli.localdomain>
References: <alpine.DEB.2.02.1108171553540.17550@ipanema>
 <201108282006.09790.laurent.pinchart@ideasonboard.com>
 <CABYn4sx5jQPyLC4d6OfVbX5SSuS4TiNsB_LPoCheaOSbwM9Pzw@mail.gmail.com>
 <20110831212010.GS12368@valkosipuli.localdomain>
 <Pine.LNX.4.64.1109010911550.21309@axis700.grange>
 <20110901084722.GV12368@valkosipuli.localdomain>
 <4E5F4CE0.8050909@samsung.com>
 <20110901120801.GA12368@valkosipuli.localdomain>
 <CABYn4sx8s0nX5iooKM4XHs1Ard_nLS4ppB848EpGLS4bQbemyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABYn4sx8s0nX5iooKM4XHs1Ard_nLS4ppB848EpGLS4bQbemyw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bastian,

On Mon, Sep 05, 2011 at 09:32:55AM +0000, Bastian Hecht wrote:
> 2011/9/1 Sakari Ailus <sakari.ailus@iki.fi>:
> > On Thu, Sep 01, 2011 at 11:14:08AM +0200, Sylwester Nawrocki wrote:
> >> Hi Sakari,
> >>
> >> On 09/01/2011 10:47 AM, Sakari Ailus wrote:
> >> > On Thu, Sep 01, 2011 at 09:15:20AM +0200, Guennadi Liakhovetski wrote:
> >> >> On Thu, 1 Sep 2011, Sakari Ailus wrote:
> >> >>
> >> >>> On Wed, Aug 31, 2011 at 03:27:49PM +0000, Bastian Hecht wrote:
> >> >>>> 2011/8/28 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> >> >>> [clip]
> >> >>>>> If I'm not mistaken V4L2_CID_PRIVATE_BASE is deprecated.
> >> >>>>
> >> >>>> I checked at http://v4l2spec.bytesex.org/spec/x542.htm, googled
> >> >>>> "V4L2_CID_PRIVATE_BASE deprecated" and read
> >> >>>> Documentation/feature-removal-schedule.txt. I couldn't find anything.
> >> >>>
> >> >>> Hmm. Did you happen to check when that has been written? :)
> >> >>>
> >> >>> Please use this one instead:
> >> >>>
> >> >>> <URL:http://hverkuil.home.xs4all.nl/spec/media.html>
> >> >>
> >> >> "Drivers can also implement their own custom controls using
> >> >> V4L2_CID_PRIVATE_BASE and higher values."
> >> >>
> >> >> Which specific location describes V4L2_CID_PRIVATE_BASE differently there?
> >> >
> >> > That was a general comment, not related to the private base. There's no
> >> > use for a three-year-old spec as a reference!
> >> >
> >> > The control framework does not support private controls, for example. The
> >> > controls should be put to their own class in videodev2.h nowadays, that's my
> >> > understanding. Cc Hans.
> >>
> >> Is this really the case that we close the door for private controls in
> >> the mainline kernel ? Or am I misunderstanding something ?
> >> How about v4l2_ctrl_new_custom() ?
> >>
> >> What if there are controls applicable to single driver only ?
> >> Do we really want to have plenty of such in videodev2.h ?
> >
> > We have some of those already in videodev2.h. I'm not certain if I'm happy
> > with this myself, considering e.g. that we could get a few truckloads of
> > only camera lens hardware specific controls in the near future.
> 
> So in my case (as these are controls that might be used by others too)
> I should add something like
> 
> #define V4L2_CID_BLUE_SATURATION		(V4L2_CID_CAMERA_CLASS_BASE+19)
> #define V4L2_CID_RED_SATURATION		(V4L2_CID_CAMERA_CLASS_BASE+20)

What do these two controls do? Do they control gain or something else?

> #define V4L2_CID_GRAY_SCALE_IMAGE		(V4L2_CID_CAMERA_CLASS_BASE+21)

V4L2_CID_COLOR_KILLER looks like something which would fit for the purpose.

> #define V4L2_CID_SOLARIZE_EFFECT		(V4L2_CID_CAMERA_CLASS_BASE+22)

Sounds interesting for a sensor. I wonder if this would fall under a menu
control, V4L2_CID_COLORFX.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
