Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44792 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751221AbdBZVhO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Feb 2017 16:37:14 -0500
Date: Sun, 26 Feb 2017 23:36:36 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: camera subdevice support was Re: [PATCH 1/4] v4l2:
 device_register_subdev_nodes: allow calling multiple times
Message-ID: <20170226213636.GA16975@valkosipuli.retiisi.org.uk>
References: <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225000918.GB23662@amd>
 <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
 <20170225215321.GA29886@amd>
 <20170225231754.GY16975@valkosipuli.retiisi.org.uk>
 <20170226083851.GA8840@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170226083851.GA8840@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hyvää iltaa!

On Sun, Feb 26, 2017 at 09:38:51AM +0100, Pavel Machek wrote:
> Ahoj! :-)
> 
> > > > > Ok, I got the camera sensor to work. No subdevices support, so I don't
> > > > > have focus (etc) working, but that's a start. I also had to remove
> > > > > video-bus-switch support; but I guess it will be easier to use
> > > > > video-multiplexer patches... 
> > > > > 
> > > > > I'll have patches over weekend.
> > > > 
> > > > I briefly looked at what's there --- you do miss the video nodes for the
> > > > non-sensor sub-devices, and they also don't show up in the media graph,
> > > > right?
> > > 
> > > Yes.
> > > 
> > > > I guess they don't end up matching in the async list.
> > > 
> > > How should they get to the async list?
> > 
> > The patch you referred to does that. The problem is, it does make the bus
> > configuration a pointer as well. There should be two patches. That's not a
> > lot of work to separate them though. But it should be done.
> 
> Well... This is the line I'm fighting with:
> 
> + of_parse_phandle(dev->of_node, "ti,camera-flashes",
> +							flash++)
> 
> If someone told me its fwnode equivalent, I might be able to get it to
> work. Knowing what group_id is and if I could ignore it would help a
> bit, too :-).

Right.

ACPI does not have equivalents for OF phandles. That's the background of the
problem. The port and endpoint references are a bit special: there'a a
device reference and indices of the port and the endpoint nodes.

I think you can just use the OF API for the time being until we define how
to describe flash devices with ACPI. The difference with ACPI will be
visible there almost no matter what do you do there, which is one more
reason to have that functionality in the framework (and not drivers).

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
