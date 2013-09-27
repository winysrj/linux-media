Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45088 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025Ab3I0LfK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Sep 2013 07:35:10 -0400
Date: Fri, 27 Sep 2013 12:34:58 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] media: rc: OF: Add Generic bindings for
 remote-control
Message-ID: <20130927113458.GB18672@e106331-lin.cambridge.arm.com>
References: <1380274391-26577-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380274391-26577-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 27, 2013 at 10:33:11AM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch attempts to collate generic bindings which can be used by
> the remote control hardwares. Currently the list is not long as there
> are only 2 drivers which are device tree'd.
> 
> Mainly this patch tries to document few bindings used by ST IRB driver
> which can be generic as well. This document also add fews common
> bindings used by most of the drivers like, interrupts, regs, clocks and
> pinctrls.
> 
> This document can also be holding place to describe generic bindings
> used in remote controls devices.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---
> Hi All, 
> Following Stephen Warren's suggestions at https://lkml.org/lkml/2013/9/24/452
> this patch is an attempt to document such generic bindings in a common
> document.
> 
> This document currently collates all the generic bindings used with
> remote-controls and act as holding place to describe generic bindings for
> remote controls.
> 
> Comments?
> 
> Thanks,
> srini
> 
>  .../devicetree/bindings/media/remote-control.txt   |   31 ++++++++++++++++++++
>  1 files changed, 31 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/remote-control.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/remote-control.txt b/Documentation/devicetree/bindings/media/remote-control.txt
> new file mode 100644
> index 0000000..901ea56
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/remote-control.txt
> @@ -0,0 +1,31 @@
> +Generic device tree bindings for remote control.
> +
> +properties:
> +	- compatible: Can contain any remote control driver compatible string.
> +	  example: "st-comms-irb, "gpio-ir-receiver".

This is more generic than remote control, could this not just be left
for the specific binding to describe?

> +	- reg: Base physical address of the controller and length of memory
> +	  mapped region.

What if it's on a bus that isn't memory mapped (e.g. i2c, SPI)?

> +	- interrupts: Interrupt-specifier for the sole interrupt generated by
> +	  the device. The interrupt specifier format depends on the
> +	  interrupt controller parent. Iff the device supports interrupts.

What if it has multiple interrupts, and has interrupts-names?

It might be better to only describe the properties that relate
specifically to remote controls, rather than listing all of the generic
properties that device tree bidnings may have. That would match the
style of the clock bindings.

> +	- rx-mode: Can be "infrared" or "uhf". rx-mode should be present iff
> +	  the rx pins are wired up.

I'm unsure on this. What if the device has multiple receivers that can
be independently configured? What if it supports something other than
"infrared" or "uhf"? What if a device can only be wired up as
"infrared"? 

I'm not sure how generic these are, though we should certainly encourage
bindings that can be described this way to be described in the same way.

> +	- tx-mode: Can be "infrared" or "uhf". tx-mode should be present iff
> +	  the tx pins are wired up.

I have similar concerns here to those for the rx-mode property.

> +
> +Optional properties:
> +	- linux,rc-map-name: Linux specific remote control map name. Refer to
> +	  include/media/rc-map.h for full list of maps.

We shouldn't refer to Linux specifics (i.e. headers) in general in
bindings. While it's possible to relax that a bit for linux,*
properties, I'd prefer to explicitly list elements in the binding. That
prevents the ABI from changing under our feet by someone altering what
looks like a completely internal header file.

> +	- pinctrl-names, pinctrl-0: The pincontrol settings to configure muxing
> +	  properly for the device pins.
> +	- clocks : phandle with clock-specifier pair for the device specified
> +	  in compatible.

While devices may have these, they're also more general than remote
control devices. I'm not sure that they need to be listed here when they
need to be described fully in any binding that needs them anyway,
especially as this gives an impression that they are valid for bindings
that don't need them.

I think what we actually need to document is the process of creating a
binding in such a way as to encourage uniformity. Something like the
following steps:

1. Look to see if a binding already exists. If so, use it.

2. Is there a binding for a compatible device? If so, use/extend it.

3. Is there a binding for a similar (but incompatible) device? Use it as
   a template, possibly factor out portions into a class binding if
   those portions are truly general.

4. Is there a binding for the class of device? If so, build around that,
   possibly extending it.

5. If there's nothing relevant, create a binding aiming for as much
   commonality as possible with other devices of that class that may
   have bindings later.

Cheers,
Mark.

> +
> +example:
> +
> +	rc: rc@fe518000 {
> +		compatible	= "st,comms-irb";
> +		reg		= <0xfe518000 0x234>;
> +		interrupts	= <0 203 0>;
> +		rx-mode		= "infrared";
> +	};
> -- 
> 1.7.6.5
> 
> 
