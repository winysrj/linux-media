Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58596 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab1KJPaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 10:30:23 -0500
Received: by wyh15 with SMTP id 15so2823782wyh.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 07:30:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EBBE336.8050501@linuxtv.org>
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com>
	<4EBBE336.8050501@linuxtv.org>
Date: Thu, 10 Nov 2011 21:00:22 +0530
Message-ID: <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com>
Subject: Re: PATCH: Query DVB frontend capabilities
From: Manu Abraham <abraham.manu@gmail.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

On Thu, Nov 10, 2011 at 8:14 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
> Hello Manu,
>
> please see my comments below:
>
> On 10.11.2011 15:18, Manu Abraham wrote:
>> Hi,
>>
>> Currently, for a multi standard frontend it is assumed that it just
>> has a single standard capability. This is fine in some cases, but
>> makes things hard when there are incompatible standards in conjuction.
>> Eg: DVB-S can be seen as a subset of DVB-S2, but the same doesn't hold
>> the same for DSS. This is not specific to any driver as it is, but a
>> generic issue. This was handled correctly in the multiproto tree,
>> while such functionality is missing from the v5 API update.
>>
>> http://www.linuxtv.org/pipermail/vdr/2008-November/018417.html
>>
>> Later on a FE_CAN_2G_MODULATION was added as a hack to workaround this
>> issue in the v5 API, but that hack is incapable of addressing the
>> issue, as it can be used to simply distinguish between DVB-S and
>> DVB-S2 alone, or another x vs X2 modulation. If there are more
>> systems, then you have a potential issue.
>>
>> In addition to the patch, for illustrative purposes the stb0899 driver
>> is depicted providing the said capability information.
>>
>> An application needs to query the device capabilities before
>> requesting an operation from the device.
>>
>> If people don't have any objections, Probably other drivers can be
>> adapted similarly. In fact the change is quite simple.
>>
>> Comments ?
>>
>> Regards,
>> Manu
>>
>>
>> query_frontend_capabilities.diff
>>
>>
>> diff -r b6eb04718aa9 linux/drivers/media/dvb/dvb-core/dvb_frontend.c
>> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c Wed Nov 09 19:52:36 2011 +0530
>> +++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c Thu Nov 10 13:51:35 2011 +0530
>> @@ -973,6 +973,8 @@
>>       _DTV_CMD(DTV_GUARD_INTERVAL, 0, 0),
>>       _DTV_CMD(DTV_TRANSMISSION_MODE, 0, 0),
>>       _DTV_CMD(DTV_HIERARCHY, 0, 0),
>> +
>> +     _DTV_CMD(DTV_DELIVERY_CAPS, 0, 0),
>>  };
>>
>>  static void dtv_property_dump(struct dtv_property *tvp)
>> @@ -1226,7 +1228,18 @@
>>               c = &cdetected;
>>       }
>>
>> +     dprintk("%s\n", __func__);
>> +
>>       switch(tvp->cmd) {
>> +     case DTV_DELIVERY_CAPS:
>> +             if (fe->ops.delivery_caps) {
>> +                     r = fe->ops.delivery_caps(fe, tvp);
>> +                     if (r < 0)
>> +                             return r;
>> +                     else
>> +                             goto done;
>
> What's the reason for introducing that label and goto?


The idea was to avoid using get_property callback being called.



>
>> +             }
>> +             break;
>>       case DTV_FREQUENCY:
>>               tvp->u.data = c->frequency;
>>               break;
>> @@ -1350,7 +1363,7 @@
>>               if (r < 0)
>>                       return r;
>>       }
>> -
>> +done:
>>       dtv_property_dump(tvp);
>>
>>       return 0;
>> diff -r b6eb04718aa9 linux/drivers/media/dvb/dvb-core/dvb_frontend.h
>> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.h Wed Nov 09 19:52:36 2011 +0530
>> +++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.h Thu Nov 10 13:51:35 2011 +0530
>> @@ -305,6 +305,8 @@
>>
>>       int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
>>       int (*get_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
>> +
>> +     int (*delivery_caps)(struct dvb_frontend *fe, struct dtv_property *tvp);
>>  };
>
> I don't think that another function pointer is required. Drivers can
> implement this in their get_property callback. The core could provide a
> default implementation, returning values derived from fe->ops.info.type
> and the 2G flag.


I see your point. While trying to address the issue I had originally
get_property being used. One Issue that came across to me was that:

 - while currently this is just one capability field, things do look
fine. As we move ahead we will possibly have more capability related
information, given the idea that with shared hardware infrastructure
on frontends, this list of properties could grow.

- Once we have a few properties, then we will need to have switches in
that callback, given that it is generic and that length will grow.
Considering different hardware capabilities, we will have quite a bit
of shared code amongst drivers in that large switch, causing code
duplication.
Eg: with hardware having shared infrastructure - while globally it
might have a larger set of capabilities, when a sub part of it is run
in some mode, the other sub parts would have reduced set of
capabilities, which won't be the same as that exists globally for the
device. The driver alone will know the change depending on what's
being used.


- Additionally, though insignificant a separate callback for each
capability will make the drivers look a bit more consistent with
regards to code style.

The basic issue is a switch that will be duplicated across drivers and
that which is expected to grow in length, eventually readability a
question. That said, this shouldn't be an issue at all. Given the
situation at this exact moment, having a generic callback is just
fine, as that will be the only which would be there, right now.


>
>>  #define MAX_EVENT 8
>> @@ -362,6 +364,8 @@
>>
>>       /* DVB-T2 specifics */
>>       u32                     dvbt2_plp_id;
>> +
>> +     fe_delivery_system_t    delivery_caps[32];
>>  };
>
> This array seems to be unused.


That just walked in astray while I worked on it. Didn't notice at all. :-)
I will send an updated patch, do you still think the generic callback
is better ?



>
> Regards,
> Andreas
>
>>  struct dvb_frontend {
>> diff -r b6eb04718aa9 linux/drivers/media/dvb/frontends/stb0899_drv.c
>> --- a/linux/drivers/media/dvb/frontends/stb0899_drv.c Wed Nov 09 19:52:36 2011 +0530
>> +++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c Thu Nov 10 13:51:35 2011 +0530
>> @@ -1605,6 +1605,19 @@
>>       return DVBFE_ALGO_CUSTOM;
>>  }
>>
>> +static int stb0899_delivery_caps(struct dvb_frontend *fe, struct dtv_property *caps)
>> +{
>> +     struct stb0899_state *state             = fe->demodulator_priv;
>> +
>> +     dprintk(state->verbose, FE_DEBUG, 1, "Get caps");
>> +     caps->u.buffer.data[0] = SYS_DSS;
>> +     caps->u.buffer.data[1] = SYS_DVBS;
>> +     caps->u.buffer.data[2] = SYS_DVBS2;
>> +     caps->u.buffer.len = 3;
>> +
>> +     return 0;
>> +}
>> +
>>  static struct dvb_frontend_ops stb0899_ops = {
>>
>>       .info = {
>> @@ -1647,6 +1660,8 @@
>>       .diseqc_send_master_cmd         = stb0899_send_diseqc_msg,
>>       .diseqc_recv_slave_reply        = stb0899_recv_slave_reply,
>>       .diseqc_send_burst              = stb0899_send_diseqc_burst,
>> +
>> +     .delivery_caps                  = stb0899_delivery_caps,
>>  };
>>
>>  struct dvb_frontend *stb0899_attach(struct stb0899_config *config, struct i2c_adapter *i2c)
>> diff -r b6eb04718aa9 linux/include/linux/dvb/frontend.h
>> --- a/linux/include/linux/dvb/frontend.h      Wed Nov 09 19:52:36 2011 +0530
>> +++ b/linux/include/linux/dvb/frontend.h      Thu Nov 10 13:51:35 2011 +0530
>> @@ -316,7 +316,9 @@
>>
>>  #define DTV_DVBT2_PLP_ID     43
>>
>> -#define DTV_MAX_COMMAND                              DTV_DVBT2_PLP_ID
>> +#define DTV_DELIVERY_CAPS    44
>> +
>> +#define DTV_MAX_COMMAND                              DTV_DELIVERY_CAPS
>>
>>  typedef enum fe_pilot {
>>       PILOT_ON,
>>
>
>

Thanks,
Manu
