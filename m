Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout11.t-online.de ([194.25.134.85]:60090 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbZAMRwf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 12:52:35 -0500
Message-ID: <496CD4C8.50004@t-online.de>
Date: Tue, 13 Jan 2009 18:52:08 +0100
From: Detlef Rohde <rohde.d@t-online.de>
MIME-Version: 1.0
To: Roberto Ragusa <mail@robertoragusa.it>
CC: Jochen Friedrich <jochen@scram.de>, linux-dvb@linuxtv.org,
	linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: MC44S803 frontend (it works)
References: <4936FF66.3020109@robertoragusa.it> <494C0002.1060204@scram.de> <49623372.90403@robertoragusa.it> <4965327A.5000605@t-online.de>
In-Reply-To: <4965327A.5000605@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again,
I wonder if there is any progress including/merging the frontend-driver 
MC44S803 i.o. to get my Cinergy T USB XE running under Linux? Currently 
I can use it on a WXP-VM, but I guess it's not the best solution making 
this detour..
Regards
Detlef

Detlef Rohde schrieb:
> Hi Roberto,
> tnx for doing your test! As a Linux-newbie I better wait now until I 
> can use a merged driver since I had bad experiences with former trys 
> i.e. OS-crashes. Hopefully one Jochen or somebody else can soon do the 
> rest. Meanwhile I am experimenting with a WXP-Pro VM running on  my 
> Ubuntu Intrepid Installation. Will try the native Terratec-SW on this 
> machine.
> Best regards,
> Detlef
>
> Roberto Ragusa schrieb:
>> (to both linux-dvb and linux-media)
>>
>> Jochen Friedrich wrote:
>>  
>>> Hi Roberto,
>>>
>>>    
>>>> Is there any plan to include this frontend in mainline kernels?
>>>> I used to run this driver months ago and it was working well.
>>>>       
>>> The reason is the huge memory footprint due to the included 
>>> frequency table.
>>> I worked a bit on the driver to get rid of this table. Could you try 
>>> this version:
>>>
>>> 1. Patch for AF9015:
>>>
>>> http://git.bocc.de/cgi-bin/gitweb.cgi?p=dbox2.git;a=commitdiff;h=e5d7398a4b2d3c520d949e53bbf7667a481e9690 
>>>
>>>
>>> 2. MC44S80x tuner driver:
>>>
>>> http://git.bocc.de/cgi-bin/gitweb.cgi?p=dbox2.git;a=blob;f=drivers/media/common/tuners/mc44s80x.c;h=b8dd335e64b03b8544b4c95e2d7f3dbd968078a0;hb=4bde668b4eca90f8bdcc5916dfc88c115a3dfd20 
>>>
>>> http://git.bocc.de/cgi-bin/gitweb.cgi?p=dbox2.git;a=blob;f=drivers/media/common/tuners/mc44s80x.h;h=c6e76da6bf51163c90f0ead259c0e54d4f637671;hb=4bde668b4eca90f8bdcc5916dfc88c115a3dfd20 
>>>
>>> http://git.bocc.de/cgi-bin/gitweb.cgi?p=dbox2.git;a=blob;f=drivers/media/common/tuners/mc44s80x_reg.h;h=299c1be9a80a3777fb46f65d6070965de9754787;hb=4bde668b4eca90f8bdcc5916dfc88c115a3dfd20 
>>>
>>>     
>>
>> Finally managed to try your version. It works, with no apparent issue.
>>
>> Scanning is OK, tuning is OK.
>> I can't test signals below 600MHz at the moment, but I will try 
>> (possibly VHF too)
>> in a couple of days, just to be sure about the frequency handling code.
>> Also tried removing the USB stick while playing a stream; the devices
>> were correctly removed when the user space apps closed them.
>>
>> In my (user) opinion this driver is ready to be merged.
>>
>> I actually fixed some trivial compilation issues in the driver.
>>
>> --- a/linux/drivers/media/common/tuners/mc44s80x.c    2009-01-05 
>> 12:38:11.000000000 +0100
>> +++ b/linux/drivers/media/common/tuners/mc44s80x.c 2009-01-05 
>> 16:12:59.000000000 +0100
>> @@ -470,12 +470,12 @@
>>
>>         mc44s80x_set_power(state, 0); /* disable powerdown */
>>         printk(KERN_WARNING "mc44s80x: MC44S80x get Device ID\n");
>> -       err = i2c_transfer(state->i2c, &msg, 1);
>> +       err = i2c_transfer(state->i2c, msg1, 1);
>>         if (err != 1) {
>>                 printk(KERN_WARNING "mc44s80x: Write error\n");
>>                 goto exit;
>>         }
>> -       err = i2c_transfer(state->i2c, &msg, 1);
>> +       err = i2c_transfer(state->i2c, msg2, 1);
>>         if (err != 1) {
>>                 printk(KERN_WARNING "mc44s80x: Read error, 
>> Reg=[0x%02x]\n",
>>                        TUNER_ADDR + 1);
>> @@ -495,7 +495,7 @@
>>         return 0;
>>  unk:
>>         printk(KERN_WARNING "mc44s80x: Chip with unknown Revision ID "
>> -              "(0x%02x)\n", __func__, id);
>> +              "(0x%02x)\n", id);
>>         goto out;
>>  exit:
>>         if (fe->ops.i2c_gate_ctrl)
>> @@ -512,7 +512,7 @@
>>         int err = 0;
>>
>>         printk(KERN_WARNING "mc44s80x: Trying to attach to Bus @ 
>> 0x%p\n", i2c);
>> -       state = kzalloc(sizeof(struct mc44s80x_state), GFP_KERNEL));
>> +       state = kzalloc(sizeof(struct mc44s80x_state), GFP_KERNEL);
>>         if (state == NULL) {
>>                 err = -ENOMEM;
>>                 goto exit;
>>
>>  
>>> Thanks,
>>> Jochen
>>>     
>>
>> Thanks to you.
>>
>>   
>
>


