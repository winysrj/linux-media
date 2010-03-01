Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:52458 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab0CAGj2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 01:39:28 -0500
Message-ID: <4B8B611D.20705@freemail.hu>
Date: Mon, 01 Mar 2010 07:39:25 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: Kang Yong <kangyong@telegent.com>,
	Zhang Xiaobing <xbzhang@telegent.com>,
	Huang Shijie <zyziii@telegent.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tlg2300: cleanups when power management is not configured
References: <4B8A7B83.8060203@freemail.hu> <4B8B3EA1.3090806@gmail.com>
In-Reply-To: <4B8B3EA1.3090806@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Huang Shijie wrote:
> hi Marton, thanks a lot.
> 
>> From: Márton Németh<nm127@freemail.hu>
>>
>> When power management is not configured (CONFIG_PM) then some code is no longer
>> necessary.
>>
>> This patch will remove the following compiler warnings:
>>   * pd-dvb.c: In function 'poseidon_fe_release':
>>   * pd-dvb.c:101: warning: unused variable 'pd'
>>   * pd-video.c:14: warning: 'pm_video_suspend' declared 'static' but never defined
>>   * pd-video.c:15: warning: 'pm_video_resume' declared 'static' but never defined
>>
>> Signed-off-by: Márton Németh<nm127@freemail.hu>
>> ---
>> diff -r 37581bb7e6f1 linux/drivers/media/video/tlg2300/pd-dvb.c
>> --- a/linux/drivers/media/video/tlg2300/pd-dvb.c	Wed Feb 24 22:48:50 2010 -0300
>> +++ b/linux/drivers/media/video/tlg2300/pd-dvb.c	Sun Feb 28 15:13:05 2010 +0100
>> @@ -96,15 +96,17 @@
>>   	return ret;
>>   }
>>
>> +#ifdef CONFIG_PM
>>   static void poseidon_fe_release(struct dvb_frontend *fe)
>>   {
>>   	struct poseidon *pd = fe->demodulator_priv;
>>
>> -#ifdef CONFIG_PM
>>   	pd->pm_suspend = NULL;
>>   	pd->pm_resume  = NULL;
>> +}
>> +#else
>> +#define poseidon_fe_release NULL
>>   #endif
>> -}
>>
>>    
> I think the change here is a little more complicated.I prefer to change 
> it like this :
> 
> static void poseidon_fe_release(struct dvb_frontend *fe)
> {
> #ifdef CONFIG_PM
>      struct poseidon *pd = fe->demodulator_priv;
>      pd->pm_suspend = NULL;
>      pd->pm_resume  = NULL;
> #endif
> }
> 
> Could you change the patch, and resend it to me ?
> thanks.

I'm afraid in this case we'll get a warning saying that the parameter fe is unused.
Here is an example:

	$ gcc -Wall -O2 -Wextra test.c
	test.c: In function ‘foo’:
	test.c:2: warning: unused parameter ‘x’
	$ cat test.c
	
	static void foo(int x)
	{
	
	}
	
	int main()
	{
		foo(0);
		return 0;
	}

The second reason I modified the code like this is that the the .release
opreation is used with the following sequence:

	if (dvb->frontend->ops.release)
		dvb->frontend->ops.release(dvb->frontend);

If power management is not configured then the symbol poseidon_fe_release will be
NULL and the condition dvb->frontend->ops.release will be false. So the otherwise
empty function will not be called at all.

Regards,

	Márton Németh
