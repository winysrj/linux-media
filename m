Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:45632 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425322AbdD1Sy0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 14:54:26 -0400
Date: Fri, 28 Apr 2017 11:54:22 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/8] arm: omap4: enable CEC pin for Pandaboard A4 and ES
Message-ID: <20170428185421.GK3780@atomide.com>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-2-hverkuil@xs4all.nl>
 <4355dab4-9c70-77f7-f89b-9a1cf24976cf@ti.com>
 <20170428150859.GI3780@atomide.com>
 <20170428182611.t77hv3ufstlrntmf@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20170428182611.t77hv3ufstlrntmf@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Sebastian Reichel <sre@kernel.org> [170428 11:29]:
> Hi,
> 
> On Fri, Apr 28, 2017 at 08:08:59AM -0700, Tony Lindgren wrote:
> > * Tomi Valkeinen <tomi.valkeinen@ti.com> [170428 04:15]:
> > > On 14/04/17 13:25, Hans Verkuil wrote:
> > > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > > 
> > > > The CEC pin was always pulled up, making it impossible to use it.
> > > > 
> > > > Change to PIN_INPUT so it can be used by the new CEC support.
> > ...
> > 
> > > Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > > 
> > > Tony, can you queue this? It's safe to apply separately from the rest of
> > > the HDMI CEC work.
> > 
> > Sure will do.
> 
> I guess the same patch should be applied to Droid 4?

I guess it depends if there is an external pull or not. If there's
an external pull, the internal pull needs to be disabled as otherwise
the resistors are parallel and pull value is much lower than intended.

Looks like on droid 4 we have:

$ grep 09a /sys/kernel/debug/pinctrl/4a100040.pinmux/pins
pin 45 (PIN45) 4a10009a 00000118 pinctrl-single

$ grep PULL_ENA ./include/dt-bindings/pinctrl/omap.h
#define PULL_ENA                (1 << 3)
...

So bit 3 is set and internal pull is enabled in pinmux_dss_hdmi_pins
for droid 4 also.

The pull seems to be enabled in the Android kernel too:

# rwmem -s16 0x4a10009a
0x4a10009a = 0x0118

So needs to be tested, what's the simplest test to check the CEC?

Hmm I wonder if disabling the internal pull also allows removing
the "regulator-always-on" hack for hdmi_regulator there? Without
regulator-always-on I noticed that HDMI panel resolutions are not
detected. This I can test easily..

Regards,

Tony
