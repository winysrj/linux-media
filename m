Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3650 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3LPJLt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 04:11:49 -0500
Message-ID: <52AEC3BA.6070204@xs4all.nl>
Date: Mon, 16 Dec 2013 10:11:22 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: luca.risolia@linux-projects.org
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 1/2] sn9c102: prepare for removal by moving it to
 staging.
References: <1386850822-3487-1-git-send-email-hverkuil@xs4all.nl> <1628977.YDkQVgTYrx@laptop> <52AD8FF9.2020901@xs4all.nl> <1921904.YLCnNg6vFe@laptop>
In-Reply-To: <1921904.YLCnNg6vFe@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2013 02:55 PM, Luca Risolia wrote:
> Hi Hans,
> 
> thanks for your reply. I understand your point of view. Since the sn9c102 will 
> be removed from the kernel soon, I am considering another option, that is to 
> move the driver to UV4L, which is a transparent, ~100% userspace 
> implementation of V4L2-compliant drivers for input devices.

While it may not be the ideal solution from my point of view, one of the wonders
of open source is that, hey, it's free! :-)

If I may make a suggestion: use the v4l2-compliance tool for these drivers as
well. Today it covers about 85% of all ioctls (main missing ones are the streaming
ioctls and cropping/selection ioctls).

Regards,

	Hans

> So, for those who are still interested in good support for the sn9cxxx, I'll 
> be porting all the code to userspace. Users will not notice any difference 
> from a kernel driver. Fore more informations:
> 
> http://linux-projects.org
> 
> Regards,
> Luca
> 
> In data domenica 15 dicembre 2013 12:18:17, Hans Verkuil ha scritto:
>> Hi Luca,
>>
>> On 12/14/2013 06:13 PM, Luca Risolia wrote:
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> During the last media summit meeting it was decided to move this driver
>>>> to
>>>> staging as the first step to removing it altogether.
>>>>
>>>> Most webcams covered by this driver are now supported by gspca. Nobody
>>>> has
>>>> the hardware to convert the remaining devices to gspca.
>>>
>>> I have all the boards given by the manufacturer. Last time I tried the
>>> gspca driver it certainly did not work with most of the sn9c1xx-based
>>> models the gspca driver claims to be supporting (which were a subset of
>>> the devices actually supported by sn9c102).
>>>
>>>> This driver needs a major overhaul to have it conform to the latest
>>>> frameworks and compliancy tests.
>>>
>>> What is not compliant? I will offer my help to update the driver in case
>>> but cannot give my help to fix or test all the boards again with the
>>> gspca, as it would be a considerable amount of extra work.
>>
>> Work is ongoing to move all drivers to the latest V4L2 frameworks (control
>> framework, using v4l2_fh, v4l2_device, video_ioctl2 & unlocked_ioctl,
>> videobuf2 were possible). This reduces code complexity of the drivers and
>> will eventually allow us to get rid of old core legacy code. In addition,
>> using these frameworks will help drivers to pass the v4l2-compliance test
>> tool (part of v4l-utils.git).
>>
>> For most drivers not yet converted I have hardware myself that I can use to
>> do the conversion and testing, but not for the sn9c102.
>>
>> Given the fact that that driver caters to very old webcams that few people
>> use, and for which cheap modern webcam replacements are easily available,
>> it is the opinion of the core v4l2 developers that it is not worth the
>> effort for us to convert the driver.
>>
>> The first step in that process is to move it to staging to signal that
>> unless something is done this driver will be removed.
>>
>> There are a number of options:
>>
>> 1) Nothing is done. In that case the driver will be removed, probably end of
>> next year.
>> 2) You convert the driver to the various frameworks, make it pass
>> v4l2-compliance, etc. In that case there is no reason to remove it.
>> 3) My estimate is that option 2) is time consuming. It might be easier for
>> you to add support for the webcams to gspca instead.
>> 4) Send the webcams that are not (or not correctly) supported by gscpa to
>> Hans de Goede, and let him add support for them to gspca. I don't know if
>> he wants to, though. He may well decide that it is not worth it, although I
>> assume he would be willing to at least fix gspca for webcams that are not
>> correctly supported.
>>
>>>> Without hardware, however, this is next to impossible. Given the fact
>>>> that
>>>> this driver seems to be pretty much unused (it has been removed from
>>>> Fedora
>>>> several versions ago and nobody complained about that), we decided to
>>>> drop
>>>> this driver.
>>>
>>> As no one has the hardware, what is the reason why the sn9c102 has been
>>> moved into gspca, although the sn9c102 driver has been already present in
>>> the kernel since years before?
>>
>> Frankly because sn9c102 isn't very good code. In all fairness, none of
>> todays frameworks existed when sn9c102 was first created. It would be done
>> quite differently today. Note that AFAIK HdG has some of the webcams
>> supported by both gspca and sn9c102, I'm assuming those are working fine
>> with gspca.
>>> In my opinion the fact that the module has been removed from Fedora does
>>> not imply that the driver is unused. For sure that does not mean the
>>> sn9c102 driver is unuseful, since gspca does not work properly with all
>>> the devices, as I mentioned.
>>
>> The fact that nobody has been complaining about the removal from Fedora
>> indicates that very few people still use the webcams supported by sn9c102.
>>
>> That in itself is not a problem, but the fact that the code is really old
>> and needs a lot of work is. Within 1-2 years I am going to require that all
>> V4L2 drivers use at least some of the core frameworks in order to enforce
>> consistent API behavior. sn9c102 is one of the very few drivers that has
>> the unlucky combination of being too complex to easily/quickly convert, is
>> only rarely used, and for which there is a cheap and easy upgrade path for
>> the few remaining users (if any) of that driver (i.e. buy a uvc webcam).
>>
>> We have removed drivers in the past as well for similar reasons. It's done
>> very rarely: only if they start blocking progress, there is nobody
>> motivated to convert them, and they are only rarely (if ever) used.
>>
>> Regards,
>>
>> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

