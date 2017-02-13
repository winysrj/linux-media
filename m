Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42918 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751815AbdBMKUk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 05:20:40 -0500
Date: Mon, 13 Feb 2017 12:20:35 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Rob Herring <robh@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        p.zabel@pengutronix.de
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170213102034.GI16975@valkosipuli.retiisi.org.uk>
References: <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170208213609.lnemfbzitee5iur2@rob-hp-laptop>
 <20170208223017.GA18807@amd>
 <CAL_JsqKSHvg+iB-SRd=YthauGP8mWeVF0j8X-fgLchwtOppH8A@mail.gmail.com>
 <CAL_JsqLfbAxBbXOyK0QOCc=wPe6=a+qyrAwtdbt3DtspK6oiaw@mail.gmail.com>
 <20170210195435.GA1615@amd>
 <20170210221742.GI13854@valkosipuli.retiisi.org.uk>
 <20170213095420.GA7065@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170213095420.GA7065@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Mon, Feb 13, 2017 at 10:54:20AM +0100, Pavel Machek wrote:
> Hi!
> 
> > > Take a look at the wikipedia. If you do "one at a time" at 100Hz, you
> > > can claim it is time-domain multiplex. But we are plain switching the
> > > cameras. It takes second (or so) to setup the pipeline.
> > > 
> > > This is not multiplex.
> > 
> > The functionality is still the same, isn't it? Does it change what it is if
> > the frequency might be 100 Hz or 0,01 Hz?
> 
> Well. In your living your you can have a switch, which is switch at
> much less than 0.01Hz. You can also have a dimmer, which is a PWM,
> which is switch at 100Hz or so. So yes, I'd say switch and mux are
> different things.

Light switches are mostly on/off switches. It'd be interesting to have a
light switch that you could use to light either of the light bulbs in a room
but not to switch both of them on at the same time. Or off... :-)

I wonder if everyone would be happy with a statement saying that it's a
on / on switch which is used to implement a multiplexer?

> 
> > I was a bit annoyed for having to have two drivers for switching the source
> > (one for GPIO, another for syscon / register), where both of the drivers
> > would be essentially the same with the minor exception of having a slightly
> > different means to toggle the mux setting.
> 
> Well, most of the video-bus-switch is the video4linux glue. Actual
> switching is very very small part. So.. where is the other driver?
> Looks like we have the same problem.

It's here, slightly hidden in plain sight in the same patch with the MUX
framework:

<URL:https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1328763.html>

> 
> > The MUX framework adds an API for controlling the MUX. Thus we'll need only
> > a single driver that uses the MUX framework API for V4L2. As an added bonus,
> > V4L2 would be in line with the rest of the MUX usage in the kernel.
> > 
> > The set appears to already contain a GPIO MUX. What's needed would be to use
> > the MUX API instead of direct GPIOs usage.
> 
> If there's a driver that already does switching for video4linux
> devices? Do you have a pointer?

I don't think there's one. But with MUX API, we'll be fine using a single
driver instead of two (other one for syscon on iMX).

Cc Steve and Philipp.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
