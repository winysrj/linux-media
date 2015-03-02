Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40939 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbbCBSZG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 13:25:06 -0500
Received: by wiwl15 with SMTP id l15so17088786wiw.5
        for <linux-media@vger.kernel.org>; Mon, 02 Mar 2015 10:25:04 -0800 (PST)
Message-ID: <54F4AAFE.70606@gmail.com>
Date: Mon, 02 Mar 2015 19:25:02 +0100
From: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?B?UmFmYWVsIExvdXJlbsOnbyBkZSBMaW1hIENoZWhhYg==?=
	<chehabrafael@gmail.com>
Subject: Re: [PATCH] [media] use a function for DVB media controller register
References: <89a2c1d60aa2cfcf4c9f194b4c923d72182be431.1425306670.git.mchehab@osg.samsung.com>	<54F495DD.7030304@gmail.com> <20150302140614.70300466@recife.lan> <54F49FC3.9030206@gmail.com>
In-Reply-To: <54F49FC3.9030206@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
I tested this an I've got no issues to report.

If I was in the position to do so, I'd ack these patches.

Regards,
Tycho


Op 02-03-15 om 18:37 schreef Tycho Lürsen:
> Hi Mauro,
> Op 02-03-15 om 18:06 schreef Mauro Carvalho Chehab:
>> Em Mon, 02 Mar 2015 17:54:53 +0100
>> Tycho Lürsen <tycholursen@gmail.com> escreveu:
>>
>>> Hi Mauro,
>>> Op 02-03-15 om 15:31 schreef Mauro Carvalho Chehab:
>>>> This is really a simple function, but using it avoids to have
>>>> if's inside the drivers.
>>>>
>>>> Also, the kABI becomes a little more clearer.
>>>>
>>>> This shouldn't generate any overhead, and the type check
>>>> will happen when compiling with MC DVB enabled.
>>>>
>>>> So, let's do it.
>>>>
>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>
>>>> diff --git a/drivers/media/common/siano/smsdvb-main.c 
>>>> b/drivers/media/common/siano/smsdvb-main.c
>>>> index c739725ca7ee..367b8e77feb8 100644
>>>> --- a/drivers/media/common/siano/smsdvb-main.c
>>>> +++ b/drivers/media/common/siano/smsdvb-main.c
>>>> @@ -1104,9 +1104,7 @@ static int smsdvb_hotplug(struct 
>>>> smscore_device_t *coredev,
>>>>            pr_err("dvb_register_adapter() failed %d\n", rc);
>>>>            goto adapter_error;
>>>>        }
>>>> -#ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>>> -    client->adapter.mdev = coredev->media_dev;
>>>> -#endif
>>>> +    dvb_register_media_controller(&client->adapter, 
>>>> coredev->media_dev);
>>>>           /* init dvb demux */
>>>>        client->demux.dmx.capabilities = DMX_TS_FILTERING;
>>>> diff --git a/drivers/media/dvb-core/dvbdev.h 
>>>> b/drivers/media/dvb-core/dvbdev.h
>>>> index 556c9e9d1d4e..12629b8ecb0c 100644
>>>> --- a/drivers/media/dvb-core/dvbdev.h
>>>> +++ b/drivers/media/dvb-core/dvbdev.h
>>>> @@ -125,8 +125,15 @@ extern void dvb_unregister_device (struct 
>>>> dvb_device *dvbdev);
>>>>       #ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>>>    void dvb_create_media_graph(struct dvb_adapter *adap);
>>>> +static inline void dvb_register_media_controller(struct 
>>>> dvb_adapter *adap,
>>>> +                         struct media_device *mdev)
>>>> +{
>>>> +    adap->mdev = mdev;
>>>> +}
>>>> +
>>>>    #else
>>>>    static inline void dvb_create_media_graph(struct dvb_adapter 
>>>> *adap) {}
>>>> +#define dvb_register_media_controller(a, b) {}
>>>>    #endif
>>> Does "#define dvb_register_media_controller(a, b) {}" restrict the
>>> number of registerd controllers in any way?
>>> I mean, I've got a couple of TBS quad adapters, 4 tuner and 4 demod
>>> chips on each card. Will they still work with this change?
>> No. What the above define does is to replace the function call by 
>> nothing,
>> if MEDIA_CONTROLLER_DVB is not set.
>>
>> Neither it or the current patches for the media controller on DVB should
>> affect the TBS quad adapters. If you're having some regressions with it,
>> please report.
>>
>> Regards,
>> Mauro
> Thanks for your reply, I will test this for regression as soon as it 
> hits the master branch.
>
> Regards,
> Tycho.
>

