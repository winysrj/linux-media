Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35523 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422Ab3FTIVP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 04:21:15 -0400
Message-ID: <51C2BB53.6080205@iki.fi>
Date: Thu, 20 Jun 2013 11:20:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "P. van Gaans" <w3ird_n3rd@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: EM28xx - MSI Digivox Trio - almost working.
References: <51C28FA2.70004@gmx.net> <51C2B1E7.9040408@iki.fi> <51C2B91F.3000305@gmx.net>
In-Reply-To: <51C2B91F.3000305@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/20/2013 11:11 AM, P. van Gaans wrote:
> On 20-06-13 09:40, Antti Palosaari wrote:
>> On 06/20/2013 08:14 AM, P. van Gaans wrote:
>>> Hi all,
>>>
>>> (device: http://linuxtv.org/wiki/index.php/MSI_DigiVox_Trio)
>>>
>>> Thanks to the message from Philip Pemberton I was able to try loading
>>> the em28xx driver myself using:
>>>
>>> sudo modprobe em28xx card=NUMBER
>>> echo eb1a 2885 | sudo tee /sys/bus/usb/drivers/em28xx/new_id
>>>
>>> Here are the results for NUMBER:
>>>
>>> Card=79 (Terratec Cinergy H5): works, less corruption than card=87, just
>>> some blocks every few seconds. Attenuators didn't help.
>>> Card=81 (Hauppauge WinTV HVR 930C): doesn't work, no /dev/dvb adapter
>>> Card=82 (Terratec Cinergy HTC Stick): similar to card=87
>>> Card=85 (PCTV QuatroStick (510e)): constantly producing i2c read errors,
>>> doesn't work
>>> Card=86 (PCTV QuatroStick nano (520e): same
>>> Card=87 (Terratec Cinergy HTC USB XS): stick works and scans channels,
>>> but reception is bugged with corruption. It's like having a DVB-T
>>> antenna that's just not good enough, except this is DVB-C and my signal
>>> is excellent. Attenuators didn't help.
>>> Card=88 (C3 Tech Digital Duo HDTV/SDTV USB): doesn't work, no /dev/dvb
>>> adapter
>>>
>>> So with card=79 it's really close to working. What else can I do?
>>
>> Take USB sniffs, generate code, copy & paste that to the driver until it
>> starts working. After it start working start reducing generated code.
>> That way with trial and error you will find out problematic register(s)
>> very quickly.
>>
>> There is suitable scripts to generate em28xx drx-k code from the sniffs,
>> maybe in dvb-utils package. Mauro has done that script. I used it when I
>> added PCTV 520e support (problem was bug in DRX-K GPIO code).
>>
>> regards
>> Antti
>>
>
> Hi Antti,
>
> Thanks for your answer. Do you mean I sniff on Windows or Linux? Would
> you happen to remember the name of the script you are referring to?
>
> Also in em28xx-new (https://bitbucket.org/mdonoughe/em28xx-new/overview)
> the device was supported. Wouldn't it be easier to try and find the
> differences between the Cinergy H5 and the Digivox in that code, or
> should I not even think of going there?
>
> Best regards,
>
> P. van Gaans

Download codes and look yourself. Also, I have added MaxMedia UB425-TC 
to that driver. You should test it too.

Basically there is not much critical that differs between those devices. 
GPIO is the most important. Also some dummy analog decoder init could be 
needed.

You have to take sniffs and compare those against drivers. There is not 
much I could do for you.

regards
Antti


-- 
http://palosaari.fi/
