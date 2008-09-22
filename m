Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8MB42eL029438
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 07:04:02 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8MB3sh1002726
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 07:03:54 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1395092fga.7
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 04:03:53 -0700 (PDT)
Message-ID: <48D77B96.8040905@gmail.com>
Date: Mon, 22 Sep 2008 13:03:50 +0200
From: "tomlohave@gmail.com" <tomlohave@gmail.com>
MIME-Version: 1.0
To: David Bentham <db260179@hotmail.com>
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
	<48D731FC.8030103@gmail.com>
	<BLU116-DAV1209DB800CB39607C15C4AC24B0@phx.gbl>
In-Reply-To: <BLU116-DAV1209DB800CB39607C15C4AC24B0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>, linux-dvb@linuxtv.org
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

David Bentham a écrit :
>   
>>>>>         
>>>>>           
>>>> there are different models of the HVR-1110 we can see on
>>>> hauppauge_eeprom down in saa7134-cards.c.
>>>>
>>>> Some don't even have analog audio in.
>>>>
>>>> In case it is there, if the current LINE2 stereo input pair doesn't
>>>> work, then it is LINE1.
>>>>
>>>>         
>
>   
>> By default the driver will set it to 0, only for that input gpio =
>> 0x0200000 is set in the card's config, it will change it to 1.
>> (masked writes, "modinfo saa7134" gpio_tracking=1)
>>
>> If changing the amux to LINE1 doesn't help for s-video and composite,
>> testing with saa7134-alsa there and say sox, then regspy might help.
>>
>> If you use the supplied m$ app, not DScaler, and save the logs for the
>> card in status unused, TV, composite/s-video and radio, we will see the
>> gpio mask in use there and likely changing gpio pins.
>>
>> They often have more pins in the mask and also more that change,
>> but usually one of them will be what we need to add to the mask.
>>
>> It looks like manufacturers group their devices together with a gpio
>> mask covering so far all of them, then subsets of devices do appear,
>> which still do more changes on the pins, then for a specific single
>> device would be needed.
>>
>> With a high granularity for each device, based on a doubtless and
>> consistent eeprom detection, the gpio settings likely could be single
>> device specific too, if wanted.
>>
>> But since we might see unrelated gpio changes there too, dunno, first of
>> all make sure that amux LINE1 does not resolve the problem.
>>
>> Cheers,
>> Hermann
>>
>>
>>
>>
>>
>>   
>> I remember that regspy shows nothing when i attempted to switch to 
>> svideo/composite.
>> i haven't got a pc with windows (only linux + freevo on it) so i can't 
>> do anything else for now.
>>     
>
>   
>> Line1 doesn't work for me so it's why there is a FIXME in sources ....
>>     
>
>   
>> Cheers,
>>     
>
>   
>> Thomas.
>>     
>
> Hopefully running regspy will tell me more. Can I send the dump logs here?,
> hopefully you can give me some key pointers?
>
> I'll Try several actions to see what if anything, will arise from it.
>   
You can try here :
http://sourceforge.net/project/downloading.php?groupname=deinterlace&filename=DScaler4115.exe&use_mirror=heanet

regspy is included in DScaler

Post your log here

Cheers,
Thomas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
