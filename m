Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:45591 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938821AbdLSJMq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 04:12:46 -0500
Received: by mail-wr0-f176.google.com with SMTP id h1so18102566wre.12
        for <linux-media@vger.kernel.org>; Tue, 19 Dec 2017 01:12:45 -0800 (PST)
Date: Tue, 19 Dec 2017 10:12:43 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, jmondi <jacopo@jmondi.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [RFC 1/1] v4l: async: Use endpoint node, not device node, for
 fwnode match
Message-ID: <20171219091243.GY32148@bigcity.dyn.berto.se>
References: <20171204210302.24707-1-sakari.ailus@linux.intel.com>
 <20171206155748.GF31989@bigcity.dyn.berto.se>
 <20171207073950.22wkpqy5l335ylo5@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171207073950.22wkpqy5l335ylo5@kekkonen.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hej Sakari,

Ledsen för sent svar.

On 2017-12-07 09:39:51 +0200, Sakari Ailus wrote:
> Hej Niklas,
> 
> Tack för dina kommentarer!
> 
> On Wed, Dec 06, 2017 at 04:57:48PM +0100, Niklas Söderlund wrote:
> > CC Jacopo, Kieran
> > 
> > Hi Sakari,
> > 
> > Thanks for your patch.
> > 
> > On 2017-12-04 23:03:02 +0200, Sakari Ailus wrote:
> > > V4L2 async framework can use both device's fwnode and endpoints's fwnode
> > > for matching the async sub-device with the sub-device. In order to proceed
> > > moving towards endpoint matching assign the endpoint to the async
> > > sub-device.
> > 
> > Endpoint matching I think is the way to go forward. It will solve a set 
> > of problems that exists today. So I think this a good step in the right 
> > direction.
> > 
> > > 
> > > As most async sub-device drivers (and the related hardware) only supports
> > > a single endpoint, use the first endpoint found. This works for all
> > > current drivers --- we only ever supported a single async sub-device per
> > > device to begin with.
> > 
> > This assumption is not true, the adv748x exposes multiple subdevice from 
> > a single device node in DT and registers them using different endpoints.  
> > Now the only user of the adv748x driver I know of is the rcar-csi2 
> > driver which is not yet upstream so this can be consider a special case.
> 
> Right, the adv748x is an exception to this but I could argue it should
> never have been merged in its current state: it does not work with other
> bridge / ISP drivers.

Agreed, the issue of endpoint matching should have been solved before.  
As the adv748x driver poses yet another dimension of this issue, 
multiple endpoints decribed in DT which should be matched to different 
subdevices registerd from the same driver.

I think this is a use-case we should consider when looking at this, what 
do you think?

> 
> > 
> > Unfortunately this patch do break already existing configurations 
> > upstream :-( For example the Koelsch board, from r8a7791-koelsch.dts:
> > 
> > hdmi-in {
> >         compatible = "hdmi-connector";
> >         type = "a";
> > 
> >         port {
> >                 hdmi_con_in: endpoint {
> >                         remote-endpoint = <&adv7612_in>;
> >                 };
> >         };
> > };
> > 
> > hdmi-in@4c {
> >         compatible = "adi,adv7612";
> >         reg = <0x4c>;
> >         interrupt-parent = <&gpio4>;
> >         interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
> >         default-input = <0>;
> > 
> >         ports {
> >                 #address-cells = <1>;
> >                 #size-cells = <0>;
> > 
> >                 port@0 {
> >                         reg = <0>;
> >                         adv7612_in: endpoint {
> >                                 remote-endpoint = <&hdmi_con_in>;
> >                         };
> >                 };
> > 
> >                 port@2 {
> >                         reg = <2>;
> >                         adv7612_out: endpoint {
> >                                 remote-endpoint = <&vin0ep2>;
> >                         };
> >                 };
> >         };
> > };
> > 
> > &vin0 {
> >         status = "okay";
> >         pinctrl-0 = <&vin0_pins>;
> >         pinctrl-names = "default";
> > 
> >         port {
> >                 #address-cells = <1>;
> >                 #size-cells = <0>;
> > 
> >                 vin0ep2: endpoint {
> >                         remote-endpoint = <&adv7612_out>;
> >                         bus-width = <24>;
> >                         hsync-active = <0>;
> >                         vsync-active = <0>;
> >                         pclk-sample = <1>;
> >                         data-active = <1>;
> >                 };
> >         };
> > };
> > 
> > Here the adv7612 driver would register a subdevice using the endpoint 
> > 'hdmi-in@4c/ports/port@0/endpoint' while the rcar-vin driver which uses 
> 
> The adv7612 needs to register both of these endpoints. I wonder if there
> are repercussions by doing that. 

I fear so too.

I don't think there is any support in the framwrk today to register the 
same subdevice twice using different fwnodes for matching, is there? If 
not this is something which we need to add.

We also need to make sure from a framwrok point of view that its 
possible for sub-devices that registers itself using two different 
endpoints could be bound to two different notifiers from two different 
remote drivers, right? I'm not sure what the state in the the framework 
is for this, do you know?

Is there anything else we need to check in the framwork before trying to 
make this change? Maybe we can add a helper much like the notifer 
helpers you posted but for sub-device drivers, which would be called 
from v4l2_async_register_subdev() to parse and register all endpoints 
with the async framework together with the device fwnode. Then the 
subdevice would work with notifiers who register both endpoints (using 
your helpers and this patch) and lens/flash devices as they are a 
special case you describe bellow. What do you think of such a solution?

> 
> > the async parsing helpers would register a notifier looking for 
> > 'hdmi-in@4c/ports/port@2/endpoint'.
> > 
> > Something like Kieran's '[PATCH v5] v4l2-async: Match parent devices' 
> > would be needed in addition to this patch. I tried Kieran's patch 
> > together with this and it did not solve the problem upstream. I did make 
> 
> The more I've been working on this problem, the less I think
> opportunistically matching devices or endpoints is a good idea. Lens
> devices will always use device nodes and flash devices use LED nodes found
> under device nodes.

Then we need someway to inform the sub-notifer parsing helpers if it 
should register using endpoints or device nodes. When the framework 
parse for lens/flash devices it would register them with the notifier 
using device nodes, but if the helper is called directly from a driver 
it would register them using endpoint nodes. Will this cover all the 
scenarios?

> 
> It's getting messy with opportunistic matching. And as this patch shows,
> it's not that hard to convert all drivers either, so why not to do just
> that?

Yes, I think we all come to the agreement that opportunistic matching is 
not the way to go here :-)

> 
> -- 
> Hälsningar,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com

-- 
Regards,
Niklas Söderlund
