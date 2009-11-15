Return-path: <linux-media-owner@vger.kernel.org>
Received: from averell.mail.tiscali.it ([213.205.33.55]:42314 "EHLO
	averell.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZKONM2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 08:12:28 -0500
Message-ID: <4AFFFE3E.8040604@gmail.com>
Date: Sun, 15 Nov 2009 14:12:30 +0100
From: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
MIME-Version: 1.0
To: Douglas Schilling Landgraf <dougsland@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: No analog audio for the Empire Dual Pen: request for help and suggestions!!!
References: <4A79EC82.4050902@email.it>	<4A7AE0B0.20507@email.it>	<829197380908060717ua009e78nc045f2940c7fc76e@mail.gmail.com>	<20090806112317.21240b9c@gmail.com>	<4A7AF3CF.3060803@email.it>	<829197380908060821x6cfb60f0jd73e5f9b30c21569@mail.gmail.com>	<4A7B0333.1010901@email.it>	<4A81D38A.2050201@email.it>	<829197380908111334xf9a89b4gf2da1e4cc765b27b@mail.gmail.com>	<4A81E6C3.7010802@email.it>	<20090811154232.4ed8a1ba@gmail.com>	<4A81F5E1.9070709@email.it> <20090811160806.43a6dfd8@gmail.com> <4A827102.60806@email.it>
In-Reply-To: <4A827102.60806@email.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I would like to solve this analog audio issue (this device would be 
useful in the future thanks to the 9 pin s-video input which, I think 
can  take the output of an external dvb-t decoder so that to be able to 
see cripted digital tv or from consoles to play and use notebook display 
as a tv).
Following the (little) expertise gained with the Dikom DK300, I think 
that the default_analog gpio is not correct for the device.
Can I try with others gpio or a wrong gpio can phisically break the device?
Otherwise how can I create a correct gpio for this device?
Thank you,
Andrea (Xwang was my nickname)

xwang1976@email.it ha scritto:
> When you want we can check the audio issue.
> Consider that actually I've installed the latest main v4l-dvb (to test 
> if all the patches have been ported to themain tree) and it's ok. 
> However I have no problem to install your tree driver again to test 
> whatever is needed to have a fully functional device.
> Xwang
> 
> PS the device has also a s-video (9 pin) input. In case I can test it, 
> but I prefer to do that after the analog audio isssue has been solved
> 
> Douglas Schilling Landgraf ha scritto:
>> Hello Xwang,
>>
>> On Wed, 12 Aug 2009 00:51:13 +0200
>> xwang1976@email.it wrote:
>>
>>  
>>> I've used the rewrite_eeprom_v_1_4 which you send me 5 month ago when 
>>> the eprom got corrupted for the first time.
>>>     
>>
>> Great, now it's available at v4l-dvb tree.
>>
>> Anyway, now we need to check the audio issue.
>>
>> Thanks!
>> Douglas
>>
>>  
>>> Xwang
>>>
>>> Douglas Schilling Landgraf ha scritto:
>>>    
>>>> Hello Xwang,
>>>>
>>>> On Tue, 11 Aug 2009 23:46:43 +0200
>>>> xwang1976@email.it wrote:
>>>>
>>>>        
>>>>> Ok!
>>>>> I've restored the eprom and now it is recognised again.
>>>>>             
>>>> Just to confirm, did you the rewrite_eeprom tool?
>>>>
>>>>        
>>>>> The only not working part is analog tv audio which doesn't work
>>>>> even if I use the sox command.
>>>>>             
>>>> Ok.
>>>>
>>>>        
>>>>>> Douglas, in a few minutes I am leaving town for the next five
>>>>>> days. Can you help Xwang out to restore his eeprom content using
>>>>>> your tool?
>>>>>>                 
>>>> Sure Devin.
>>>>
>>>> Cheers,
>>>> Douglas
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-media" in the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>         
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>   
> 
