Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <joshoekstra@gmx.net>) id 1LCuVx-0001C1-1q
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 12:24:30 +0100
Message-ID: <4948E149.4040502@gmx.net>
Date: Wed, 17 Dec 2008 12:23:53 +0100
From: Jos Hoekstra <joshoekstra@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20081217002735.GF45924@dereel.lemis.com>
	<1229488967.8328.2.camel@icarus.wilsonet.com>
In-Reply-To: <1229488967.8328.2.camel@icarus.wilsonet.com>
Subject: Re: [linux-dvb] Support for Afatech 9035 (Aldi Fission USB tuner)
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

Jarod Wilson schreef op 17-12-2008 5:42:
> On Wed, 2008-12-17 at 11:27 +1100, Greg 'groggy' Lehey wrote:
>> I have a dual USB tuner from Aldi, which they call a Fission dual high
>> definition DVB-T receiver.
> [...]
>> dmesg output (complete version is attached)
>> says:
>>
>> [  789.696018] usb 4-3: new high speed USB device using ehci_hcd and
>> address 2
>> [  789.846003] usb 4-3: configuration #1 chosen from 1 choice
>> [  790.052259] usbcore: registered new interface driver hiddev
>> [  790.056703] input: Afa Technologies Inc. AF9035A USB Device
>> as /devices/pci0000:00/0000:00:10.3/usb4/4-3/4-3:1.1/input/input8
>> [  790.057902] input,hidraw0: USB HID v1.01 Keyboard [Afa Technologies
>> Inc. AF9035A USB Device] on usb-0000:00:10.3-3
>> [  790.058287] usbcore: registered new interface driver usbhid
>> [  790.058511] usbhid: v2.6:USB HID core driver
>>
>> I've been following the instructions on the wiki, and I've got hold of
>> the firmware files dvb-usb-af9015.fw and xc3028-v27.fw.  The former
>> doesn't get loaded; the latter gets loaded even if the stick isn't
>> present
> 
>> >From your dmesg output, it appears the usbhid driver has claimed the
> device, thus the dvb driver can't grab it. If I recall correctly, usbhid
> is a module on ubuntu, so you should be able to tell it not to load
> w/some modprobe options (which I don't remember off the top of my head).
> 
> --jarod

Which would be something like this:
options usbhid quirks=15a4:1001:0x0004
in your case. Not totally sure about the 0x0004 though.
With my Avermedia Volar X(af9015) I don't need to add that line though. 
For that I downloaded the repo[1] of Antti Palosaari and added a line to 
the usb-devices with the usb id, now it's already included. Dunno if 
this is gonna work for you though.
Just wait for a dev who has some more knowledge about the different 
chips and it might get support.


[1]: http://linuxtv.org/hg/~anttip/af9015/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
