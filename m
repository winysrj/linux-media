Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:47620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652Ab1BPNrW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 08:47:22 -0500
Message-ID: <4D5BD565.60604@redhat.com>
Date: Wed, 16 Feb 2011 11:47:17 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] [media] tuner-core: remove usage of DIGITAL_TV
References: <cover.1297776328.git.mchehab@redhat.com>	 <20110215113334.49ead2c2@pedra>	 <a0597677-0cba-48b0-97e6-df1fa46464b7@email.android.com>	 <4D5AD880.1050702@redhat.com> <1297860929.2086.3.camel@morgan.silverblock.net>
In-Reply-To: <1297860929.2086.3.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 16-02-2011 10:55, Andy Walls escreveu:
> On Tue, 2011-02-15 at 17:48 -0200, Mauro Carvalho Chehab wrote:
>> Em 15-02-2011 15:25, Andy Walls escreveu:
>>> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>>>
>>>> tuner-core has no business to do with digital TV. So, don't use
>>>> T_DIGITAL_TV on it, as it has no code to distinguish between
>>>> them, and nobody fills T_DIGITAL_TV right.
>>>>
>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>>>
> 
>>>> diff --git a/drivers/media/video/tuner-core.c
>>>> b/drivers/media/video/tuner-core.c
>>>> index dcf03fa..5e1437c 100644
>>>> --- a/drivers/media/video/tuner-core.c
>>>> +++ b/drivers/media/video/tuner-core.c
> 
>>>> @@ -596,7 +595,7 @@ static int tuner_probe(struct i2c_client *client,
>>>> 	   first found TV tuner. */
>>>> 	tuner_lookup(t->i2c->adapter, &radio, &tv);
>>>> 	if (tv == NULL) {
>>>> -		t->mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
>>>> +		t->mode_mask = T_ANALOG_TV;
>>>> 		if (radio == NULL)
>>>> 			t->mode_mask |= T_RADIO;
>>>> 		tuner_dbg("Setting mode_mask to 0x%02x\n", t->mode_mask);
>>>> @@ -607,18 +606,15 @@ register_client:
>>>> 	/* Sets a default mode */
>>>> 	if (t->mode_mask & T_ANALOG_TV)
>>>> 		t->mode = V4L2_TUNER_ANALOG_TV;
>>>> -	else if (t->mode_mask & T_RADIO)
>>>> -		t->mode = V4L2_TUNER_RADIO;
>>>> 	else
>>>> -		t->mode = V4L2_TUNER_DIGITAL_TV;
>>>> +		t->mode = V4L2_TUNER_RADIO;
>                             ^^^^^^^^^^^^^^^^^^^^^
> Mauro,
> 
> Here's where I saw a default being changed from DIGITAL_TV to RADIO.
> Maybe it doesn't matter?

Currently, there are just two mode_mask's: T_ANALOG_TV and T_RADIO. If it is not one, it is
the other ;)

Well, in a matter of fact, I didn't drop T_DIGITAL_TV yet, just because it is used internally
inside one driver, for its internal usage only:

$ git grep T_DIGITAL_TV include/media
include/media/tuner.h:    T_DIGITAL_TV    = 1 << V4L2_TUNER_DIGITAL_TV,

$ git grep -B1 T_DIGITAL_TV drivers/media/ 
drivers/media/common/tuners/tuner-xc2028.c-       return generic_set_freq(fe, p->frequency,
drivers/media/common/tuners/tuner-xc2028.c:                               T_DIGITAL_TV, type, 0, demod);

As you see, the changes are simple, and the usage is pure internally:

drivers/media/common/tuners/tuner-xc2028.c:static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
drivers/media/common/tuners/tuner-xc2028.c-                           enum tuner_mode new_mode,
--
drivers/media/common/tuners/tuner-xc2028.c:               return generic_set_freq(fe, (625l * p->frequency) / 10,
drivers/media/common/tuners/tuner-xc2028.c-                               T_RADIO, type, 0, 0);
--
drivers/media/common/tuners/tuner-xc2028.c:       return generic_set_freq(fe, 62500l * p->frequency,
drivers/media/common/tuners/tuner-xc2028.c-                               T_ANALOG_TV, type, p->std, 0);
--
drivers/media/common/tuners/tuner-xc2028.c:       return generic_set_freq(fe, p->frequency,
drivers/media/common/tuners/tuner-xc2028.c-                               T_DIGITAL_TV, type, 0, demod);

I'll write a patch removing the latest usage of it (basically, replacing them by V4L2_TUNER_*).

Of course, tests are more than welcome to be sure that those changes didn't cause any regression.

Cheers,
Mauro
