Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51838 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1KUVmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 16:42:11 -0500
Received: by iage36 with SMTP id e36so7839762iag.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 13:42:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHFNz9Lt11cy9kJtAaVWDRs5tQ938caupB-Tm0Ju6woBF3USUg@mail.gmail.com>
References: <CAHFNz9+e0K__EWdc=ckHURjjYMbez22=xup0d7=H7k2xQNVnyw@mail.gmail.com>
	<CAOcJUbyPPJe_ONV5bOXx_r+cwNd43eyThyRrawA0Gi1JydQV=Q@mail.gmail.com>
	<CAHFNz9Lt11cy9kJtAaVWDRs5tQ938caupB-Tm0Ju6woBF3USUg@mail.gmail.com>
Date: Mon, 21 Nov 2011 16:42:10 -0500
Message-ID: <CAOcJUbw-dLfY-nocioQXhJSP-ig3FTkL351f2RQhL_LC+d=MSg@mail.gmail.com>
Subject: Re: PATCH 04/13: 0004-TDA18271-Allow-frontend-to-set-DELSYS
From: Michael Krufky <mkrufky@linuxtv.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 21, 2011 at 4:28 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
> On 11/22/11, Michael Krufky <mkrufky@linuxtv.org> wrote:
>> Thank you, Manu... After the Linux Kernel Summit in Prague, I had
>> intentions of solving this exact problem, but you did it first -- good
>> job!
>>
>> I have reviewed the patch to the tda18271 driver, and the changes make
>> good sense to me.  I have one question, however:
>>
>> Perhaps my eyes have overlooked something -- I fail to see any code
>> that defines the new "set_state" callback or any code that calls this
>> new callback within dvb-core (assuming dvb_frontend.c)  I also can't
>> find the structure declaration of the "tuner_state" struct... ... is
>> this patch missing from your series, or did I just overlook it?
>
> I guess more like that. The data structure existed for quite a long
> while in dvb_frontend.h and hence you don't find any new changes. Only
> delivery and modulation added to it.
>
>>
>> That missing patch is what interests me most.  Once I can see that
>> missing code, I'd like to begin discussion on whether we actually need
>> the additional callback, or if it can simply be handled by the
>> set_params call.  Likewise, I'm not exactly sure why we need this
>> affional "struct tuner_state" ...  Perhaps the answer will be
>> self-explanatory once I see the code - maybe no discussion is
>> necessary :-P
>>
>> But this does look good to me so far.  I'd be happy to provide my
>> "reviewed-by" tag once I can see the missing code mentioned above.
>
> The callback is used from within a demodulator context as usual and hence.
> eg:
>
>        /* program tuner */
> -       if (fe->ops.tuner_ops.set_params)
> -               fe->ops.tuner_ops.set_params(fe, params);
> +       tstate.delsys = SYS_DVBC_ANNEX_AC;
> +       tstate.frequency = c->frequency;
> +
> +       if (fe->ops.tuner_ops.set_state) {
> +               fe->ops.tuner_ops.set_state(fe,
> +                                           DVBFE_TUNER_DELSYS    |
> +                                           DVBFE_TUNER_FREQUENCY,
> +                                           &tstate);
> +       } else {
> +               if (fe->ops.tuner_ops.set_params)
> +                       fe->ops.tuner_ops.set_params(fe, params);
> +       }
>
>
> Best Regards,
> Manu
>

Manu,

Thank you for explaining -- I found that structure in dvb_frontend.h,
now that you've pointed that out.

I am on board with this change -- it is a positive move in the right
direction.  I believe that after this is merged, we may be able to
obsolete and remove the set_params callback.  In fact, we can even
obsolete the set_analog_params callback as well, using set_state as
the single entry point for setting the tuner.  Of course, one step at
a time -- this is great for now.  We should consider the other
optimizations after this has been merged and tested. :-)

Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
