Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8M5o43K005918
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 01:50:05 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8M5nqNF028849
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 01:49:53 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1308241fga.7
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 22:49:52 -0700 (PDT)
Message-ID: <48D731FC.8030103@gmail.com>
Date: Mon, 22 Sep 2008 07:49:48 +0200
From: "tomlohave@gmail.com" <tomlohave@gmail.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <52E25CB7BF4E483089A488BD33B01059@DadyPC>	
	<BLU121-DAV6F8BF57A7A953B8492CD6C2A60@phx.gbl>	
	<7E99B38C8E0743AC9433ADCFAE34BC40@DadyPC>	
	<BLU121-DAV23EF75E8170A0882139E5C2A60@phx.gbl>	
	<5DFFD9161FC443AFB5D747B0EFA48C1A@DadyPC>	
	<BLU121-DAV10925F9CFA27DB5428BD48C2A10@phx.gbl>	
	<AE5A9016310A49F9902FCA896F18CED1@DadyPC>	
	<BLU116-W707A6B2D87B90CC2FB50AC24E0@phx.gbl>
	<48D4FA9E.6000802@gmail.com>	
	<1221930905.2694.23.camel@pc10.localdom.local>	
	<BLU116-W32B0C75C2CC416FD664FBFC2480@phx.gbl>
	<1222039247.2671.14.camel@pc10.localdom.local>
In-Reply-To: <1222039247.2671.14.camel@pc10.localdom.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: dabby bentam <db260179@hotmail.com>, linux-dvb@linuxtv.org,
	Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [linux-dvb] FIXME: audio doesn't work on svideo/composite
 -	hvr-1110 S-Video and Composite
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

hermann pitton a écrit :
> Hi,
>
> Am Sonntag, den 21.09.2008, 19:12 +0000 schrieb dabby bentam: 
>   
>> Thanks for your assistant.
>>
>> Yes, that makes sense, as the TV sound can be turned on.
>>
>> I'll try your suggestions, changing the code to LINE1.
>>
>> Has anyone tried this - Mostly it is high (0x0200000) for the radio switch, only sometimes the
>>  other way round. Then you must set .gpio = 0x0200000 for the TV input
>>  with the same gpio_mask. < did you try this tom?
>>
>> Thanks to all, i will play around with this, hopefully get a result. Is there anyway to find the exact gpio mask?
>>
>> David
>>     
>
> please don't top post. I continue below.
>
>   
>> ----------------------------------------
>>     
>>> Subject: Re: [linux-dvb] FIXME: audio doesn't work on svideo/composite -	hvr-1110 S-Video and Composite
>>> From: hermann-pitton@arcor.de
>>> To: tomlohave@gmail.com
>>> CC: db260179@hotmail.com; linux-dvb@linuxtv.org; video4linux-list@redhat.com
>>> Date: Sat, 20 Sep 2008 19:15:05 +0200
>>>
>>> Hello,
>>>
>>> Am Samstag, den 20.09.2008, 15:29 +0200 schrieb tomlohave@gmail.com:
>>>       
>>>> dabby bentam a écrit :
>>>>         
>>>>> Hi Tom,
>>>>>
>>>>> Sorry to bother you like this in this way. I'm emailing because i have 
>>>>> a Wintv hvr-1110 card. In the kernel sources it has
>>>>>
>>>>> FIXME: audio doesn't work on svideo/composite
>>>>>
>>>>> Do you know what is required to get this to work?
>>>>>
>>>>> Can i help in getting this to work?
>>>>>
>>>>> Thanks for your time
>>>>>
>>>>> David Bentham
>>>>>
>>>>>           
>>>> Hi,
>>>>
>>>> first, sorry for my poor english
>>>>
>>>> No sorry not sure what to do, i've try many configurations and 
>>>> modifications in order to have svideo/composite audio but no result
>>>>
>>>> you can try different parameter (see in sources, take example on other 
>>>> cards)
>>>> or ask on linuxtv mailing list
>>>> I forward your precedant mail to this list
>>>>
>>>> Cheers
>>>>
>>>> Thomas
>>>>
>>>>         
>>> there are different models of the HVR-1110 we can see on
>>> hauppauge_eeprom down in saa7134-cards.c.
>>>
>>> Some don't even have analog audio in.
>>>
>>> In case it is there, if the current LINE2 stereo input pair doesn't
>>> work, then it is LINE1.
>>>
>>> If that still does not work, you can expect an external gpio driven mux
>>> chip on the board. On cards with analog audio out it can be fairly easy
>>> tested by unloading the driver. Default is then to loop the sound
>>> through to the analog output of the card to the soundcard, but with the
>>> driver unloaded you can't test, since you need saa7134-alsa for it
>>> without having analog audio out connected on the card.
>>>
>>> In that case regspy.exe from DScaler (deinterlace.sf.net) might help.
>>>
>>> A work around could be to plug the external analog sound directly into
>>> the sound card/chip and record from there.
>>>
>>> Was the radio ever tested? Since the tda8275ac1 has only one RF signal
>>> input pin and the card has two antenna connectors, we usually see that
>>> these inputs are switched on gpio21 including the AutoGainControl and
>>> using the 5.5MHz ceramic filter for radio input.
>>>
>>> See the other cards with TUNER_PHILIPS_TDA8290.
>>>
>>> Mostly it is high (0x0200000) for the radio switch, only sometimes the
>>> other way round. Then you must set .gpio = 0x0200000 for the TV input
>>> with the same gpio_mask.
>>>
>>>       
>
> For the TV versus radio switch the gpio mask is just 0x0200000.
>
> With this mask only gpio pin 21 will change.
>
> By default the driver will set it to 0, only for that input gpio =
> 0x0200000 is set in the card's config, it will change it to 1.
> (masked writes, "modinfo saa7134" gpio_tracking=1)
>
> If changing the amux to LINE1 doesn't help for s-video and composite,
> testing with saa7134-alsa there and say sox, then regspy might help.
>
> If you use the supplied m$ app, not DScaler, and save the logs for the
> card in status unused, TV, composite/s-video and radio, we will see the
> gpio mask in use there and likely changing gpio pins.
>
> They often have more pins in the mask and also more that change,
> but usually one of them will be what we need to add to the mask.
>
> It looks like manufacturers group their devices together with a gpio
> mask covering so far all of them, then subsets of devices do appear,
> which still do more changes on the pins, then for a specific single
> device would be needed.
>
> With a high granularity for each device, based on a doubtless and
> consistent eeprom detection, the gpio settings likely could be single
> device specific too, if wanted.
>
> But since we might see unrelated gpio changes there too, dunno, first of
> all make sure that amux LINE1 does not resolve the problem.
>
> Cheers,
> Hermann
>
>
>
>
>
>   
I remember that regspy shows nothing when i attempted to switch to 
svideo/composite.
i haven't got a pc with windows (only linux + freevo on it) so i can't 
do anything else for now.

Line1 doesn't work for me so it's why there is a FIXME in sources ....

Cheers,

Thomas.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
