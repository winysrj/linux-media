Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:42485 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZFVNwT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 09:52:19 -0400
From: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
To: "ext Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: Re: OMAP3 ISP and camera drivers (update 2)
Date: Mon, 22 Jun 2009 16:52:01 +0300
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"ext Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Koskipaa Antti (Nokia-D/Helsinki)" <antti.koskipaa@nokia.com>,
	"Cohen David.A (Nokia-D/Helsinki)" <david.cohen@nokia.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	"gary@mlbassoc.com" <gary@mlbassoc.com>
References: <4A3A7AE2.9080303@maxwell.research.nokia.com> <5e9665e10906200205ga45073eue92b73abba79e41c@mail.gmail.com>
In-Reply-To: <5e9665e10906200205ga45073eue92b73abba79e41c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906221652.02119.tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 20 June 2009 12:05:13 ext Dongsoo, Nathaniel Kim wrote:
> Following patch.
> http://www.gitorious.org/omap3camera/mainline/commit/d92c96406296310a977b00f45b209523929b15b5
> What happens to the capability when the int device is dummy? (does it
> mean that there is no int device?)

Yes, when the int device is dummy, there is no such a device.
For example, when vdev->vdev_sensor == v4l2_int_device_dummy()
it means that the device has no sensor.

In that case, obviously, the device is not capable of capturing
or streaming.

> And one more thing. If I want to test how the "ISP" driver is working,
> is there any target board that I can buy also a sensor device already
> attached on it? 

I think that TI probably has some boards for sale, you
could take a look at their web pages.

- Tuukka
