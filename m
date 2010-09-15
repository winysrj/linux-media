Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32974 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab0IOSBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 14:01:37 -0400
Received: by pzk34 with SMTP id 34so138581pzk.19
        for <linux-media@vger.kernel.org>; Wed, 15 Sep 2010 11:01:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C90B4FB.2050401@s5r6.in-berlin.de>
References: <AANLkTin53SY_xaed_tRfWRPOFmc65GmGzXrEt15ZyriW@mail.gmail.com>
	<4C90B4FB.2050401@s5r6.in-berlin.de>
Date: Wed, 15 Sep 2010 20:01:35 +0200
Message-ID: <AANLkTikasNTUQPZ8UMfaEQAeLV79Bde2Ty_VWWVkxjoo@mail.gmail.com>
Subject: Re: [PATCH] firedtv driver: support for PSK8 for S2 devices. To watch HD.
From: Tommy Jonsson <quazzie2@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sorry, that's the only values i was able to find out.
The _AUTO for both ROLLOFF and PILOT are my own as there where no auto
in the scanning program i used to scan with. I set them to what i
thought was best.

About the set_property and get_property i don't know if you need to
define them, i just saw that other drivers where doing it so i did to.

On Wed, Sep 15, 2010 at 1:58 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Tommy Jonsson wrote:
>> --- a/linux/drivers/media/dvb/firewire/firedtv-avc.c  Fri Sep 03
>> 00:28:05 2010 -0300
>> +++ b/linux/drivers/media/dvb/firewire/firedtv-avc.c  Sun Sep 12
>> 06:52:02 2010 +0200
> [...]
>> @@ -368,10 +369,30 @@
>>               c->operand[12] = 0;
>>
>>       if (fdtv->type == FIREDTV_DVB_S2) {
>> -             c->operand[13] = 0x1;
>> -             c->operand[14] = 0xff;
>> -             c->operand[15] = 0xff;
>> -
>> +             if (fe->dtv_property_cache.delivery_system == SYS_DVBS2) {
>> +                     switch (fe->dtv_property_cache.modulation) {
>> +                     case QAM_16:            c->operand[13] = 0x1; break;
>> +                     case QPSK:              c->operand[13] = 0x2; break;
>> +                     case PSK_8:             c->operand[13] = 0x3; break;
>> +                     default:                c->operand[13] = 0x2; break;
>> +                     }
>> +                     switch (fe->dtv_property_cache.rolloff) {
>> +                     case ROLLOFF_AUTO:      c->operand[14] = 0x2; break;
>> +                     case ROLLOFF_35:        c->operand[14] = 0x2; break;
>> +                     case ROLLOFF_20:        c->operand[14] = 0x0; break;
>> +                     case ROLLOFF_25:        c->operand[14] = 0x1; break;
>> +                     /* case ROLLOFF_NONE:   c->operand[14] = 0xff; break; */
>> +                     }
>> +                     switch (fe->dtv_property_cache.pilot) {
>> +                     case PILOT_AUTO:        c->operand[15] = 0x0; break;
>> +                     case PILOT_OFF:         c->operand[15] = 0x0; break;
>> +                     case PILOT_ON:          c->operand[15] = 0x1; break;
>> +                     }
>> +             } else {
>> +                     c->operand[13] = 0x1;  /* auto modulation */
>> +                     c->operand[14] = 0xff; /* disable rolloff */
>> +                     c->operand[15] = 0xff; /* disable pilot */
>> +             }
>>               return 16;
>
> Is it correct that there is no default: case for operand[14] and [15]?
>
>>       } else {
>>               return 13;
>> @@ -548,7 +569,7 @@
>>       return 17 + add_pid_filter(fdtv, &c->operand[17]);
>>  }
>>
>> -int avc_tuner_dsd(struct firedtv *fdtv,
>> +int avc_tuner_dsd(struct dvb_frontend *fe, struct firedtv *fdtv,
>>                 struct dvb_frontend_parameters *params)
>>  {
>>       struct avc_command_frame *c = (void *)fdtv->avc_data;
>
> The frontend can be accessed via fdtv->fe also.  (I can change this together
> with the whitespace things if you agree.)
>
>> @@ -561,7 +582,7 @@
>>
>>       switch (fdtv->type) {
>>       case FIREDTV_DVB_S:
>> -     case FIREDTV_DVB_S2: pos = avc_tuner_tuneqpsk(fdtv, params); break;
>> +     case FIREDTV_DVB_S2: pos = avc_tuner_tuneqpsk(fe, fdtv, params); break;
>>       case FIREDTV_DVB_C: pos = avc_tuner_dsd_dvb_c(fdtv, params); break;
>>       case FIREDTV_DVB_T: pos = avc_tuner_dsd_dvb_t(fdtv, params); break;
>>       default:
>> diff -r 6e0befab696a linux/drivers/media/dvb/firewire/firedtv-fe.c
>> --- a/linux/drivers/media/dvb/firewire/firedtv-fe.c   Fri Sep 03
>> 00:28:05 2010 -0300
>> +++ b/linux/drivers/media/dvb/firewire/firedtv-fe.c   Sun Sep 12
>> 06:52:02 2010 +0200
> [...]
>> @@ -155,6 +156,17 @@
>>       return -EOPNOTSUPP;
>>  }
>>
>> +static int fdtv_get_property(struct dvb_frontend *fe,
>> +                             struct dtv_property *tvp)
>> +{
>> +     return 0;
>> +}
>> +static int fdtv_set_property(struct dvb_frontend *fe,
>> +                             struct dtv_property *tvp)
>> +{
>> +     return 0;
>> +}
>> +
>>  void fdtv_frontend_init(struct firedtv *fdtv)
>>  {
>>       struct dvb_frontend_ops *ops = &fdtv->fe.ops;
>> @@ -166,6 +178,9 @@
>>       ops->set_frontend               = fdtv_set_frontend;
>>       ops->get_frontend               = fdtv_get_frontend;
>>
>> +     ops->get_property               = fdtv_get_property;
>> +     ops->set_property               = fdtv_set_property;
>> +
>>       ops->read_status                = fdtv_read_status;
>>       ops->read_ber                   = fdtv_read_ber;
>>       ops->read_signal_strength       = fdtv_read_signal_strength;
> [...]
>
> (Hmm, note to self:  Can't DVB core provide empty default methods?)
> --
> Stefan Richter
> -=====-==-=- =--= -====
> http://arcgraph.de/sr/
>
