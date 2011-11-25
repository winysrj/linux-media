Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab1KYAM2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 19:12:28 -0500
Message-ID: <4ECEDD64.2010505@redhat.com>
Date: Thu, 24 Nov 2011 22:12:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Andreas Oberritter <obi@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: PATCH 00/13: Enumerate DVB frontend Delivery System capabilities
 to identify devices correctly.
References: <CAHFNz9KAi=XRZt=qM=KKnSKmmf_mn18JJAiUmd_5gXG71VBELA@mail.gmail.com> <4ECAEB37.4040404@linuxtv.org> <CAHFNz9LfMc3LTOscX9=Wtpsj5DtL-k9fgKnWzqw5NnLgHRZq6A@mail.gmail.com>
In-Reply-To: <CAHFNz9LfMc3LTOscX9=Wtpsj5DtL-k9fgKnWzqw5NnLgHRZq6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-11-2011 22:43, Manu Abraham escreveu:
> On Tue, Nov 22, 2011 at 5:52 AM, Andreas Oberritter <obi@linuxtv.org> wrote:
>> On 21.11.2011 22:05, Manu Abraham wrote:
>>> Hi,
>>>
>>> As discussed prior, the following changes help to advertise a
>>> frontend's delivery system capabilities.
>>>
>>> Sending out the patches as they are being worked out.
>>>
>>> The following patch series are applied against media_tree.git
>>> after the following commit
>>
>> Patches 7, 9 and 10 semm to be unneeded, because they just set the defaults.
>>
> 
> cx24116 AFAIR handles dss, but no code exists in the driver to handle the same.
> ds3000, I have no clue
> tda10071, is a derivative of the CX demods and likely supports DSS,
> just like the ST ones.

cx24123 also handles dss, but the driver doesn't support it, AFAICT.

> but that said no code exists in the driver.
> 
> As you state, yes, it is pointless to have these 3 patches, 

Yes, with the current way.

> but then I
> thought maybe if someone adds in DSS it would be okay. DSS hasn't been
> added to most frontends for the reasons
> 
> - earlier there was no support from the frontend API
> - need to handle it with demux as well.
> 
> Well, anyway patch exists, so anyone can add it in later if they need
> when adding support to the driver.
> 
>> Regarding the patches adding SYS_DSS: If I remember correctly, DSS
>> doesn't use MPEG-2 TS packets. Do we have a way to deliver DSS payload
>> to userspace?
> 
> Yes, even the SYNC is different, length is different too. Somebody
> wrote a parser a while back. But nothing happened on that front due to
> the mentioned 2 reasons.
> 
> there are 2 options,
> 
> - send the captured packets as it is to userspace
> - based on delivery system (dvb-s2 has generic streams as well, other
> than MPEG2-TS, didn't look at dvb-t2, most likely the same option
> exists there as well), look for sync and length, send packets to
> userspace.

Just flagging that the driver supports DSS won't work, as there's currently
no way for userspace to get it.

My suggestion is to delay those patches to be added after we have a solution
that works for DSS, or if we end by getting rid of the compat code inside
the drivers (e. g. use struct dvb_frontend_parameters only at the part of the
DVB core that provides backward support for v3 calls).

> 
> Regards,
> Manu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Regards,
Mauro
