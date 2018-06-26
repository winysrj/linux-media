Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:40332 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752201AbeFZUNE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 16:13:04 -0400
Date: Tue, 26 Jun 2018 14:13:01 -0600
From: Rob Herring <robh@kernel.org>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Rutland <mark.rutland@arm.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH/RFC 0/2] media: adv748x: Fix decimal unit addresses
Message-ID: <20180626201301.GC30143@rob-hp-laptop>
References: <1528984088-24801-1-git-send-email-geert+renesas@glider.be>
 <39b13aa8-ed02-5aaa-2422-728ace157ae3@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39b13aa8-ed02-5aaa-2422-728ace157ae3@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 14, 2018 at 04:50:49PM +0100, Kieran Bingham wrote:
> Hi Geert,
> 
> On 14/06/18 14:48, Geert Uytterhoeven wrote:
> > 	Hi Rob et al.
> > 
> > Recent dtc assumes unit addresses are always hexadecimal (without
> > prefix), while the bases of reg property values depend on their
> > prefixes, and thus can be either decimal or hexadecimal.
> > 
> > This leads to (with W=1):
> > 
> >      Warning (graph_port): video-receiver@70/port@10: graph node unit address error, expected "a"
> >      Warning (graph_port): video-receiver@70/port@11: graph node unit address error, expected "b"
> > 
> > In this particular case, the unit addresses are (assumed hexadecimal) 10
> > resp. 11, while the reg properties are decimal 10 resp. 11, and thus
> > don't match.
> > 
> > This RFC patch series corrects the unit addresses to match the reg
> > address values for the DT bindings for adi,adv748x and its users.
> > There's at least one other violator (port@10 in
> > arch/arm/boot/dts/vf610-zii-dev-rev-c.dts), which I didn't fix.
> > 
> > However, ePAPR v1.1 states:
> > 
> >      The unit-address component of the name is specific to the bus type
> >      on which the node sits. It consists of one or more ASCII characters
> >      from the set of characters in Table 2-1. The unit-address must match
> >      the first address specified in the reg property of the node. If the
> >      node has no reg property, the @ and unit-address must be omitted and
> >      the node-name alone differentiates the node from other nodes at the
> >      same level in the tree. The binding for a particular bus may specify
> >      additional, more specific requirements for the format of reg and the
> >      unit-address.
> > 
> > i.e. nothing about an hexadecimal address requirement?

No, because unit-addresses are bus specific, so in theory a bus could 
use decimal. However, it's pretty well established practice to use hex.

> > Should this series be applied, or should the warnings be ignored, until
> > dtc is fixed?
> 
> IMO - the ports are human readable indexes, and not hexadecimal. I'd be
> loathed to see these become hex. .. especially if not prefixed by a 0x...

I read hex. :)

> Otherwise, is '10', Ten, or Sixteen? IMO - no 0x = decimal only.

It's hex because *everywhere* else is hex. Having a mixture would just 
invite more confusion and errors (especially because dtc only checks 
cases it knows the bus type).

For OF graph, I'm not that worried about it because 99% of the users 
have 10 or less ports/endpoints.

> That said - I look up and see "video-receiver@70", which is of course the
> hexadecimal I2C address :(

It is bad enough that I2C addresses get expressed in both 7 and 8-bits 
(shifted up 1), using decimal there would be really fun.

Rob
