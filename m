Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48829 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab1L0N2b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 08:28:31 -0500
Message-ID: <4EF9C7FA.9070203@infradead.org>
Date: Tue, 27 Dec 2011 11:28:26 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 01/91] [media] dvb-core: allow demods to specify the
 supported delivery systems supported standards.
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com> <1324948159-23709-2-git-send-email-mchehab@redhat.com> <4EF9B606.3090908@linuxtv.org>
In-Reply-To: <4EF9B606.3090908@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27-12-2011 10:11, Andreas Oberritter wrote:
> On 27.12.2011 02:07, Mauro Carvalho Chehab wrote:
>> DVB-S and DVB-T, as those were the standards supported by DVBv3.
> 
> The description seems to be incomplete.
> 
>> New standards like DSS, ISDB and CTTB don't fit on any of the
>> above types.
>>
>> while there's a way for the drivers to explicitly change whatever
>> default DELSYS were filled inside the core, still a fake value is
>> needed there, and a "compat" code to allow DVBv3 applications to
>> work with those delivery systems is needed. This is good for a
>> short term solution, while applications aren't using DVBv5 directly.
>>
>> However, at long term, this is bad, as the compat code runs even
>> if the application is using DVBv5. Also, the compat code is not
>> perfect, and only works when the frontend is capable of auto-detecting
>> the parameters that aren't visible by the faked delivery systems.
>>
>> So, let the frontend fill the supported delivery systems at the
>> device properties directly, and, in the future, let the core to use
>> the delsys to fill the reported info::type based on the delsys.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>  drivers/media/dvb/dvb-core/dvb_frontend.c |   13 +++++++++++++
>>  drivers/media/dvb/dvb-core/dvb_frontend.h |    8 ++++++++
>>  2 files changed, 21 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
>> index 8dedff4..f17c411 100644
>> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
>> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
>> @@ -1252,6 +1252,19 @@ static void dtv_set_default_delivery_caps(const struct dvb_frontend *fe, struct
>>  	const struct dvb_frontend_info *info = &fe->ops.info;
>>  	u32 ncaps = 0;
>>  
>> +	/*
>> +	 * If the frontend explicitly sets a list, use it, instead of
>> +	 * filling based on the info->type
>> +	 */
>> +	if (fe->ops.delsys[ncaps]) {
>> +		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
>> +			p->u.buffer.data[ncaps] = fe->ops.delsys[ncaps];
>> +			ncaps++;
>> +		}
>> +		p->u.buffer.len = ncaps;
>> +		return;
>> +	}
>> +
> 
> I don't understand what this is trying to solve. This is already handled
> by the get_property driver callback.
> 
> dtv_set_default_delivery_caps() only sets some defaults for drivers not
> implementing get_property yet.

dtv_set_default_delivery_caps() does the wrong thing for delivery systems
like ISDB-T, ISDB-S, DSS, DMB-TH, as it fills data with a fake value that
is there at fe->ops.info.type. 

The fake values there should be used only for DVBv3 legacy calls emulation
on those delivery systems that are not fully compatible with a DVBv3 call.

At the end, I think we should deprecate the fe->ops.info.type, as its
contents is not reliable (as it can represent something else). 

Btw, there are several places at dvb_frontend.c that uses the info.type
to assume the delivery system. This leads DVB core to do the wrong assumptions
for non-DVBv3 supported systems. The right way is to use a new field that
really represents the supported delivery systems by a given frontend, instead
of relying on fe->ops.info.type.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

