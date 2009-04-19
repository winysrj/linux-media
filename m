Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:56019 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbZDSGgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2009 02:36:21 -0400
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"R, Sivaraj" <sivaraj@ti.com>, "Hadli, Manjunath" <mrh@ti.com>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"Kumar, Purushotam" <purushotam@ti.com>
Message-Id: <793DE56C-45AE-48ED-B26D-A1A4BECC5F87@gmail.com>
From: Dongsoo Kim <dongsoo.kim@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200904181753.47515.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=EUC-KR; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [RFC] Stand-alone Resizer/Previewer Driver support under V4L2 framework
Date: Sun, 19 Apr 2009 15:36:15 +0900
References: <19F8576C6E063C45BE387C64729E73940427E3F70B@dbde02.ent.ti.com> <200903301902.21783.hverkuil@xs4all.nl> <19F8576C6E063C45BE387C64729E73940427E3F8F1@dbde02.ent.ti.com> <200904181753.47515.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans and Hiremath,

One of my recent job is making S3C64XX camera interface driver (even  
though other jobs of mine are not finished yet...;-()
And, what a incident! S3C64XX has also similar H/W block in camera  
interface.
Resizer in S3C camera interface can be used in system wide like the  
one in Omap3.

But in case of mine, I decided to make it as a TYPE_VIDEO_CAPTURE and  
TYPE_VIDEO_OUTPUT.
I thought that is was enough. Actually I took omap video out (vout?)  
for reference :-)
Cheers,

Nate


2009. 04. 19, 오전 12:53, Hans Verkuil 작성:

> On Tuesday 31 March 2009 10:53:02 Hiremath, Vaibhav wrote:
>> Thanks,
>> Vaibhav Hiremath
>>
>>>> APPROACH 3 -
>>>> ----------
>>>>
>>>> .....
>>>>
>>>> (Any other approach which I could not think of would be
>>>
>>> appreciated)
>>>
>>>> I would prefer second approach, since this will provide standard
>>>> interface to applications independent on underneath hardware.
>>>>
>>>> There may be many number of such configuration parameters required
>>>
>>> for
>>>
>>>> different such devices, we need to work on this and come up with
>>>
>>> some
>>>
>>>> standard capability fields covering most of available devices.
>>>>
>>>> Does anybody have some other opinions on this?
>>>> Any suggestions will be helpful here,
>>>
>>> FYI: I have very little time to look at this for the next 2-3 weeks.
>>> As you
>>> know I'm working on the last pieces of the v4l2_subdev conversion
>>> for 2.6.30
>>> that should be finished this week. After that I'm attending the
>>> Embedded
>>> Linux Conference in San Francisco.
>>>
>>> But I always thought that something like this would be just a
>>> regular video
>>> device that can do both 'output' and 'capture'. For a resizer I
>>> would
>>> expect that you set the 'output' size (the size of your source
>>> image) and
>>> the 'capture' size (the size of the resized image), then just send
>>> the
>>> frames to the device (== resizer) and get them back on the capture
>>> side.
>>
>> [Hiremath, Vaibhav] Yes, it is possible to do that.
>>
>> Hans,
>>
>> I went through the link referred by Sergio and I think we should  
>> inherit
>> some implementation for CODECs here for such devices.
>>
>> V4L2_BUF_TYPE_CODECIN - To access the input format.
>> V4L2_BUF_TYPE_CODECOUT - To access the output format.
>>
>> It makes sense, since such memory-to-memory devices will mostly being
>> used from codecs context. And this would be more clear from user
>> application.
>
> To be honest, I don't see the need for this. I think  
> TYPE_VIDEO_CAPTURE and
> TYPE_VIDEO_OUTPUT are perfectly fine.
>
>> And as acknowledged by you, we can use VIDIOC_S_FMT for setting
>> parameters.
>>
>> One thing I am not able to convince myself is that, using "priv"  
>> field
>> for custom configuration.
>
> I agree. Especially since you cannot use it as a pointer to addition
> information.
>
>> I would prefer and recommend capability based
>> interface, where application will query the capability of the  
>> device for
>> luma enhancement, filter coefficients (number of coeff and depth),
>> interpolation type, etc...
>>
>> This way we can make sure that, any such future devices can be  
>> adapted by
>> this framework.
>
> The big question is how many of these capabilities are 'generic' and  
> how
> many are very much hardware specific. I am leaning towards using the
> extended control API for this. It's a bit awkward to implement in  
> drivers
> at the moment, but that should improve in the future when a lot of the
> control handling code will move into the new core framework.
>
> I really need to know more about the sort of features that omap/ 
> davinci
> offer (and preferably also for similar devices by other  
> manufacturers).
>
>>
>>
>> Hans,
>> Have you get a chance to look at Video-Buf layer issues I mentioned  
>> in
>> original draft?
>
> I've asked Magnus Damm to take a look at this. I know he did some  
> work in
> this area and he may have fixed some of these issues already. Very  
> useful,
> that Embedded Linux conference...
>
> Regards,
>
> 	Hans
>
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG

=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
           dongsoo45.kim@samsung.com



