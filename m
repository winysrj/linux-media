Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44544 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbZDTHjm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 03:39:42 -0400
Message-ID: <49EC2793.6020205@redhat.com>
Date: Mon, 20 Apr 2009 09:43:15 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
CC: Adam Baker <linux@baker-net.org.uk>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l release: 0.5.97: the whitebalance release!
References: <49E5D4DE.6090108@hhs.nl>	 <200904152326.59464.linux@baker-net.org.uk> <49E66787.2080301@hhs.nl>	 <200904162146.59742.linux@baker-net.org.uk>	 <49E843CB.6050306@redhat.com> <49E8D808.9070804@gmail.com>	 <49E9B989.70602@redhat.com> <49E9E652.5070706@gmail.com>	 <49EAD6A5.1010507@redhat.com> <62e5edd40904191220r87d5979peae56148793aa70@mail.gmail.com> <49EB8055.4040407@redhat.com> <49EBFD5D.7020803@gmail.com>
In-Reply-To: <49EBFD5D.7020803@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/20/2009 06:43 AM, Erik Andrén wrote:
>
> Hans de Goede wrote:
>>
>> On 04/19/2009 09:20 PM, Erik Andrén wrote:
>>> 2009/4/19 Hans de Goede<hdegoede@redhat.com>:
>>>> On 04/18/2009 04:40 PM, Erik Andrén wrote:
>>>>> Hans de Goede wrote:
>>>>>> On 04/17/2009 09:27 PM, Erik Andrén wrote:
>>>>>>> Hans de Goede wrote:
>>>>>>>> On 04/16/2009 10:46 PM, Adam Baker wrote:
>>>>>>>>> On Thursday 16 Apr 2009, Hans de Goede wrote:
>>>>>>>>>> On 04/16/2009 12:26 AM, Adam Baker wrote:
>>>>>>>>>>> On Wednesday 15 Apr 2009, Hans de Goede wrote:
>>>>>>>>>>>> Currently only whitebalancing is enabled and only on Pixarts
>>>>>>>>>>>> (pac)
>>>>>>>>>>>> webcams (which benefit tremendously from this). To test this
>>>>>>>>>>>> with
>>>>>>>>>>>> other
>>>>>>>>>>>> webcams (after instaling this release) do:
>>>>>>>>>>>>
>>>>>>>>>>>> export LIBV4LCONTROL_CONTROLS=15
>>>>>>>>>>>> LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so v4l2ucp&
>>>>>>>>>>> Strangely while those instructions give me a whitebalance control
>>>>>>>>>>> for the
>>>>>>>>>>> sq905 based camera I can't get it to appear for a pac207 based
>>>>>>>>>>> camera
>>>>>>>>>>> regardless of whether LIBV4LCONTROL_CONTROLS is set.
>>>>>>>>>> Thats weird, there is a small bug in the handling of pac207
>>>>>>>>>> cams with usb id 093a:2476 causing libv4l to not automatically
>>>>>>>>>> enable whitebalancing (and the control) for cams with that id,
>>>>>>>>>> but if you have LIBV4LCONTROL_CONTROLS set (exported!) both
>>>>>>>>>> when loading v4l2ucp (you must preload v4l2convert.so!) and
>>>>>>>>>> when loading your viewer, then it should work.
>>>>>>>>>>
>>>>>>>>> I've tested it by plugging in the sq905 camera, verifying the
>>>>>>>>> whitebablance
>>>>>>>>> control is present and working, unplugging the sq905 and
>>>>>>>>> plugging in
>>>>>>>>> the
>>>>>>>>> pac207 and using up arrow to restart v4l2ucp and svv so I think
>>>>>>>>> I've
>>>>>>>>> eliminated most finger trouble possibilities. The pac207 is id
>>>>>>>>> 093a:2460 so
>>>>>>>>> not the problem id. I'll have to investigate more thoroughly later.
>>>>>>>>>
>>>>>>>> Does the pac207 perhaps have a / in its "card" string (see v4l-info
>>>>>>>> output) ?
>>>>>>>> if so try out this patch:
>>>>>>>> http://linuxtv.org/hg/~hgoede/libv4l/rev/1e08d865690a
>>>>>>>>
>>>>>>> I have the same issue as Adam when trying to test this with my
>>>>>>> gspca_stv06xx based Quickcam Web camera i. e no whitebalancing
>>>>>>> controls show up. I'm attaching a dump which logs all available
>>>>>>> pixformats and v4l2ctrls showing that libv4l is properly loaded.
>>>>>>> (And yes, LIBV4LCONTROL_CONTROLS is exported and set to 15).
>>>>>>>
>>>>>>> Best regards,
>>>>>>> Erik
>>>>>>>
>>>>>> Ah, you are using v4l2-ctl, not v4l2ucp, and that uses
>>>>>> V4L2_CTRL_FLAG_NEXT_CTRL
>>>>>> control enumeration. My code doesn't handle V4L2_CTRL_FLAG_NEXT_CTRL
>>>>>> (which is
>>>>>> a bug). I'm not sure when I'll have time to fix this. Patches welcome,
>>>>>> or in
>>>>>> the mean time use v4l2ucp to play with the controls.
>>>>>>
>>>>> Actually, I've tried to use both without finding the controls.
>>>>> I've only tried with v4l2ucp v. 1.2. Is 1.3 necessary?
>>>>>
>>>> Apparently there are different versions of v4l2ucp in different distro's
>>>> and some do use the V4L2_CTRL_FLAG_NEXT_CTRL, just like v4l2-ctl. See
>>>> Adam Baker's patch later in this thread. Which I will apply to my
>>>> tree after I've reviewed it (when I find some time currently I've a
>>>> lot of
>>>> $work$ )
>>>>
>>> Applying Adam Bakers patch makes the control appear _but_ I can't seem
>>> to make out any difference when any of the whitebalancing and
>>> normalize options, regardless of how i tweak the max / min values.
>>>
>> Did you also do the
>> export LIBV4LCONTROL_CONTROLS=15
>>
>> In the terminal from where you are starting the viewing application ?
>>
>
> Yes.
>

Hmm,

Then the camera you are using probably already has some whitebalancing
itself using the same algorithm. What happens if you enable normalize
and then lower the high bound significantly? If that doesn't do anything
either then somehow things are not working.

Regards,

Hans
