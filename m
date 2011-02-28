Return-path: <mchehab@pedra>
Received: from postfix.mbigroup.it ([84.233.239.88]:43158 "EHLO
	postfix.mbigroup.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab1B1Kh1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 05:37:27 -0500
Message-ID: <4D6B7AD6.1050309@mbigroup.it>
Date: Mon, 28 Feb 2011 11:37:10 +0100
From: Vinicio Nocciolini <vnocciolini@mbigroup.it>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: ec168-9295d36ab66e compiling error
References: <4D666A3A.1090701@mbigroup.it> <4D6A9388.5030001@iki.fi>
In-Reply-To: <4D6A9388.5030001@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 02/27/2011 07:10 PM, Antti Palosaari wrote:
> Dont use my, or anyone else, old HG trees. You should follow that
> http://www.linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers
>
> Antti
>
> On 02/24/2011 04:24 PM, Vinicio Nocciolini wrote:
>> Hi all
>>
>> I have problem compiling the project
>>
>> regards Vinicio
>>
>> ----------------------------------------------------------------------------------------------------------- 
>>
>>
>>
>> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/vc032x.o
>> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/zc3xx.o
>> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hdpvr-control.o
>> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hdpvr-core.o
>> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hdpvr-video.o
>> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hopper_cards.o
>> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/hopper_vp3028.o
>> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-functions.o
>> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-keytable.o
>> /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-keytable.c: In function
>> '__ir_input_register':
>> /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-keytable.c:452:24:
>> warning: assignment from incompatible pointer type
>> /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-keytable.c:453:24:
>> warning: assignment from incompatible pointer type
>> CC [M] /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.o
>> /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.c: In function
>> 'ir_register_class':
>> /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.c:268:23: error:
>> 'ir_raw_dev_type' undeclared (first use in this function)
>> /home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.c:268:23: note:
>> each undeclared identifier is reported only once for each function it
>> appears in
>> make[3]: *** [/home/vinicio/Desktop/ec168-9295d36ab66e/v4l/ir-sysfs.o]
>> Error 1
>> make[2]: *** [_module_/home/vinicio/Desktop/ec168-9295d36ab66e/v4l] 
>> Error 2
>> make[2]: Leaving directory `/usr/src/kernels/2.6.35.11-83.fc14.i686'
>> make[1]: *** [default] Error 2
>> make[1]: Leaving directory 
>> `/home/vinicio/Desktop/ec168-9295d36ab66e/v4l'
>> make: *** [all] Error 2
>>
>>
>>
>>
>>
>>
>>
>>
>> [vinicio@localhost ec168-9295d36ab66e]$ cat /etc/issue
>> Fedora release 14 (Laughlin)
>> Kernel \r on an \m (\l)
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>




Hi
I have compiled and installed the driver
But I think there is an error
regards Vinicio


[root@localhost ~]# dmesg -c
[  304.598047] usb 1-4: new high speed USB device using ehci_hcd and 
address 5
[  304.712607] usb 1-4: New USB device found, idVendor=18b4, idProduct=1689
[  304.712614] usb 1-4: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[  304.715963] input: HID 18b4:1689 as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4:1.0/input/input10
[  304.716902] generic-usb 0003:18B4:1689.0004: input,hidraw0: USB HID 
v1.11 Keyboard [HID 18b4:1689] on usb-0000:00:1d.7-4/input0
[  304.722224] dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference 
design' in cold state, will try to load a firmware
[  304.742587] dvb-usb: did not find the firmware file. 
(dvb-usb-ec168.fw) Please see linux/Documentation/dvb/ for more details 
on firmware-problems. (-2)
[  304.742603] dvb_usb_ec168: probe of 1-4:1.1 failed with error -2
