Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52493 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab3I3Old (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 10:41:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>, LDOC <linux-doc@vger.kernel.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] media: i2c: adv7343: fix the DT binding properties
Date: Mon, 30 Sep 2013 16:41:38 +0200
Message-ID: <12127401.nFSuWlICDy@avalon>
In-Reply-To: <CA+V-a8sEPAFz=Jo9LdwRf5QtnY6TFXzSTrtHQuyeb3uSEYCvSQ@mail.gmail.com>
References: <1379073471-7244-1-git-send-email-prabhakar.csengg@gmail.com> <CA+V-a8u5_rhxTgkVgCbtmGpaZCt2ciu4vABW4t80aSp7csttnw@mail.gmail.com> <CA+V-a8sEPAFz=Jo9LdwRf5QtnY6TFXzSTrtHQuyeb3uSEYCvSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On Monday 30 September 2013 18:57:01 Prabhakar Lad wrote:
> On Mon, Sep 23, 2013 at 8:18 AM, Prabhakar Lad wrote:
> > On Fri, Sep 20, 2013 at 3:22 PM, Sylwester Nawrocki wrote:
> >> On 09/20/2013 10:11 AM, Prabhakar Lad wrote:
> >>> OK I will, just send out a fix up patch which fixes the mismatch between
> >>> names for the rc-cycle, and later send out a patch which removes the
> >>> platform data usage for next release with proper DT bindings.
> >> 
> >> I think the binding need to be fully corrected now, I just meant to not
> >> touch the board file, i.e. leave non-dt support unchanged.
> > 
> > Ok
> > 
> >>> I'm OK with making regulator properties as optional, But still it would
> >>> change the meaning of what DT is, we know that the VDD/VDD_IO .. etc
> >>> pins are required properties (but still making them as optional) :-(
> >>> 
> >>> I think there might several devices where this situation may arise so
> >>> just thinking of a alternative solution.
> >>> 
> >>> say we have property 'software-regulator' which takes true/false(0/1)
> >>> If set to true we make the regulators as required property or else we
> >>> assume it is handled and ignore it ?
> >> 
> >> I don't think this is a good idea. You would have to add a similar
> >> platform data flag for non-dt, it doesn't sound right. I can see two
> >> options here:
> >> 
> >> 1. Make the regulator properties mandatory and, e.g. define a fixed
> >>    voltage GPIO regulator in DT with an empty 'gpio' property. Then
> >>    pass a phandle to that regulator in the adv7343 *-supply properties.
> >>    For non-dt similarly a fixed voltage regulator(s) and voltage
> >>    supplies  would need to be defined in the board files.
> >> 
> >> 2. Make the properties optional and use (devm_)regulator_get_optional()
> >>    calls in the driver (a recently added function). I must admit I don't
> >>    fully understand description of this function, it currently looks
> >>    pretty much same as (devm_)regulator_get(). Thus the driver would
> >>    need to be handling regulator supplies only when non ERR_PTR() is
> >>    returned from regulator_get_optional() and otherwise assume a non
> >>    critical error. There is already quite a few example occurrences of
> >>    regulator_get_optional() usage.
> 
> The same question arises in case of the clock, The adv7343 encoder has two
> input clocks CLKIN_A and CLKIN_B. I case of da850 EVM the clock source to
> adv7343 encoder is fixed source which is enabled by default so none of the
> bridge nor the adv7343 driver cares of the clock to enable/disable. So in
> this case should I be registering  (v4l2_clk_register() /
> v4l2_clk_unregister()) a dummy clock in the bridge driver or in the board
> file ?

The fixed clock (which is a real clock, not a dummy clock) should be 
registered in board file, preferably using the common clock framework if 
that's available on your platform.

-- 
Regards,

Laurent Pinchart

