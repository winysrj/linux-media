Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout08.t-online.de ([194.25.134.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rohde.d@t-online.de>) id 1LELmn-0008Jb-1h
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 11:43:50 +0100
Message-ID: <494E1DD6.8010302@t-online.de>
Date: Sun, 21 Dec 2008 11:43:34 +0100
From: Detlef Rohde <rohde.d@t-online.de>
MIME-Version: 1.0
To: Roberto Ragusa <mail@robertoragusa.it>
References: <4936FF66.3020109@robertoragusa.it> <494C0002.1060204@scram.de>
	<494D2B6B.2070501@robertoragusa.it>
In-Reply-To: <494D2B6B.2070501@robertoragusa.it>
Cc: linux-dvb@linuxtv.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] MC44S803 frontend
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi All,
from Roberto's latest posting I see that there is some effort in solving 
my shortly before reported problem. As an owner of a Cinergy T USB XE 
Ver.2- stick which works fine under WXP I am bothering for a while i.o. 
to get rid of problems running it under linux. Could anyone please list 
some easy steps how I can set up a working hardwaredriver? Currently I 
have installed: 1. Driver for Afatech 9015, 2. Driver for devices based 
on Afatech 9015, driver for the AF901x demodulator. The first is 
reported as being activated and in use, the latter two which are bundled 
together appear as activated but not in use. This report comes from my 
hardware driver info in Ubuntu Intrepid. Have tried to switch this one 
to be in use with no success. I am uncertain if I need all this stuff or 
should remove 2). As a linux newbie I am not familiar with compiling and 
merging software changes in existing drivers. Hope you can help.
Best regards,
Detlef

Roberto Ragusa schrieb:
> Jochen Friedrich wrote:
>   
>> Hi Roberto,
>>
>>     
>>> Is there any plan to include this frontend in mainline kernels?
>>> I used to run this driver months ago and it was working well.
>>>       
>> The reason is the huge memory footprint due to the included frequency table.
>> I worked a bit on the driver to get rid of this table. Could you try this version:
>>
>> 1. Patch for AF9015:
>>
>> http://git.bocc.de/cgi-bin/gitweb.cgi?p=dbox2.git;a=commitdiff;h=e5d7398a4b2d3c520d949e53bbf7667a481e9690
>>
>> 2. MC44S80x tuner driver:
>>
>> http://git.bocc.de/cgi-bin/gitweb.cgi?p=dbox2.git;a=blob;f=drivers/media/common/tuners/mc44s80x.c;h=b8dd335e64b03b8544b4c95e2d7f3dbd968078a0;hb=4bde668b4eca90f8bdcc5916dfc88c115a3dfd20
>> http://git.bocc.de/cgi-bin/gitweb.cgi?p=dbox2.git;a=blob;f=drivers/media/common/tuners/mc44s80x.h;h=c6e76da6bf51163c90f0ead259c0e54d4f637671;hb=4bde668b4eca90f8bdcc5916dfc88c115a3dfd20
>> http://git.bocc.de/cgi-bin/gitweb.cgi?p=dbox2.git;a=blob;f=drivers/media/common/tuners/mc44s80x_reg.h;h=299c1be9a80a3777fb46f65d6070965de9754787;hb=4bde668b4eca90f8bdcc5916dfc88c115a3dfd20
>>     
>
> Hi Jochen,
>
> thank you for your work. I see the table values are gone and
> parameters are computed by the code.
>
> I will only be able to test this driver in a couple of days, as I do
> not have the hardware (Cinergy T USB XE Ver.2) with me at the moment.
>
> Do you prefer me to apply the patch to one tree in particular?
>
>   


-- 
Dipl.-Ing. Detlef Rohde
Titiseestr. 12
D-13469 Berlin
Phone: +4930 4021731
A.R.S.: DL7IY


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
