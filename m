Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:60982 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZBTTFM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 14:05:12 -0500
Message-ID: <499EFEE4.50306@kaiser-linux.li>
Date: Fri, 20 Feb 2009 20:05:08 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
CC: Jean-Francois Moine <moinejf@free.fr>,
	Kyle Guinn <elyk03@gmail.com>, linux-media@vger.kernel.org
Subject: Re: MR97310A and other image formats
References: <20090217200928.1ae74819@free.fr> <alpine.LNX.2.00.0902182305300.6388@banach.math.auburn.edu> <499DB030.7010206@kaiser-linux.li> <alpine.LNX.2.00.0902191502380.7303@banach.math.auburn.edu> <499DE107.80502@kaiser-linux.li> <alpine.LNX.2.00.0902191723380.7472@banach.math.auburn.edu> <499DFEBF.9020601@kaiser-linux.li> <alpine.LNX.2.00.0902191913320.7602@banach.math.auburn.edu> <499E6305.7020707@kaiser-linux.li> <alpine.LNX.2.00.0902201234090.8350@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0902201234090.8350@banach.math.auburn.edu>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kilgota@banach.math.auburn.edu wrote:
> 
> 
> On Fri, 20 Feb 2009, Thomas Kaiser wrote:
> 
>> kilgota@banach.math.auburn.edu wrote:
>>>
>>>
>>> On Fri, 20 Feb 2009, Thomas Kaiser wrote:
>>>
>>>> kilgota@banach.math.auburn.edu wrote:
>>>>>
>>>>>
>>>>> On Thu, 19 Feb 2009, Thomas Kaiser wrote:
>>>>>
>>>>>> kilgota@banach.math.auburn.edu wrote:
>>>>>>> Yes, what you quote is the SOF marker for all of these cameras. 
>>>>>>> The total header length, including the SOF marker ought to be 12 
>>>>>>> bytes. On all of the mr97310 cameras that I have dealt with, the 
>>>>>>> last 5 bytes are obviously related somehow to the image 
>>>>>>> (contrast, color balance, gamma, whatever).  I have no idea how 
>>>>>>> to interpret those values, but we can hope
>>>>>>> that someone will figure out how.
>>>>>>
>>>>>> Two of them are luminance values (middle and edge) for the PAC207.
>>>>>
>>>>> Which two, and how do those numbers translate into anything relevant?
>>>>
>>>> Looks like I had some off list (private) email conversation about 
>>>> the frame header of PAC207 with Michel Xhaard. I just paste the 
>>>> whole thing in here:
>>>>
>>>> michel Xhaard wrote:
>>>>> Le Samedi 18 Fe'vrier 2006 12:16, vous avez e'crit :
>>>>>
>>>>>> michel Xhaard wrote:
>>>>>>
>>>>>>> Le Samedi 18 Fe'vrier 2006 10:10, vous avez e'crit :
>>>>>>>
>>>>>>>> Hello Michel
>>>>>>>>
>>>>>>>> michel Xhaard wrote:
>>>>>>>>
>>>>>>>>> Le Mercredi 15 Fe'vrier 2006 12:43, vous avez e'crit :
>>>>>>>>> Just relook the snoop, the header is always 16 bytes long starting 
>>>> with:
>>>>>>>>> ff ff 00 ff 96 64 follow
>>>>>>>>> xx 00 xx xx xx xx  64 xx 00 00
>>>>>>>>> let try to play poker with the asumption the R mean G0 mean B 
>>>>>>>>> mean G1
>>>>>>>>> mean is encoded here.
>>>>>>>>> Not sure about the 64 can you look at your snoop?
>>>>>>>>
>>>>>>>> I never thought about that. So, you see I have not experience with
>>>>>>>> webcams.
>>>>>>>>
>>>>>>>> Anyway, here are my observations about the header:
>>>>>>>> In the snoop, it looks a bit different then yours
>>>>>>>>
>>>>>>>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx 00 00
>>>>>>>> 1. xx: looks like random value
>>>>>>>> 2. xx: changed from 0x03 to 0x0b
>>>>>>>> 3. xx: changed from 0x06 to 0x49
>>>>>>>> 4. xx: changed from 0x07 to 0x55
>>>>>>>> 5. xx: static 0x96
>>>>>>>> 6. xx: static 0x80
>>>>>>>> 7. xx: static 0xa0
>>>>>>>>
>>>>>>>> And I did play in Linux and could identify some fields :-) .
>>>>>>>> In Linux the header looks like this:
>>>>>>>>
>>>>>>>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx F0 00
>>>>>>>> 1. xx: don't know but value is changing between 0x00 to 0x07
>>>>>>>> 2. xx: this is the actual pixel clock
>>>>>>>> 3. xx: this is changing according light conditions from 0x03 
>>>>>>>> (dark) to
>>>>>>>> 0xfc (bright)
>>>>>>>> 4. xx: this is changing according light conditions from 0x03 
>>>>>>>> (dark) to
>>>>>>>> 0xfc (bright)
>>>>>>>> 5. xx: set value "Digital Gain of Red"
>>>>>>>> 6. xx: set value "Digital Gain of Green"
>>>>>>>> 7. xx: set value "Digital Gain of Blue"
>>>>>>>>
>>>>>>>> Regards, Thomas
>>>>>>>
>>>>>>> Thomas,
>>>>>>> Cool good works :) so 3 and 4 are good candidate . To get good 
>>>>>>> picture
>>>>>>> result there are 2 windows where the chips measure the ligth 
>>>>>>> condition.
>>>>>>> Generally one is set to the center of the image the other are set 
>>>>>>> to get
>>>>>>> the background light. At the moment my autobrightness setting 
>>>>>>> used simple
>>>>>>> code and only one windows of measurement (the center one) .
>>>>>>
>>>>>> Some more info, 3 is the center one.
>>>>>
>>>>> :)
>>>>>
>>>>>>> Did you want i try to implement these feature ? or maybe you can 
>>>>>>> have a
>>>>>>> try :) the only problem i see is between interrupt() context and 
>>>>>>> process
>>>>>>> context. I have set up a spinlock for that look at the code how 
>>>>>>> to use it
>>>>>>> ( spca5xx_move_data() )
>>>>>>
>>>>>> Yes, please. Because I have no idea how to do this :-(
>>>>>> I am good in investigating :-)
>>>>>
>>>>> I know, but can be very good in code to, as you know the hardware 
>>>>> :) now 
>>>> let try to look at 1
>>>>                         ^^ What does this mean?
>>>>> is there the black luma level ?
>>>> I don't get it. What is the black luma level?
>>>>
>>>> Regards, Thomas
>>>>
>>>>
>>>> -- 
>>>> http://www.kaiser-linux.li
>>>>
>>>>
>>>>> By any chance, you do not have a JL2005B or JL2005C or JL2005D 
>>>>> camera among them, do you? AFAICT they all use the same compression 
>>>>> algorithm (in stillcam mode), and it appears to me to be a really 
>>>>> nasty one. Any help I could get with that algorithm is welcome indeed.
>>>>
>>>> I have to check. Please send me the USB ID.
>>>
>>>     0x0979 is the Vendor ID from Jeilin.
>>>     0x0227 is the Product ID of the JL2005B/C/D cameras
>>>     (yes, all three of them have the same ID)
>>>>
>>>> Thomas
>>>
>>> Thanks for the information. But this is an old letter. What is 
>>> happening with Michel Xhaard these days? Do you know? I miss him.
>>
>> Yes, I know it is an old letter, but these info are still valid for 
>> the PAC207 chipset!
>>
>> I don't know what happened to Michel. I didn't exchange mails with him 
>> for a long time.
> 
> I believe you that the information is valid. The comment about the age 
> of the letter related to the fact that I have not heard from Michel for 
> approximately that long, myself. As to the information, though, what I 
> would really like to see is a collection started which lists the known 
> compression algorithms for the PAC family and, at least, their code 
> bytes. So far, we have 0x00 (no compression) and 0x20, 0x50, 0xd0, and 
> what else? For example, what is the next byte after the FF FF 00 FF 96 
> for the PAC207? That would probably be good to know, but if anyone has 
> recorded that information I have missed it.
> 
> Theodore Kilgore

Hello Theodore

At this time I wrote this letter, I had a lot of email conversation with 
  Michel. I got a cam with PAC207 chip and he got an other some weeks 
later. Together, we could implement the PAC207 into spca5xx -> gspca.

For the next byte after FF FF 00 FF 96:
FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx F0 00
1. xx: don't know but value is changing between 0x00 to 0x07

As far as I can remember (at the time I did this), the cam did 
compresses sometimes and sometimes not during streaming.

So, I guess 0x07 means a compressed PAC207 frame!?

Actually, I got some frames where some lines were compressed and the 
rest was raw. The line marker tells you if the line is compressed or 
not. So, it doesn't make a lot of sense to send this information in the 
frame header. But may be 0x07 means "you can get compressed lines"?

Thomas
