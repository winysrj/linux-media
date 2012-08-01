Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53406 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab2HAF7y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 01:59:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] media DT bindings
Date: Wed, 01 Aug 2012 07:59:59 +0200
Message-ID: <3134777.Df1peamEaY@avalon>
In-Reply-To: <50186A54.3@wwwdotorg.org>
References: <Pine.LNX.4.64.1207110854290.18999@axis700.grange> <1853410.hC8HZhzZI6@avalon> <50186A54.3@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stephen,

On Tuesday 31 July 2012 17:29:24 Stephen Warren wrote:
> On 07/31/2012 03:22 PM, Laurent Pinchart wrote:
> > On Tuesday 31 July 2012 14:39:07 Guennadi Liakhovetski wrote:
> ...
> 
> >> Ok, then, how about
> >> 
> >> 		#address-cells = <1>;
> >> 		#size-cells = <0>;
> >> 		...
> >> 		ov772x-1 = {
> >> 		
> >> 			reg = <1>;			/* local pad # */
> >> 			client = <&ov772x@0x21-0 0>;	/* remote phandle and pad */
> > 
> > The client property looks good, but isn't such a usage of the reg property
> > an abuse ? Maybe the local pad # should be a device-specific property.
> > Many hosts won't need it, and on others it would actually need to
> > reference a subdev, not just a pad.
> 
> That's a very odd syntax the the phandle; I assume that "&ov772x@0x21-0"
> is supposed to reference some other DT node. However, other nodes are
> either referenced by:
> 
> "&foo" where foo is a label, and the label name is unlikely to include
> the text "@0x21"; the @ symbol probably isn't even legal in label names.
> 
> "&{/path/to/node}" which might include the "@0x21" syntax since it might
> be part of the node's name, but your example didn't include {}.
> 
> I'm not sure what "-0" is meant to be in that string - a math
> expression, or ...? If it's intended to represent some separate field
> relative to the node the phandle references, it needs to be just another
> cell.

I'm actually not sure what -0 represents, and I don't think we need the 
@0x21-0 at all. I believe &ov772x@0x21-0 is supposed to just be a label. We 
don't need an extra cell.

> So overall, perhaps:
> 
> / {
>    ...
>    pad: something { ... };
>    ...
>    ov772x@1 = { /* @1 not -1 would be canonical syntax */
>      reg = <1>;
>      client = <&pad 0 0>;
>    ...
> 
> I'm sorry I haven't followed the thread; I'm wondering why a client is a
> pad, which to me means a pin/pad/ball on an IC package, so I'm still not
> entirely sure if even this makes sense.

Client references an image source (which is usually an I2C client, but can be 
a different type of device) and a pad. Pad refers here to a media entity pad 
(see http://linuxtv.org/downloads/v4l-dvb-apis/media-controller-model.html), 
not a physical pin on an IC package.

-- 
Regards,

Laurent Pinchart

