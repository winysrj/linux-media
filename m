Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36315 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2HNJmu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 05:42:50 -0400
Received: by weyx8 with SMTP id x8so115734wey.19
        for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 02:42:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502A1890.2050803@redhat.com>
References: <CAHFNz9+H9=NJSB6FY7i5bJPhXQL-eCpmomBCqi14hca2q-wVvg@mail.gmail.com>
	<502A1890.2050803@redhat.com>
Date: Tue, 14 Aug 2012 15:12:49 +0530
Message-ID: <CAHFNz9+b2sJVhrhcQVDLG7ZE=PQLUKE58c2raUz9oCBVzucWrQ@mail.gmail.com>
Subject: Re: Copyright issues, do not copy code and add your own copyrights
From: Manu Abraham <abraham.manu@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Aug 14, 2012 at 2:51 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
>
> On 08/14/2012 11:10 AM, Manu Abraham wrote:
>>
>> Hi,
>>
>> The subject line says it.
>>
>> Please fix the offending Copyright header.
>>
>> Offending one.
>>
>> http://git.linuxtv.org/media_tree.git/blob/staging/for_v3.7:/drivers/media/dvb-frontends/stb6100_proc.h
>>
>> Original one.
>>
>> http://git.linuxtv.org/media_tree.git/blob/staging/for_v3.7:/drivers/media/dvb-frontends/stb6100_cfg.h
>
>
> Or even better, get rid of the offending one and add a i2c_gate_ctrl
> parameters to the inline
> functions defined in stb6100_cfg.h, as this seems a typical case of
> unnecessary code-duplication.


i2c_gate_ctrl is not provided by stb6100 hardware, but by the demodulator
used in conjunction such as a stb0899 as can be seen.


1473                         /* enable tuner I/O */
1474                         stb0899_i2c_gate_ctrl(&state->frontend, 1);
1475
1476                         if (state->config->tuner_set_bandwidth)
1477
state->config->tuner_set_bandwidth(fe, (13 *
(stb0899_carr_width(state) + SearchRange)) / 10);
1478                         if (state->config->tuner_get_bandwidth)
1479
state->config->tuner_get_bandwidth(fe, &internal->tuner_bw);


A sleep for a jiffie is needed after the gate is enabled, but any real life
sleep is pointless and causes unnecessary delays, causing noise to bleed
into the demodulator.

This improves tuning performance slightly. The user (demodulator) of the tuner
needs to enable/disable the gate, in this case as seen in

http://git.linuxtv.org/media_tree.git/blob/staging/for_v3.7:/drivers/media/dvb-frontends/stb0899_drv.c


>
> I would also like to point out that things like these are pretty much wrong:
>
>   27         if (&fe->ops)
>   28                 frontend_ops = &fe->ops;
>   29         if (&frontend_ops->tuner_ops)
>   30                 tuner_ops = &frontend_ops->tuner_ops;
>   31         if (tuner_ops->get_state) {
>
> The last check de-references tuner_ops, which only is non-NULL if
> fe-ops and fe->ops->tuner_ops are non NULL. So either the last check
> needs to be:
>              if (tuner_ops && tuner_ops->get_state) {
>
> Or we assume that fe-ops and fe->ops->tuner_ops are always non NULL
> when this helper gets called and all the previous checks can be removed.


fe->ops is not NULL in any case, when we reach here, but that conditionality
check causes a slight additional delay. The additional check you proposed
presents no harm, though not bringing any new advantage/disadvantage.

Regards,

Manu
