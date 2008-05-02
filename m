Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m429VF8R002800
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 05:31:15 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m429UwMp004898
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 05:30:58 -0400
Received: from [131.234.87.115] by mail.uni-paderborn.de with esmtpsa
	(TLS-1.0:DHE_RSA_AES_256_CBC_SHA:32) (Exim 4.62 cyclopia)
	id 1JrrbU-0006uN-Au
	for video4linux-list@redhat.com; Fri, 02 May 2008 11:30:57 +0200
Message-ID: <481ADF4F.9030208@hni.uni-paderborn.de>
Date: Fri, 02 May 2008 11:30:55 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
CC: video4linux-list@redhat.com
References: <48030F6F.1040007@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804142224570.5332@axis700.grange>
	<480477BD.5090900@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804151228370.5159@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0804151228370.5159@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
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

Sorry for the late answers, but first I want to get my ov9655 driver 
work prober.

Guennadi Liakhovetski schrieb:
> On Tue, 15 Apr 2008, Stefan Herbrechtsmeier wrote:
>
>  
>> Guennadi Liakhovetski schrieb:
>>    
>>> Look in pxa_camera.c, e.g., in pxa_camera_activate. There are 
>>> function calls
>>> like
>>>
>>> pxa_camera_activate(struct pxa_camera_dev *pcdev)
>>> {
>>>     struct pxacamera_platform_data *pdata = pcdev->pdata;
>>>
>>> ...
>>>
>>>     pdata->power(pcdev->dev, 1);
>>>
>>> ...
>>>
>>>     pdata->reset(pcdev->dev, 1);
>>>
>>> in it, which should do exactly what you need. And they are supposed 
>>> to be
>>> implemented in the platform, so, you have all the required GPIO 
>>> information
>>> you need there. That is exactly the reason they are defined that way -
>>> because they were thought to be platform-dependent. Let me know if 
>>> there's
>>> still anything missing. It is still a work in progress, so, we are 
>>> flexible
>>> and can add any (reasonable) APIs we find useful.
>>>         
>> Thanks, that exact what I search, but maybe this functions should be 
>> in the
>> soc_camera_link. I think this functions belong to the camera chip and 
>> not to
>> the capture interface. This allows more than one camera chip on one 
>> capture
>> interface with separate enable and reset.
>>     
>
> Well, in principle, yes, I think this is a good idea. But:
>
> 1. ATM these functions are called from the camera-host (pxa-camera) 
> driver. And until now it knew nothing about soc_camera_link. Which is 
> also good.
>
>    a) If we want to keep calls to these functions in the camera-host 
> driver, we'll either have to let it also handle soc_camera_link, or 
> introduce some parameter to these functions to tell the platform which 
> camera shall be resetted / powered on or off.
>
>    b) Alternatively, we could call these functions from soc_camera_ops 
> init() and release() methods. Actually, I think, this would be the 
> best option.
>   
This means moving the init() and reset() functions into the 
soc_camera_link. Is this right?
> 2. Do you have a real-life example with several cameras on one 
> interface? ATM pxa_camera is explicitely limited to handle only one 
> camera on its quick capture interface. You would have to lift that 
> restriction too.
>   
Not at the moment.

I have some addition suggestion for the soc_camera interface:

1. Renaming SOCAM_HSYNC_* to SOCAM_HREF_*
I think the current used Signal is HREF and not HSYNC.
- HREF is active during valid pixels
- HSYNC is a impulse at the start of each line before valid pixels and 
need some pixel skipping.

2. Add a new SOCAM_HSYNC_* to the soc_camera interface

3. Add x_skip_left to soc_camera_device
The pxa_camera has to skip some pixel at the begin of each line if a 
HSYNC signal is used.
(y_skip_top and x_skip_left can change with each format adjustment!)

4. Remove camera_init() call before camera_probe()
I think the driver should first detect the hardware before it do 
something with it.
The first hardware initialization should be done in the probe function.

Regards,
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
