Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:55787 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab1EDHYi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 03:24:38 -0400
Message-ID: <4DC0FF31.8020309@linuxtv.org>
Date: Wed, 04 May 2011 09:24:33 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Issa Gorissen <flop.m@usa.net>,
	Ralph Metzler <rjkm@metzlerbros.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <756PDXLlA1632S04.1303645106@web04.cms.usa.net> <4DC08BB9.4050405@redhat.com>
In-Reply-To: <4DC08BB9.4050405@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/04/2011 01:11 AM, Mauro Carvalho Chehab wrote:
> Em 24-04-2011 08:38, Issa Gorissen escreveu:
>> On 28/03/11 23:40, Mauro Carvalho Chehab wrote:
>>> Em 27-03-2011 21:44, Ralph Metzler escreveu:
>>>> Hi,
>>>>
>>>> since I just saw cxd2099 appear in staging in the latest git kernel, a
>>>> simple question which has been pointed out to me before:
>>>>
>>>> Why is cxd2099.c in staging regarding the device name question?
>>>> It has nothing to do with the naming.
>>> It is not just because of naming. A NACK was given to it, as is, at:
>>>
>>> http://www.spinics.net/lists/linux-media/msg28004.html
>>>
>>> A previous discussion about this subject were started at:
>>> 	http://www.mail-archive.com/linux-media@vger.kernel.org/msg22196.html
>>>
>>> The point is that an interface meant to be used by satellite were
>>> used as a ci interface, due to the lack of handling independent CA devices.
>>>
>>> As there were no final decision about a proper way to address it, Oliver
>>> decided to keep it as-is, and I decided to move it to staging while we
>>> don't properly address the question, extending the DVB API in order to
>> support
>>> independent CA devs.
>>>
>>> Having the driver at staging allow us to rework at the API and change the
>>> driver when API changes are done, without needing to pass through kernel 
>>> process of deprecating old API stuff.
>>>
>>> Cheers,
>>> Mauro
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> Hello all,
>>
>> Here is the patch for the NGene card family and the new caio device.
>> Can cxd2099 be removed from staging as this patch fixes the raised issue.
>>
>> Signed-off-by: Issa Gorissen <flop.m@usa.net>
>> ---
>>  drivers/media/dvb/dvb-core/dvbdev.c  |    2 +-
>>  drivers/media/dvb/dvb-core/dvbdev.h  |    1 +
>>  drivers/media/dvb/ngene/ngene-core.c |    2 +-
>>  3 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/dvb/dvb-core/dvbdev.c
>> b/drivers/media/dvb/dvb-core/dvbdev.c
>> index f732877..7a64b81 100644
>> --- a/drivers/media/dvb/dvb-core/dvbdev.c
>> +++ b/drivers/media/dvb/dvb-core/dvbdev.c
>> @@ -47,7 +47,7 @@ static DEFINE_MUTEX(dvbdev_register_lock);
>>  
>>  static const char * const dnames[] = {
>>  	"video", "audio", "sec", "frontend", "demux", "dvr", "ca",
>> -	"net", "osd"
>> +	"net", "osd", "caio"
>>  };

There's no reason to keep sec.

>>  
>>  #ifdef CONFIG_DVB_DYNAMIC_MINORS
>> diff --git a/drivers/media/dvb/dvb-core/dvbdev.h
>> b/drivers/media/dvb/dvb-core/dvbdev.h
>> index fcc6ae9..c63c70d 100644
>> --- a/drivers/media/dvb/dvb-core/dvbdev.h
>> +++ b/drivers/media/dvb/dvb-core/dvbdev.h
>> @@ -47,6 +47,7 @@
>>  #define DVB_DEVICE_CA         6
>>  #define DVB_DEVICE_NET        7
>>  #define DVB_DEVICE_OSD        8
>> +#define DVB_DEVICE_CAIO       9
>>  
>>  #define DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr) \
>>  	static short adapter_nr[] = \
>> diff --git a/drivers/media/dvb/ngene/ngene-core.c
>> b/drivers/media/dvb/ngene/ngene-core.c
>> index 175a0f6..17cdd38 100644
>> --- a/drivers/media/dvb/ngene/ngene-core.c
>> +++ b/drivers/media/dvb/ngene/ngene-core.c
>> @@ -1523,7 +1523,7 @@ static int init_channel(struct ngene_channel *chan)
>>  		set_transfer(&chan->dev->channel[2], 1);
>>  		dvb_register_device(adapter, &chan->ci_dev,
>>  				    &ngene_dvbdev_ci, (void *) chan,
>> -				    DVB_DEVICE_SEC);
>> +				    DVB_DEVICE_CAIO);
>>  		if (!chan->ci_dev)
>>  			goto err;
>>  	}
>>
> 
> It is not that simple. The question is not just how to name the interface, 
> but that such interface will work on a different way than the current 
> ca interface.
> 
> In other words, the DVB API should clearly explain why this
> interface is different, when it should be used and how.

Also, there's still no mapping between ca and caio devices. Imagine a
built-in descrambler ca0 and two CI slots ca1 and ca2.

ca0 won't get a caio device, at least for now.
ca1 and ca2 might or might not have a caio device.

If there is caio0, how am I supposed to know that it's related to ca1 or
ca2 (or ca0, if someone implements a caio device to bypass the software
demux to use a built-in descrambler)? You must not assume that there are
either none or two (or three) caio interfaces. You need to be able to
detect (or set up) the connection between the interfaces. Otherwise this
"API" will be a mess.

Regards,
Andreas
