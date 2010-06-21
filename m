Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40819 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab0FUQTO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 12:19:14 -0400
Message-ID: <4C1F8FD2.6090809@gmail.com>
Date: Mon, 21 Jun 2010 09:14:10 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 8/8 v2]tuners:tuner-simple Fix warning: variable 'tun'
 set but not used
References: <1276580914-21883-1-git-send-email-justinmattock@gmail.com> <20100621093436.376b819a@pedra>
In-Reply-To: <20100621093436.376b819a@pedra>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/21/2010 05:34 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 14 Jun 2010 22:48:34 -0700
> "Justin P. Mattock"<justinmattock@gmail.com>  escreveu:
>
>> Resend due to a whitespace issue I created by mistake.
>> The below patch fixes a warning message create by gcc 4.6.0
>
> It seems OK for me, but you shouldn't be sending it to be applied at reiserfs-devel ML.
> Instead, it should be sent to linux-media ML, and applied via my tree.
>

I should of used get_maintainer.pl to find the correct list to send this 
too(instead I just looked into the MAINTAINERS file).
I'll resend.

>>
>>   CC [M]  drivers/media/common/tuners/tuner-simple.o
>> drivers/media/common/tuners/tuner-simple.c: In function 'simple_set_tv_freq':
>> drivers/media/common/tuners/tuner-simple.c:548:20: warning: variable 'tun' set but not used
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>   Reviewed-By: Mauro Carvalho Chehab<mchehab@redhat.com>
>>
>> ---
>>   drivers/media/common/tuners/tuner-simple.c |    3 ---
>>   1 files changed, 0 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/common/tuners/tuner-simple.c b/drivers/media/common/tuners/tuner-simple.c
>> index 8abbcc5..84900fa 100644
>> --- a/drivers/media/common/tuners/tuner-simple.c
>> +++ b/drivers/media/common/tuners/tuner-simple.c
>> @@ -545,14 +545,11 @@ static int simple_set_tv_freq(struct dvb_frontend *fe,
>>   	struct tuner_simple_priv *priv = fe->tuner_priv;
>>   	u8 config, cb;
>>   	u16 div;
>> -	struct tunertype *tun;
>>   	u8 buffer[4];
>>   	int rc, IFPCoff, i;
>>   	enum param_type desired_type;
>>   	struct tuner_params *t_params;
>>
>> -	tun = priv->tun;
>> -
>>   	/* IFPCoff = Video Intermediate Frequency - Vif:
>>   		940  =16*58.75  NTSC/J (Japan)
>>   		732  =16*45.75  M/N STD
>
>

Justin P. Mattock
