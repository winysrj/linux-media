Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59990 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751246AbdBYNpt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 08:45:49 -0500
Date: Sat, 25 Feb 2017 15:44:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [PATCH 1/4] v4l2: device_register_subdev_nodes: allow calling
 multiple times
Message-ID: <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225000918.GB23662@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170225000918.GB23662@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 25, 2017 at 01:09:18AM +0100, Pavel Machek wrote:
> On Tue 2017-02-21 13:11:04, Sakari Ailus wrote:
> > On Tue, Feb 21, 2017 at 12:07:21PM +0100, Pavel Machek wrote:
> > > On Mon 2017-02-20 15:56:36, Sakari Ailus wrote:
> > > > On Mon, Feb 20, 2017 at 03:09:13PM +0200, Sakari Ailus wrote:
> > > > > I've tested ACPI, will test DT soon...
> > > > 
> > > > DT case works, too (Nokia N9).
> > > 
> > > Hmm. Good to know. Now to figure out how to get N900 case to work...
> > > 
> > > AFAICT N9 has CSI2, not CSI1 support, right? Some of the core changes
> > > seem to be in, so I'll need to figure out which, and will still need
> > > omap3isp modifications...
> > 
> > Indeed, I've only tested for CSI-2 as I have no functional CSI-1 devices.
> > 
> > It's essentially the functionality in the four patches. The data-lane and
> > clock-name properties have been renamed as data-lanes and clock-lanes (i.e.
> > plural) to match the property documentation.
> 
> Ok, I got the camera sensor to work. No subdevices support, so I don't
> have focus (etc) working, but that's a start. I also had to remove
> video-bus-switch support; but I guess it will be easier to use
> video-multiplexer patches... 
> 
> I'll have patches over weekend.

I briefly looked at what's there --- you do miss the video nodes for the
non-sensor sub-devices, and they also don't show up in the media graph,
right?

I guess they don't end up matching in the async list.

I think we need to make the non-sensor sub-device support more generic;
it's not just the OMAP 3 ISP that needs it. I think we need to document
the property for the flash phandle as well; I can write one, or refresh
an existing one that I believe already exists.

How about calling it either simply "flash" or "camera-flash"? Similarly
for lens: "lens" or "camera-lens". I have a vague feeling the "camera-"
prefix is somewhat redundant, so I'd just go for "flash" or "lens".

At the very least the property names must be generic (not hardware
dependent) as this kind of functionality should be present in the
framework rather than in individual drivers. That'll be for later though.

Making the sub-device bus configuration a pointer should be in a separate
patch. It makes sense since the entire configuration is not valid for all
sub-devices attached to the ISP anymore. I think it originally was a
separate patch, but they probably have been merged at some point. I can't
find it right now anyway.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
