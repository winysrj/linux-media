Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36886 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1BCXu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Feb 2011 18:50:28 -0500
Received: by ewy5 with SMTP id 5so1040468ewy.19
        for <linux-media@vger.kernel.org>; Thu, 03 Feb 2011 15:50:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D497693.5020403@redhat.com>
References: <AANLkTim3=Xuyantq2zKJ0W8C+-objnBQNbYNaqb9pgc-@mail.gmail.com>
	<4D497693.5020403@redhat.com>
Date: Thu, 3 Feb 2011 18:50:25 -0500
Message-ID: <AANLkTikXKxdPDQZjdi_LwqGSUpiYbDvR3=EXnJS6u0Ok@mail.gmail.com>
Subject: Re: [RFC PATCH] tuner-core: fix broken G_TUNER call when tuner is in standby
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Feb 2, 2011 at 10:21 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 23-01-2011 20:22, Devin Heitmueller escreveu:
>> Hello all,
>>
>> The following patch addresses a V4L2 specification violation where the
>> G_TUNER call would return complete garbage in the event that the tuner
>> is asleep.  Per Hans' suggestion, I have split out the tuner
>> operational mode from whether it is in standby, and fixed the G_TUNER
>> call to return as much as possible when the tuner is in standby.
>>
>> Without this change, products that have tuners which support standby
>> mode cannot be tuned from within VLC.
>>
>> I recognize that changes to tuner-core tend to be pretty hairy, so I
>> welcome suggestions/feedback on this patch.
>>
>> Regards,
>>
>> Devin
>>
>> -- Devin J. Heitmueller - Kernel Labs http://www.kernellabs.com
>>
>>
>> tuner_standby_mode.patch
>>
>>
>> tuner-core: fix broken G_TUNER call when tuner is in standby
>>
>> From: Devin Heitmueller <dheitmueller@kernellabs.com>
>>
>> The logic for determining the supported device modes was combined with the
>> logic which dictates whether the tuner was asleep.  This resulted in calls
>> such as G_TUNER returning complete garbage in the event that the tuner was
>> in standby mode (a violation of the V4L2 specification, and causing VLC to
>> be broken for such tuners).
>>
>> This patch reworks the logic so the current tuner mode is maintained separately
>> from whether it is in standby (per Hans Verkuil's suggestion).  It also
>> restructures the G_TUNER call such that all the staticly defined information
>> related to the tuner is returned regardless of whether it is in standby (e.g.
>> the supported frequency range, etc).
>>
>> Priority: normal
>>
>> Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>>
>> --- media_build/linux/drivers/media/video/tuner-core.c        2010-10-24 19:34:59.000000000 -0400
>> +++ media_build_950qfixes//linux/drivers/media/video/tuner-core.c     2011-01-23 17:18:22.381107568 -0500
>> @@ -90,6 +90,7 @@
>>
>>       unsigned int        mode;
>>       unsigned int        mode_mask; /* Combination of allowable modes */
>> +     unsigned int        in_standby:1;
>>
>>       unsigned int        type; /* chip type id */
>>       unsigned int        config;
>> @@ -700,6 +701,7 @@
>>  static inline int set_mode(struct i2c_client *client, struct tuner *t, int mode, char *cmd)
>>  {
>>       struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
>> +     unsigned int orig_mode = t->mode;
>>
>>       if (mode == t->mode)
>>               return 0;
>> @@ -709,7 +711,8 @@
>>       if (check_mode(t, cmd) == -EINVAL) {
>>               tuner_dbg("Tuner doesn't support this mode. "
>>                         "Putting tuner to sleep\n");
>> -             t->mode = T_STANDBY;
>> +             t->mode = orig_mode;
>
> Hmm... as orig_mode = t->mode, this is:
>        t->mode = t->mode...
>
> This doesn't make sense ;)

Look again.  The target mode being switched to is provided as an
argument.  So the code preserves the old mode in orig_mode, switches
to the new mode, then calls check_mode() against the new mode.  If the
call fails, we reset it back to the mode it was in before the call.

>> +             t->in_standby = 1;
>>               if (analog_ops->standby)
>>                       analog_ops->standby(&t->fe);
>>               return -EINVAL;
>> @@ -769,7 +772,7 @@
>>
>>       if (check_mode(t, "s_power") == -EINVAL)
>>               return 0;
>> -     t->mode = T_STANDBY;
>> +     t->in_standby = 1;
>>       if (analog_ops->standby)
>>               analog_ops->standby(&t->fe);
>>       return 0;
>> @@ -854,47 +857,54 @@
>>       struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
>>       struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
>>
>> -     if (check_mode(t, "g_tuner") == -EINVAL)
>> -             return 0;
>
> Some of those checks are to allow switching between radio and TV
> mode. Had you test to switch between video/radio mode on your tests
> (e. g. alternating video streaming on/off with radio tune)?

I don't have any radio supported devices.

>>       switch_v4l2();
>>
>> +     /* First populate everything that doesn't require talking to the
>> +        actual hardware */
>>       vt->type = t->mode;
>> -     if (analog_ops->get_afc)
>> -             vt->afc = analog_ops->get_afc(&t->fe);
>>       if (t->mode == V4L2_TUNER_ANALOG_TV)
>> +     {
>>               vt->capability |= V4L2_TUNER_CAP_NORM;
>> -     if (t->mode != V4L2_TUNER_RADIO) {
>>               vt->rangelow = tv_range[0] * 16;
>>               vt->rangehigh = tv_range[1] * 16;
>> -             return 0;
>> +     } else {
>> +             /* radio mode */
>> +             vt->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
>> +             vt->capability |= V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
>> +             vt->audmode = t->audmode;
>> +             vt->rangelow = radio_range[0] * 16000;
>> +             vt->rangehigh = radio_range[1] * 16000;
>>       }
>>
>> -     /* radio mode */
>> -     vt->rxsubchans =
>> -             V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
>> -     if (fe_tuner_ops->get_status) {
>> -             u32 tuner_status;
>> +     /* If the hardware is in sleep mode, bail out at this point */
>> +     if (t->in_standby)
>> +             return 0;
>
> This doesn't seem right. Instead, the proper behaviour should be
> to turn tuner on (likely waiting for some time) and then get a status.

I disagree.  Turning the tuner on (and incurring firmware load time)
just to get the tuner's basic capabilities would significantly change
the timing of the call and likely break applications that expect it to
return immediately.

>>
>> -             fe_tuner_ops->get_status(&t->fe, &tuner_status);
>> -             vt->rxsubchans =
>> -                     (tuner_status & TUNER_STATUS_STEREO) ?
>> -                     V4L2_TUNER_SUB_STEREO :
>> -                     V4L2_TUNER_SUB_MONO;
>> +     /* Now populate the fields that requires the hardware to be alive */
>> +     if (t->mode == V4L2_TUNER_ANALOG_TV) {
>> +             if (analog_ops->get_afc)
>> +                     vt->afc = analog_ops->get_afc(&t->fe);
>>       } else {
>> -             if (analog_ops->is_stereo) {
>> +             if (fe_tuner_ops->get_status) {
>
> Hmm... get_status() taking procedence over is_stereo... not sure if this
> work as expected. On the other hand:
>
> $ git grep is_stereo drivers/media/
> drivers/media/dvb/dvb-core/dvb_frontend.h:        int  (*is_stereo)(struct dvb_frontend *fe);
> drivers/media/radio/radio-zoltrix.c:static int zol_is_stereo(struct zoltrix *zol)
> drivers/media/radio/radio-zoltrix.c:      if (zol_is_stereo(zol))
> drivers/media/video/msp3400-kthreads.c:   int is_stereo = status & 0x40;
> drivers/media/video/msp3400-kthreads.c:   if (is_stereo)
> drivers/media/video/msp3400-kthreads.c:           status, is_stereo, is_bilingual, state->rxsubchans);
> drivers/media/video/tuner-core.c: if (analog_ops->is_stereo)
> drivers/media/video/tuner-core.c:                    analog_ops->is_stereo(fe) ? "yes" : "no");
> drivers/media/video/tuner-core.c:         if (analog_ops->is_stereo) {
> drivers/media/video/tuner-core.c:                         analog_ops->is_stereo(&t->fe) ?
>
> It seems that nobody is using is_stereo() callback anymore. So, we can just
> get rid of it. This is part of an old API that was there before mkrufky patches
> that unified analog and digital tuners.

Feel free to dump deprecated functionality.  I don't know the code
well enough to make determinations on what code can go away.

>> +                     u32 tuner_status;
>> +
>> +                     fe_tuner_ops->get_status(&t->fe, &tuner_status);
>>                       vt->rxsubchans =
>> -                             analog_ops->is_stereo(&t->fe) ?
>> +                             (tuner_status & TUNER_STATUS_STEREO) ?
>>                               V4L2_TUNER_SUB_STEREO :
>>                               V4L2_TUNER_SUB_MONO;
>> +             } else {
>> +                     if (analog_ops->is_stereo) {
>> +                             vt->rxsubchans =
>> +                                     analog_ops->is_stereo(&t->fe) ?
>> +                                     V4L2_TUNER_SUB_STEREO :
>> +                                     V4L2_TUNER_SUB_MONO;
>> +                     }
>>               }
>> +             if (analog_ops->has_signal)
>> +                     vt->signal = analog_ops->has_signal(&t->fe);
>
> has_signal() seems to be another callback asking for its removal. Only tda8290 has it:

Yeah, seems I confused "has_signal()" with "get_rf_strength()".  It
does make me wonder though how you userland is expected to actually
get the signal strength in for devices that implement
get_rf_strength().

> $ git grep has_signal drivers/media/
> drivers/media/common/tuners/tda8290.c:static int tda8295_has_signal(struct dvb_frontend *fe)
> drivers/media/common/tuners/tda8290.c:    if (tda8295_has_signal(fe))
> drivers/media/common/tuners/tda8290.c:static int tda8290_has_signal(struct dvb_frontend *fe)
> drivers/media/common/tuners/tda8290.c:    .has_signal     = tda8290_has_signal,
> drivers/media/common/tuners/tda8290.c:    .has_signal     = tda8295_has_signal,
> drivers/media/dvb/dvb-core/dvb_frontend.h:        int  (*has_signal)(struct dvb_frontend *fe);
> drivers/media/video/tuner-core.c:static int fe_has_signal(struct dvb_frontend *fe)
> drivers/media/video/tuner-core.c: .has_signal     = fe_has_signal,
> drivers/media/video/tuner-core.c: if (analog_ops->has_signal)
> drivers/media/video/tuner-core.c:                    analog_ops->has_signal(fe));
> drivers/media/video/tuner-core.c: if (analog_ops->has_signal)
> drivers/media/video/tuner-core.c:         vt->signal = analog_ops->has_signal(&t->fe);
>
> Other drivers use get_rf_strength():
>
> $ git grep get_rf_strength drivers/media/
> drivers/media/common/tuners/tea5761.c:static int tea5761_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
> drivers/media/common/tuners/tea5761.c:    .get_rf_strength   = tea5761_get_rf_strength,
> drivers/media/common/tuners/tea5767.c:static int tea5767_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
> drivers/media/common/tuners/tea5767.c:    .get_rf_strength   = tea5767_get_rf_strength,
> drivers/media/common/tuners/tuner-simple.c:static int simple_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
> drivers/media/common/tuners/tuner-simple.c:       .get_rf_strength   = simple_get_rf_strength,
> drivers/media/common/tuners/tuner-xc2028.c:       .get_rf_strength   = xc2028_signal,
> drivers/media/dvb/dvb-core/dvb_frontend.h:        int (*get_rf_strength)(struct dvb_frontend *fe, u16 *strength);
> drivers/media/video/tuner-core.c: if (fe->ops.tuner_ops.get_rf_strength)
> drivers/media/video/tuner-core.c:         fe->ops.tuner_ops.get_rf_strength(fe, &strength);
>
> So, I think we should replace has_signal() at tda8290, with get_rf_strength(),
> and remove its call from tuner-core.
>
>>       }
>> -     if (analog_ops->has_signal)
>> -             vt->signal = analog_ops->has_signal(&t->fe);
>> -     vt->capability |=
>> -             V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
>> -     vt->audmode = t->audmode;
>> -     vt->rangelow = radio_range[0] * 16000;
>> -     vt->rangehigh = radio_range[1] * 16000;
>> +
>>       return 0;
>>  }
>>
>> @@ -911,6 +921,11 @@
>>       /* do nothing unless we're a radio tuner */
>>       if (t->mode != V4L2_TUNER_RADIO)
>>               return 0;
>> +
>> +     /* Should this really fail silently if the device is asleep? */
>> +     if (t->in_standby == 1)
>> +             return 0;
>> +
>
> Same comment as before: it should wake up the device. That's
> the expected behaviour by radio applications like console/radio.
>
>>       t->audmode = vt->audmode;
>>       set_radio_freq(client, t->radio_freq);
>>       return 0;
>> @@ -1004,14 +1019,11 @@
>>       *tv = NULL;
>>
>>       list_for_each_entry(pos, &tuner_list, list) {
>> -             int mode_mask;
>> -
>>               if (pos->i2c->adapter != adap ||
>>                   strcmp(pos->i2c->driver->driver.name, "tuner"))
>>                       continue;
>>
>> -             mode_mask = pos->mode_mask & ~T_STANDBY;
>> -             if (*radio == NULL && mode_mask == T_RADIO)
>> +             if (*radio == NULL && pos->mode_mask == T_RADIO)
>>                       *radio = pos;
>>               /* Note: currently TDA9887 is the only demod-only
>>                  device. If other devices appear then we need to
>> @@ -1063,7 +1075,8 @@
>>                                              t->i2c->addr) >= 0) {
>>                               t->type = TUNER_TEA5761;
>>                               t->mode_mask = T_RADIO;
>> -                             t->mode = T_STANDBY;
>> +                             t->mode = T_RADIO;
>> +                             t->in_standby = 1;
>>                               /* Sets freq to FM range */
>>                               t->radio_freq = 87.5 * 16000;
>>                               tuner_lookup(t->i2c->adapter, &radio, &tv);
>> @@ -1088,7 +1101,8 @@
>>                               t->type = TUNER_TDA9887;
>>                               t->mode_mask = T_RADIO | T_ANALOG_TV |
>>                                              T_DIGITAL_TV;
>> -                             t->mode = T_STANDBY;
>> +                             t->mode = T_ANALOG_TV;
>> +                             t->in_standby = 1;
>>                               goto register_client;
>>                       }
>>                       break;
>> @@ -1098,7 +1112,8 @@
>>                                       >= 0) {
>>                               t->type = TUNER_TEA5767;
>>                               t->mode_mask = T_RADIO;
>> -                             t->mode = T_STANDBY;
>> +                             t->mode = T_RADIO;
>> +                             t->in_standby = 1;
>>                               /* Sets freq to FM range */
>>                               t->radio_freq = 87.5 * 16000;
>>                               tuner_lookup(t->i2c->adapter, &radio, &tv);
>
> Not sure about the above. In the past, T_STANDBY were used at the
> initial setup to tell the core that the tuner is not in usage. I
> think we need to do some tests to see if none of the above changes
> would break it. Complex devices to probe are those with multiple
> tuners, like devices with a tea5767 for FM and a separate tuner for
> TV. I think we need to do some tests with those devices.
>
> Cheers,
> Mauro
>

This whole driver's an absolute mess, so I was obviously loathe to
touch *anything* in there.  I really didn't have any choice though
given the violation of the V4L2 specification with regards to the
G_TUNER call.  Hans was the one who pushed for separating out whether
the tuner was asleep from the tuner mode, which unfortunately is
necessary because G_TUNER is returning a garbage value for the type
field (because it's returning T_STANDBY, which is a violation of the
spec).

I don't think I have any devices with radio support, so I cannot test
those scenarios.

I'm not confident any get call should really be waking up the tuner
(which could be very expensive if firmware loading is involved).  It
seems like the driver should return what it knows, and the other
fields which require the tuner to be alive should just return zero.
This should be fine since we're really only talking about signal
strength, which would already be zero if the device was in standby.

I welcome any alternative patch which makes G_TUNER work per the spec
for tuners in a standby state.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
