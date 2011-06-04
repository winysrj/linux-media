Return-path: <mchehab@pedra>
Received: from mx01.sz.bfs.de ([194.94.69.103]:2803 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab1FDRZL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 13:25:11 -0400
Message-ID: <4DEA62D5.7030902@bfs.de>
Date: Sat, 04 Jun 2011 18:52:37 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Andreas Oberritter <obi@linuxtv.org>,
	Dan Carpenter <error27@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Steven Toth <stoth@kernellabs.com>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] DVB: dvb_frontend: off by one in dtv_property_dump()
References: <20110526084452.GB14591@shale.localdomain> <4DDE36AB.2070202@linuxtv.org> <4DEA34F1.1020401@infradead.org>
In-Reply-To: <4DEA34F1.1020401@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



Am 04.06.2011 15:36, schrieb Mauro Carvalho Chehab:
> Em 26-05-2011 08:16, Andreas Oberritter escreveu:
>> Hi Dan,
>>
>> On 05/26/2011 10:44 AM, Dan Carpenter wrote:
>>> If the tvp->cmd == DTV_MAX_COMMAND then we read past the end of the
>>> array.
>>>
>>> Signed-off-by: Dan Carpenter <error27@gmail.com>
>>>
>>> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
>>> index 9827804..607e293 100644
>>> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
>>> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
>>> @@ -981,7 +981,7 @@ static void dtv_property_dump(struct dtv_property *tvp)
>>>  {
>>>  	int i;
>>>  
>>> -	if (tvp->cmd <= 0 || tvp->cmd > DTV_MAX_COMMAND) {
>>> +	if (tvp->cmd <= 0 || tvp->cmd >= DTV_MAX_COMMAND) {
>>>  		printk(KERN_WARNING "%s: tvp.cmd = 0x%08x undefined\n",
>>>  			__func__, tvp->cmd);
>>>  		return;
>>
>> thanks for spotting this, but this fixes the wrong end. This does not need to
>> be applied to kernels older than 2.6.40.
>>
>> From 6d8588a4546fd4df717ca61450f99fb9c1b13a5f Mon Sep 17 00:00:00 2001
>> From: Andreas Oberritter <obi@linuxtv.org>
>> Date: Thu, 26 May 2011 10:54:14 +0000
>> Subject: [PATCH] DVB: dvb_frontend: fix dtv_property_dump for DTV_DVBT2_PLP_ID
>>
>> - Add missing entry to array "dtv_cmds".
>> - Set array size to DTV_MAX_COMMAND + 1 to avoid future off-by-ones.
> 
> Patchwork.kernel.org is not reliable at all. It missed this entire thread.
> 
> Andreas patch is the right thing to do.
> 
> Thank you both for reporting and fixing this issue. I'm applying the
> patch right now.
> 
>>
>> Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
>> ---
>>  drivers/media/dvb/dvb-core/dvb_frontend.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
>> index 9827804..bed7bfe 100644
>> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
>> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
>> @@ -904,7 +904,7 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
>>  	.buffer = b \
>>  }
>>  
>> -static struct dtv_cmds_h dtv_cmds[] = {
>> +static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
>>  	_DTV_CMD(DTV_TUNE, 1, 0),
>>  	_DTV_CMD(DTV_CLEAR, 1, 0),
>>  
>> @@ -966,6 +966,7 @@ static struct dtv_cmds_h dtv_cmds[] = {
>>  	_DTV_CMD(DTV_ISDBT_LAYERC_TIME_INTERLEAVING, 0, 0),
>>  
>>  	_DTV_CMD(DTV_ISDBS_TS_ID, 1, 0),
>> +	_DTV_CMD(DTV_DVBT2_PLP_ID, 1, 0),
>>  
>>  	/* Get */
>>  	_DTV_CMD(DTV_DISEQC_SLAVE_REPLY, 0, 1),
> 
>
Do you really want a fixed size array ?
perhaps it is better to leave it struct dtv_cmds_h dtv_cmds[]
and use ARRAY_SIZE(dtv_cmds) instead of DTV_MAX_COMMAND ?

i do not see any use beyond dtv_property_dump().

re,
 wh
