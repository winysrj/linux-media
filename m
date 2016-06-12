Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36756 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbcFLIqg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2016 04:46:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqLd+sXeEtq+chtrCxyDgyBm9s3giCC+ri8oMvfVLjunaA@mail.gmail.com>
References: <1465479695-18644-1-git-send-email-kieran@bingham.xyz>
 <1465479695-18644-3-git-send-email-kieran@bingham.xyz> <20160610173914.GA20505@rob-hp-laptop>
 <CAMuHMdWQZjE+AnPry6PiVc69PVdZ_2zstOKR==B6nywun2Om9Q@mail.gmail.com> <CAL_JsqLd+sXeEtq+chtrCxyDgyBm9s3giCC+ri8oMvfVLjunaA@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 12 Jun 2016 10:46:34 +0200
Message-ID: <CAMuHMdUnwHYUVGHZn=gE0dxqR81iKO0dMEMATOL=Sw5aWbGVgQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] dt-bindings: Document Renesas R-Car FCP power-domains usage
To: Rob Herring <robh@kernel.org>
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
	open list <linux-kernel@vger.kernel.org>,
	Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

CC linux-pm

On Fri, Jun 10, 2016 at 11:33 PM, Rob Herring <robh@kernel.org> wrote:
> On Fri, Jun 10, 2016 at 2:11 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Fri, Jun 10, 2016 at 7:39 PM, Rob Herring <robh@kernel.org> wrote:
>>> On Thu, Jun 09, 2016 at 02:41:33PM +0100, Kieran Bingham wrote:
>>>> The power domain must be specified to bring the device out of module
>>>> standby. Document this in the example provided, so that new additions
>>>> are not missed.
>>>>
>>>> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
>>>> ---
>>>>  Documentation/devicetree/bindings/media/renesas,fcp.txt | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt b/Documentation/devicetree/bindings/media/renesas,fcp.txt
>>>> index 271dcfdb5a76..6a55f5215221 100644
>>>> --- a/Documentation/devicetree/bindings/media/renesas,fcp.txt
>>>> +++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
>>>> @@ -31,4 +31,5 @@ Device node example
>>>>               compatible = "renesas,r8a7795-fcpv", "renesas,fcpv";
>>>>               reg = <0 0xfea2f000 0 0x200>;
>>>>               clocks = <&cpg CPG_MOD 602>;
>>>> +             power-domains = <&sysc R8A7795_PD_A3VP>;
>>>
>>> This needs to be documented above too, not just the example.
>>
>> Why? Power domains are an optional feature, whose presence depends
>> on the platform, not on the device.
>
> Examples are not documentation. The binding should stand on its own
> without the example.
>
> How did I know this is optional unless you document it as optional?
> How many power domains does the device have?

The device does not have power domains, and is not aware of the existence
of power domains. Each SoC has one or more power domains.

"power-domains" properties are used to describe the hierarchical relationship
between power domains and the devices that resides in these power domains.
Just like nodes and subnodes describe the hierarchical relationship between
buses and the devices directly connected to these buses.

On the (Linux) software side, the device driver does have to use Runtime PM
if an SoC has more power domains than just the single "always-on" power domain.

>> Hence "power-domains" properties may appear in any device node.
>> Having to document them in every single binding document is overkill.
>
> We do it for everything else pretty much. There's some exceptions like "status".

IMHO having to document "power-domains" in every single DT binding is
as silly as having to document that the device node must be a child of the bus
device node in every single DT binding. This belongs in the DT binding of the
power controller, which is the device controlling the power domain.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
