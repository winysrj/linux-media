Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62818 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab3FTILR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 04:11:17 -0400
Received: from mailout-de.gmx.net ([10.1.76.31]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MJHUa-1UrDr70Fz8-002mJV for
 <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 10:11:15 +0200
Message-ID: <51C2B91F.3000305@gmx.net>
Date: Thu, 20 Jun 2013 10:11:11 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: EM28xx - MSI Digivox Trio - almost working.
References: <51C28FA2.70004@gmx.net> <51C2B1E7.9040408@iki.fi>
In-Reply-To: <51C2B1E7.9040408@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20-06-13 09:40, Antti Palosaari wrote:
> On 06/20/2013 08:14 AM, P. van Gaans wrote:
>> Hi all,
>>
>> (device: http://linuxtv.org/wiki/index.php/MSI_DigiVox_Trio)
>>
>> Thanks to the message from Philip Pemberton I was able to try loading
>> the em28xx driver myself using:
>>
>> sudo modprobe em28xx card=NUMBER
>> echo eb1a 2885 | sudo tee /sys/bus/usb/drivers/em28xx/new_id
>>
>> Here are the results for NUMBER:
>>
>> Card=79 (Terratec Cinergy H5): works, less corruption than card=87, just
>> some blocks every few seconds. Attenuators didn't help.
>> Card=81 (Hauppauge WinTV HVR 930C): doesn't work, no /dev/dvb adapter
>> Card=82 (Terratec Cinergy HTC Stick): similar to card=87
>> Card=85 (PCTV QuatroStick (510e)): constantly producing i2c read errors,
>> doesn't work
>> Card=86 (PCTV QuatroStick nano (520e): same
>> Card=87 (Terratec Cinergy HTC USB XS): stick works and scans channels,
>> but reception is bugged with corruption. It's like having a DVB-T
>> antenna that's just not good enough, except this is DVB-C and my signal
>> is excellent. Attenuators didn't help.
>> Card=88 (C3 Tech Digital Duo HDTV/SDTV USB): doesn't work, no /dev/dvb
>> adapter
>>
>> So with card=79 it's really close to working. What else can I do?
>
> Take USB sniffs, generate code, copy & paste that to the driver until it
> starts working. After it start working start reducing generated code.
> That way with trial and error you will find out problematic register(s)
> very quickly.
>
> There is suitable scripts to generate em28xx drx-k code from the sniffs,
> maybe in dvb-utils package. Mauro has done that script. I used it when I
> added PCTV 520e support (problem was bug in DRX-K GPIO code).
>
> regards
> Antti
>

Hi Antti,

Thanks for your answer. Do you mean I sniff on Windows or Linux? Would 
you happen to remember the name of the script you are referring to?

Also in em28xx-new (https://bitbucket.org/mdonoughe/em28xx-new/overview) 
the device was supported. Wouldn't it be easier to try and find the 
differences between the Cinergy H5 and the Digivox in that code, or 
should I not even think of going there?

Best regards,

P. van Gaans
