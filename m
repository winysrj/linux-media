Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53285 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507AbcCKQzI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 11:55:08 -0500
Subject: Re: [PATCH 1/2] [media] au0828: disable tuner links and cache
 tuner/decoder
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <d14f3141901856eaed358ab049f4a3aac8fe4863.1457711514.git.mchehab@osg.samsung.com>
 <56E2F1FC.1080405@osg.samsung.com> <20160311133447.31f9e3f5@recife.lan>
 <56E2F7E5.7060503@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56E2F869.7070905@osg.samsung.com>
Date: Fri, 11 Mar 2016 09:55:05 -0700
MIME-Version: 1.0
In-Reply-To: <56E2F7E5.7060503@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/2016 09:52 AM, Shuah Khan wrote:
> On 03/11/2016 09:34 AM, Mauro Carvalho Chehab wrote:
>> Em Fri, 11 Mar 2016 09:27:40 -0700
>> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
>>
>>> On 03/11/2016 08:55 AM, Mauro Carvalho Chehab wrote:
>>>> For au0828_enable_source() to work, the tuner links should be
>>>> disabled and the tuner/decoder should be cached at au0828 struct.  
>>>
>>> hmm. are you sure about needing to cache decoder in au0828 struct.
>>> It gets cached in au0828_card_analog_fe_setup() which is called
>>> from au0828_card_setup() - this step happens before
>>> au0828_media_device_register()
>>>
>>> #ifdef CONFIG_MEDIA_CONTROLLER
>>>                 if (sd)
>>>                         dev->decoder = &sd->entity;
>>> #endif
>>
>> I haven't check it. Yet, I guess the best would be to put those
>> caches all at au0828_media_device_register(). This way, it would be
>> easier to remember removing them, once we move au0828_enable_source
>> to the core.
> 
> Yes. Consolidating caches in one place is a good idea. One thing we
> have to keep in mind when we do that is the !MEDIA_CONTROLLER cases.
> The above cached value could be used even when MEDIA_CONTROLLER isn't
> enabled.

Never mind - the second comment isn't valid! We are setting this
in ifdef CONFIG_MEDIA_CONTROLLER :)

thanks,
-- Shuah



-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
