Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab1KJVU4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 16:20:56 -0500
Message-ID: <4EBC402E.20208@redhat.com>
Date: Thu, 10 Nov 2011 19:20:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Andreas Oberritter <obi@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: PATCH: Query DVB frontend capabilities
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com> <4EBBE336.8050501@linuxtv.org> <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com>
In-Reply-To: <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-11-2011 13:30, Manu Abraham escreveu:
> Hi Andreas,
> 
> On Thu, Nov 10, 2011 at 8:14 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
>> Hello Manu,
>>
>> please see my comments below:
>>
>> On 10.11.2011 15:18, Manu Abraham wrote:
>>> Hi,
>>>
>>> Currently, for a multi standard frontend it is assumed that it just
>>> has a single standard capability. This is fine in some cases, but
>>> makes things hard when there are incompatible standards in conjuction.
>>> Eg: DVB-S can be seen as a subset of DVB-S2, but the same doesn't hold
>>> the same for DSS. This is not specific to any driver as it is, but a
>>> generic issue. This was handled correctly in the multiproto tree,
>>> while such functionality is missing from the v5 API update.
>>>
>>> http://www.linuxtv.org/pipermail/vdr/2008-November/018417.html
>>>
>>> Later on a FE_CAN_2G_MODULATION was added as a hack to workaround this
>>> issue in the v5 API, but that hack is incapable of addressing the
>>> issue, as it can be used to simply distinguish between DVB-S and
>>> DVB-S2 alone, or another x vs X2 modulation. If there are more
>>> systems, then you have a potential issue.

For sure something like that is needed.

DVB TURBO is another example where the FE_CAN_2G_MODULATION approach doesn't
properly address.

>>>
>>> In addition to the patch, for illustrative purposes the stb0899 driver
>>> is depicted providing the said capability information.
>>>
>>> An application needs to query the device capabilities before
>>> requesting an operation from the device.
>>>
>>> If people don't have any objections, Probably other drivers can be
>>> adapted similarly. In fact the change is quite simple.
>>>
>>> Comments ?
>>>
>>> Regards,
>>> Manu
>>>
>>>
>>> query_frontend_capabilities.diff
>>>
>>>
>>> diff -r b6eb04718aa9 linux/drivers/media/dvb/dvb-core/dvb_frontend.c
>>> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c Wed Nov 09 19:52:36 2011 +0530
>>> +++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c Thu Nov 10 13:51:35 2011 +0530
>>> @@ -973,6 +973,8 @@
>>>       _DTV_CMD(DTV_GUARD_INTERVAL, 0, 0),
>>>       _DTV_CMD(DTV_TRANSMISSION_MODE, 0, 0),
>>>       _DTV_CMD(DTV_HIERARCHY, 0, 0),
>>> +
>>> +     _DTV_CMD(DTV_DELIVERY_CAPS, 0, 0),
>>>  };
>>>
>>>  static void dtv_property_dump(struct dtv_property *tvp)
>>> @@ -1226,7 +1228,18 @@
>>>               c = &cdetected;
>>>       }
>>>
>>> +     dprintk("%s\n", __func__);
>>> +
>>>       switch(tvp->cmd) {
>>> +     case DTV_DELIVERY_CAPS:
>>> +             if (fe->ops.delivery_caps) {
>>> +                     r = fe->ops.delivery_caps(fe, tvp);
>>> +                     if (r < 0)
>>> +                             return r;
>>> +                     else
>>> +                             goto done;
>>
>> What's the reason for introducing that label and goto?
> 
> 
> The idea was to avoid using get_property callback being called.

Nothing warrants that the only property will be DTV_DELIVERY_CAPS.
calling get_property callback will likely work better.
> 
> 
> 
>>
>>> +             }
>>> +             break;
>>>       case DTV_FREQUENCY:
>>>               tvp->u.data = c->frequency;
>>>               break;
>>> @@ -1350,7 +1363,7 @@
>>>               if (r < 0)
>>>                       return r;
>>>       }
>>> -
>>> +done:
>>>       dtv_property_dump(tvp);
>>>
>>>       return 0;
>>> diff -r b6eb04718aa9 linux/drivers/media/dvb/dvb-core/dvb_frontend.h
>>> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.h Wed Nov 09 19:52:36 2011 +0530
>>> +++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.h Thu Nov 10 13:51:35 2011 +0530
>>> @@ -305,6 +305,8 @@
>>>
>>>       int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
>>>       int (*get_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
>>> +
>>> +     int (*delivery_caps)(struct dvb_frontend *fe, struct dtv_property *tvp);
>>>  };
>>
>> I don't think that another function pointer is required. Drivers can
>> implement this in their get_property callback. The core could provide a
>> default implementation, returning values derived from fe->ops.info.type
>> and the 2G flag.
> 
> 
> I see your point. While trying to address the issue I had originally
> get_property being used. One Issue that came across to me was that:
> 
>  - while currently this is just one capability field, things do look
> fine. As we move ahead we will possibly have more capability related
> information, given the idea that with shared hardware infrastructure
> on frontends, this list of properties could grow.

There are two DVBv5 calls that are likely designed to address this
need:
	DTV_FE_CAPABILITY_COUNT
	DTV_FE_CAPABILITY

Unfortunately, those were never implemented. I _suspect_ that the original
idea were to allow passing an arbritary count to the driver, and let it fill
each capability.

> - Once we have a few properties, then we will need to have switches in
> that callback, given that it is generic and that length will grow.
> Considering different hardware capabilities, we will have quite a bit
> of shared code amongst drivers in that large switch, causing code
> duplication.
> Eg: with hardware having shared infrastructure - while globally it
> might have a larger set of capabilities, when a sub part of it is run
> in some mode, the other sub parts would have reduced set of
> capabilities, which won't be the same as that exists globally for the
> device. The driver alone will know the change depending on what's
> being used.
> 
> 
> - Additionally, though insignificant a separate callback for each
> capability will make the drivers look a bit more consistent with
> regards to code style.
> 
> The basic issue is a switch that will be duplicated across drivers and
> that which is expected to grow in length, eventually readability a
> question. That said, this shouldn't be an issue at all. Given the
> situation at this exact moment, having a generic callback is just
> fine, as that will be the only which would be there, right now.
> 
> 
>>
>>>  #define MAX_EVENT 8
>>> @@ -362,6 +364,8 @@
>>>
>>>       /* DVB-T2 specifics */
>>>       u32                     dvbt2_plp_id;
>>> +
>>> +     fe_delivery_system_t    delivery_caps[32];
>>>  };
>>
>> This array seems to be unused.
> 
> 
> That just walked in astray while I worked on it. Didn't notice at all. :-)
> I will send an updated patch, do you still think the generic callback
> is better ?
> 
> 
> 
>>
>> Regards,
>> Andreas
>>
>>>  struct dvb_frontend {
>>> diff -r b6eb04718aa9 linux/drivers/media/dvb/frontends/stb0899_drv.c
>>> --- a/linux/drivers/media/dvb/frontends/stb0899_drv.c Wed Nov 09 19:52:36 2011 +0530
>>> +++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c Thu Nov 10 13:51:35 2011 +0530
>>> @@ -1605,6 +1605,19 @@
>>>       return DVBFE_ALGO_CUSTOM;
>>>  }
>>>
>>> +static int stb0899_delivery_caps(struct dvb_frontend *fe, struct dtv_property *caps)
>>> +{
>>> +     struct stb0899_state *state             = fe->demodulator_priv;
>>> +
>>> +     dprintk(state->verbose, FE_DEBUG, 1, "Get caps");
>>> +     caps->u.buffer.data[0] = SYS_DSS;
>>> +     caps->u.buffer.data[1] = SYS_DVBS;
>>> +     caps->u.buffer.data[2] = SYS_DVBS2;
>>> +     caps->u.buffer.len = 3;

This doesn't sound right to me. If userspace passed space for only one delivery system,
you can't just adjust the size here and expect it to work, as the array on userspace
may be smaller than 3 properties.

Also, the other DVBv5 properties may not be DTV_DELIVERY_CAPS type.

In other words, the driver or core needs to check if the type is DTV_DELIVERY_CAPS
before filling it.

Btw, if the "capabilities" here is just the delivery system, it would be better to
name it as something like DTV_GET_SUPPORTED_DELIVERY.

We should also think on a way to enumerate the supported values for each DVB properties,
the enum fe_caps is not enough anymore to store everything. It currently has 30 bits
filled (of a total of 32 bits), and we currently have:
	12 code rates (including AUTO/NONE);
	13 modulation types;
	7 transmission modes;
	7 bandwidths;
	8 guard intervals (including AUTO);
	5 hierarchy names;
	4 rolloff's (probably, we'll need to add 2 more, to distinguish between DVB-C Annex A and Annex C).

So, if we would need to add one CAN_foo for each of the above, we would need 56 to 58
bits, plus 5-6 bits to the other capabilities that currently exists there. So, even
64 bits won't be enough for the current needs (even having the delivery system caps
addressed by something else).

It means that FE_GET_INFO needs to be replaced by something that scales better, e. g.
that would allow to enumerate the supported ranges for each DVBv5 parameter.


>>> +
>>> +     return 0;
>>> +}
>>> +
>>>  static struct dvb_frontend_ops stb0899_ops = {
>>>
>>>       .info = {
>>> @@ -1647,6 +1660,8 @@
>>>       .diseqc_send_master_cmd         = stb0899_send_diseqc_msg,
>>>       .diseqc_recv_slave_reply        = stb0899_recv_slave_reply,
>>>       .diseqc_send_burst              = stb0899_send_diseqc_burst,
>>> +
>>> +     .delivery_caps                  = stb0899_delivery_caps,
>>>  };
>>>
>>>  struct dvb_frontend *stb0899_attach(struct stb0899_config *config, struct i2c_adapter *i2c)
>>> diff -r b6eb04718aa9 linux/include/linux/dvb/frontend.h
>>> --- a/linux/include/linux/dvb/frontend.h      Wed Nov 09 19:52:36 2011 +0530
>>> +++ b/linux/include/linux/dvb/frontend.h      Thu Nov 10 13:51:35 2011 +0530
>>> @@ -316,7 +316,9 @@
>>>
>>>  #define DTV_DVBT2_PLP_ID     43
>>>
>>> -#define DTV_MAX_COMMAND                              DTV_DVBT2_PLP_ID
>>> +#define DTV_DELIVERY_CAPS    44
>>> +
>>> +#define DTV_MAX_COMMAND                              DTV_DELIVERY_CAPS
>>>
>>>  typedef enum fe_pilot {
>>>       PILOT_ON,
>>>
>>
>>
> 
> Thanks,
> Manu

