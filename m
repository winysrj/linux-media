Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:9303 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZBLHwf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2009 02:52:35 -0500
MIME-Version: 1.0
In-Reply-To: <4993CB1F.603@maxwell.research.nokia.com>
References: <A24693684029E5489D1D202277BE894416429FA1@dlee02.ent.ti.com>
	 <5e9665e10902102000i3433beb8jab7a70e7ac9b57e3@mail.gmail.com>
	 <4993CB1F.603@maxwell.research.nokia.com>
Date: Thu, 12 Feb 2009 16:52:31 +0900
Message-ID: <5e9665e10902112352i57177f20r9022a7cb8a66fa0@mail.gmail.com>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
From: DongSoo Kim <dongsoo.kim@gmail.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
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

Thank you for your comment.

BTW, what should I do if I would rather use external ISP device than
OMAP3 internal ISP feature?

You said that you just have raw sensors by now, so you mean this patch
is not verified working with some ISP modules?

I'm testing your patch on my own omap3 target board with NEC ISP...but
unfortunately not working yet ;(

I should try more harder. more research is needed :)

Cheers,


On Thu, Feb 12, 2009 at 4:09 PM, Sakari Ailus
<sakari.ailus@maxwell.research.nokia.com> wrote:
> DongSoo Kim wrote:
>>
>> Hello.
>
> Hi, and thanks for the comments!
>
>> +static int omap34xxcam_open(struct inode *inode, struct file *file)
>> +{
>>
>> <snip>
>>
>> +       if (atomic_inc_return(&vdev->users) == 1) {
>> +               isp_get();
>> +               if (omap34xxcam_slave_power_set(vdev, V4L2_POWER_ON,
>> +
>> OMAP34XXCAM_SLAVE_POWER_ALL))
>> +                       goto out_slave_power_set_standby;
>> +               omap34xxcam_slave_power_set(
>> +                       vdev, V4L2_POWER_STANDBY,
>> +                       OMAP34XXCAM_SLAVE_POWER_SENSOR);
>> +               omap34xxcam_slave_power_suggest(
>> +                       vdev, V4L2_POWER_STANDBY,
>> +                       OMAP34XXCAM_SLAVE_POWER_LENS);
>> +       }
>>
>>
>> I'm wondering whether this V4L2_POWER_STANDBY operation for sensor
>> device is really necessary.
>>
>> Because if that makes sensor device in standby mode, we do S_FMT and
>> bunch of V4L2 APIs while the camera module is in standby mode.
>>
>> In most cases of "sensor + ISP" SOC camera modules, I2C command is not
>> working while the camera module is in standby mode.
>
> I guess that applies to most sensors.
>
>> Following the camera interface source code, sensor goes down to
>> standby mode until VIDIOC_STREAMON is called.
>>
>> If this power up timing depends on sensor device, then I think we need
>> a conditional power on sequence.
>
> You're right, there's something wrong with the slave power handling. :)
>
> We were thinking that the sensor (or any slave) power management (current
> on, off and standby) could be replaced by four commands: open, close,
> streamon and streamoff. The slave could decide by itself what its real power
> state is. IMO direct power management doesn't belong to the camera driver
> which doesn't drive any hardware anyway.
>
>> As you defined slave devices as SENSOR, LENS, FLASH, then how about
>> making a new slave category like "ISP" for "sensor+ISP" SOC modules?
>
> I currently have just raw sensors. It'd be nice to keep the interface for
> smart sensors the same, though. You still need for a receiver for the image
> data, sometimes called the camera controller. That would be the same than
> the ISP but without fancy features.
>
> Cheers,
>
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
>



-- 
========================================================
Dong Soo, Kim
Engineer
Mobile S/W Platform Lab. S/W centre
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
           dongsoo45.kim@samsung.com
========================================================
