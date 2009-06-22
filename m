Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:3989 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZFVOBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 10:01:02 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1477170wfd.4
        for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 07:01:04 -0700 (PDT)
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"ext Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Koskipaa Antti (Nokia-D/Helsinki)" <antti.koskipaa@nokia.com>,
	"Cohen David.A (Nokia-D/Helsinki)" <david.cohen@nokia.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	"gary@mlbassoc.com" <gary@mlbassoc.com>
Message-Id: <9FCF32A4-259F-43EA-BA43-02248198FDE6@gmail.com>
From: Dongsoo Kim <dongsoo.kim@gmail.com>
To: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
In-Reply-To: <200906221652.02119.tuukka.o.toivonen@nokia.com>
Content-Type: text/plain; charset=EUC-KR; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: OMAP3 ISP and camera drivers (update 2)
Date: Mon, 22 Jun 2009 23:00:53 +0900
References: <4A3A7AE2.9080303@maxwell.research.nokia.com> <5e9665e10906200205ga45073eue92b73abba79e41c@mail.gmail.com> <200906221652.02119.tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


2009. 06. 22, 오후 10:52, Tuukka.O Toivonen 작성:

> On Saturday 20 June 2009 12:05:13 ext Dongsoo, Nathaniel Kim wrote:
>> Following patch.
>> http://www.gitorious.org/omap3camera/mainline/commit/d92c96406296310a977b00f45b209523929b15b5
>> What happens to the capability when the int device is dummy? (does it
>> mean that there is no int device?)
>
> Yes, when the int device is dummy, there is no such a device.
> For example, when vdev->vdev_sensor == v4l2_int_device_dummy()
> it means that the device has no sensor.
>
> In that case, obviously, the device is not capable of capturing
> or streaming.

OK, what I'm afraid is that even though the device could be opened and  
recognized as a v4l2 device but has no capability should be weird.  
Actually I'm not sure about this case is spec-in or not.
In my opinion it should be better when the camera interface (or ISP)  
has no int device (or subdev) attahced on it, no device node mounted  
in /dev or returning ENODEV. But before that, I'm very curious about  
why you made in that way.

>
>> And one more thing. If I want to test how the "ISP" driver is  
>> working,
>> is there any target board that I can buy also a sensor device already
>> attached on it?
>
> I think that TI probably has some boards for sale, you
> could take a look at their web pages.
>
> - Tuukka

Thank you I'll try to find on their web site :-)
Cheers,

Nate

==========================
Dong Soo, Kim
Engineer
Mobile S/W Platform Lab.
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
            dongsoo45.kim@samsung.com
==========================

