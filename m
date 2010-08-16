Return-path: <mchehab@pedra>
Received: from mp1-smtp-5.eutelia.it ([62.94.10.165]:45651 "EHLO
	smtp.eutelia.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752774Ab0HPIoa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Aug 2010 04:44:30 -0400
Message-ID: <4C68FA61.1040305@gmail.com>
Date: Mon, 16 Aug 2010 10:44:17 +0200
From: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
MIME-Version: 1.0
To: Douglas Schilling Landgraf <dougsland@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Error building v4l
References: <4C664723.9070303@gmail.com> <AANLkTine4xDHhTqeEWUNypCc0t0MksUpKeLuFCJ+-EW-@mail.gmail.com>
In-Reply-To: <AANLkTine4xDHhTqeEWUNypCc0t0MksUpKeLuFCJ+-EW-@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Ok!
Now it works!
Thank you very much,
Xwang

Il 16/08/2010 04:59, Douglas Schilling Landgraf ha scritto:
> Hello,
>
> On Sat, Aug 14, 2010 at 3:34 AM, Andrea.Amorosi76@gmail.com
> <Andrea.Amorosi76@gmail.com>  wrote:
>> Building the v4l, I obtain the following error:
>>
>>
>> home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.c: In function
>> 'mceusb_dev_probe':
>> /home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.c:923: error:
>> implicit declaration of function 'usb_alloc_coherent'
>> /home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.c:923:
>> warning: assignment makes pointer from integer without a cast
>> /home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.c:1003: error:
>> implicit declaration of function 'usb_free_coherent'
>> make[3]: ***
>> [/home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.o] Error 1
>> make[2]: ***
>> [_module_/home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l] Error 2
>> make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-24-generic'
>> make[1]: *** [default] Errore 2
>> make[1]: uscita dalla directory
>> «/home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l»
>> make: *** [all] Errore 2
>>
>> My system is a Kubuntu 10.04 amd64 with kernel 2.6.32-24-generic #39-Ubuntu
>> SMP Wed Jul 28 05:14:15 UTC 2010 x86_64 GNU/Linux
>>
>> How can I solve?
>
> Please download the new patches available and try again.
>
> Cheers
> Douglas
>
