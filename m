Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35085 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753247AbdAKJNJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 04:13:09 -0500
Received: by mail-oi0-f44.google.com with SMTP id b126so762541417oia.2
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2017 01:13:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5b4bb7bd-83ae-c1f3-6b24-989dd6b0aa48@mentor.com>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
 <20161019213026.GU9460@valkosipuli.retiisi.org.uk> <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
 <20161229205113.j6wn7kmhkfrtuayu@pengutronix.de> <7350daac-14ee-74cc-4b01-470a375613a3@denx.de>
 <c38d80aa-5464-1e9d-e11a-f54716fdb565@mentor.com> <1483990983.13625.58.camel@pengutronix.de>
 <43564c16-f7aa-2d35-a41f-991465faaf8b@mentor.com> <5b4bb7bd-83ae-c1f3-6b24-989dd6b0aa48@mentor.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Wed, 11 Jan 2017 10:12:48 +0100
Message-ID: <CAH-u=81csDa=4ugLbE28shohLU0JyDi=DbqL5VrAjaLoX2DekA@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve and Philipp,

2017-01-11 0:52 GMT+01:00 Steve Longerbeam <steve_longerbeam@mentor.com>:
>
>
> On 01/09/2017 04:15 PM, Steve Longerbeam wrote:
>>
>> Hi Philipp,
>>
>>
>> On 01/09/2017 11:43 AM, Philipp Zabel wrote:
>>
>>
>> <snip>
>>>
>>> One is the amount and organization of subdevices/media entities visible
>>> to userspace. The SMFCs should not be user controllable subdevices, but
>>> can be implicitly enabled when a CSI is directly linked to a camif.
>>
>>
>> I agree the SMFC could be folded into the CSI, but I see at least one
>> issue.
>>
>> From the dot graph you'll see that the PRPVF entity can receive directly
>> from the CSI, or indirectly via the SMFC. If the SMFC entity were folded
>> into the CSI entity, there would have to be a "direct to PRPVF" output pad
>> and a "indirect via SMFC" output pad and I'm not sure how that info would
>> be conveyed to the user. With a SMFC entity those pipelines are explicit.
>
>
> In summary here, unless you have strong objection I'd prefer to keep a
> distinct SMFC entity. It makes the pipelines more clear to the user, and it
> better models the IPU internals.
>
>>
>>> Also I'm not convinced the 1:1 mapping of IC task to subdevices is the
>>> best choice. It is true that the three tasks can be enabled separately,
>>> but to my understanding, the PRP ENC and PRP VF tasks share a single
>>> input channel. Shouldn't this be a single PRP subdevice with one input
>>> and two (VF, ENC) outputs?
>>
>>
>> Since the VDIC sends its motion compensated frames to the PRP VF task,
>> I've created the PRPVF entity solely for motion compensated de-interlace
>> support. I don't really see any other use for the PRPVF task except for
>> motion compensated de-interlace.
>>
>> So really, the PRPVF entity is a combination of the VDIC and PRPVF
>> subunits.
>>
>> So looking at link_setup() in imx-csi.c, you'll see that when the CSI is
>> linked
>> to PRPVF entity, it is actually sending to IPU_CSI_DEST_VDIC.
>>
>> But if we were to create a VDIC entity, I can see how we could then
>> have a single PRP entity. Then if the PRP entity is receiving from the
>> VDIC,
>> the PRP VF task would be activated.
>>
>> Another advantage of creating a distinct VDIC entity is that frames could
>> potentially be routed directly from the VDIC to camif, for
>> motion-compensated
>> frame capture only with no scaling/CSC. I think that would be IDMAC
>> channel
>> 5, we've tried to get that pipeline to work in the past without success.
>> That's
>> mainly why I decided not to attempt it and instead fold VDIC into PRPVF
>> entity.
>>
>>
>
> Here also, I'd prefer to keep distinct PRPENC and PRPVF entities. You are
> correct
> that PRPENC and PRPVF do share an input channel (the CSIs). But the PRPVF
> has an additional input channel from the VDIC, and since my PRPVF entity
> roles
> up the VDIC internally, it is actually receiving from the VDIC channel.
>
> So unless you think we should have a distinct VDIC entity, I would like to
> keep this
> the way it is.
>
> Steve
>

That is exactly my thought. I was wondering if VDIC could be an
independent entity, as it could also be used as a combiner if one adds
the channels...

What do you think about that ?

JM
PS: My phone sent the mail in HTML, again, sorry for the double mail, again...
