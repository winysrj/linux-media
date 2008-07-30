Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6U8w2pU009031
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 04:58:03 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6U8vonZ003314
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 04:57:51 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KO7VC-0002NA-AM
	for video4linux-list@redhat.com; Wed, 30 Jul 2008 08:57:46 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 08:57:46 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 08:57:46 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Wed, 30 Jul 2008 11:57:35 +0300
Message-ID: <48902CFF.9020204@teltonika.lt>
References: <48030F6F.1040007@hni.uni-paderborn.de>	<Pine.LNX.4.64.0804142224570.5332@axis700.grange>	<480477BD.5090900@hni.uni-paderborn.de>	<Pine.LNX.4.64.0804151228370.5159@axis700.grange>	<481ADED1.8050201@hni.uni-paderborn.de>	<Pine.LNX.4.64.0805021143250.4920@axis700.grange>	<481AF6CA.9030505@hni.uni-paderborn.de>	<Pine.LNX.4.64.0805021314510.4920@axis700.grange>	<481AFB30.5070508@hni.uni-paderborn.de>	<481B3D2F.80203@hni.uni-paderborn.de>	<Pine.LNX.4.64.0805022059090.31894@axis700.grange>	<481F0BFA.7010306@hni.uni-paderborn.de>	<Pine.LNX.4.64.0807291909510.17188@axis700.grange>	<48902011.7020609@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0807301005520.26534@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0807301005520.26534@axis700.grange>
Cc: 
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

Guennadi Liakhovetski wrote:
> Hi Stefan,
> 
> On Wed, 30 Jul 2008, Stefan Herbrechtsmeier wrote:
> 
>> Guennadi Liakhovetski schrieb:
>>> On Mon, 5 May 2008, Stefan Herbrechtsmeier wrote:
>>>   
>>>> Guennadi Liakhovetski schrieb:
>>>>     
>>>>> So, I would say, patches 1 and 3 look useful to me. Please fix
>>>>> formatting
>>>>> issues, add your Signed-off-by and submit in two separate emails.
>>>>>         
>>>> At the moment I update my system to the 2.6.25 kernel. When everything
>>>> works
>>>> fine, I submit the reworked
>>>> patches the next days.
>>> How is this going? Do you have your patches ready? We have a few patches
>>> brewing from sveral people, that touch the same code as yours, so, it would
>>> be good to have your "move .power, .reset to camera-link" patch applied,
>>> then we could move on with the others.
>>>   
>> Sorry for the long delay. I�m waiting for some answer form OmniVision if I�m
>> allowed to publish my current version of the OV9655 driver or whether
>> something violent the NDA.
> 
> Yes, this is an interesting question...
> 
>> Should I resend my "move .power, .reset to camera-link" patch without the
>> driver or waiting until I can send my OV9655 driver? At the moment there is no
>> driver which uses this.
> 
> I think, yes, it would be useful to move .reset and .power now, as I said, 
> I keep telling people "please keep in mind these fields are going to 
> move", so, we shall really finally move them:-)

I am waiting for this also! Add me to the list :)
Currently I have mclk parameter for camera host driver... And I have to
set it frequently since I am playing with couple different sensors...

>> I have also implement some simple timeperframe configuration (vidioc_s_parm)
>> via clock PLL and divider configuration in OV9655 driver, but only with a fix
>> mclk_10khz of 2600.
> 
> Good! If this is ov9655-specific, let's wait until you're allowed to 
> submit your patch:-)
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
