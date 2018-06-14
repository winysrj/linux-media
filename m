Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:57458 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755072AbeFNPu4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 11:50:56 -0400
Subject: Re: [PATCH/RFC 0/2] media: adv748x: Fix decimal unit addresses
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <1528984088-24801-1-git-send-email-geert+renesas@glider.be>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <39b13aa8-ed02-5aaa-2422-728ace157ae3@ideasonboard.com>
Date: Thu, 14 Jun 2018 16:50:49 +0100
MIME-Version: 1.0
In-Reply-To: <1528984088-24801-1-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On 14/06/18 14:48, Geert Uytterhoeven wrote:
> 	Hi Rob et al.
> 
> Recent dtc assumes unit addresses are always hexadecimal (without
> prefix), while the bases of reg property values depend on their
> prefixes, and thus can be either decimal or hexadecimal.
> 
> This leads to (with W=1):
> 
>      Warning (graph_port): video-receiver@70/port@10: graph node unit address error, expected "a"
>      Warning (graph_port): video-receiver@70/port@11: graph node unit address error, expected "b"
> 
> In this particular case, the unit addresses are (assumed hexadecimal) 10
> resp. 11, while the reg properties are decimal 10 resp. 11, and thus
> don't match.
> 
> This RFC patch series corrects the unit addresses to match the reg
> address values for the DT bindings for adi,adv748x and its users.
> There's at least one other violator (port@10 in
> arch/arm/boot/dts/vf610-zii-dev-rev-c.dts), which I didn't fix.
> 
> However, ePAPR v1.1 states:
> 
>      The unit-address component of the name is specific to the bus type
>      on which the node sits. It consists of one or more ASCII characters
>      from the set of characters in Table 2-1. The unit-address must match
>      the first address specified in the reg property of the node. If the
>      node has no reg property, the @ and unit-address must be omitted and
>      the node-name alone differentiates the node from other nodes at the
>      same level in the tree. The binding for a particular bus may specify
>      additional, more specific requirements for the format of reg and the
>      unit-address.
> 
> i.e. nothing about an hexadecimal address requirement?
> 
> Should this series be applied, or should the warnings be ignored, until
> dtc is fixed?

IMO - the ports are human readable indexes, and not hexadecimal. I'd be 
loathed to see these become hex. .. especially if not prefixed by a 0x...

Otherwise, is '10', Ten, or Sixteen? IMO - no 0x = decimal only.

That said - I look up and see "video-receiver@70", which is of course 
the hexadecimal I2C address :(

--

Kieran


> Thanks for your comments!
> 
> Geert Uytterhoeven (2):
>    media: dt-bindings: adv748x: Fix decimal unit addresses
>    arm64: dts: renesas: salvator-common: Fix adv7482 decimal unit
>      addresses
> 
>   Documentation/devicetree/bindings/media/i2c/adv748x.txt | 4 ++--
>   arch/arm64/boot/dts/renesas/salvator-common.dtsi        | 4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 


-- 
Regards
--
Kieran
