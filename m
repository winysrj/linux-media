Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:34703 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2GaX31 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 19:29:27 -0400
Message-ID: <50186A54.3@wwwdotorg.org>
Date: Tue, 31 Jul 2012 17:29:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] media DT bindings
References: <Pine.LNX.4.64.1207110854290.18999@axis700.grange> <2642313.6bQqiyFNFL@avalon> <Pine.LNX.4.64.1207311432590.27888@axis700.grange> <1853410.hC8HZhzZI6@avalon>
In-Reply-To: <1853410.hC8HZhzZI6@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2012 03:22 PM, Laurent Pinchart wrote:
> On Tuesday 31 July 2012 14:39:07 Guennadi Liakhovetski wrote:
...
>> Ok, then, how about
>>
>> 		#address-cells = <1>;
>> 		#size-cells = <0>;
>> 		...
>> 		ov772x-1 = {
>> 			reg = <1>;			/* local pad # */
>> 			client = <&ov772x@0x21-0 0>;	/* remote phandle and pad */
> 
> The client property looks good, but isn't such a usage of the reg property an 
> abuse ? Maybe the local pad # should be a device-specific property. Many hosts 
> won't need it, and on others it would actually need to reference a subdev, not 
> just a pad.

That's a very odd syntax the the phandle; I assume that "&ov772x@0x21-0"
is supposed to reference some other DT node. However, other nodes are
either referenced by:

"&foo" where foo is a label, and the label name is unlikely to include
the text "@0x21"; the @ symbol probably isn't even legal in label names.

"&{/path/to/node}" which might include the "@0x21" syntax since it might
be part of the node's name, but your example didn't include {}.

I'm not sure what "-0" is meant to be in that string - a math
expression, or ...? If it's intended to represent some separate field
relative to the node the phandle references, it needs to be just another
cell.

So overall, perhaps:

/ {
   ...
   pad: something { ... };
   ...
   ov772x@1 = { /* @1 not -1 would be canonical syntax */
     reg = <1>;
     client = <&pad 0 0>;
   ...

I'm sorry I haven't followed the thread; I'm wondering why a client is a
pad, which to me means a pin/pad/ball on an IC package, so I'm still not
entirely sure if even this makes sense.
