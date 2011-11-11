Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab1KKKMJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 05:12:09 -0500
Message-ID: <4EBCF4F1.2030606@redhat.com>
Date: Fri, 11 Nov 2011 08:12:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Andreas Oberritter <obi@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: PATCH: Query DVB frontend capabilities
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com> <4EBBE336.8050501@linuxtv.org> <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com> <4EBC402E.20208@redhat.com> <CAHFNz9KFv7XvK4Uafuk8UDZiu1GEHSZ8bUp3nAyM21ck09yOCQ@mail.gmail.com>
In-Reply-To: <CAHFNz9KFv7XvK4Uafuk8UDZiu1GEHSZ8bUp3nAyM21ck09yOCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 11-11-2011 04:26, Manu Abraham escreveu:
> On Fri, Nov 11, 2011 at 2:50 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 10-11-2011 13:30, Manu Abraham escreveu:
>>> Hi Andreas,
>>>
>>> On Thu, Nov 10, 2011 at 8:14 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
>>>> Hello Manu,
>>>>
>>>> please see my comments below:
>>>>
>>>> On 10.11.2011 15:18, Manu Abraham wrote:
>>>>> Hi,
>>>>>
>>>>> Currently, for a multi standard frontend it is assumed that it just
>>>>> has a single standard capability. This is fine in some cases, but
>>>>> makes things hard when there are incompatible standards in conjuction.
>>>>> Eg: DVB-S can be seen as a subset of DVB-S2, but the same doesn't hold
>>>>> the same for DSS. This is not specific to any driver as it is, but a
>>>>> generic issue. This was handled correctly in the multiproto tree,
>>>>> while such functionality is missing from the v5 API update.
>>>>>
>>>>> http://www.linuxtv.org/pipermail/vdr/2008-November/018417.html
>>>>>
>>>>> Later on a FE_CAN_2G_MODULATION was added as a hack to workaround this
>>>>> issue in the v5 API, but that hack is incapable of addressing the
>>>>> issue, as it can be used to simply distinguish between DVB-S and
>>>>> DVB-S2 alone, or another x vs X2 modulation. If there are more
>>>>> systems, then you have a potential issue.
>>
>> For sure something like that is needed.
>>
>> DVB TURBO is another example where the FE_CAN_2G_MODULATION approach doesn't
>> properly address.
>>
> 
> 
> It is similar to a DVB-S system with a different modulation and FEC.
> It was specifically designed to make it proprietary. Nothing wrong
> with it as it is now.

Yes, but DVB_TURBO uses its own FE_CAN flag. The point I'm trying to bold
is that using FE_CAN for delivery system doesn't scale, as there are only 
2 bits left.

>> There are two DVBv5 calls that are likely designed to address this
>> need:
>>        DTV_FE_CAPABILITY_COUNT
>>        DTV_FE_CAPABILITY
>>
>> Unfortunately, those were never implemented. I _suspect_ that the original
>> idea were to allow passing an arbritary count to the driver, and let it fill
>> each capability.
> 
> 
> This was likely meant to be used for the FE_CAN flags as far as I can
> see. This is not what I am trying to address.

Yes, but a few FE_CAN flags are used to indicate delivery systems (CAN_2G, CAN_TURBO).
So, both problems are connected, as future changes should not spend FE_CAN bit anymore 
for delivery systems.

>>>>> +static int stb0899_delivery_caps(struct dvb_frontend *fe, struct dtv_property *caps)
>>>>> +{
>>>>> +     struct stb0899_state *state             = fe->demodulator_priv;
>>>>> +
>>>>> +     dprintk(state->verbose, FE_DEBUG, 1, "Get caps");
>>>>> +     caps->u.buffer.data[0] = SYS_DSS;
>>>>> +     caps->u.buffer.data[1] = SYS_DVBS;
>>>>> +     caps->u.buffer.data[2] = SYS_DVBS2;
>>>>> +     caps->u.buffer.len = 3;
>>
>> This doesn't sound right to me. If userspace passed space for only one delivery system,
>> you can't just adjust the size here and expect it to work, as the array on userspace
>> may be smaller than 3 properties.
> 
> 
> You misunderstood.
> 
> The userspace requested just a single property, not more than that.
> The usage at the kernel side is also for a single property.
> 
> This would be what would be running at userspace for the specified patch.
> 
> struct dtv_property p[] = {
>     { .cmd = DTV_DELIVERY_CAPS },
> }
> 
> struct dtv_properties cmd = {
>      .num = 1,
>      .props = p,
> }
> 
> ioctl(fd, FE_GET_PROPERTY, &cmd);


Ah, now I see. As data is defined as __u8, that means that the DVB core will
be limited by up to 255 delivery systems. Also, as data size is 32, it is limited
up to 32 delivery systems supported by a single frontend.

Hmm... Currently, there is 17 delivery systems (18 with DSS). It seems that it would
scale. If we end by having more than 254 delivery systems, we can still use it, by
encoding it with RLE.

Seems reasonable for me.

>> Also, the other DVBv5 properties may not be DTV_DELIVERY_CAPS type.
>>
>> In other words, the driver or core needs to check if the type is DTV_DELIVERY_CAPS
>> before filling it.
> 
> 
> It is indeed called within a case switch:
> +	case DTV_DELIVERY_CAPS:
> +		if (fe->ops.delivery_caps) {
> +			r = fe->ops.delivery_caps(fe, tvp);
> 
> 
> So, It does warrant that delivery caps are filled only with the
> DTV_DELIVERY_CAPS, just like any other command, no difference in
> there. But as I stated earlier, using get_property is just as fine.
> 
> 
>>
>> Btw, if the "capabilities" here is just the delivery system, it would be better to
>> name it as something like DTV_GET_SUPPORTED_DELIVERY.
> 
> 
> Yes that's the intention. But I would like to have a shorter name.
> First of all the GET in there is superfluous as it is used in a
> FE_GET_PROPERTY. Also you cannot SET from userspace a
> SUPPORTED_DELIVERY. Do you feel much of a difference between
> DTV_DELIVERY_CAPS and DTV_SUPPORTED_DELIVERY ? It's just a naming
> issue. I can live with either of them, but still feel that
> DTV_DELIVERY_CAPS is a bit more relevant.

IMO, CAPS reminds FE_CAN flags. DTV_SUPPORTED_DELIVERY seems a good choice.

>>
>> We should also think on a way to enumerate the supported values for each DVB properties,
>> the enum fe_caps is not enough anymore to store everything. It currently has 30 bits
>> filled (of a total of 32 bits), and we currently have:
>>        12 code rates (including AUTO/NONE);
>>        13 modulation types;
>>        7 transmission modes;
>>        7 bandwidths;
>>        8 guard intervals (including AUTO);
>>        5 hierarchy names;
>>        4 rolloff's (probably, we'll need to add 2 more, to distinguish between DVB-C Annex A and Annex C).
> 
> These parameters aren't anything related to the current patch.
> 
>>
>> So, if we would need to add one CAN_foo for each of the above, we would need 56 to 58
>> bits, plus 5-6 bits to the other capabilities that currently exists there. So, even
>> 64 bits won't be enough for the current needs (even having the delivery system caps
>> addressed by something else).
>>
>> It means that FE_GET_INFO needs to be replaced by something that scales better, e. g.
>> that would allow to enumerate the supported ranges for each DVBv5 parameter.
> 
> 
> This is not what I am addressing. This is outside the scope of the
> proposed patch and requirement.

Ok, but, once we add it, we should not spend flags anymore for delivery system
support capabilities.

> These flags are retrieved correctly as of now and is used without any issues. 

There are some potential issues. If you look at the DVB-T2 patch
(changeset 94d56ffa0a9bf11dfb602dae9223089e09a8e050), you'll see that it 
added 3 new transmission modes, 3 new guard intervals and 3 new bandwidths. 

If some DVB-T2 devices have a limited set of capabilities, the two remaining FE_CAN
bits may not be enough.

> The purpose of the patch is to
> query DVB delivery system capabilities alone, rather than DVB frontend
> info/capability.
> 
> Attached is a revised version 2 of the patch, which addresses the
> issues that were raised.

It looks good for me. I would just rename it to DTV_SUPPORTED_DELIVERY.
Please, when submitting upstream, don't forget to increment DVB version and
add touch at DocBook, in order to not increase the gap between API specs and the
implementation.

Regards,
Mauro
