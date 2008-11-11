Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from tuc.ic3s.de ([80.146.164.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas@ic3s.de>) id 1KzvPK-0004Xp-TJ
	for linux-dvb@linuxtv.org; Tue, 11 Nov 2008 16:44:00 +0100
Message-ID: <4919A82D.5060707@ic3s.de>
Date: Tue, 11 Nov 2008 16:43:41 +0100
From: Thomas <thomas@ic3s.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
References: <491980CC.3000708@ic3s.de> <4919A1B3.4060304@iki.fi>
In-Reply-To: <4919A1B3.4060304@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] af9015 problem on fedora rawhide 9.93 with 2.6.27x
 kernel
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

Hi Antti,

> I think good place
> to test fix is add some sleep (msleep(100)) before/after RECONNECT_USB
> -command around line 685 in af9015.c file. 

thank you, that helps.

i have added two lines:

	msleep(1000);
        req.cmd = RECONNECT_USB;
	msleep(1000);

maybe some fine tunnig is required :)
but for me it works fine.

Regards

Thomas

Antti Palosaari schrieb:
> hello
> 
> 
> Thomas wrote:
>> Hi List,
>>
>>
>> since fedora use 2.6.27 kernels this
>> is all what happens when i plug in the stick:
>>
>> Nov 11 13:24:56 thomas-lt kernel: usb 2-6: new high speed USB device
>> using ehci_hcd and address 3
>> Nov 11 13:24:57 thomas-lt kernel: usb 2-6: configuration #1 chosen
>> from 1 choice
>> Nov 11 13:24:57 thomas-lt kernel: Afatech DVB-T 2: Fixing fullspeed to
>> highspeed interval: 16 -> 8
>> Nov 11 13:24:57 thomas-lt kernel: input: Afatech DVB-T 2 as
>> /devices/pci0000:00/0000:00:1d.7/usb2/2-6/2-6:1.1/input/input9
>> Nov 11 13:24:57 thomas-lt kernel: input,hidraw0: USB HID v1.01
>> Keyboard [Afatech DVB-T 2] on usb-0000:00:1d.7-6
>> Nov 11 13:24:57 thomas-lt kernel: usb 2-6: New USB device found,
>> idVendor=15a4, idProduct=9016
>> Nov 11 13:24:57 thomas-lt kernel: usb 2-6: New USB device strings:
>> Mfr=1, Product=2, SerialNumber=3
>> Nov 11 13:24:57 thomas-lt kernel: usb 2-6: Product: DVB-T 2
>> Nov 11 13:24:57 thomas-lt kernel: usb 2-6: Manufacturer: Afatech
>> Nov 11 13:24:57 thomas-lt kernel: usb 2-6: SerialNumber: 010101010600001
>> Nov 11 13:24:57 thomas-lt kernel: dvb-usb: found a 'Afatech AF9015
>> DVB-T USB2.0 stick' in cold state, will try to load a firmware
>> Nov 11 13:24:57 thomas-lt kernel: firmware: requesting dvb-usb-af9015.fw
>> Nov 11 13:24:57 thomas-lt kernel: dvb-usb: downloading firmware from
>> file 'dvb-usb-af9015.fw'
>> Nov 11 13:24:57 thomas-lt kernel: usbcore: registered new interface
>> driver dvb_usb_af9015
>>
>>
>> if the stick is connected at boot time everything is working correctly.
>>
>> can someone please give me a hint where to look for the problem?
>>
>> version is af9015-e0e0e4ee5b33
> 
> you are not alone with this problem. It only happens 2.6.27 kernels.
> Looks like it does not reconnect device in the USB-bus as it should. I
> don't have access to 2.6.27 kernel yet, so I cannot examine it more.
> Hopefully there is someone who could fix that soon... I think good place
> to test fix is add some sleep (msleep(100)) before/after RECONNECT_USB
> -command around line 685 in af9015.c file. The other solution could be
> to remove whole RECONNECT_USB (after firmware download) and set
> no_reconnect -flag.
> 
>>
>>
>> Best Regards
>> Thomas
> 
> regards
> Antti

-- 
[:O]###[O:]

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
