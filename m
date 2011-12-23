Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54838 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757894Ab1LWVzP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Dec 2011 16:55:15 -0500
Message-ID: <4EF4F8B3.3070709@iki.fi>
Date: Fri, 23 Dec 2011 23:54:59 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: [RFCv1] add DTMB support for DVB API
References: <4EF3A171.3030906@iki.fi> <4EF45E0D.1080509@redhat.com>
In-Reply-To: <4EF45E0D.1080509@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/23/2011 12:55 PM, Mauro Carvalho Chehab wrote:
> On 22-12-2011 19:30, Antti Palosaari wrote:
>> Rename DMB-TH to DTMB.
>
> Patrick seems to believe that CTTB is a better name. In any case,
> whatever name we pick, I think that the DocBook specs (and
> maybe a comment at the header file) should point all the known
> ways to call this standard. So, I'm fine with any choice.

I am not going to change it for CTTB unless there is no some document 
given says it is more correct than DTMB. I have looked very many papers 
over there and DTMB is absolutely more common as far as I gave seen.

>> Add few new values for existing parameters.
>>
>> Add two new parameters, interleaving and carrier.
>> DTMB supports interleavers: 240 and 720.
>> DTMB supports carriers: 1 and 3780.
>
> The API change looks sane to my eyes. I have just a couple
> comments below.

I think I will add carrier modes to enum fe_transmit_mode... I will send 
new propose soon.

>> @@ -169,8 +170,11 @@ typedef enum fe_modulation {
>>       APSK_16,
>>       APSK_32,
>>       DQPSK,
>> +    QAM_4_NR,
>
> While the NR is generally associated with the modulation,
> this is a channel code, and not part of the modulation itself
> (btw, the DVBv3 API calls it as "constellation").
>
> Ok, it is easier to add it here, but maybe it would be safer
> to add a separate field for channel coding that would be used
> to enable or disable the Nordstrom-Robinson code.
>
> This is currently used only with QAM-4, but nothing prevents this
> parity code to be added to other types of modulation.
>
>>   } fe_modulation_t;
>>
>> +#define QAM_4 QPSK
>
> IMHO, this is overkill, but I'm ok with that.

Anyone else have comment about that?

regards
Antti
-- 
http://palosaari.fi/
