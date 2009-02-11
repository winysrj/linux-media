Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:25644 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZBKEA2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 23:00:28 -0500
MIME-Version: 1.0
In-Reply-To: <A24693684029E5489D1D202277BE894416429FA1@dlee02.ent.ti.com>
References: <Acl1IyQQvIDQejCAQ5O/QnkHIBmt3w==>
	 <A24693684029E5489D1D202277BE894416429FA1@dlee02.ent.ti.com>
Date: Wed, 11 Feb 2009 13:00:27 +0900
Message-ID: <5e9665e10902102000i3433beb8jab7a70e7ac9b57e3@mail.gmail.com>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
From: DongSoo Kim <dongsoo.kim@gmail.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	kyungmin.park@samsung.com,
	=?EUC-KR?B?x/zB2CCx6A==?= <riverful.kim@samsung.com>,
	jongse.won@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

+static int omap34xxcam_open(struct inode *inode, struct file *file)
+{

<snip>

+       if (atomic_inc_return(&vdev->users) == 1) {
+               isp_get();
+               if (omap34xxcam_slave_power_set(vdev, V4L2_POWER_ON,
+                                               OMAP34XXCAM_SLAVE_POWER_ALL))
+                       goto out_slave_power_set_standby;
+               omap34xxcam_slave_power_set(
+                       vdev, V4L2_POWER_STANDBY,
+                       OMAP34XXCAM_SLAVE_POWER_SENSOR);
+               omap34xxcam_slave_power_suggest(
+                       vdev, V4L2_POWER_STANDBY,
+                       OMAP34XXCAM_SLAVE_POWER_LENS);
+       }


I'm wondering whether this V4L2_POWER_STANDBY operation for sensor
device is really necessary.

Because if that makes sensor device in standby mode, we do S_FMT and
bunch of V4L2 APIs while the camera module is in standby mode.

In most cases of "sensor + ISP" SOC camera modules, I2C command is not
working while the camera module is in standby mode.

Following the camera interface source code, sensor goes down to
standby mode until VIDIOC_STREAMON is called.

If this power up timing depends on sensor device, then I think we need
a conditional power on sequence.

As you defined slave devices as SENSOR, LENS, FLASH, then how about
making a new slave category like "ISP" for "sensor+ISP" SOC modules?

Then we could make slave devices with conditional cases.
Cheers.


Regards,
Nate
