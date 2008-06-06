Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.adfinis.com ([212.103.64.13])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@0x17.ch>) id 1K4d5O-0003J0-Tt
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 16:38:39 +0200
From: Nicolas Christener <lists@0x17.ch>
To: Dennis Noordsij <dennis.noordsij@movial.fi>
In-Reply-To: <4849016A.8050607@movial.fi>
References: <1212736555.4264.12.camel@oipunk.loozer.local>
	<4849016A.8050607@movial.fi>
Date: Fri, 06 Jun 2008 16:38:30 +0200
Message-Id: <1212763110.14191.12.camel@oipunk.loozer.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy Piranha
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

Hello 
thanks very much for your fast response!

Am Freitag, den 06.06.2008, 11:20 +0200 schrieb Dennis Noordsij:

[...]

> You're in luck :-) That device works very well.

*w00h00* sounds good :)

> The driver is not in the official tree (yet) so if you would like to use
> it you will need to compile it yourself, 

[...]

> You will also need to take the firmware file "SMS100x_Dvbt.inp" (from
> the installation CD or windows, or download the drivers from
> terratec.net) and copy it to your \lib\firmware or \lib\firmware\`uname
> -r` as "dvbt_stellar_usb.inp".
> 
> I hope those instructions make sense :-)

thank you very much four your explanation. This is what I get:

[root@oipunk:/lib/firmware]# uname -a
Linux oipunk 2.6.25.4-paldo1-x86 #1 SMP PREEMPT Fri May 16 14:52:58 CEST
2008 i686 GNU/Linux

[root@oipunk:/lib/firmware]# lsmod | grep sms1xxx
sms1xxx                25560  0 
dvb_core               80512  1 sms1xxx
firmware_class         10496  4 sms1xxx,microcode,iwl3945,pcmcia

[root@oipunk:/lib/firmware]# modinfo sms1xxx
filename:       /lib/modules/2.6.25.4-paldo1-x86/kernel/drivers/media/dvb/siano/sms1xxx.ko
license:        GPL
author:         Anatoly Greenblatt,,, (anatolyg@siano-ms.com)
description:    smscore
alias:          usb:v187Fp0200d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v187Fp0100d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v187Fp0010d*dc*dsc*dp*ic*isc*ip*
depends:        dvb-core,firmware_class
vermagic:       2.6.25.4-paldo1-x86 SMP preempt mod_unload PENTIUMIII 
parm:           adapter_nr:DVB adapter numbers (array of short)
parm:           default_mode:default firmware id (device mode) (int)

[root@oipunk:/lib/firmware]# ls -la *.inp
-r-xr-xr-x 1 root root 40324 2008-06-06 14:34 dvbh_stellar_usb.inp
-r-xr-xr-x 1 root root 38144 2008-06-06 14:28 dvbt_stellar_usb.inp

[root@oipunk:/var/log]# dmesg
[...]
usb 3-1: new full speed USB device using uhci_hcd and address 43
usb 3-1: configuration #1 chosen from 1 choice
smsusb_probe 0
endpoint 0 81 02 64
endpoint 1 02 02 64
smscore_register_device allocated 50 buffers
smscore_register_device device ed48cf00 created
smsusb1_detectmode: 1 "SMS DVBH Receiver"
smscore_onresponse no client (00000000) or error (-16), type:698 dstid:0
DVB: registering new adapter (Siano Digital Receiver)
DVB: registering frontend 0 (Siano Mobile Digital SMS10xx)...
smscore_register_client f6972800 693 0
smsdvb_hotplug success
smscore_start_device device ed48cf00 started, rc 0
smsusb_init_device device f6973000 created
usb 3-1: New USB device found, idVendor=187f, idProduct=0100
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: SMS DVBH Receiver
usb 3-1: Manufacturer: Siano Mobile Silicon
smsusb_onresponse error, urb status -84, 0 bytes
smsusb_onresponse error, urb status -84, 0 bytes
smsusb_onresponse error, urb status -84, 0 bytes
smsusb_onresponse error, urb status -84, 0 bytes
smsusb_onresponse error, urb status -84, 0 bytes
smsusb_onresponse error, urb status -84, 0 bytes
smsusb_onresponse error, urb status -84, 0 bytes
smsusb_onresponse error, urb status -84, 0 bytes
smsusb_onresponse error, urb status -84, 0 bytes
smsusb_onresponse error, urb status -84, 0 bytes
usb 3-1: USB disconnect, address 43
smscore_unregister_client f6972800 693
smscore_unregister_device freed 50 buffers
smscore_unregister_device device ed48cf00 destroyed
smsusb_term_device device f6973000 destroyed

Unfortunately I do not get a device within /dev
Am I doing something wrong? Or is there just something missing in my
installation?

I would very much appreciate any help.

kind regards
Nicolas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
