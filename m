Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3F9dRQ3005869
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 05:39:27 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3F9dCLu018548
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 05:39:13 -0400
Message-ID: <480477BD.5090900@hni.uni-paderborn.de>
Date: Tue, 15 Apr 2008 11:39:09 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <48030F6F.1040007@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804142224570.5332@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0804142224570.5332@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Guennadi Liakhovetski schrieb:
> On Mon, 14 Apr 2008, Stefan Herbrechtsmeier wrote:
>
>   
>> I'm writing a driver for the OmniVision OV9655 camera chip connected to a
>> PXA270 processor. I based my work on the soc_camera interface, but I need some
>> additional gpios for reset and power_enable. What is the best way to pass this
>> information to the driver?
>>     
>
> Look in pxa_camera.c, e.g., in pxa_camera_activate. There are function calls like
>
> pxa_camera_activate(struct pxa_camera_dev *pcdev)
> {
> 	struct pxacamera_platform_data *pdata = pcdev->pdata;
>
> ...
>
> 	pdata->power(pcdev->dev, 1);
>
> ...
>
> 	pdata->reset(pcdev->dev, 1);
>
> in it, which should do exactly what you need. And they are supposed to be 
> implemented in the platform, so, you have all the required GPIO 
> information you need there. That is exactly the reason they are defined 
> that way - because they were thought to be platform-dependent. Let me know 
> if there's still anything missing. It is still a work in progress, so, we 
> are flexible and can add any (reasonable) APIs we find useful.
>   
Thanks, that exact what I search, but maybe this functions should be in 
the soc_camera_link. I think this functions belong to the camera chip 
and not to the capture interface. This allows more than one camera chip 
on one capture interface with separate enable and reset.
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
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
