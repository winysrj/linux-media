Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:35550 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750857AbdLGHj5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Dec 2017 02:39:57 -0500
Date: Thu, 7 Dec 2017 09:39:51 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org, jmondi <jacopo@jmondi.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [RFC 1/1] v4l: async: Use endpoint node, not device node, for
 fwnode match
Message-ID: <20171207073950.22wkpqy5l335ylo5@kekkonen.localdomain>
References: <20171204210302.24707-1-sakari.ailus@linux.intel.com>
 <20171206155748.GF31989@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171206155748.GF31989@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hej Niklas,

Tack för dina kommentarer!

On Wed, Dec 06, 2017 at 04:57:48PM +0100, Niklas Söderlund wrote:
> CC Jacopo, Kieran
> 
> Hi Sakari,
> 
> Thanks for your patch.
> 
> On 2017-12-04 23:03:02 +0200, Sakari Ailus wrote:
> > V4L2 async framework can use both device's fwnode and endpoints's fwnode
> > for matching the async sub-device with the sub-device. In order to proceed
> > moving towards endpoint matching assign the endpoint to the async
> > sub-device.
> 
> Endpoint matching I think is the way to go forward. It will solve a set 
> of problems that exists today. So I think this a good step in the right 
> direction.
> 
> > 
> > As most async sub-device drivers (and the related hardware) only supports
> > a single endpoint, use the first endpoint found. This works for all
> > current drivers --- we only ever supported a single async sub-device per
> > device to begin with.
> 
> This assumption is not true, the adv748x exposes multiple subdevice from 
> a single device node in DT and registers them using different endpoints.  
> Now the only user of the adv748x driver I know of is the rcar-csi2 
> driver which is not yet upstream so this can be consider a special case.

Right, the adv748x is an exception to this but I could argue it should
never have been merged in its current state: it does not work with other
bridge / ISP drivers.

> 
> Unfortunately this patch do break already existing configurations 
> upstream :-( For example the Koelsch board, from r8a7791-koelsch.dts:
> 
> hdmi-in {
>         compatible = "hdmi-connector";
>         type = "a";
> 
>         port {
>                 hdmi_con_in: endpoint {
>                         remote-endpoint = <&adv7612_in>;
>                 };
>         };
> };
> 
> hdmi-in@4c {
>         compatible = "adi,adv7612";
>         reg = <0x4c>;
>         interrupt-parent = <&gpio4>;
>         interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
>         default-input = <0>;
> 
>         ports {
>                 #address-cells = <1>;
>                 #size-cells = <0>;
> 
>                 port@0 {
>                         reg = <0>;
>                         adv7612_in: endpoint {
>                                 remote-endpoint = <&hdmi_con_in>;
>                         };
>                 };
> 
>                 port@2 {
>                         reg = <2>;
>                         adv7612_out: endpoint {
>                                 remote-endpoint = <&vin0ep2>;
>                         };
>                 };
>         };
> };
> 
> &vin0 {
>         status = "okay";
>         pinctrl-0 = <&vin0_pins>;
>         pinctrl-names = "default";
> 
>         port {
>                 #address-cells = <1>;
>                 #size-cells = <0>;
> 
>                 vin0ep2: endpoint {
>                         remote-endpoint = <&adv7612_out>;
>                         bus-width = <24>;
>                         hsync-active = <0>;
>                         vsync-active = <0>;
>                         pclk-sample = <1>;
>                         data-active = <1>;
>                 };
>         };
> };
> 
> Here the adv7612 driver would register a subdevice using the endpoint 
> 'hdmi-in@4c/ports/port@0/endpoint' while the rcar-vin driver which uses 

The adv7612 needs to register both of these endpoints. I wonder if there
are repercussions by doing that. 

> the async parsing helpers would register a notifier looking for 
> 'hdmi-in@4c/ports/port@2/endpoint'.
> 
> Something like Kieran's '[PATCH v5] v4l2-async: Match parent devices' 
> would be needed in addition to this patch. I tried Kieran's patch 
> together with this and it did not solve the problem upstream. I did make 

The more I've been working on this problem, the less I think
opportunistically matching devices or endpoints is a good idea. Lens
devices will always use device nodes and flash devices use LED nodes found
under device nodes.

It's getting messy with opportunistic matching. And as this patch shows,
it's not that hard to convert all drivers either, so why not to do just
that?

-- 
Hälsningar,

Sakari Ailus
sakari.ailus@linux.intel.com
