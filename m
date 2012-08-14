Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab2HNMeh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 08:34:37 -0400
Message-ID: <502A4615.1070600@redhat.com>
Date: Tue, 14 Aug 2012 14:35:33 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Copyright issues, do not copy code and add your own copyrights
References: <CAHFNz9+H9=NJSB6FY7i5bJPhXQL-eCpmomBCqi14hca2q-wVvg@mail.gmail.com> <502A1890.2050803@redhat.com> <CAHFNz9+b2sJVhrhcQVDLG7ZE=PQLUKE58c2raUz9oCBVzucWrQ@mail.gmail.com>
In-Reply-To: <CAHFNz9+b2sJVhrhcQVDLG7ZE=PQLUKE58c2raUz9oCBVzucWrQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/14/2012 11:42 AM, Manu Abraham wrote:
> Hi,
>
> On Tue, Aug 14, 2012 at 2:51 PM, Hans de Goede <hdegoede@redhat.com> wrote:
>> Hi,
>>
>>
>> On 08/14/2012 11:10 AM, Manu Abraham wrote:
>>>
>>> Hi,
>>>
>>> The subject line says it.
>>>
>>> Please fix the offending Copyright header.
>>>
>>> Offending one.
>>>
>>> http://git.linuxtv.org/media_tree.git/blob/staging/for_v3.7:/drivers/media/dvb-frontends/stb6100_proc.h
>>>
>>> Original one.
>>>
>>> http://git.linuxtv.org/media_tree.git/blob/staging/for_v3.7:/drivers/media/dvb-frontends/stb6100_cfg.h
>>
>>
>> Or even better, get rid of the offending one and add a i2c_gate_ctrl
>> parameters to the inline
>> functions defined in stb6100_cfg.h, as this seems a typical case of
>> unnecessary code-duplication.
>
>
> i2c_gate_ctrl is not provided by stb6100 hardware, but by the demodulator
> used in conjunction such as a stb0899 as can be seen.

Right, I was merely pointing out that the only difference between the
original function wrappers in stb6100_cfg.h and the ones in stb6100_proc.h,
is the calling of the i2c_gate_ctrl frontend-op if defined. So the 2 files
could be merged into one, with the wrappers getting an extra boolean parameter
making them call the frontend-op when that parameter is true.

Note that if the i2c_gate_ctrl frontend-op should always be called when
present then the extra parameter could be omitted.

<snip>

>> I would also like to point out that things like these are pretty much wrong:
>>
>>    27         if (&fe->ops)
>>    28                 frontend_ops = &fe->ops;
>>    29         if (&frontend_ops->tuner_ops)
>>    30                 tuner_ops = &frontend_ops->tuner_ops;
>>    31         if (tuner_ops->get_state) {
>>
>> The last check de-references tuner_ops, which only is non-NULL if
>> fe-ops and fe->ops->tuner_ops are non NULL. So either the last check
>> needs to be:
>>               if (tuner_ops && tuner_ops->get_state) {
>>
>> Or we assume that fe-ops and fe->ops->tuner_ops are always non NULL
>> when this helper gets called and all the previous checks can be removed.
>
>
> fe->ops is not NULL in any case, when we reach here, but that conditionality
> check causes a slight additional delay. The additional check you proposed
> presents no harm, though not bringing any new advantage/disadvantage.

Well if we know that fe->ops and fe->ops->tuner_ops are never NULL, then the
if (&fe->ops) and if (&frontend_ops->tuner_ops) are superfluous and should be
removed, on the other hand if we don't know that, then the get_state check should
be:
                if (tuner_ops && tuner_ops->get_state) {

Either know fe->ops and fe->ops->tuner_ops are never NULL and then all checks
should be removed, or we don't know and we should check them in *all* places
where they are used. What we've now is somewhat of the former, and then some of
the latter, which makes no sense at all.

Regards,

Hans




>
> Regards,
>
> Manu
>
