Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037C0C10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA6D920663
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733126AbfCANTD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:19:03 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:60280 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731716AbfCANTD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 08:19:03 -0500
Received: from [IPv6:2001:983:e9a7:1:e06f:53e3:ca47:5e48] ([IPv6:2001:983:e9a7:1:e06f:53e3:ca47:5e48])
        by smtp-cloud7.xs4all.net with ESMTPA
        id zi44gO5YILMwIzi45gimCX; Fri, 01 Mar 2019 14:19:01 +0100
Subject: Re: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
 support
To:     Biju Das <biju.das@bp.renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
 <TYXPR01MB1775F18270FB477D010C180EC0760@TYXPR01MB1775.jpnprd01.prod.outlook.com>
 <8a5429a0-b4c5-a208-3e56-406bd031b01b@xs4all.nl>
 <CAMuHMdXOcFaQiLUNiuUS_p5H0r3ZWMrWd09m5xZk4qitvLS25g@mail.gmail.com>
 <3b702231-8d50-8434-177c-716203dac7b2@xs4all.nl>
 <OSBPR01MB21034BCCB73E585F2BC8C03CB8760@OSBPR01MB2103.jpnprd01.prod.outlook.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f6a3e336-9d44-aa06-5f92-e08398b6e992@xs4all.nl>
Date:   Fri, 1 Mar 2019 14:19:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <OSBPR01MB21034BCCB73E585F2BC8C03CB8760@OSBPR01MB2103.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfCFSDoNzduND583dQGCLMiMT8naAkERJOBlTInXZ7lPA9yFApU3d048rGEvvpaIYXNVc9H7pYuxaAOEc40o+KAEeTt6d7Y7NJ0OcbyehOrt23zyz/FEf
 vdUKRoqpKb7KF2vBhRAs4WknY9NixxRb4TXyxX3veU8iTmdTEcozKRKN8q2QeGShjixXRNhz1cOc+Ip84AaHHGHRiiiSfBFr80LbL5i/oyNVj8IfAwiOTLlL
 CjhpGLZn9SL5tVLW1US4sxYzQeL/dG+ZLmvAiO115aka5MwN6zjLaVuGRIBTp3dVWtJF47rbwRA5gzM4DN1+F6SWEzv9t0vTIxjO9RttI69CgTUKggckJDrc
 aMeJWUEPst5u15G2MnPeGE/1Wrysn2MOCcJN3rPnOlLCm4heQzkwTQ3hf13gsUGVnUT/fH5nwlnj+LjpbEK7ISRGocPdAqS1I02+sWK2GKeENdxmRo2ymLvr
 h4wfypr4QiyENO6436Eost4GTtVKgPhaDwlfHlv1aiLe2pS5S0eHxnQRGI9rnTjpw3QeljNGe8NFmMENU9UUFt6PnJriQg4AIbc6icBzuQRf851oGDUjeFEX
 j2v3Vs7APmonJFFX0A2HsylpQkNien0h4o5KXnmYzwRuB3Wpn/hOSujDdf0z+SwT6wzGebm15I8heLYjQitqjT85KQvxQH8o9uD3ptCfPhL1Dm2kyWtLJl3I
 e7nchbyLyRFZnluTe4QzKpAZjPJWJQzrCnrMQAVsLFHCyiBlSOPJexUu0Bif3a5G+6fJO64vYT0=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Biju,

Can you do the following:

1) forward both of Rob's replies with his Reviewed-by tag to linux-media,
   that way I have seen it.
2) rebase the patch series and add all Reviewed-by etc. tags and post as
   a v2. I'll pick it up and make sure it will get merged. Not sure if we
   can manage 5.1, but it will certainly get in 5.2.

Regards,

	Hans

On 3/1/19 2:12 PM, Biju Das wrote:
> Hi Hans,
> 
> Thanks for the feedback.
> 
>> -----Original Message-----
>> From: Hans Verkuil <hverkuil@xs4all.nl>
>> Sent: 01 March 2019 13:09
>> To: Geert Uytterhoeven <geert@linux-m68k.org>
>> Cc: Fabrizio Castro <fabrizio.castro@bp.renesas.com>; Mauro Carvalho
>> Chehab <mchehab@kernel.org>; Biju Das <biju.das@bp.renesas.com>;
>> Niklas Söderlund <niklas.soderlund@ragnatech.se>; linux-
>> media@vger.kernel.org; linux-renesas-soc@vger.kernel.org;
>> devicetree@vger.kernel.org; Simon Horman <horms@verge.net.au>; Geert
>> Uytterhoeven <geert+renesas@glider.be>; Chris Paterson
>> <Chris.Paterson2@renesas.com>; Rob Herring <robh+dt@kernel.org>; Mark
>> Rutland <mark.rutland@arm.com>; Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com>
>> Subject: Re: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
>> support
>>
>> On 3/1/19 1:58 PM, Geert Uytterhoeven wrote:
>>> Hi Hans,
>>>
>>> On Fri, Mar 1, 2019 at 1:55 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> It looks like this series fell through the cracks.
>>>>
>>>> I looked at it and the main problem is that it is missing a
>>>> Reviewed-by from Rob Herring (devicetree maintainer). It's a bit
>>>> surprising since he is usually fairly prompt.
>>>
>>> He actually did provide his Rb on Sep 17.
>>
>> Hmm, I don't see anything about that in my linux-media archive, and
>> patchwork didn't pick that up either.
>>
>> Was linux-media in the CC list of Rob's reply?
> 
> Yes. Please see below.
> 
>> -----Original Message-----
>> From: Rob Herring <robh@kernel.org>
>> Sent: 17 September 2018 06:45
>> To: Biju Das <biju.das@bp.renesas.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>; Mark Rutland
>> <mark.rutland@arm.com>; Biju Das <biju.das@bp.renesas.com>; Niklas
>> Söderlund <niklas.soderlund@ragnatech.se>; linux-media@vger.kernel.org;
>> linux-renesas-soc@vger.kernel.org; devicetree@vger.kernel.org; Simon
>> Horman <horms@verge.net.au>; Geert Uytterhoeven
>> <geert+renesas@glider.be>; Chris Paterson
>> <Chris.Paterson2@renesas.com>; Fabrizio Castro
>> <fabrizio.castro@bp.renesas.com>
>> Subject: Re: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
>> support
>>
>> On Mon, 10 Sep 2018 15:31:14 +0100, Biju Das wrote:
>>> Document RZ/G2M (R8A774A1) SoC bindings.
>>>
>>> The RZ/G2M SoC is similar to R-Car M3-W (R8A7796).
>>>
>>> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
>>> Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
>>> ---
>>>  Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 5 +++--
>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>
>> Reviewed-by: Rob Herring <robh@kernel.org>
> 
> Regards,
> Biju
> 
> 
> Renesas Electronics Europe GmbH,Geschaeftsfuehrer/President : Michael Hannawald, Sitz der Gesellschaft/Registered office: Duesseldorf, Arcadiastrasse 10, 40472 Duesseldorf, Germany,Handelsregister/Commercial Register: Duesseldorf, HRB 3708 USt-IDNr./Tax identification no.: DE 119353406 WEEE-Reg.-Nr./WEEE reg. no.: DE 14978647
> 

