Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab1GOMkn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 08:40:43 -0400
Message-ID: <4E203543.6090905@redhat.com>
Date: Fri, 15 Jul 2011 09:40:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>,
	Ralph Metzler <rjkm@metzlerbros.de>
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices
 bridge (ddbridge)
References: <201107032321.46092@orion.escape-edv.de> <201107150145.29547@orion.escape-edv.de> <4E1FBF93.6040702@redhat.com> <201107150721.25744@orion.escape-edv.de>
In-Reply-To: <201107150721.25744@orion.escape-edv.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-07-2011 02:21, Oliver Endriss escreveu:
> On Friday 15 July 2011 06:18:27 Mauro Carvalho Chehab wrote:
>> Em 14-07-2011 20:45, Oliver Endriss escreveu:
>>> - DVB-T tuning does not work anymore.
>>
>> The enclosed patch should fix the issue. It were due to a wrong goto error
>> replacements that happened at the changeset that were fixing the error
>> propagation logic. Sorry for that.
>>
>> Please test.
> 
> Done. DVB-T works again. Thanks.

Thanks for reporting the issue and testing the fix!

> @all
> Could someone please test DVB-C?
> 
>> [media] drxk: Fix a bug at some switches that broke DVB-T
>>     
>> The error propagation changeset c23bf4402 broke the DVB-T
>> code, as it wrongly replaced some break with goto error.
>> Fix the broken logic.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
>> index a0e2ff5..217796d 100644
>> --- a/drivers/media/dvb/frontends/drxk_hard.c
>> +++ b/drivers/media/dvb/frontends/drxk_hard.c
>> @@ -3451,13 +3451,13 @@ static int DVBTCtrlSetEchoThreshold(struct drxk_state *state,
>>  		data |= ((echoThres->threshold <<
>>  			OFDM_SC_RA_RAM_ECHO_THRES_2K__B)
>>  			& (OFDM_SC_RA_RAM_ECHO_THRES_2K__M));
>> -		goto error;
>> +		break;
>>  	case DRX_FFTMODE_8K:
>>  		data &= ~OFDM_SC_RA_RAM_ECHO_THRES_8K__M;
>>  		data |= ((echoThres->threshold <<
>>  			OFDM_SC_RA_RAM_ECHO_THRES_8K__B)
>>  			& (OFDM_SC_RA_RAM_ECHO_THRES_8K__M));
>> -		goto error;
>> +		break;
>>  	default:
>>  		return -EINVAL;
>>  		goto error;
> 		^^^^^^^^^^^
> Hm, this 'goto' should be removed.

True. I've just added a small trivial patch removing this goto, and a break after
a return.

Thanks!
Mauro
