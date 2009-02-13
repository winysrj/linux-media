Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:49916 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbZBMKEw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 05:04:52 -0500
MIME-Version: 1.0
In-Reply-To: <dfeb90390902130131r7743af98ge8c9baf4856f835e@mail.gmail.com>
References: <A24693684029E5489D1D202277BE894416429FA1@dlee02.ent.ti.com>
	 <5e9665e10902102000i3433beb8jab7a70e7ac9b57e3@mail.gmail.com>
	 <4993CB1F.603@maxwell.research.nokia.com>
	 <5e9665e10902112352i57177f20r9022a7cb8a66fa0@mail.gmail.com>
	 <dfeb90390902130131r7743af98ge8c9baf4856f835e@mail.gmail.com>
Date: Fri, 13 Feb 2009 19:04:51 +0900
Message-ID: <5e9665e10902130204n7be98d1k400fdded30625537@mail.gmail.com>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
From: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>
To: Arun KS <getarunks@gmail.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?EUC-KR?B?x/zB2CCx6A==?= <riverful.kim@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun.

I appreciate your helpful words!
For the meantime, I need a concrete driver for my camera module first
and I'm still working on it.
I wish I could post my work as a patch ASAP :)
Wish me luck!
Cheers,

Nate


On Fri, Feb 13, 2009 at 6:31 PM, Arun KS <getarunks@gmail.com> wrote:
> On Thu, Feb 12, 2009 at 1:22 PM, DongSoo Kim <dongsoo.kim@gmail.com> wrote:
>> Thank you for your comment.
>>
>> BTW, what should I do if I would rather use external ISP device than
>> OMAP3 internal ISP feature?
>>
>> You said that you just have raw sensors by now, so you mean this patch
>> is not verified working with some ISP modules?
>
> Hi DongSoo,
>
>          The driver is tested and working with sensors which have
> inbuilt ISP modules.
>
> Thanks,
> Arun
>
>>
>> I'm testing your patch on my own omap3 target board with NEC ISP...but
>> unfortunately not working yet ;(
>>
>> I should try more harder. more research is needed :)
>>
>> Cheers,
>>
>>
>> On Thu, Feb 12, 2009 at 4:09 PM, Sakari Ailus
>> <sakari.ailus@maxwell.research.nokia.com> wrote:
>>> DongSoo Kim wrote:
>>>>
>>>> Hello.
>>>
>>> Hi, and thanks for the comments!
>>>
>>>> +static int omap34xxcam_open(struct inode *inode, struct file *file)
>>>> +{
>>>>
>>>> <snip>
>>>>
>>>> +       if (atomic_inc_return(&vdev->users) == 1) {
>>>> +               isp_get();
>>>> +               if (omap34xxcam_slave_power_set(vdev, V4L2_POWER_ON,
>>>> +
>>>> OMAP34XXCAM_SLAVE_POWER_ALL))
>>>> +                       goto out_slave_power_set_standby;
>>>> +               omap34xxcam_slave_power_set(
>>>> +                       vdev, V4L2_POWER_STANDBY,
>>>> +                       OMAP34XXCAM_SLAVE_POWER_SENSOR);
>>>> +               omap34xxcam_slave_power_suggest(
>>>> +                       vdev, V4L2_POWER_STANDBY,
>>>> +                       OMAP34XXCAM_SLAVE_POWER_LENS);
>>>> +       }
>>>>
>>>>
>>>> I'm wondering whether this V4L2_POWER_STANDBY operation for sensor
>>>> device is really necessary.
>>>>
>>>> Because if that makes sensor device in standby mode, we do S_FMT and
>>>> bunch of V4L2 APIs while the camera module is in standby mode.
>>>>
>>>> In most cases of "sensor + ISP" SOC camera modules, I2C command is not
>>>> working while the camera module is in standby mode.
>>>
>>> I guess that applies to most sensors.
>>>
>>>> Following the camera interface source code, sensor goes down to
>>>> standby mode until VIDIOC_STREAMON is called.
>>>>
>>>> If this power up timing depends on sensor device, then I think we need
>>>> a conditional power on sequence.
>>>
>>> You're right, there's something wrong with the slave power handling. :)
>>>
>>> We were thinking that the sensor (or any slave) power management (current
>>> on, off and standby) could be replaced by four commands: open, close,
>>> streamon and streamoff. The slave could decide by itself what its real power
>>> state is. IMO direct power management doesn't belong to the camera driver
>>> which doesn't drive any hardware anyway.
>>>
>>>> As you defined slave devices as SENSOR, LENS, FLASH, then how about
>>>> making a new slave category like "ISP" for "sensor+ISP" SOC modules?
>>>
>>> I currently have just raw sensors. It'd be nice to keep the interface for
>>> smart sensors the same, though. You still need for a receiver for the image
>>> data, sometimes called the camera controller. That would be the same than
>>> the ISP but without fancy features.
>>>
>>> Cheers,
>>>
>>> --
>>> Sakari Ailus
>>> sakari.ailus@maxwell.research.nokia.com
>>>
>>
>>
>>
>> --
>> ========================================================
>> Dong Soo, Kim
>> Engineer
>> Mobile S/W Platform Lab. S/W centre
>> Telecommunication R&D Centre
>> Samsung Electronics CO., LTD.
>> e-mail : dongsoo.kim@gmail.com
>>           dongsoo45.kim@samsung.com
>> ========================================================
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>



-- 
========================================================
DongSoo(Nathaniel), Kim
Engineer
Mobile S/W Platform Lab. S/W centre
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
