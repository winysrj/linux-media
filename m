Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:45716 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938532AbdD2UVJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Apr 2017 16:21:09 -0400
Date: Sat, 29 Apr 2017 13:21:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/8] arm: omap4: enable CEC pin for Pandaboard A4 and ES
Message-ID: <20170429202104.GL3780@atomide.com>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-2-hverkuil@xs4all.nl>
 <4355dab4-9c70-77f7-f89b-9a1cf24976cf@ti.com>
 <20170428150859.GI3780@atomide.com>
 <20170428182611.t77hv3ufstlrntmf@earth>
 <20170428185421.GK3780@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170428185421.GK3780@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Tony Lindgren <tony@atomide.com> [170428 11:57]:
> The pull seems to be enabled in the Android kernel too:
> 
> # rwmem -s16 0x4a10009a
> 0x4a10009a = 0x0118
> 
> So needs to be tested, what's the simplest test to check the CEC?

So on droid 4, with the internal pull enabled cec-ctl -m does not
show anything. With the internal pull disabled, cec-ctl -m produces
the following with a lapdock:

Initial Event: State Change: PA: 1.0.0.0, LA mask: 0x4000

Event: State Change: PA: f.f.f.f, LA mask: 0x0000

Event: State Change: PA: 1.0.0.0, LA mask: 0x0000
Transmitted by Specific to Specific (14 to 14): CEC_MSG_POLL
        Tx, Not Acknowledged (4), Max Retries

Event: State Change: PA: 1.0.0.0, LA mask: 0x4000
Transmitted by Specific to all (14 to 15): CEC_MSG_REPORT_FEATURES (0xa6):
        cec-version: version-2-0 (0x06)
        all-device-types: switch (0x04)
        rc-profile: tv-profile-none (0x00)
        dev-features: 0 (0x00)
Transmitted by Specific to all (14 to 15): CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
        phys-addr: 1.0.0.0
        prim-devtype: processor (0x07)

And looking at the ifixit.com board picture, there seems to be a
IP4791CZ12 chip on droid 4. And it's docs seem to hint it has a
pull in the IP4791CZ12.

So yeah my guess is the cec internal pull should be disabled on
all omap4 devices with HDMI. I'll send a follow-up patch for that.

> Hmm I wonder if disabling the internal pull also allows removing
> the "regulator-always-on" hack for hdmi_regulator there? Without
> regulator-always-on I noticed that HDMI panel resolutions are not
> detected. This I can test easily..

The regulator-fixed is still needed, I think this GPIO regulator
powers the IP4791CZ12 which has no control channel. Not sure if
we should still have encoder-ip4791cz12.c driver for it just to
manage the regulator?

Regards,

Tony
