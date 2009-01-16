Return-path: <linux-media-owner@vger.kernel.org>
Received: from ado-01.adocentral.net.au ([203.88.117.121]:38870 "EHLO
	ado-01.adocentral.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbZAPHIR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2009 02:08:17 -0500
Received: from localhost (localhost [127.0.0.1])
	by ado-01.adocentral.net.au (Postfix) with ESMTP id CF01A5890C
	for <linux-media@vger.kernel.org>; Fri, 16 Jan 2009 18:08:15 +1100 (EST)
Received: from ado-01.adocentral.net.au ([127.0.0.1])
	by localhost (ado-01.adocentral.net.au [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JI2VO5Sg5Svs for <linux-media@vger.kernel.org>;
	Fri, 16 Jan 2009 18:08:11 +1100 (EST)
Received: from [192.168.1.20] (ppp167-251-1.static.internode.on.net [59.167.251.1])
	by ado-01.adocentral.net.au (Postfix) with ESMTP id DC56A5890B
	for <linux-media@vger.kernel.org>; Fri, 16 Jan 2009 18:08:10 +1100 (EST)
Message-ID: <497031CF.9060703@bat.id.au>
Date: Fri, 16 Jan 2009 18:05:51 +1100
From: Aaron Theodore <aaron@bat.id.au>
Reply-To: aaron@bat.id.au
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: kernel soft lockup on boot loading cx2388x based DVB-S card (TeVii
 S420)
References: <17229660.2191232079572873.JavaMail.root@ado-01>
In-Reply-To: <17229660.2191232079572873.JavaMail.root@ado-01>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Horay my TeVii DVB-S S420 is now working,
only thing now is to work out why it wont load on boot before my DVB-T card

On 16/01/2009 3:19 PM, Aaron Theodore wrote:
> I tried:
> make rmmod
> make rminstall
>
> Although there were still some drivers left over from "tevii_linuxdriver_0815"
>
> /lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/dvb-usb/dvb-usb-s600.ko
> /lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/dvb-usb/dvb-usb-s650.ko
> /lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/zr36067.ko
> /lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/zr36060.ko
> /lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/zr36050.ko
> /lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/saa7134/saa7134-oss.ko
> /lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/zr36016.ko
> /lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/tuner-3036.ko
> /lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/videocodec.ko
> /lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/dpc7146.ko
>
> so i just removed manually and rebooted.
> Same issue occurred on reboot.
>
> So i thought to try manually unloading and reloading the module
>
>
> barry:~# rmmod cx8802
> barry:~# modprobe cx8802   
>
> kernel: cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
> kernel: cx88[0]/2: cx2388x 8802 Driver Manager
> kernel: ACPI: PCI Interrupt 0000:05:08.2[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
> kernel: cx88[0]/2: found at 0000:05:08.2, rev: 5, irq: 18, latency: 32, mmio: 0xd9000000
> kernel: cx88/2: cx2388x dvb driver version 0.0.6 loaded
> kernel: cx88/2: registering cx8802 driver, type: dvb access: shared
> kernel: cx88[0]/2: subsystem: d420:9022, board: TeVii S420 DVB-S [card=73]
> kernel: cx88[0]/2: cx2388x based DVB/ATSC card
> kernel: cx8802_alloc_frontends() allocating 1 frontend(s)
> kernel: DVB: registering new adapter (cx88[0])
> kernel: DVB: registering adapter 2 frontend 0 (ST STV0288 DVB-S)...
>
>
> This time it makes the devices in /dev/dvb/
> Now unfortunately i can't test to see if it can actually Tune until a few hours time when i get home (i think i forgot to plug my satellite cable back in!)
>
> Will report back later
>
>
> Can i change the load order of kernel modules, it dosnt seem to like being loaded before my other dvb modules
>
>
> Aaron
>
>
> ----- "Mauro Carvalho Chehab" <mchehab@infradead.org> wrote:
>
>   
>> On Fri, 16 Jan 2009 06:56:05 +1100
>> Aaron Theodore <aaron@bat.id.au> wrote:
>>
>>     
>>> Mauro,
>>>
>>> Thanks for the speedy patch!
>>>       
>> You should thanks to Andy. He is the author of this patch ;)
>>
>>     
>>> My system can at least boot now, but has issues loading the
>>>       
>> frontend.
>>     
>>> DVB: Unable to find symbol stv0299_attach()
>>> DVB: Unable to find symbol stv0288_attach()
>>>       
>> It seems that you didn't compile those two frontends.
>>
>> Cheers,
>> Mauro
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

