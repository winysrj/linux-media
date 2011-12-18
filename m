Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:33865 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1LRGDP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Dec 2011 01:03:15 -0500
Message-ID: <4EED8215.7040308@stefanringel.de>
Date: Sun, 18 Dec 2011 07:03:01 +0100
From: Stefan Ringel <linuxtv@stefanringel.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>, mchehab@redhat.com
Subject: Re: [PATCH 2/3] drxk: correction frontend attatching
References: <1324155437-15834-1-git-send-email-linuxtv@stefanringel.de> <1324155437-15834-2-git-send-email-linuxtv@stefanringel.de> <201112180039.50208@orion.escape-edv.de>
In-Reply-To: <201112180039.50208@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 18.12.2011 00:39, schrieb Oliver Endriss:
> On Saturday 17 December 2011 21:57:16linuxtv@stefanringel.de  wrote:
>> From: Stefan Ringel<linuxtv@stefanringel.de>
>>
>> all drxk have dvb-t, but not dvb-c.
>>
>> Signed-off-by: Stefan Ringel<linuxtv@stefanringel.de>
>> ---
>>   drivers/media/dvb/frontends/drxk_hard.c |    6 ++++--
>>   1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
>> index 038e470..8a59801 100644
>> --- a/drivers/media/dvb/frontends/drxk_hard.c
>> +++ b/drivers/media/dvb/frontends/drxk_hard.c
>> @@ -6460,9 +6460,11 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
>>   	init_state(state);
>>   	if (init_drxk(state)<  0)
>>   		goto error;
>> -	*fe_t =&state->t_frontend;
>          ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> -	return&state->c_frontend;
>          ^^^^^^^^^^^^^^^^^^^^^^^^^^
>> +	if (state->m_hasDVBC)
>> +		*fe_t =&state->c_frontend;
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> +
>> +	return&state->t_frontend;
>                 ^^^^^^^^^^^^^^^^^^^
>>
>>   error:
>>   	printk(KERN_ERR "drxk: not found\n");
> NAK, this changes the behaviour for existing drivers.
>
> What is the point to swap DVB-T and DVB-C frontends?
broking by attaching or deattaching the frontend driver, if no dvb-c 
frontend drxk can use(i.e. drx-3916k). Do you add a frontend which is 
not physically present? Look to my 3rd patch. I tested many ways to 
attach that.

Stefan
> If you really need this, please add an option to the config struct
> with default that does not change anything for existing drivers.
>
> CU
> Oliver
>


