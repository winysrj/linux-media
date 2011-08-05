Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab1HEX3f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2011 19:29:35 -0400
Message-ID: <4E3C7CD8.5060200@redhat.com>
Date: Fri, 05 Aug 2011 20:29:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Andrew Chew <AChew@nvidia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"'Doug Anderson'" <dianders@google.com>
Subject: Re: Guidance regarding deferred I2C transactions
References: <643E69AA4436674C8F39DCC2C05F76383CF0DD22D0@HQMAIL03.nvidia.com> <4E3C557A.2060103@redhat.com> <643E69AA4436674C8F39DCC2C05F76383CF0DD22D5@HQMAIL03.nvidia.com> <Pine.LNX.4.64.1108060108580.26715@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1108060108580.26715@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-08-2011 20:16, Guennadi Liakhovetski escreveu:
> On Fri, 5 Aug 2011, Andrew Chew wrote:
> 
>>>> One way to solve this can be to defer these I2C 
>>> transactions in the image sensor driver all the way up 
>>>> to the time the image sensor is asked to start streaming 
>>> frames. However, it seems to me that this breaks 
>>>> the spirit of the probe; applications will successfully 
>>> probe for camera presence even though the camera 
>>>> isn't actually there. Is this okay?
>>>>
>>>> Is there a better way to do this? Maybe a more general 
>>> thing we can add to the V4L2 framework?
>>>
>>> Probing for the presence of the device hardware at driver 
>>> init time seems 
>>> to be the right thing to do, even when the LED blinks. PC 
>>> keyboard LEDs
>>> also blinks during machine reset, and this is not really 
>>> annoying. Even
>>> on some embedded devices like some cell phones, LEDs blink 
>>> during the boot
>>> time.
>>
>> It's a bit different when the camera LED blinks, though.  The whole 
>> problem is that the user will have thought that the system took a 
>> picture of them without knowing.  What the user sees will potentially be 
>> indistinguishable between expected behavior, and a system that has been 
>> compromised to make use of that blink to actually take a picture, 
>> leading to privacy concerns.
>>
>>
>>> So, as a general rule, I'd say that the better is to keep the 
>>> capability of 
>>> probing the hardware at init time, especially since the same 
>>> sensor may
>>> eventually be used by non SoC drivers.
>>
>> I completely agree with you.  I was just hoping that others have run 
>> into this as well, and that there was an officially endorsed method to 
>> solve this.  Sounds like there isn't.
>>
>>
>>> One strategy that several drivers do, and that solves the 
>>> issue of blinking
>>> after the device reset is to have a shadow copy of the 
>>> register contents.
>>> This way, you can defer the device register writes to occur 
>>> only when you're
>>> actually streaming. E. g. you'll still have the blink at 
>>> probe time (probably
>>> a longer one), but, after that, the driver can just work with 
>>> the cached
>>> values, up to the moment it will really start streaming.
>>
>> Yes, that's easy to do, and will completely solve the blink on open issue.
> 
> This would require modifying each sensor driver.

Why? Only the one(s) that have such trouble will need that. Also, a config option
for the device init may enable or disable such feature.

> And not always these shadowing is desired.

It should be checked case by case. On some cases where shadowing is used,
developers have no option, as some registers are write-only. On other cases,
this is needed, in order to support PM operations (like suspend/resume).

> A simpler approach seems to be to only load the driver, when streaming is 
> required. Yes, it would add a (considerable) delay to streaming begin, but 
> you'd be completely honest to your user and privacy would be guaranteed.

The delay will likely be close to the one introduced by flushing the shadow
registers: it will basically be the needed time to transfer all registers data
via I2C.

> Another less secure approach would be to tie your LED to a different 
> function, to one, that only activates, when actual data is transferred. 
> Maybe you can tie it to one of sync or clock signals? Look whether your 
> sensor has any pins, that only get activated, when video data is 
> transferred.

I agree. If the hardware design is not finished, this is the best way of
doing that.

It is safer and more honest than attaching the led to the I2C bus, as
it will be monitoring the actual data transfer, an not the control bus.

> You can also trigger it from the software, but this might 
> contradict your security policy. However, if you think about it, I don't 
> think your users anyway have a chance to make really 100% sure, their 
> privacy is not violated, so...
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

