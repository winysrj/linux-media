Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54578 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2EFDMm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 23:12:42 -0400
Received: by wibhr7 with SMTP id hr7so2489550wib.1
        for <linux-media@vger.kernel.org>; Sat, 05 May 2012 20:12:40 -0700 (PDT)
Message-ID: <4FA5EC25.9070406@gmail.com>
Date: Sun, 06 May 2012 05:12:37 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: error - cx18 driver
References: <CACOfU4NXM5itsw17bRhtNeDP+-dbCM+Ms84k47NbPf6NjzOmtw@mail.gmail.com> <5dd58a2c-0789-423d-8bd1-e583edcba17d@email.android.com> <0ace01cd2b29$513a4840$f3aed8c0$@gmail.com>
In-Reply-To: <0ace01cd2b29$513a4840$f3aed8c0$@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/06/2012 03:41 AM, Hector Catre wrote:
> Thanks Andy.
> Again I'm a n00b, thus, can you point me to a page or resource where I can find and install i2c_algo_bit?
> Thanks again,
> H
>
Please paste output of:
grep -w 'CONFIG_I2C\|CONFIG_I2C_HELPER_AUTO\|CONFIG_I2C_ALGOBIT'
/boot/config-`uname -r`
grep -i i2c /etc/modprobe.d/* /etc/modules.conf
modinfo i2c-core
modinfo i2c_algo_bit
lsmod | grep -w 'i2c-core\|i2c_algo_bit'


> -----Original Message-----
> From: Andy Walls [mailto:awalls@md.metrocast.net] 
> Sent: May-05-12 8:43 PM
> To: Hector Catre; linux-media@vger.kernel.org
> Subject: Re: error - cx18 driver
> 
> Hector Catre <hcatre@gmail.com> wrote:
> 
>> Note: I’m a relatively n00b trying to set up mythtv and having issues 
>> installing the hauppage hvr-1600 tuner/capture card.
>>
>> When I run dmesg, I get the following:
>>
>> [  117.013178]  a1ac5dc28d2b4ca78e183229f7c595ffd725241c [media] gspca
>> - sn9c20x: Change the exposure setting of Omnivision sensors [  
>> 117.013183]  4fb8137c43ebc0f5bc0dde6b64faa9dd1b1d7970 [media] gspca
>> - sn9c20x: Don't do sensor update before the capture is started [  
>> 117.013188]  c4407fe86d3856f60ec711e025bbe9a0159354a3 [media] gspca
>> - sn9c20x: Set the i2c interface speed
>> [  117.028665] cx18: Unknown symbol i2c_bit_add_bus (err 0)
>>
>> Help.
>>
>> Thanks,
>> H
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org More majordomo info 
>> at  http://vger.kernel.org/majordomo-info.html
> 
> You must ensure i2c_algo_bit.ko exists as a kernel module or that i2c_algo_bit is built into your kernel.
> 
> Regards,
> Andy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

