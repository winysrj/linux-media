Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758290Ab2AEUqq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jan 2012 15:46:46 -0500
Message-ID: <4F060C2D.6070107@redhat.com>
Date: Thu, 05 Jan 2012 18:46:37 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <linuxtv@stefanringel.de>
CC: linux-media@vger.kernel.org, Oliver Endriss <o.endriss@gmx.de>
Subject: Re: [PATCH 2/3] drxk: correction frontend attatching
References: <1324155437-15834-1-git-send-email-linuxtv@stefanringel.de> <1324155437-15834-2-git-send-email-linuxtv@stefanringel.de> <201112180039.50208@orion.escape-edv.de> <201112180048.00667@orion.escape-edv.de> <4EED829E.6020407@stefanringel.de>
In-Reply-To: <4EED829E.6020407@stefanringel.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18-12-2011 04:05, Stefan Ringel wrote:
> Am 18.12.2011 00:47, schrieb Oliver Endriss:
>> On Sunday 18 December 2011 00:39:49 Oliver Endriss wrote:
>>> On Saturday 17 December 2011 21:57:16 linuxtv@stefanringel.de wrote:
>>>> From: Stefan Ringel<linuxtv@stefanringel.de>
>>>>
>>>> all drxk have dvb-t, but not dvb-c.
>>>>
>>>> Signed-off-by: Stefan Ringel<linuxtv@stefanringel.de>
>>>> ---
>>>>   drivers/media/dvb/frontends/drxk_hard.c |    6 ++++--
>>>>   1 files changed, 4 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
>>>> index 038e470..8a59801 100644
>>>> --- a/drivers/media/dvb/frontends/drxk_hard.c
>>>> +++ b/drivers/media/dvb/frontends/drxk_hard.c
>>>> @@ -6460,9 +6460,11 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
>>>>       init_state(state);
>>>>       if (init_drxk(state)<  0)
>>>>           goto error;
>>>> -    *fe_t =&state->t_frontend;
>>>          ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>
>>>> -    return&state->c_frontend;
>>>          ^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>> +    if (state->m_hasDVBC)
>>>> +        *fe_t =&state->c_frontend;
>>>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>> +
>>>> +    return&state->t_frontend;
>>>                 ^^^^^^^^^^^^^^^^^^^
>>>>
>>>>   error:
>>>>       printk(KERN_ERR "drxk: not found\n");
>>> NAK, this changes the behaviour for existing drivers.
>>>
>>> What is the point to swap DVB-T and DVB-C frontends?
>>> If you really need this, please add an option to the config struct
>>> with default that does not change anything for existing drivers.
>> Correction:
>> Better do something like this (untested):
>>
>> if (state->m_hasDVBC) {
>>     *fe_t =&state->t_frontend;
>>     return state->c_frontend;
>> } else
>>     return&state->t_frontend;
>>
>> CU
>> Oliver
>>
> What shall be that, explain? For me not practicable.

The right thing to do here is to create just one frontend per DRX-K.
This were already discussed in the past. Now that we have enough
dvb-core infrastructure to support it, I've made the patches for it:

	http://news.gmane.org/gmane.linux.drivers.video-input-infrastructure

I took the m_hasDVBC and m_hasDVBT states into account, so DRX-K
drivers that implement just one of the types should now be properly
reported.

It also made the attachment logic simpler.

Regards,
Mauro
