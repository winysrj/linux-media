Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57988 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab1LXWEO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 17:04:14 -0500
Message-ID: <4EF64C5C.1030708@iki.fi>
Date: Sun, 25 Dec 2011 00:04:12 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [RFCv1] add DTMB support for DVB API
References: <4EF3A171.3030906@iki.fi> <201112231830.59716.pboettcher@kernellabs.com>
In-Reply-To: <201112231830.59716.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/23/2011 07:30 PM, Patrick Boettcher wrote:
> Hi Antti,
>
> On Thursday, December 22, 2011 10:30:25 PM Antti Palosaari wrote:
>> Rename DMB-TH to DTMB.
>>
>> Add few new values for existing parameters.
>>
>> Add two new parameters, interleaving and carrier.
>> DTMB supports interleavers: 240 and 720.
>> DTMB supports carriers: 1 and 3780.
>>
>> Signed-off-by: Antti Palosaari<crope@iki.fi>
>> ---
>>    drivers/media/dvb/dvb-core/dvb_frontend.c |   19 ++++++++++++++++++-
>>    drivers/media/dvb/dvb-core/dvb_frontend.h |    3 +++
>>    include/linux/dvb/frontend.h              |   13 +++++++++++--
>>    include/linux/dvb/version.h               |    2 +-
>>    4 files changed, 33 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c
>> b/drivers/media/dvb/dvb-core/dvb_frontend.c
>> index 821b225..ec2cbae 100644
>> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
>> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
>> @@ -924,6 +924,8 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND +
>> 1] = {
>>    	_DTV_CMD(DTV_CODE_RATE_LP, 1, 0),
>>    	_DTV_CMD(DTV_GUARD_INTERVAL, 1, 0),
>>    	_DTV_CMD(DTV_TRANSMISSION_MODE, 1, 0),
>> +	_DTV_CMD(DTV_CARRIER, 1, 0),
>
> What would you think if instead of adding DTV_CARRIER (which indicates
> whether we are using single carrier or multi carrier, if I understand it
> correctly) we add a TRANSMISSION_MODE_SC.
>
> Then TRANSMISSION_MODE_4K is the multi-carrier mode and TRANSMISSION_MODE_SC
> is the single-carrier mode. We save a new DTV-command.
>
> I'm not making a secret of it, this is how we handled this inside DiBcom and
> it would simplify the integration of our drivers for this standard. This is
> planned to be done during the first half of 2012.
>
> Comments?

I already did that :)

I proposed it yesterday. But as you seems to have problem with your send 
mail server that reply arrives more than one day late you have sent. 
Anyhow, nice to see you have ended up same decision.

I named those TRANSMISSION_MODE_C=1 and TRANSMISSION_MODE_C=3780 as 
those were names used by specification.

The only totally new parameter is interleaver which I didn't find 
existing one have same meaning.

But look my yesterday mails and reply, I will wait your review under I 
post new RFC patch. Also I would like to hear Andreas comments.

thanks
Antti



-- 
http://palosaari.fi/
