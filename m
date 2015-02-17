Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50597 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbbBQPOW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 10:14:22 -0500
Message-id: <54E35ACA.6060604@samsung.com>
Date: Tue, 17 Feb 2015 16:14:18 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media/v4l2-ctrls: Always run s_ctrl on volatile ctrls
References: <1424170934-18619-1-git-send-email-ricardo.ribalda@gmail.com>
 <54E32358.8010303@cisco.com> <54E326C0.8040901@linux.intel.com>
 <54E347D7.6090104@samsung.com> <54E34AE9.90505@linux.intel.com>
 <54E34E95.7070001@samsung.com> <54E351B5.8040608@linux.intel.com>
In-reply-to: <54E351B5.8040608@linux.intel.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/17/2015 03:35 PM, Sakari Ailus wrote:
> Jacek Anaszewski wrote:
>> On 02/17/2015 03:06 PM, Sakari Ailus wrote:
>>> Hi Jacek,
>>>
>>> Jacek Anaszewski wrote:
>>>> Hi Hans, Sakari,
>>>>
>>>> On 02/17/2015 12:32 PM, Sakari Ailus wrote:
>>>>> Hi Hans,
>>>>>
>>>>> Hans Verkuil wrote:
>>>>> ...
>>>>>>> Unfortunately, it only works one time, because the next time the
>>>>>>> user writes
>>>>>>> a zero to the control cluster_changed returns false.
>>>>>>>
>>>>>>> I think on volatile controls it is safer to run s_ctrl twice than
>>>>>>> missing a
>>>>>>> valid s_ctrl.
>>>>>>>
>>>>>>> I know I am abusing a bit the API for this :P, but I also believe
>>>>>>> that the
>>>>>>> semantic here is a bit confusing.
>>>>>>
>>>>>> The reason for that is that I have yet to see a convincing argument
>>>>>> for
>>>>>> allowing s_ctrl for a volatile control.
>>>>>
>>>>> Well, one example are LED flash class devices which implement V4L2
>>>>> flash
>>>>> API through a wrapper. The user may use the LED flash class API to
>>>>> change the values of the controls, and V4L2 framework has no clue about
>>>>> this. The V4L2 controls are volatile, and the real values of the
>>>>> settings are stored in the LED flash class.
>>>>>
>>>>> This is the current implementation (not merged yet); an alternative, a
>>>>> more correct one, would be to use callbacks to tell about the
>>>>> changes in
>>>>> control values. I haven't pushed for that, primarily because the
>>>>> patchset is already quite complex and I've seen this as something that
>>>>> can be always implemented later if it bothers someone.
>>>>>
>>>>> Cc Jacek.
>>>>>
>>>>
>>>> Actually this will be not an issue for v4l2-flash sub-device anymore.
>>>> In the next version of the patch set the v4l2-flash sub-device
>>>> will be synchronizing the flash device registers with the
>>>> state of the controls on open.
>>>
>>> Ah, right --- you're preventing the use of the LED flash class whilst
>>> the V4L2 sub-device is opened?
>>
>> Yes.
>>
>>> I'm not fully certain whether that'd be
>>> really useful, as the V4L2 sub-device can also be opened by multiple
>>> users at the same time.
>>
>> We also prevent from this using v4l2_fh_is_singular on open.
>
> I'm not fully certain if I'd do that --- no other flash chip driver
> does. It might be good to think about how does one acquire the ownership
> of media devices or parts of media devices, or whether it's something
> that's needed at all.
>

Well, it was your remark from the review to add this :)

Regarding locking the LED subsystem sysfs interface - it is required for
preventing reconfiguration of the device from the sysfs level. Without
this the V4L2 flash device couldn't be certain about the flash LED
device state.

The patch adding the locking mechanism to the LED subsystem has been
merged few months ago.

-- 
Best Regards,
Jacek Anaszewski
