Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:60060 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZBLHLN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2009 02:11:13 -0500
Message-ID: <4993CB1F.603@maxwell.research.nokia.com>
Date: Thu, 12 Feb 2009 09:09:19 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: DongSoo Kim <dongsoo.kim@gmail.com>
CC: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?UTF-8?B?7ZiV7KSAIOq5gA==?= <riverful.kim@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
References: <Acl1IyQQvIDQejCAQ5O/QnkHIBmt3w==>	 <A24693684029E5489D1D202277BE894416429FA1@dlee02.ent.ti.com> <5e9665e10902102000i3433beb8jab7a70e7ac9b57e3@mail.gmail.com>
In-Reply-To: <5e9665e10902102000i3433beb8jab7a70e7ac9b57e3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DongSoo Kim wrote:
> Hello.

Hi, and thanks for the comments!

> +static int omap34xxcam_open(struct inode *inode, struct file *file)
> +{
> 
> <snip>
> 
> +       if (atomic_inc_return(&vdev->users) == 1) {
> +               isp_get();
> +               if (omap34xxcam_slave_power_set(vdev, V4L2_POWER_ON,
> +                                               OMAP34XXCAM_SLAVE_POWER_ALL))
> +                       goto out_slave_power_set_standby;
> +               omap34xxcam_slave_power_set(
> +                       vdev, V4L2_POWER_STANDBY,
> +                       OMAP34XXCAM_SLAVE_POWER_SENSOR);
> +               omap34xxcam_slave_power_suggest(
> +                       vdev, V4L2_POWER_STANDBY,
> +                       OMAP34XXCAM_SLAVE_POWER_LENS);
> +       }
> 
> 
> I'm wondering whether this V4L2_POWER_STANDBY operation for sensor
> device is really necessary.
> 
> Because if that makes sensor device in standby mode, we do S_FMT and
> bunch of V4L2 APIs while the camera module is in standby mode.
> 
> In most cases of "sensor + ISP" SOC camera modules, I2C command is not
> working while the camera module is in standby mode.

I guess that applies to most sensors.

> Following the camera interface source code, sensor goes down to
> standby mode until VIDIOC_STREAMON is called.
> 
> If this power up timing depends on sensor device, then I think we need
> a conditional power on sequence.

You're right, there's something wrong with the slave power handling. :)

We were thinking that the sensor (or any slave) power management 
(current on, off and standby) could be replaced by four commands: open, 
close, streamon and streamoff. The slave could decide by itself what its 
real power state is. IMO direct power management doesn't belong to the 
camera driver which doesn't drive any hardware anyway.

> As you defined slave devices as SENSOR, LENS, FLASH, then how about
> making a new slave category like "ISP" for "sensor+ISP" SOC modules?

I currently have just raw sensors. It'd be nice to keep the interface 
for smart sensors the same, though. You still need for a receiver for 
the image data, sometimes called the camera controller. That would be 
the same than the ISP but without fancy features.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
