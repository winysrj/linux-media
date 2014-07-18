Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3999 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaGRPBs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 11:01:48 -0400
Message-ID: <53C936D0.40708@xs4all.nl>
Date: Fri, 18 Jul 2014 17:01:36 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] airspy: AirSpy SDR driver
References: <1405366031-31937-1-git-send-email-crope@iki.fi> <53C430AC.9030204@xs4all.nl> <53C435A9.8020004@iki.fi> <53C43705.8020207@xs4all.nl> <53C4938A.3000308@iki.fi> <53C4A51F.9000500@xs4all.nl> <53C866F2.9090005@iki.fi> <53C8AAB7.1080305@xs4all.nl> <53C935D9.50202@iki.fi>
In-Reply-To: <53C935D9.50202@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/2014 04:57 PM, Antti Palosaari wrote:
> 
> 
> On 07/18/2014 08:03 AM, Hans Verkuil wrote:
>> On 07/18/2014 02:14 AM, Antti Palosaari wrote:
>>>
>>>
>>> On 07/15/2014 06:50 AM, Hans Verkuil wrote:
>>>> On 07/15/2014 04:35 AM, Antti Palosaari wrote:
>>>>> On 07/14/2014 11:01 PM, Hans Verkuil wrote:
>>>>>> On 07/14/2014 09:55 PM, Antti Palosaari wrote:
>>>>>>> I actually ran v4l2-compliance and there was problem with ADC band
>>>>>>> enumeration. v4l2-compliance didn't liked as ADC freq was just 20MHz,
>>>>>>> both upper and lower limit. Due to that I added even small hack to driver,
>>>>>>>
>>>>>>> +		.rangelow   = 20000000,
>>>>>>> +		.rangehigh  = 20000001, /* FIXME: make v4l2-compliance happy */
>>>>>>
>>>>>> Hmm, does the latest v4l2-compliance (direct from the git repo) still fail on
>>>>>> that? That shouldn't be a problem, and I don't see that here either if I try that
>>>>>> myself.
>>>>>>
>>>>>> If it still fails, can you show me the error message?
>>>>>
>>>>> [crope@localhost gr-analog]$ ls -l /usr/local/bin/v4l2-compliance
>>>>> -rwxr-xr-x. 1 root root 1497964 Jul 14 22:50 /usr/local/bin/v4l2-compliance
>>>>> [crope@localhost gr-analog]$ /usr/local/bin/v4l2-compliance -S
>>>>> /dev/swradio0 -s
>>>>> Driver Info:
>>>>> 	Driver name   : airspy
>>>>> 	Card type     : AirSpy SDR
>>>>> 	Bus info      : usb-0000:00:13.2-2
>>>>> 	Driver version: 3.15.0
>>>>> 	Capabilities  : 0x85110000
>>>>> 		SDR Capture
>>>>> 		Tuner
>>>>> 		Read/Write
>>>>> 		Streaming
>>>>> 		Device Capabilities
>>>>> 	Device Caps   : 0x05110000
>>>>> 		SDR Capture
>>>>> 		Tuner
>>>>> 		Read/Write
>>>>> 		Streaming
>>>>>
>>>>> Compliance test for device /dev/swradio0 (not using libv4l2):
>>>>>
>>>>> Required ioctls:
>>>>> 	test VIDIOC_QUERYCAP: OK
>>>>>
>>>>> Allow for multiple opens:
>>>>> 	test second sdr open: OK
>>>>> 	test VIDIOC_QUERYCAP: OK
>>>>> 	test VIDIOC_G/S_PRIORITY: OK
>>>>>
>>>>> Debug ioctls:
>>>>> 	test VIDIOC_DBG_G/S_REGISTER: OK
>>>>> 	test VIDIOC_LOG_STATUS: OK
>>>>>
>>>>> Input ioctls:
>>>>> 		fail: v4l2-test-input-output.cpp(107): rangelow >= rangehigh
>>>>> 		fail: v4l2-test-input-output.cpp(190): invalid tuner 0
>>>>> 	test VIDIOC_G/S_TUNER: FAIL
>>>>> 		fail: v4l2-test-input-output.cpp(290): could get frequency for invalid
>>>>
>>>> Try again, it should be fixed now.
>>>
>>> Old error has gone, but two new comes:
>>>
>>> Compliance test for device /dev/swradio0 (not using libv4l2):
>>>
>>> Required ioctls:
>>> 		fail: v4l2-compliance.cpp(354): !(caps & V4L2_CAP_EXT_PIX_FORMAT)
>>
>> That suggests you were not using the very latest media tree.
>>
>> But now you'll get a new error: !(dcaps & V4L2_CAP_EXT_PIX_FORMAT)
>>
>> That's because of a bug in the kernel that I mailed Laurent about.
>>
>> Perhaps I was a bit too hasty in adding that to v4l2-compliance :-)
> 
> Yes, I am stuck on 3.15-rc6 media/fixes as Mauro did not apply patches 
> needed from fixes to master. Also, master is about always unusable as it 
> is very buggy rc1.

FYI: master is now rc5.

	Hans

> 
> regards
> Antti
> 

