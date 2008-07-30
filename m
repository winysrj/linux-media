Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6U9YVrE031745
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 05:34:31 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6U9Xqpu025510
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 05:33:53 -0400
Message-ID: <4890357C.7050306@hni.uni-paderborn.de>
Date: Wed, 30 Jul 2008 11:33:48 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <48030F6F.1040007@hni.uni-paderborn.de>	<Pine.LNX.4.64.0804142224570.5332@axis700.grange>	<480477BD.5090900@hni.uni-paderborn.de>	<Pine.LNX.4.64.0804151228370.5159@axis700.grange>	<481ADED1.8050201@hni.uni-paderborn.de>	<Pine.LNX.4.64.0805021143250.4920@axis700.grange>	<481AF6CA.9030505@hni.uni-paderborn.de>	<Pine.LNX.4.64.0805021314510.4920@axis700.grange>	<481AFB30.5070508@hni.uni-paderborn.de>	<481B3D2F.80203@hni.uni-paderborn.de>	<Pine.LNX.4.64.0805022059090.31894@axis700.grange>	<481F0BFA.7010306@hni.uni-paderborn.de>	<Pine.LNX.4.64.0807291909510.17188@axis700.grange>	<48902011.7020609@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0807301005520.26534@axis700.grange>
	<48902CFF.9020204@teltonika.lt>
In-Reply-To: <48902CFF.9020204@teltonika.lt>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: Re: [PATCH] Some suggestions for the soc_camera interface
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

Paulius Zaleckas schrieb:
> Guennadi Liakhovetski wrote:
>> Hi Stefan,
>>
>> On Wed, 30 Jul 2008, Stefan Herbrechtsmeier wrote:
>>
>>> Guennadi Liakhovetski schrieb:
>>>> On Mon, 5 May 2008, Stefan Herbrechtsmeier wrote:
>>>>  
>>>>> Guennadi Liakhovetski schrieb:
>>>>>    
>>>>>> So, I would say, patches 1 and 3 look useful to me. Please fix
>>>>>> formatting
>>>>>> issues, add your Signed-off-by and submit in two separate emails.
>>>>>>         
>>>>> At the moment I update my system to the 2.6.25 kernel. When 
>>>>> everything
>>>>> works
>>>>> fine, I submit the reworked
>>>>> patches the next days.
>>>> How is this going? Do you have your patches ready? We have a few 
>>>> patches
>>>> brewing from sveral people, that touch the same code as yours, so, 
>>>> it would
>>>> be good to have your "move .power, .reset to camera-link" patch 
>>>> applied,
>>>> then we could move on with the others.
>>>>   
>>> Sorry for the long delay. I’m waiting for some answer form 
>>> OmniVision if I’m
>>> allowed to publish my current version of the OV9655 driver or whether
>>> something violent the NDA.
>>
>> Yes, this is an interesting question...
>>
>>> Should I resend my "move .power, .reset to camera-link" patch 
>>> without the
>>> driver or waiting until I can send my OV9655 driver? At the moment 
>>> there is no
>>> driver which uses this.
>>
>> I think, yes, it would be useful to move .reset and .power now, as I 
>> said, I keep telling people "please keep in mind these fields are 
>> going to move", so, we shall really finally move them:-)
>
> I am waiting for this also! Add me to the list :)
> Currently I have mclk parameter for camera host driver... And I have to
> set it frequently since I am playing with couple different sensors...
My current version only touch the soc_camera files. Should I change the 
mt9m001 and mt9v022 sensor to use the new functions?
>
>
>>> I have also implement some simple timeperframe configuration 
>>> (vidioc_s_parm)
>>> via clock PLL and divider configuration in OV9655 driver, but only 
>>> with a fix
>>> mclk_10khz of 2600.
>>
>> Good! If this is ov9655-specific, let's wait until you're allowed to 
>> submit your patch:-)
>>
>> Thanks
>> Guennadi
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>>
>> -- 
>> video4linux-list mailing list
>> Unsubscribe 
>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>

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
