Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m54LimNp012483
	for <video4linux-list@redhat.com>; Wed, 4 Jun 2008 17:44:48 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.180])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m54Lhka2026677
	for <video4linux-list@redhat.com>; Wed, 4 Jun 2008 17:44:37 -0400
Received: by py-out-1112.google.com with SMTP id a29so212300pyi.0
	for <video4linux-list@redhat.com>; Wed, 04 Jun 2008 14:44:37 -0700 (PDT)
Message-ID: <a0580c510806041444y1c722ed7qdfad3f4c325ff495@mail.gmail.com>
Date: Wed, 4 Jun 2008 17:44:37 -0400
From: "Eduardo Valentin" <edubezval@gmail.com>
To: mkrufky@linuxtv.org
In-Reply-To: <484703B9.7070107@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080604172221.6c7448e7@gaivota> <484703B9.7070107@linuxtv.org>
Cc: tony@atomide.com, eduardo.valentin@indt.org.br, video4linux-list@redhat.com,
	sakari.ailus@nokia.com, mchehab@infradead.org
Subject: Re: [PATCH 0/1] Add support for TEA5761 (from linux-omap)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Ok guys,

Sorry, my bad. I'll try to rewrite it. I'll re-send this as soon as possible.
Maybe some doubts will come up, but I'll be polling you :).

Cheers,

On Wed, Jun 4, 2008 at 5:06 PM,  <mkrufky@linuxtv.org> wrote:
> Mauro Carvalho Chehab wrote:
>> On Wed, 4 Jun 2008 16:13:57 -0400
>> "Eduardo Valentin" <edubezval@gmail.com> wrote:
>>
>>
>>> Hi Mike,
>>>
>>> On Wed, Jun 4, 2008 at 11:20 AM,  <mkrufky@linuxtv.org> wrote:
>>>
>>>> Mauro Carvalho Chehab wrote:
>>>>
>>>>> Hi Eduardo,
>>>>>
>>>>> On Wed, 4 Jun 2008 10:25:23 -0400
>>>>> "Eduardo Valentin" <edubezval@gmail.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>>> Hi Mauro and Michael,
>>>>>>
>>>>>> Thanks for pointing that there were a duplicated work. If there is any
>>>>>> update on the current driver, I'll contact you. I'm not the author of
>>>>>> this driver, but I'm interested in some points here.
>>>>>>
>>>>>> This chip is used on n800 FM radio. That's why this version came from
>>>>>> linux-omap.
>>>>>> Anyway, one quest that came from my mind, taking a brief look into
>>>>>> this two drivers,
>>>>>> I see they use different interfaces to register a FM radio driver, and
>>>>>> more they are located
>>>>>> under different places inside the tree. So, what is more recommended
>>>>>> for FM radio drivers?
>>>>>> being under drivers/media/radio/ or under
> drivers/media/common/tunners/ ?
>>>>>> What is the API more recommended dvb_tuner_ops or video_device ? I
>>>>>> wonder also what current applications are using.
>>>>>>
>>>>>>
>>>>> Good point. some radio tuners are used inside video boards. Before,
> this
>>>>>
>>>> were
>>>>
>>>>> located inside drivers/media/video. Now, they are at common/tuners.
> This
>>>>>
>>>> seems
>>>>
>>>>> to be a better place.
>>>>>
>>>>> It should be noticed that tea5761 is an I2C device. So, you'll probably
>>>>>
>>>> need a
>>>>
>>>>> counterpart module, at media/radio, that will provice I2C access
> methods
>>>>>
>>>> needed
>>>>
>>>>> on N800.
>>>>>
>>>>>
>>>> Basically, what you will have to do is create a n800 driver under
>>>> media/radio.  This n800 driver will provide the userspace interface via
>>>> v4l2, and it will use internal tuner API to interface to the tea5761
> module.
>>>>
>>>>
>>> Yeah, true.
>>>
>>>
>>>> When all is said and done, most likely all of the tea5761-specific code
>>>> would be removed from the driver that you submit -- the remaining code
>>>> would merely handle glue between userspace and internal tuner api.
>>>>
>>> Humm.. some code may remain inside this driver. Functions to power
> on/down
>>> the device, for example. They are not exported through this tuner API.
>>>
>>
>> Please map what functions you're needing. It makes sense to extend tuner
> API to
>> handle such things. In the case of power down, I think there's one
> callback for
>> it already.
>
> .sleep for power down
>
> .init for power up
>
> It's all there.  Is there anything else missing, Eduardo?
>
> -Mike
>
>
>



-- 
Eduardo Bezerra Valentin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
