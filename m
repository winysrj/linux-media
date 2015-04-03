Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46575 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751435AbbDCMP0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2015 08:15:26 -0400
Date: Fri, 3 Apr 2015 15:15:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v1 09/11] DT: Add documentation for exynos4-is 'flashes'
 property
Message-ID: <20150403121523.GM20756@valkosipuli.retiisi.org.uk>
References: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
 <1426863811-12516-10-git-send-email-j.anaszewski@samsung.com>
 <20150325010641.GI18321@valkosipuli.retiisi.org.uk>
 <55127732.7020004@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55127732.7020004@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Wed, Mar 25, 2015 at 09:52:02AM +0100, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 03/25/2015 02:06 AM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >On Fri, Mar 20, 2015 at 04:03:29PM +0100, Jacek Anaszewski wrote:
> >>This patch adds a description of 'flashes' property
> >>to the samsung-fimc.txt.
> >>
> >>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >>---
> >>  .../devicetree/bindings/media/samsung-fimc.txt     |    8 ++++++++
> >>  1 file changed, 8 insertions(+)
> >>
> >>diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> >>index 922d6f8..cb0e263 100644
> >>--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
> >>+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> >>@@ -40,6 +40,13 @@ should be inactive. For the "active-a" state the camera port A must be activated
> >>  and the port B deactivated and for the state "active-b" it should be the other
> >>  way around.
> >>
> >>+Optional properties:
> >>+
> >>+- flashes - Array of phandles to the flash LEDs that can be controlled by the
> >>+	    sub-devices contained in this media device. Flash LED is
> >>+	    represented by a child node of a flash LED device
> >
> >This should be in
> >Documentation/devicetree/bindings/media/video-interfaces.txt.
> >
> >Should flash devices be associated with sensors somehow rather than ISPs?
> >That's how they commonly are arranged, however that doesn't limit placing
> >them in silly places.
> >
> >I'm not necessarily saying the flashes-property should be present in
> >sensor's DT nodes, but it'd be good to be able to make the association if
> >it's there.
> 
> I know of a SoC, which drives the flash from its on-chip ISP. The GPIO
> connected to the flash controller's external strobe pin can be
> configured so that the signal is routed to it from the ISP or from
> CPU (for software strobe mode).
> 
> I think that Sylwester could say more in this subject.

Yeah, some ISPs can also generate strobe signals. Otherwise this would be
the job of the sensor, sadly many module vendors ignore the sensor strobe
signal routing even when it's available. The sensor is by far in the best
position to trigger the flash since it has the best readout timing
information.

Currently we have no way to express this, I think what's first needed is the
data in the DT. Probably the flash driver and the driver that provides the
strobe signal should both be aware of this. User space interface wise the
strobe source control could be used --- we'd just need new menu entries.

> 
> 
> >>+	    (see Documentation/devicetree/bindings/leds/common.txt).
> >>+
> >>  The 'camera' node must include at least one 'fimc' child node.
> >>
> >>
> >>@@ -166,6 +173,7 @@ Example:
> >>  		clock-output-names = "cam_a_clkout", "cam_b_clkout";
> >>  		pinctrl-names = "default";
> >>  		pinctrl-0 = <&cam_port_a_clk_active>;
> >>+		flashes = <&camera_flash>, <&system_torch>;
> >>  		status = "okay";
> >>  		#address-cells = <1>;
> >>  		#size-cells = <1>;
> >
> >There will be other kind of devices that have somewhat similar relationship.
> >They just haven't been defined yet. Lens controllers or EEPROM for instance.
> >The two are an integral part of a module, something which is not modelled in
> >DT in any way, but perhaps should be.
> 
> Do you suggest using more generic name than 'flashes'?

So far I don't have a better suggestion for the name of the property.
However, it'd be good to be able to associate the flash to a sensor. I
wonder how wrong would it be to put the flashes property to the port node...

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
