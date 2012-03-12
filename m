Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35097 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab2CLJop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 05:44:45 -0400
Received: by iagz16 with SMTP id z16so6637053iag.19
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2012 02:44:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120311090434.GH1591@valkosipuli.localdomain>
References: <1960253.l1xo097dr7@avalon>
	<1331215050-20823-2-git-send-email-sakari.ailus@iki.fi>
	<CAGGh5h37Rd9O1Hp6FHBo1KcQRdEb=2OJxGkA0aJmyWkEB9juGQ@mail.gmail.com>
	<20120311090434.GH1591@valkosipuli.localdomain>
Date: Mon, 12 Mar 2012 10:44:44 +0100
Message-ID: <CAGGh5h0bYronLv59d30yvMToBup+zS=Fb1s6fKLe07+4ac7qRQ@mail.gmail.com>
Subject: Re: [PATCH v5.1 35/35] smiapp: Add driver
From: jean-philippe francois <jp.francois@cynove.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 11 mars 2012 10:04, Sakari Ailus <sakari.ailus@iki.fi> a écrit :
> Hi François,
>
> On Thu, Mar 08, 2012 at 04:06:34PM +0100, jean-philippe francois wrote:
>> Le 8 mars 2012 14:57, Sakari Ailus <sakari.ailus@iki.fi> a écrit :
>> > Add driver for SMIA++/SMIA image sensors. The driver exposes the sensor as
>> > three subdevs, pixel array, binner and scaler --- in case the device has a
>> > scaler.
>> >
>> > Currently it relies on the board code for external clock handling. There is
>> > no fast way out of this dependency before the ISP drivers (omap3isp) among
>> > others will be able to export that clock through the clock framework
>> > instead.
>> >
>> > +       case V4L2_CID_EXPOSURE:
>> > +               return smiapp_write(
>> > +                       client,
>> > +                       SMIAPP_REG_U16_COARSE_INTEGRATION_TIME, ctrl->val);
>> > +
>> At this point, knowing pixel clock and line length, it is possible
>> to get / set the exposure in useconds or millisecond value.
>
> It is possible, but still I don't think we even want that at this level.
> This is a fairly low level interface.
>
> The exposure time in seconds can always be constructed from horizontal and
> vertical blanking and the pixel rate in the user space.
>
I think it is on the side of abstraction, not on the side of policy.
If you want to sort this in userspace, then you need to decide
on a common unit for the exposure control.

Is it a number of pixel, a number of line, anumber of quarter of line ?
If userspace does not know that, then it needs to know which kind of sensor
it is driving, and then the driver somehow failed at providing
abstraction. And I
should not have to use a library with all the quirks for all the existing
sensor out there when it could have been done at the driver level. Modularity
is generally lost when you leave the solution to userspace.

I think there are two orthogonal subject here :
-one is abstracting sensor differences, to expose sensor capabilities
in a way that is sensible or natural. Wether you set  the exposure to 50 msec
or 337 "native unit" does not change the fact that it may conflicts
with a previous
framerate settings of 1/30 sec, but it is much easier to understand
what you do using msec.

- The other subject is how to solve a particular set of constraints
with a given set
of conflicting controls. As you pointed it, framerate and exposure can be one
of those. Let's suppose the application adjust the framerate, using
hblank. Exposure will change as
a consequences . If the application wants to keep the same exposure,
it will either
   - do sensor dependant computation to compute a new "native unit"
exposure value.
   - Set the exposure to it's previous value using "natural, sensor
independent" unit.
In both cases, the exposure unit has no effect on the decision making
ability of the
application. In both cases, if the new exposure value is out of range,
a decision must be taken
wether framerate should limit exposure or not. And in this particular
case, the policy is clearly in
the driver already, since setting vblank determine the exposure setting limits.

So to sum up :
- Exposure control unit has nothing to do with policy, but is rather a
matter of useful abstraction
- Conflicting control is another orthogonal problem.

Jean-Philippe François
