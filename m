Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:48488 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab2HAP5f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 11:57:35 -0400
Message-ID: <501951E4.7000208@wwwdotorg.org>
Date: Wed, 01 Aug 2012 09:57:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] media DT bindings
References: <Pine.LNX.4.64.1207110854290.18999@axis700.grange> <1853410.hC8HZhzZI6@avalon> <50186A54.3@wwwdotorg.org> <3134777.Df1peamEaY@avalon>
In-Reply-To: <3134777.Df1peamEaY@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2012 11:59 PM, Laurent Pinchart wrote:
> Hi Stephen,
> 
> On Tuesday 31 July 2012 17:29:24 Stephen Warren wrote:
>> On 07/31/2012 03:22 PM, Laurent Pinchart wrote:
>>> On Tuesday 31 July 2012 14:39:07 Guennadi Liakhovetski wrote:
>> ...
>>
>>>> Ok, then, how about
>>>>
>>>> 		#address-cells = <1>;
>>>> 		#size-cells = <0>;
>>>> 		...
>>>> 		ov772x-1 = {
>>>> 		
>>>> 			reg = <1>;			/* local pad # */
>>>> 			client = <&ov772x@0x21-0 0>;	/* remote phandle and pad */
>>>
>>> The client property looks good, but isn't such a usage of the reg property
>>> an abuse ? Maybe the local pad # should be a device-specific property.
>>> Many hosts won't need it, and on others it would actually need to
>>> reference a subdev, not just a pad.
>>
>> That's a very odd syntax the the phandle; I assume that "&ov772x@0x21-0"
>> is supposed to reference some other DT node. However, other nodes are
>> either referenced by:
>>
>> "&foo" where foo is a label, and the label name is unlikely to include
>> the text "@0x21"; the @ symbol probably isn't even legal in label names.
>>
>> "&{/path/to/node}" which might include the "@0x21" syntax since it might
>> be part of the node's name, but your example didn't include {}.
>>
>> I'm not sure what "-0" is meant to be in that string - a math
>> expression, or ...? If it's intended to represent some separate field
>> relative to the node the phandle references, it needs to be just another
>> cell.
> 
> I'm actually not sure what -0 represents, and I don't think we need the 
> @0x21-0 at all. I believe &ov772x@0x21-0 is supposed to just be a label. We 
> don't need an extra cell.

Ah, OK. The lexer in dtc has the following definition for label names:

LABEL		[a-zA-Z_][a-zA-Z0-9_]*

