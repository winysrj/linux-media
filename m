Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33956 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752659AbdDKL0Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 07:26:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "crope@iki.fi" <crope@iki.fi>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v3 2/7] dt-bindings: media: Add MAX2175 binding description
Date: Tue, 11 Apr 2017 14:27:17 +0300
Message-ID: <6297638.5S79beP3Jj@avalon>
In-Reply-To: <HK2PR06MB0545282102FBC0472D9831AEC3000@HK2PR06MB0545.apcprd06.prod.outlook.com>
References: <1486479757-32128-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <14921696.qIuO4easis@avalon> <HK2PR06MB0545282102FBC0472D9831AEC3000@HK2PR06MB0545.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramesh,

On Tuesday 11 Apr 2017 09:57:45 Ramesh Shanmugasundaram wrote:
> > On Tuesday 07 Feb 2017 15:02:32 Ramesh Shanmugasundaram wrote:
> >> Add device tree binding documentation for MAX2175 Rf to bits tuner
> >> device.
> >> 
> >> Signed-off-by: Ramesh Shanmugasundaram
> >> <ramesh.shanmugasundaram@bp.renesas.com> ---
> >> 
> >>  .../devicetree/bindings/media/i2c/max2175.txt      | 61 +++++++++++++++
> >>  .../devicetree/bindings/property-units.txt         |  1 +
> >>  2 files changed, 62 insertions(+)
> >>  create mode 100644
> >> 
> >> Documentation/devicetree/bindings/media/i2c/max2175.txt
> >> 
> >> diff --git a/Documentation/devicetree/bindings/media/i2c/max2175.txt
> >> b/Documentation/devicetree/bindings/media/i2c/max2175.txt new file
> >> mode 100644
> >> index 0000000..f591ab4
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/i2c/max2175.txt

[snip]

> >> +- maxim,am-hiz	      : empty property indicates AM Hi-Z filter path
> >> is
> >> +			selected for AM antenna input. By default this
> >> +			filter path is not used.
> > 
> > Isn't this something that should be selected at runtime through a control
> > ? Or does the hardware design dictate whether the filter has to be used or
> > must not be used ?
> 
> This is dictated by the h/w design and not selectable at run-time.
> I will update these changes in the next patchset.

In that case I'm fine with a property, but could we name it in such a way that 
it describes the hardware instead of instructing the software on how to 
configure the device ? For instance (and this is a made-up example as I don't 
know exactly how this works), if the AM Hi-Z filter is required when dealing 
with AM frequencies and forbidden when dealing with other frequency bands, and 
*if* boards have to be designed specifically for one frequency band (AM, FM, 
VHF, L, ...) without any way to accept different bands, then you could instead 
use

	maxim,frequency-band = "AM";

and enable the filter accordingly in the driver. This would be in my opinion a 
better system hardware description.

-- 
Regards,

Laurent Pinchart
