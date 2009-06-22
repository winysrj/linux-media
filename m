Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.216.174]:42699 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZFVOFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 10:05:24 -0400
Received: by pxi4 with SMTP id 4so59639pxi.33
        for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 07:05:27 -0700 (PDT)
Cc: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Koskipaa Antti (Nokia-D/Helsinki)" <antti.koskipaa@nokia.com>,
	"Cohen David.A (Nokia-D/Helsinki)" <david.cohen@nokia.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	"gary@mlbassoc.com" <gary@mlbassoc.com>
Message-Id: <1DA2ED23-DD14-4E7C-9CDB-D86009620337@gmail.com>
From: Dongsoo Kim <dongsoo.kim@gmail.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894441306D3E@dlee02.ent.ti.com>
Content-Type: text/plain; charset=EUC-KR; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: OMAP3 ISP and camera drivers (update 2)
Date: Mon, 22 Jun 2009 23:05:15 +0900
References: <4A3A7AE2.9080303@maxwell.research.nokia.com> <5e9665e10906200205ga45073eue92b73abba79e41c@mail.gmail.com> <200906221652.02119.tuukka.o.toivonen@nokia.com> <A24693684029E5489D1D202277BE894441306D3E@dlee02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


2009. 06. 22, 오후 11:01, Aguirre Rodriguez, Sergio Alberto 작성:

>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Tuukka.O Toivonen
>> Sent: Monday, June 22, 2009 8:52 AM
>> To: ext Dongsoo, Nathaniel Kim
>> Cc: Sakari Ailus; linux-media@vger.kernel.org; Aguirre Rodriguez,  
>> Sergio
>> Alberto; Hiremath, Vaibhav; Koskipaa Antti (Nokia-D/Helsinki); Cohen
>> David.A (Nokia-D/Helsinki); Alexey Klimov; gary@mlbassoc.com
>> Subject: Re: OMAP3 ISP and camera drivers (update 2)
>>
>> On Saturday 20 June 2009 12:05:13 ext Dongsoo, Nathaniel Kim wrote:
>>> Following patch.
>>>
>> http://www.gitorious.org/omap3camera/mainline/commit/d92c96406296310a977b0
>> 0f45b209523929b15b5
>>> What happens to the capability when the int device is dummy? (does  
>>> it
>>> mean that there is no int device?)
>>
>> Yes, when the int device is dummy, there is no such a device.
>> For example, when vdev->vdev_sensor == v4l2_int_device_dummy()
>> it means that the device has no sensor.
>>
>> In that case, obviously, the device is not capable of capturing
>> or streaming.
>>
>>> And one more thing. If I want to test how the "ISP" driver is  
>>> working,
>>> is there any target board that I can buy also a sensor device  
>>> already
>>> attached on it?
>>
>> I think that TI probably has some boards for sale, you
>> could take a look at their web pages.
>
> Hi Nate,
>
> I'm currently rebasing these patches on top of latest Kevin's PM  
> tree, and trying to make 3430SDP (MT9P012 and OV3640), Zoom1 and  
> Zoom2 (not there yet, but in the works) sensors to work in there.

Thank you Sergio. So you mean that I can buy OMAP Zoom target board  
with MT or OV sensor on it sooner or later? cool!

>
> You can find this tree on:
>
> http://dev.omapzoom.org/?p=saaguirre/linux-omap-camera.git;a=summary
>
> Checkout devel branch.
>
> That's my latest progress.

OK I'll try to look at the devel branch.
Cheers,

Nate

>
> Regards,
> Sergio
>>
>> - Tuukka
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

