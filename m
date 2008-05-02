Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42BBkpk019797
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 07:11:46 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m42BBAHX026883
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 07:11:11 -0400
Message-ID: <481AF6CA.9030505@hni.uni-paderborn.de>
Date: Fri, 02 May 2008 13:11:06 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <48030F6F.1040007@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804142224570.5332@axis700.grange>
	<480477BD.5090900@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804151228370.5159@axis700.grange>
	<481ADED1.8050201@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021143250.4920@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0805021143250.4920@axis700.grange>
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
> On Fri, 2 May 2008, Stefan Herbrechtsmeier wrote:
>
>   
>> Guennadi Liakhovetski schrieb:
>>     
>>> 1. ATM these functions are called from the camera-host (pxa-camera) driver.
>>> And until now it knew nothing about soc_camera_link. Which is also good.
>>>
>>>    a) If we want to keep calls to these functions in the camera-host driver,
>>> we'll either have to let it also handle soc_camera_link, or introduce some
>>> parameter to these functions to tell the platform which camera shall be
>>> resetted / powered on or off.
>>>
>>>    b) Alternatively, we could call these functions from soc_camera_ops
>>> init() and release() methods. Actually, I think, this would be the best
>>> option.
>>>   
>>>       
>> This means moving the init() and reset() functions into the soc_camera_link.
>> Is this right?
>>     
>
> Yes.
>
>   
>>> 2. Do you have a real-life example with several cameras on one interface?
>>> ATM pxa_camera is explicitely limited to handle only one camera on its quick
>>> capture interface. You would have to lift that restriction too.
>>>   
>>>       
>> Not at the moment.
>>
>> I have some addition suggestion for the soc_camera interface:
>>
>> 1. Renaming SOCAM_HSYNC_* to SOCAM_HREF_*
>> I think the current used Signal is HREF and not HSYNC.
>> - HREF is active during valid pixels
>> - HSYNC is a impulse at the start of each line before valid pixels and need
>> some pixel skipping.
>>
>> 2. Add a new SOCAM_HSYNC_* to the soc_camera interface
>>
>> 3. Add x_skip_left to soc_camera_device
>> The pxa_camera has to skip some pixel at the begin of each line if a HSYNC
>> signal is used.
>> (y_skip_top and x_skip_left can change with each format adjustment!)
>>     
>
> How and why shall they change?
>   
They shall change to support both signal types and to make the names and 
function clear. The OmniVision chips
support both types and you can configure the VSYNC pin. At the moment I 
used SOCAM_HSYNC_*
but configure the chip to use HREF to work without pixel skipping.
>   
>> 4. Remove camera_init() call before camera_probe()
>> I think the driver should first detect the hardware before it do something
>> with it.
>> The first hardware initialization should be done in the probe function.
>>     
>
> What camera_init do you mean? If you mean the ->add() call in 
> soc_camera_open() then it is needed to activate the interface.
>   
I mean the ->add() call in soc_camera_probe(). We first add the device 
and then probe. But I see
the problem with the external clock activation, witch it possibly need 
for probing.
> As usual, patches are welcome. When we see the code we can discuss it in 
> detail.
>   
I try to post some patches, but it's the first time for me.

Regards
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
