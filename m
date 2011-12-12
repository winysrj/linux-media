Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55001 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab1LLEGl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 23:06:41 -0500
Received: by wgbds13 with SMTP id ds13so7550201wgb.1
        for <linux-media@vger.kernel.org>; Sun, 11 Dec 2011 20:06:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE3545F.4070607@gmail.com>
References: <CAHFNz9LOoDcrGpMKLU3wSnCYsDiuJMrOir-+nJEkkWfN9Cpd9w@mail.gmail.com>
	<4EE3535C.7050309@redhat.com>
	<4EE3545F.4070607@gmail.com>
Date: Mon, 12 Dec 2011 09:36:40 +0530
Message-ID: <CAHFNz9Leyzy_uzF0_4hudiRLXGY240oEz4PNQuJfaCGCsusHOA@mail.gmail.com>
Subject: Re: v4 [PATCH 07/10] TDA18271: Allow frontend to set DELSYS
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 10, 2011 at 6:15 PM, Mauro Carvalho Chehab
<maurochehab@gmail.com> wrote:
> On 10-12-2011 10:41, Mauro Carvalho Chehab wrote:
>>
>> On 10-12-2011 02:43, Manu Abraham wrote:
>>>
>>> From 252d4ec800ba73bde8958b8c23ca92a6e17288e2 Mon Sep 17 00:00:00 2001
>>> From: Manu Abraham <abraham.manu@gmail.com>
>>> Date: Thu, 24 Nov 2011 19:15:56 +0530
>>> Subject: [PATCH 07/10] TDA18271: Allow frontend to set DELSYS, rather
>>> than querying fe->ops.info.type
>>>
>>> With any tuner that can tune to multiple delivery systems/standards, it
>>> does
>>> query fe->ops.info.type to determine frontend type and set the delivery
>>> system type. fe->ops.info.type can handle only 4 delivery systems, viz
>>> FE_QPSK,
>>> FE_QAM, FE_OFDM and FE_ATSC.
>>>
>>> The change allows the tuner to be set to any delivery system specified in
>>> fe_delivery_system_t, thereby simplifying a lot of issues.
>>>
>>> Signed-off-by: Manu Abraham <abraham.manu@gmail.com>
>>> ---
>>> drivers/media/common/tuners/tda18271-fe.c | 81
>>> +++++++++++++++--------------
>>> 1 files changed, 41 insertions(+), 40 deletions(-)
>>>
>>> diff --git a/drivers/media/common/tuners/tda18271-fe.c
>>> b/drivers/media/common/tuners/tda18271-fe.c
>>> index 3347c5b..cee1a39 100644
>>> --- a/drivers/media/common/tuners/tda18271-fe.c
>>> +++ b/drivers/media/common/tuners/tda18271-fe.c
>>> @@ -935,69 +935,70 @@ static int tda18271_set_params(struct dvb_frontend
>>> *fe,
>>> struct tda18271_std_map *std_map = &priv->std;
>>> struct tda18271_std_map_item *map;
>>> int ret;
>>> - u32 bw, freq = params->frequency;
>>> + u32 bw, bandwidth = 0, freq;
>>> + fe_delivery_system_t delsys;
>>> +
>>> + delsys = fe->dtv_property_cache.delivery_system;
>>> + bw = fe->dtv_property_cache.bandwidth_hz;
>>> + freq = fe->dtv_property_cache.frequency;
>>>
>>> priv->mode = TDA18271_DIGITAL;
>>>
>>> - if (fe->ops.info.type == FE_ATSC) {
>>> - switch (params->u.vsb.modulation) {
>>> - case VSB_8:
>>> - case VSB_16:
>>> - map = &std_map->atsc_6;
>>> - break;
>>> - case QAM_64:
>>> - case QAM_256:
>>> - map = &std_map->qam_6;
>>> - break;
>>> - default:
>>> - tda_warn("modulation not set!\n");
>>> + if (!delsys || !freq) {
>>> + tda_warn("delsys:%d freq:%d!\n", delsys, freq);
>>> + return -EINVAL;
>>> + }
>>> + switch (delsys) {
>>> + case SYS_ATSC:
>>> + map = &std_map->atsc_6;
>>> + bandwidth = 6000000;
>>> + break;
>>> + case SYS_DVBC_ANNEX_B:
>>> + map = &std_map->qam_6;
>>> + bandwidth = 6000000;
>>> + break;
>>> + case SYS_DVBC_ANNEX_A:
>>> + case SYS_DVBC_ANNEX_C:
>>> + map = &std_map->qam_8;
>>> + bandwidth = 8000000;
>>> + break;
>>
>>
>> This is wrong.
>>
>> The bandwidth needs to be calculated, based on the roll-off factor.
>
>
>
>> Also, this patch doesn't apply anymore, due to the patches that were
>> already applied.
>
>
> This is actually not true. The other tda18271 has the code for bandwidth
> calculus, not this one. Anyway, this driver needs a bandwidth estimation
> for DVB-C. Mental note added.
>

When applying a patch series, the right way is not to make too
many modifications, thinking that some other driver has it. What
I did was to handle it according to the coding style and code flow
of each driver. In any case, you can add calculations based on
rolloff in a later stage. Rather than making large changes which
the driver authors/maintainers might not appreciate.


>>
>>> + case SYS_DVBT:
>>> + case SYS_DVBT2:
>>> + if (!bw)
>>> return -EINVAL;
>>> - }
>>> -#if 0
>>> - /* userspace request is already center adjusted */
>>> - freq += 1750000; /* Adjust to center (+1.75MHZ) */
>>> -#endif
>>> - bw = 6000000;
>>> - } else if (fe->ops.info.type == FE_OFDM) {
>>> - switch (params->u.ofdm.bandwidth) {
>>> - case BANDWIDTH_6_MHZ:
>>> - bw = 6000000;
>>> + switch (bw) {
>>> + case 6000000:
>>> map = &std_map->dvbt_6;
>>> break;
>>> - case BANDWIDTH_7_MHZ:
>>> - bw = 7000000;
>>> + case 7000000:
>>> map = &std_map->dvbt_7;
>>> break;
>>> - case BANDWIDTH_8_MHZ:
>>> - bw = 8000000;
>>> + case 8000000:
>>> map = &std_map->dvbt_8;
>>> break;
>>> default:
>>> - tda_warn("bandwidth not set!\n");
>>> - return -EINVAL;
>>> + ret = -EINVAL;
>>> + goto fail;
>>> }
>>> - } else if (fe->ops.info.type == FE_QAM) {
>>> - /* DVB-C */
>>> - map = &std_map->qam_8;
>>> - bw = 8000000;
>>> - } else {
>>> - tda_warn("modulation type not supported!\n");
>>> - return -EINVAL;
>>> + break;
>>> + default:
>>> + tda_warn("Invalid delivery system!\n");
>>> + ret = -EINVAL;
>>> + goto fail;
>>> }
>>> -
>>> /* When tuning digital, the analog demod must be tri-stated */
>>> if (fe->ops.analog_ops.standby)
>>> fe->ops.analog_ops.standby(fe);
>>>
>>> - ret = tda18271_tune(fe, map, freq, bw);
>>> + ret = tda18271_tune(fe, map, freq, bandwidth);
>>>
>>> if (tda_fail(ret))
>>> goto fail;
>>>
>>> priv->if_freq = map->if_freq;
>>> priv->frequency = freq;
>>> - priv->bandwidth = (fe->ops.info.type == FE_OFDM) ?
>>> - params->u.ofdm.bandwidth : 0;
>>> + priv->bandwidth = (delsys == SYS_DVBT || delsys == SYS_DVBT2) ?
>>> + bandwidth : 0;
>>
>>
>> This rises an interesting point: it may be useful to store the bandwidth
>> used by the tuner, in order to allow applications to retrieve this value.
>>


The logic is the same as that of the existing logic, nothing new.
No new logic introduced.

-       priv->bandwidth = (fe->ops.info.type == FE_OFDM) ?
-               params->u.ofdm.bandwidth : 0;
+       priv->bandwidth = (delsys == SYS_DVBT || delsys == SYS_DVBT2) ?
+                          bandwidth : 0;


As you can see, only fe_info has been switched to use delsys instead.
