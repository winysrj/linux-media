Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3F9HToh028215
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 05:17:29 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3F9HF3w004357
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 05:17:15 -0400
Message-ID: <48047297.8030905@hni.uni-paderborn.de>
Date: Tue, 15 Apr 2008 11:17:11 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Jaime Velasco <jsagarribay@gmail.com>
References: <48030F6F.1040007@hni.uni-paderborn.de>
	<461039140804140420q1fcce3eexad090ce78e3e497e@mail.gmail.com>
In-Reply-To: <461039140804140420q1fcce3eexad090ce78e3e497e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: OmniVision OV9655 camera chip via soc-camera interface
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Jaime,

Jaime Velasco schrieb:
> Hello, Stefan,
>
> 2008/4/14, Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>:
>   
>> Hi,
>>
>>  I'm writing a driver for the OmniVision OV9655 camera chip connected to a
>> PXA270 processor. I based my work on the soc_camera interface, but I need
>> some additional gpios for reset and power_enable. What is the best way to
>> pass this information to the driver?
>>
>>     
>
> I don't know about soc_camera, but the stkwebcam driver has code to drive
> the ov9650 sensors. I'd like to use some generic interface in it, instead of the
> current code. IIRC, Mauro suggested v4l2-int-device when the driver
> was submitted.
> Do you think your work could be used by stkwebcam? note that I don't know much
> about the syntek camera controller, and stkwebcam is a reverse
> engineered driver.
>   
I use the soc_camera interface, because I can reused the pxa_camera 
driver. If we want to use the same driver for the stkwebcam, we have to 
implement a generic interface for the register access and split the 
OV9655 driver or a i2c bus driver for the syntek camera controller.
> Anyway, maybe the code in drivers/media/video/stk-sensor.c is useful for you, so
> feel free to use it if you want.
>
> Regards,
> Jaime
>   
Thanks
    Stefan

-- 
Dipl.-Ing. Stefan Herbrechtsmeier

Heinz Nixdorf Institute
University of Paderborn 
System and Circuit Technology 
Fürstenallee 11
D-33102 Paderborn (Germany)

office : F0.415
phone  : + 49 5251 - 60 6342
fax    : + 49 5251 - 60 6351

mailto : hbmeier@hni.upb.de

www    : http://wwwhni.upb.de/sct/mitarbeiter/hbmeier


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
