Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45839 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1KVA1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 19:27:33 -0500
Received: by eye27 with SMTP id 27so6014968eye.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 16:27:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ECAE71B.2060700@linuxtv.org>
References: <CAHFNz9+e0K__EWdc=ckHURjjYMbez22=xup0d7=H7k2xQNVnyw@mail.gmail.com>
	<4ECAE71B.2060700@linuxtv.org>
Date: Tue, 22 Nov 2011 05:57:31 +0530
Message-ID: <CAHFNz9L4O+UrGv4_o1SK22fThE3Lf66H5vpD_COMh0enjknWzg@mail.gmail.com>
Subject: Re: PATCH 04/13: 0004-TDA18271-Allow-frontend-to-set-DELSYS
From: Manu Abraham <abraham.manu@gmail.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 22, 2011 at 5:34 AM, Andreas Oberritter <obi@linuxtv.org> wrote:
> On 21.11.2011 22:06, Manu Abraham wrote:
>>
>> 0004-TDA18271-Allow-frontend-to-set-DELSYS-rather-than-qu.patch
>>
>>
>> From 2ece38602678ae323450d0e35379147e6e086326 Mon Sep 17 00:00:00 2001
>> From: Manu Abraham <abraham.manu@gmail.com>
>> Date: Sat, 19 Nov 2011 19:50:09 +0530
>> Subject: [PATCH 04/13] TDA18271: Allow frontend to set DELSYS, rather than querying fe->ops.info.type
>>
>> With any tuner that can tune to multiple delivery systems/standards, it does
>> query fe->ops.info.type to determine frontend type and set the delivery
>> system type. fe->ops.info.type can handle only 4 delivery systems, viz FE_QPSK,
>> FE_QAM, FE_OFDM and FE_ATSC.
>>
>> The change allows the tuner to be set to any delivery system specified in
>> fe_delivery_system_t, thereby simplifying a lot of issues.
>>
>> Signed-off-by: Manu Abraham <abraham.manu@gmail.com>
>> ---
>>  drivers/media/common/tuners/tda18271-fe.c   |   80 +++++++++++++++++++++++++++
>>  drivers/media/common/tuners/tda18271-priv.h |    2 +
>>  2 files changed, 82 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/common/tuners/tda18271-fe.c b/drivers/media/common/tuners/tda18271-fe.c
>> index 3347c5b..6e29faf 100644
>> --- a/drivers/media/common/tuners/tda18271-fe.c
>> +++ b/drivers/media/common/tuners/tda18271-fe.c
>> @@ -928,6 +928,85 @@ fail:
>>
>>  /* ------------------------------------------------------------------ */
>>
>> +static int tda18271_set_state(struct dvb_frontend *fe,
>> +                           enum tuner_param param,
>> +                           struct tuner_state *state)
>> +{
>> +     struct tda18271_priv *priv = fe->tuner_priv;
>> +     struct tuner_state *req = &priv->request;
>> +     struct tda18271_std_map *std_map = &priv->std;
>> +     struct tda18271_std_map_item *map;
>> +     int ret;
>> +
>> +     BUG_ON(!priv);
>
> At this point priv has already been dereferenced.


True, that check is useless.

>
>> +     if (param & DVBFE_TUNER_DELSYS)
>> +             req->delsys = state->delsys;
>> +     if (param & DVBFE_TUNER_FREQUENCY)
>> +             req->frequency = state->frequency;
>> +     if (param & DVBFE_TUNER_BANDWIDTH)
>> +             req->bandwidth = state->bandwidth;
>
> What happens if one of these flags is not set, when the function is
> called for the first time? priv->request doesn't seem to get initialized.

Request needs to be evaluated, whether it is a valid request for the
tuner operation. Need to fix.


Thanks,
Manu
