Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48939 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2ABGUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 01:20:47 -0500
Received: by wgbds13 with SMTP id ds13so21267913wgb.1
        for <linux-media@vger.kernel.org>; Sun, 01 Jan 2012 22:20:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EF9FB1A.5090509@infradead.org>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
	<1324948159-23709-2-git-send-email-mchehab@redhat.com>
	<4EF9B606.3090908@linuxtv.org>
	<4EF9C7FA.9070203@infradead.org>
	<4EF9D71E.5090606@linuxtv.org>
	<4EF9FB1A.5090509@infradead.org>
Date: Mon, 2 Jan 2012 11:50:45 +0530
Message-ID: <CAHFNz9JgHoTfA6pSy-n_By9MMVm3a0w5115G+ig7yzhm8MiU8g@mail.gmail.com>
Subject: Re: [PATCH RFC 01/91] [media] dvb-core: allow demods to specify the
 supported delivery systems supported standards.
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 27, 2011 at 10:36 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On 27-12-2011 12:33, Andreas Oberritter wrote:
>> On 27.12.2011 14:28, Mauro Carvalho Chehab wrote:
>>> On 27-12-2011 10:11, Andreas Oberritter wrote:
>>>> On 27.12.2011 02:07, Mauro Carvalho Chehab wrote:
>>>>> DVB-S and DVB-T, as those were the standards supported by DVBv3.
>>>>
>>>> The description seems to be incomplete.
>>>>
>>>>> New standards like DSS, ISDB and CTTB don't fit on any of the
>>>>> above types.
>>>>>
>>>>> while there's a way for the drivers to explicitly change whatever
>>>>> default DELSYS were filled inside the core, still a fake value is
>>>>> needed there, and a "compat" code to allow DVBv3 applications to
>>>>> work with those delivery systems is needed. This is good for a
>>>>> short term solution, while applications aren't using DVBv5 directly.
>>>>>
>>>>> However, at long term, this is bad, as the compat code runs even
>>>>> if the application is using DVBv5. Also, the compat code is not
>>>>> perfect, and only works when the frontend is capable of auto-detecting
>>>>> the parameters that aren't visible by the faked delivery systems.
>>>>>
>>>>> So, let the frontend fill the supported delivery systems at the
>>>>> device properties directly, and, in the future, let the core to use
>>>>> the delsys to fill the reported info::type based on the delsys.
>>>>>
>>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>>>> ---
>>>>>  drivers/media/dvb/dvb-core/dvb_frontend.c |   13 +++++++++++++
>>>>>  drivers/media/dvb/dvb-core/dvb_frontend.h |    8 ++++++++
>>>>>  2 files changed, 21 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
>>>>> index 8dedff4..f17c411 100644
>>>>> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
>>>>> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
>>>>> @@ -1252,6 +1252,19 @@ static void dtv_set_default_delivery_caps(const struct dvb_frontend *fe, struct
>>>>>    const struct dvb_frontend_info *info = &fe->ops.info;
>>>>>    u32 ncaps = 0;
>>>>>
>>>>> +  /*
>>>>> +   * If the frontend explicitly sets a list, use it, instead of
>>>>> +   * filling based on the info->type
>>>>> +   */
>>>>> +  if (fe->ops.delsys[ncaps]) {
>>>>> +          while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
>>>>> +                  p->u.buffer.data[ncaps] = fe->ops.delsys[ncaps];
>>>>> +                  ncaps++;
>>>>> +          }
>>>>> +          p->u.buffer.len = ncaps;
>>>>> +          return;
>>>>> +  }
>>>>> +
>>>>
>>>> I don't understand what this is trying to solve. This is already handled
>>>> by the get_property driver callback.
>>>>
>>>> dtv_set_default_delivery_caps() only sets some defaults for drivers not
>>>> implementing get_property yet.
>>>
>>> dtv_set_default_delivery_caps() does the wrong thing for delivery systems
>>> like ISDB-T, ISDB-S, DSS, DMB-TH, as it fills data with a fake value that
>>> is there at fe->ops.info.type.
>>>
>>> The fake values there should be used only for DVBv3 legacy calls emulation
>>> on those delivery systems that are not fully compatible with a DVBv3 call.
>>
>> That's right. Still, there's no need to introduce fe->ops.delsys,
>> because the drivers in question could just implement get_property
>> instead. At least that's what we discussed and AFAIR agreed upon when
>> Manu recently submitted his patches regarding enumeration of delivery
>> systems.
>
> Manu's patches were applied (well, except for two patches related to af9013
> driver that are/were under discussion between Manu and Antti).
>
> Manu's approach is good, as it provided a way to enumerate the
> standards without much changes, offering a way for userspace to
> query the delivery system, at the expense of serializing a driver
> call for each property.
>
> Yet, it doesn't allow the DVB core to detect the supported
> delivery systems on a sane way [1].
>
> The addition of fe->ops.delsys is going one step further, as it will
> allow, at the long term, the removal of info.type.
>
> There are two reasons why we need to get rid of info.type:
>
> 1) dvb_frontend core can be changed to use fe->ops.delsys
>   internally, instead of info.type, in order to fix some
>   bugs inside it, where it does the wrong assumption, because
>   the frontend is lying about the delivery system;


The frontend doesn't lie about the delivery system, but just announces
the delivery system to which the device is initialized by default.


>
> 2) There is no sane way to fill fe->ops.info.type for Multi delivery
>   system frontends, like DRX-K, that supports both DVB-T and DVB-C.
>   The type can be filled with either FE_QAM or FE_OFDM, not with both.
>   So, choosing either type will be plain wrong, and may cause bad
>   side effects inside dvb_frontend.


for any multi-standard demodulator, you cannot
announce 2 or more delivery systems as the default
initialized one. Logically, also it doesn't make sense
to announce 2 delivery systems as default. You have
now introduced an ambiguity as to what mode it is
now initialized.

for any multi-standard device, the device is initialized
to only 1 single delivery system and only that should
be announced and available through info.type
for the same reason fe->ops.info.type shouldn't be
filled by anybody else other than the driver alone.
