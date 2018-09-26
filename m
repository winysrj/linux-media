Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.intenta.de ([178.249.25.132]:30661 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbeIZQhH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 12:37:07 -0400
Date: Wed, 26 Sep 2018 12:24:42 +0200
From: Helmut Grohne <helmut.grohne@intenta.de>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>,
        "rajmohan.mani@intel.com" <rajmohan.mani@intel.com>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "ricardo.ribalda@gmail.com" <ricardo.ribalda@gmail.com>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "ping-chung.chen@intel.com" <ping-chung.chen@intel.com>,
        "andy.yeh@intel.com" <andy.yeh@intel.com>,
        "jim.lai@intel.com" <jim.lai@intel.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "snawrocki@kernel.org" <snawrocki@kernel.org>
Subject: Re: [PATCH 0/5] Add units to controls
Message-ID: <20180926102442.wo3gzjifkosh6e2h@laureti-dev>
References: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
 <20180925114802.ywbboqlfxe56qeei@laureti-dev>
 <20180925123031.b6ay5piaqymi7kht@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20180925123031.b6ay5piaqymi7kht@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 25, 2018 at 02:30:31PM +0200, Sakari Ailus wrote:
> On Tue, Sep 25, 2018 at 01:48:02PM +0200, Helmut Grohne wrote:
> > 1. There are a number of controls whose value is not easily described as
> >    either linear or exponential. I'm faced with at least two controls
> >    that actually are floating point numbers. One with two bits for the
> >    exponent and one (strange) bit for the mantissa (no joke) and another
> >    with three bits for the exponent and four bits for the mantissa.
> >    Neither can suitably be represented.

> The proposal does not address all potential situations, that's true.
> There's no way to try to represent everything out there (without
> enumerating the values) in an easily generalised way but something can be
> done.

Sure, but the rounding control flag would address that. The rounding
control flag could also solve exponential controls. Since there is a
certain overlap here. These proposals should be discussed together. We
should avoid solving problems twice.

> There are devices such as some flash LED controllers where the flash current
> if simply a value you can pick from the list. It's currently implemented as
> an integer control. AFAIR the driver is drivers/leds/leds-aat1290.c .

Possibly, relaxing the "each control id has a fixed type" requirement is
another option. Allowing an integer menu wherever an integer is
specified could solve issues such as these in a different way.

Again it is fine that your proposal, does not cover that. Still these
uapi changes are interdependent and therefore need to be considered
together.

> The fact is that the unit is specific to hardware. The documentation
> documents something, and often suggests a unit, but if the hardware does
> something else, then that's what you get --- independently of what the
> documentation says.
> 
> Hence the need to convey it via the API.

That is vaguely convincing. It still seems like a niche case.

> Some controls could have the unit set by the framework if that makes sense.

I'd use a stronger s/could/should/ here as it directly translates into
maintenance cost.

> Most drivers shouldn't actually need to touch this if they're fine with
> defaults (whenever a control has a default).

Exactly this. Therefore I think you shouldn't update smiapp, but the
framework instead.

> A macro or two, it's not a major change. From the user space point of view,
> does it make a difference if a control has no unit or when it's not known
> what the unit is?

There are situations where there is a difference. If you count things
(e.g. reference pictures V4L2_CID_MPEG_VIDEO_MAX_REF_PIC), there is no
unit, but that's different from unknown. Having unknown separate from no
unit also helps with the transition period where controls lack units.

Therefore, i'm in favour of keeping the distinction between unknown and
no unit. Still, I don't think that merging them is fundamentally
"wrong".

> Yes, I think [V4L2_CTRL_FLAG_EXPONENTIAL] can be dropped as I suggested.

Ok. Looking forward to the rounding flag then.

> > Thus, I think that control over the rounding is tightly related to this
> > patchset and needs to be discussed together.
> 
> It addresses some of the same problem area but the implementation is
> orthogonal to this.

I don't disagree here. Still I think that the question "what should be
implemented" (not how) is dependent on those other problems.

> Providing that would probably make the base field less useful: the valid
> control values could be enumerated by the user using TRY_EXT_CTRLS without
> the need to tell the valid values are powers of e.g. two.

After dropping V4L2_CTRL_FLAG_EXPONENTIAL, the base field is
meaningless, no?

> I don't really have a strong opinion on that actually when it comes to the
> API itself. The imx208 driver could proceed to use linear relation between
> the control value and the digital gain. My worry is just the driver
> implementation: this may not be entirely trivial. There's still no way to
> address this problem in a generic way otherwise.

Yeah, I'm mostly looking at this from an uapi pov (as that is the one
that cannot be changed later) and have no good answer here. Allowing
integer menus for integers would be easy from a driver pov though.

Helmut
