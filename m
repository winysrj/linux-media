Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38724 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbcFJVeA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2016 17:34:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWQZjE+AnPry6PiVc69PVdZ_2zstOKR==B6nywun2Om9Q@mail.gmail.com>
References: <1465479695-18644-1-git-send-email-kieran@bingham.xyz>
 <1465479695-18644-3-git-send-email-kieran@bingham.xyz> <20160610173914.GA20505@rob-hp-laptop>
 <CAMuHMdWQZjE+AnPry6PiVc69PVdZ_2zstOKR==B6nywun2Om9Q@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Fri, 10 Jun 2016 16:33:36 -0500
Message-ID: <CAL_JsqLd+sXeEtq+chtrCxyDgyBm9s3giCC+ri8oMvfVLjunaA@mail.gmail.com>
Subject: Re: [PATCH 2/3] dt-bindings: Document Renesas R-Car FCP power-domains usage
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kieran Bingham <kieran@ksquared.org.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"open list:MEDIA DRIVERS FOR RENESAS - FCP"
	<linux-media@vger.kernel.org>,
	"open list:MEDIA DRIVERS FOR RENESAS - FCP"
	<linux-renesas-soc@vger.kernel.org>,
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
	<devicetree@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 10, 2016 at 2:11 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Rob,
>
> On Fri, Jun 10, 2016 at 7:39 PM, Rob Herring <robh@kernel.org> wrote:
>> On Thu, Jun 09, 2016 at 02:41:33PM +0100, Kieran Bingham wrote:
>>> The power domain must be specified to bring the device out of module
>>> standby. Document this in the example provided, so that new additions
>>> are not missed.
>>>
>>> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
>>> ---
>>>  Documentation/devicetree/bindings/media/renesas,fcp.txt | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt b/Documentation/devicetree/bindings/media/renesas,fcp.txt
>>> index 271dcfdb5a76..6a55f5215221 100644
>>> --- a/Documentation/devicetree/bindings/media/renesas,fcp.txt
>>> +++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
>>> @@ -31,4 +31,5 @@ Device node example
>>>               compatible = "renesas,r8a7795-fcpv", "renesas,fcpv";
>>>               reg = <0 0xfea2f000 0 0x200>;
>>>               clocks = <&cpg CPG_MOD 602>;
>>> +             power-domains = <&sysc R8A7795_PD_A3VP>;
>>
>> This needs to be documented above too, not just the example.
>
> Why? Power domains are an optional feature, whose presence depends
> on the platform, not on the device.

Examples are not documentation. The binding should stand on its own
without the example.

How did I know this is optional unless you document it as optional?
How many power domains does the device have?

> Hence "power-domains" properties may appear in any device node.
> Having to document them in every single binding document is overkill.

We do it for everything else pretty much. There's some exceptions like "status".

I agree that we get a bunch of redundancy with random text describing
the properties. I'm all for a structured syntax that can distill the
device bindings down to the pertainent information. If only someone
proposed using yaml or something...

Rob
