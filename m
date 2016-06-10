Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34710 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbcFJTL1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2016 15:11:27 -0400
MIME-Version: 1.0
In-Reply-To: <20160610173914.GA20505@rob-hp-laptop>
References: <1465479695-18644-1-git-send-email-kieran@bingham.xyz>
 <1465479695-18644-3-git-send-email-kieran@bingham.xyz> <20160610173914.GA20505@rob-hp-laptop>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 10 Jun 2016 21:11:25 +0200
Message-ID: <CAMuHMdWQZjE+AnPry6PiVc69PVdZ_2zstOKR==B6nywun2Om9Q@mail.gmail.com>
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
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On Fri, Jun 10, 2016 at 7:39 PM, Rob Herring <robh@kernel.org> wrote:
> On Thu, Jun 09, 2016 at 02:41:33PM +0100, Kieran Bingham wrote:
>> The power domain must be specified to bring the device out of module
>> standby. Document this in the example provided, so that new additions
>> are not missed.
>>
>> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
>> ---
>>  Documentation/devicetree/bindings/media/renesas,fcp.txt | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt b/Documentation/devicetree/bindings/media/renesas,fcp.txt
>> index 271dcfdb5a76..6a55f5215221 100644
>> --- a/Documentation/devicetree/bindings/media/renesas,fcp.txt
>> +++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
>> @@ -31,4 +31,5 @@ Device node example
>>               compatible = "renesas,r8a7795-fcpv", "renesas,fcpv";
>>               reg = <0 0xfea2f000 0 0x200>;
>>               clocks = <&cpg CPG_MOD 602>;
>> +             power-domains = <&sysc R8A7795_PD_A3VP>;
>
> This needs to be documented above too, not just the example.

Why? Power domains are an optional feature, whose presence depends
on the platform, not on the device.

Hence "power-domains" properties may appear in any device node.
Having to document them in every single binding document is overkill.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
