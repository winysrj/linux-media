Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:42296 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0DRE5d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Apr 2010 00:57:33 -0400
Received: by bwz25 with SMTP id 25so4355174bwz.28
        for <linux-media@vger.kernel.org>; Sat, 17 Apr 2010 21:57:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8103ad501001240056k62cc7628sb767e01ade13d783@mail.gmail.com>
References: <3f3a053b1001021407k6ce936b8gd7d3e575a25e734d@mail.gmail.com>
	 <846899811001100728x27eaf4faqd83373dd16ef58d3@mail.gmail.com>
	 <4B4A0C95.5000804@sgtwilko.f9.co.uk>
	 <1a297b361001221531q4a2726ecm5952379c6ef08182@mail.gmail.com>
	 <8103ad501001231345l24316554j12c7a45de58f7f3b@mail.gmail.com>
	 <1a297b361001231543g7bde6ac8qc6e8048173f07492@mail.gmail.com>
	 <8103ad501001232349h24377ef8j9a052f69d0d4da55@mail.gmail.com>
	 <1a297b361001240012t3d11d555t5e03c95178aceced@mail.gmail.com>
	 <8103ad501001240054s4e6b8863o813b7b56c0bfa847@mail.gmail.com>
	 <8103ad501001240056k62cc7628sb767e01ade13d783@mail.gmail.com>
Date: Sun, 18 Apr 2010 05:57:29 +0100
Message-ID: <x2oa413d4881004172157g3c69b7aegb9ad54f8648c3de0@mail.gmail.com>
Subject: Re: CI USB
From: Another Sillyname <anothersname@googlemail.com>
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24 January 2010 09:56, Konstantin Dimitrov <kosio.dimitrov@gmail.com> wrote:
> On Sun, Jan 24, 2010 at 10:54 AM, Konstantin Dimitrov
> <kosio.dimitrov@gmail.com> wrote:
>> On Sun, Jan 24, 2010 at 10:12 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>>> On Sun, Jan 24, 2010 at 11:49 AM, Konstantin Dimitrov
>>> <kosio.dimitrov@gmail.com> wrote:
>>>> On Sun, Jan 24, 2010 at 1:43 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>>>>> On Sun, Jan 24, 2010 at 1:45 AM, Konstantin Dimitrov
>>>>> <kosio.dimitrov@gmail.com> wrote:
>>>>>> On Sat, Jan 23, 2010 at 1:31 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>>>>>>> On Sun, Jan 10, 2010 at 9:21 PM, Ian Wilkinson <null@sgtwilko.f9.co.uk> wrote:
>>>>>>>> HoP wrote:
>>>>>>>>
>>>>>>>> I don't know the details into the USB device, but each of those CAM's
>>>>>>>> have bandwidth limits on them and they vary from one CAM to the other.
>>>>>>>> Also, there is a limit on the number of simultaneous PID's that which
>>>>>>>> you can decrypt.
>>>>>>>>
>>>>>>>> Some allow only 1 PID, some allow 3. Those are the basic CAM's for
>>>>>>>> home usage.The most expensive CAM's allow a maximum of 24 PID's. But
>>>>>>>>
>>>>>>>>
>>>>>>>> You, of course, ment number of descramblers not PIDS because it is evident
>>>>>>>> that getting TV service descrambled, you need as minimum 2 PIDS for A/V.
>>>>>>>>
>>>>>>>> Anyway, it is very good note. Users, in general, don't know about it.
>>>>>>>>
>>>>>>>
>>>>>>> If it is using a CI+ plus chip (I heard from someone that it is a CI+
>>>>>>> chip inside) :
>>>>>>> http://www.smardtv.com/index.php?page=ciplus
>>>>>>>
>>>>>>> After reading the CI+ specifications, I doubt that it can be supported
>>>>>>> under Linux with open source support, without a paired decoder
>>>>>>> hardware or software decoder. A paired open source software decoder
>>>>>>> seems highly unlikely, as the output of the CI+ module is eventually
>>>>>>> an encrypted stream which can be descrambled with the relevant keys.
>>>>>>> The TS is not supposed to be stored on disk, or that's what the whole
>>>>>>> concept is for CI+
>>>>>>>
>>>>>>> http://www.ci-plus.com/data/ci-plus_overview_v2009-07-06.pdf
>>>>>>>
>>>>>>> See pages 7, 8 , 12, 15
>>>>>>>
>>>>>>> It could be possible to pair a software decoder with a key and hence
>>>>>>> under Windows, but under Linux I would really doubt it, if it happens
>>>>>>> to be a CI+ chip
>>>>>>
>>>>>> at least in Windows Hauppage WinTV-CI USB (which is OEM version of
>>>>>> SmartDTV USB CI) allows you to capture the decrypted stream to your
>>>>>> hard drive (i've just tested it).
>>>>>
>>>>>
>>>>> Maybe it is not CI+ itself in the first place
>>>>>
>>>>>
>>>>>> so, i can't see a reason why even if it has CI+ chip inside same
>>>>>> functionally as in Windows can't be provided in Linux if someone
>>>>>> developed a driver.
>>>>>
>>>>>
>>>>> It would be interesting to know what chips the hardware has  ...
>>>>
>>>> i can confirm the information here:
>>>>
>>>> * http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-CI
>>>>
>>>> and it contains:
>>>>
>>>> * "an FX2 from Cypress (CY7C68013A) and a FPGA (Actel Proasic-plus, APA075-F)"
>>>>
>>>
>>>
>>> No CI+ in there ... Generic USB bridge with microcontroller and
>>> possibly a FPGA programmed by Hauppauge themselves, most probably. The
>>
>> no, the whole Hauppauge device is actually made by SmartDTV even on
>> the board there is a title "SmartDTV Rev..."
>>
>> also, Terratec device is the same as Hauppauge device, they even look the same:
>>
>> http://www.terratec.net/en/products/Cinergy_CI_USB_2296.html
>>
>> and Terratec driver for Windows says "Copyright SmarDTV.", which means
>> it's made by SmarDTV.
>>
>> actually, Terratec driver for Windows is essentially the same as
>> Hauppauge one, because firmware extracted from both drivers is the
>> same (they update the firmware with driver updates, so matching
>> versions of Terratec and Hauppauge driver is needed to check that the
>> firmwares are the same).
>>
>>> bridge would be similar to other DVB USB devices, Application on the
>>> FPGA would be more or less similar to the one found on general DVB CI
>>> devices.
>>>
>>> If it's not a Masked FPGA, it would need to load it's instructions
>>> some place, maybe an EEPROM or maybe from the firmware that you need
>>> load itself. Some part of the firmware that you load could be partly
>>> for the microcontroller on the USB bridge as well.
>>
>> i believe that "40 A3" firmware requests are for the USB controller
>
> typo, "40 A0" firmware requests are for the USB controller
>
>> and then the subsequent "40 A3" firmware requests are to load the FPGA
>> instructions through the USB controller.
>>
>>>
>>>
>>> Manu
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

According to this page

http://www.bsc-bvba.be/linux/dvb/

the firmware load problem was solved about a month ago

What is needed in the way of resources to solve this problem?

Regards
