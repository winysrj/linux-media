Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36932 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751912AbdBYXSM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 18:18:12 -0500
Date: Sun, 26 Feb 2017 01:17:55 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: camera subdevice support was Re: [PATCH 1/4] v4l2:
 device_register_subdev_nodes: allow calling multiple times
Message-ID: <20170225231754.GY16975@valkosipuli.retiisi.org.uk>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225000918.GB23662@amd>
 <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
 <20170225215321.GA29886@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170225215321.GA29886@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi! :-)

On Sat, Feb 25, 2017 at 10:53:22PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > Ok, I got the camera sensor to work. No subdevices support, so I don't
> > > have focus (etc) working, but that's a start. I also had to remove
> > > video-bus-switch support; but I guess it will be easier to use
> > > video-multiplexer patches... 
> > > 
> > > I'll have patches over weekend.
> > 
> > I briefly looked at what's there --- you do miss the video nodes for the
> > non-sensor sub-devices, and they also don't show up in the media graph,
> > right?
> 
> Yes.
> 
> > I guess they don't end up matching in the async list.
> 
> How should they get to the async list?

The patch you referred to does that. The problem is, it does make the bus
configuration a pointer as well. There should be two patches. That's not a
lot of work to separate them though. But it should be done.

> 
> > I think we need to make the non-sensor sub-device support more generic;
> > it's not just the OMAP 3 ISP that needs it. I think we need to document
> > the property for the flash phandle as well; I can write one, or refresh
> > an existing one that I believe already exists.
> > 
> > How about calling it either simply "flash" or "camera-flash"? Similarly
> > for lens: "lens" or "camera-lens". I have a vague feeling the "camera-"
> > prefix is somewhat redundant, so I'd just go for "flash" or "lens".
> 
> Actually, I'd go for "flash" and "focus-coil". There may be other
> lens properties, such as zoom, mirror movement, lens identification,
> ...

Good point. Still there may be other ways to move the lens than the voice
coil (which sure is cheap), so how about "flash" and "lens-focus"?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
