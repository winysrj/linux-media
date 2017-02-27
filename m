Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:52418 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbdB0RFl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 12:05:41 -0500
Date: Mon, 27 Feb 2017 17:04:55 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCHv4 1/9] video: add hotplug detect notifier support
Message-ID: <20170227170454.GA21222@n2100.armlinux.org.uk>
References: <20170206102951.12623-1-hverkuil@xs4all.nl>
 <20170206102951.12623-2-hverkuil@xs4all.nl>
 <20170227160841.3pgmpqwtidvjbnzn@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170227160841.3pgmpqwtidvjbnzn@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 27, 2017 at 05:08:41PM +0100, Daniel Vetter wrote:
> On Mon, Feb 06, 2017 at 11:29:43AM +0100, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Add support for video hotplug detect and EDID/ELD notifiers, which is used
> > to convey information from video drivers to their CEC and audio counterparts.
> > 
> > Based on an earlier version from Russell King:
> > 
> > https://patchwork.kernel.org/patch/9277043/
> > 
> > The hpd_notifier is a reference counted object containing the HPD/EDID/ELD state
> > of a video device.
> > 
> > When a new notifier is registered the current state will be reported to
> > that notifier at registration time.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> So I'm super late to the party because I kinda ignored all things CEC thus
> far. Ḯ'm not sure this is a great design, with two main concerns:

I'm afraid that I walked away from this after it became clear that there
was little hope for any forward progress being made in a timely manner
for multiple reasons (mainly the core CEC code being out of mainline.)

The original notifier was created in August 2015, before there was any
"hdmi codec" support or anything of the like.  At some point (I'm not
sure when) Philipp gave his ack on it, and I definitely know it was
subsequently posted for RFC in August 2016.  We're now 1.5 years after
its creation, 7 months after it was definitely publically posted to
dri-devel, and you've only just said that you don't like the approach...

Anyway, the hdmi-codec header you point at is only relevant when you
have a driver using ASoC and you have the codec part tightly integrated
with your HDMI interface.  That generally works fine there, because
generally they are on the same device, and are very dependent (due to
the need to know the HDMI bus clock.)

The same is not true of CEC though - for example, the TDA998x is
actually two devices - the HDMI bridge, and an entirely separate
TDA9950 CEC device.  They may be in the same package, but the TDA9950
was available as an entirely separate device.  The reason that is the
case is because they are entirely separate entities as far as
functionality goes: nothing on the CEC communication side electrically
depends on the HDMI bus itself.  The only common thing in common is
the connector.

>From the protocol point of view, CEC requires the "physical address"
of a device, and that is part of the EDID information from the HDMI
device - so CEC needs to have access to the EDID.  CEC also needs to
know when if/when the EDID information is updated, or when connection/
disconnection events occur so that it can re-negotiate its "logical
address", and update for any physical address changes.

For example, if you have a CEC device connected to an AV receiver,
which is in turn connected to a TV, and the TV is powered down but
the AV receiver is powered up, then the AV receiver will give all
devices connected to it a physical address to the best of its
knowledge.  Turn the TV on, and the physical address will change
(especially so if the AV receiver has been moved between different
inputs on the TV.)

This all needs the HDMI driver to _notify_ the CEC part of these state
changes - you can't get away from the need to _notify_ these events.

So, what we need is:

(a) some way for CEC to be _notified_ of all HPD change events
(b) some way for CEC to query the EDID in a race free manner w.r.t. HPD

(a) pretty much involves some kind of notification system.  It doesn't
matter whether it's a real notifier, or a struct of function pointers,
the effect is going to be the same no matter what - the basic requirement
is that we run some code in the CEC side when a HPD state change occurs.
Given that, what you seem to be objecting to (wrt locking on this) is
against the fundamental requirement that CEC needs to track the HPD
state.

(b) can be done in other ways, but I'd suggest reversing the design (iow,
having CEC explicitly query the HDMI part for the current EDID) is more
racy than having the HDMI part notify CEC - you have the situation where
CEC could be querying the EDID on one CPU while HDMI on another CPU is
saying that the HPD changed state.

The query approach also carries with it a whole new set of locking issues,
because we can get into this situation:

 HDMI              CEC
  --- HPD insert --->
  <--- EDID read ----

The problem then is that if HDMI holds a lock while sending the HPD insert
message, and it tries to take the same lock when supplying the EDID back
to CEC, you have an immediate deadlock.

So, given that HDMI needs to notify CEC about HPD changes, it also makes
sense to keep the overall flow of data the same for everything - avoid
back-queries, and have HDMI notify CEC of the new EDID.

It also avoids the problem where we may see HPD assert, but it may take
some time for the EDID to become available from HDMI (eg, in the case
of TDA998x, we have to wait a while before even attempting to read the
EDID.)

The last point on EDID is one about the source of the EDID (eg, firmware-
loaded EDID from disk).  That won't work for CEC, since loading a fixed
EDID off disk will not give the correct physical address, and so HDMI
routing will break.  That could be worked around by having userspace
modify the loaded EDID, but that sounds like making the job unnecessarily
hard, when the correct information is only available in the sink's EDID.

When I created the notifier, the obvious problem was how does a driver
receiving a notify message know that it should process that message -
and I chose to supply the source "struct device" with each message.
This would be the HDMI interface itself, and using "struct device"
gives a firmware/no-firmware independent way of identifying the source.

For cases like the TDA998x and dw-hdmi, firmware doesn't get involved
with this: in both cases, the drivers declare their CEC device as a
platform device, so the relationship between the two struct device's
is known.  In the case of a stand-alone TDA9950, then the struct
device for the HDMI side needs to be indicated by firmware, and it's
possible to get the struct device corresponding with a firmware node.

For setups like i915, I would not expect i915 to want to use this, as
I would imagine that (if they did support CEC) CEC would be tightly
integrated, following the pattern of ultra-tight integration of
everything in i915 hardware (it seems to program everything through
the GPU stream.)

If you can think of a better approach, then I'm sure there's lots of
people who'd be willing to do the coding for it... if not, I'm not
sure where we go from here (apart from keeping code in private/vendor
trees.)

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
