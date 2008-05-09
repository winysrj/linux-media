Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from walker.ipnetwork.de ([83.246.120.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <admin@ipnetwork.de>) id 1JuPIT-0003iJ-Hi
	for linux-dvb@linuxtv.org; Fri, 09 May 2008 11:53:51 +0200
Received: from [192.168.0.20] (BAG11e1.bag.pppool.de [77.134.17.225])
	(authenticated bits=0)
	by walker.ipnetwork.de (8.13.8/8.13.8/Debian-3) with ESMTP id
	m499rXmg017650
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Fri, 9 May 2008 11:53:39 +0200
Message-ID: <48241F25.40607@ipnetwork.de>
Date: Fri, 09 May 2008 11:53:41 +0200
From: Ingo Peukes <admin@ipnetwork.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <481ED628.4070901@ipnetwork.de> <482374BA.7040508@ipnetwork.de>
	<4824034D.7000700@free.fr>
In-Reply-To: <4824034D.7000700@free.fr>
Subject: Re: [linux-dvb] Cinergy T2 Kernel Oops on Linkstation Live V1
 (Marvel Orion ARM Architecture)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello Thierry,

Thierry Merle wrote:
> Hi Ingo,
> =

> Ingo Peukes a =E9crit :
>> Hello everyone...
>>
>> a few days ago I bought e Pinnacle PCTV200e to try if it works with my =

>> Linkstation. After getting some drivers for it from here: =

>> http://ubuntuforums.org/showthread.php?t=3D511676&page=3D8
>> As result I just got the same kernel oops, only triggered by the dvb_usb =

>> module instead of the cinergyT2 one.
>>
> Is it the same ManufacturerID/VendorID as the cinergyT2 device or did you=
 make some adaptations to make your Pinnacle device to work with the cinerg=
yT2 driver?
> =

Well, think I was a bit unclear here.
I don't use the cinergyT2 module with the Pinnacle device.
The v4l-dvb drivers I found on the ubuntu forum contains a separate =

driver for the PCTV200e. What I was trying to say is that both drivers =

trigger the same oops, in case of the PCTV it originates in dvb-usb.ko =

and in case of the cinergy in cinergyT2.ko

>> Today I found a patch sent to this list on 01/20/2008 by Michele =

>> Scorcia. Although it is for kernel 2.6.20.4 and written to fix a problem =

>> on a mips platform the description of the problem came close to mine. So =

>> I applied it to the usb-urb.c from the above archive and built the modul=
es.
>> After that the oops was gone and the PCTV runs without problems.
>> The cinergy driver still triggers the oops but i think that's normal =

>> cause it does not use the dvb-usb module and would need a separate patch.
>> The new cinergyT2 driver from Tomi Orava works just fine so I give it a =

>> chance instead of fixing the old one.
>> Another reason for this is that I tried both receivers on my desktop =

>> with the same kernel and v4l-dvb sources as I use on the Linkstation and =

>> couldn't make them run both at the same time. dmesg shows no errors but
>> w_scan hangs when both drivers are loaded. Either receiver alone works
>> great but together none does.
>> This problem does not exist with the new driver.
>>
> I hope Tomi will be able to finalize his patch so we will be able to repl=
ace the old one.
> The old driver is monolithic and does not follow the dvb framework evolut=
ions/bug corrections.
Hope so too,  as I stated in my reply to the 'Tester wanted ...' thread =

it works good except the signal recognition is very poor compared to the =

old driver.
> =

>>
>> Here's the patch I use, only difference to the one from Michele Scorcia =

>> are the line numbers:
>>
> Please post this patch in an email with [PATCH] in subject and with the S=
igned-off-by: name <email> line so that maintainers get aware of the patch,=
 and don't miss it.
> See: http://www.linuxtv.org/v4lwiki/index.php/How_to_submit_patches
Thanks for the hint, will do that :)
> =

> Thanks
> Thierry

REgrads

Ingo PEukes

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
