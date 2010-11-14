Return-path: <mchehab@pedra>
Received: from mx1.polytechnique.org ([129.104.30.34]:34012 "EHLO
	mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab0KNWU4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 17:20:56 -0500
Message-ID: <4CE060C7.5050104@free.fr>
Date: Sun, 14 Nov 2010 23:20:55 +0100
From: Massis Sirapian <msirapian@free.fr>
MIME-Version: 1.0
To: Mariusz Bialonczyk <manio@skyboo.net>
CC: linux-media@vger.kernel.org
Subject: Re: HVR900H : IR Remote Control
References: <4CDFF446.2000403@free.fr> <4CE0047D.8060401@arcor.de> <4CE03704.4070300@free.fr> <4CE04B60.4080105@skyboo.net>
In-Reply-To: <4CE04B60.4080105@skyboo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Le 14/11/2010 21:49, Mariusz Bialonczyk a écrit :
> Hello Massis,
>
> On 11/14/2010 08:22 PM, Massis Sirapian wrote:
>> Thanks Stefan. I've checked the /drivers/media/IR/keymaps of the kernel
>> source directory, but nothing seems to fit my remote, which is a
>> DSR-0012 : http://lirc.sourceforge.net/remotes/hauppauge/DSR-0112.jpg.
>  >
>> Were you talking about these rc_"map" modules? If so and if there is
>> corresponding module for my remote, how can I contribute as I have one?
>
> First of all you need to check for the codes if they appear when you
> pressing buttons. If you have /dev/input/eventX number then you can use:
> input-events X
> where X is the event number related with you IR receiver
>
> then you can make a map for you remote (based on that codes you've got)
> you can also create the temporary map for testing and load it using
> command:
> input-kbd -f your_map_file X
> where X - event number,
> your_map_file - a file with key mappings in format:
> key_code = KEY_something, ie:
> 146 = KEY_0
>
> regards

Hi Mariusz, I'd be delighted to do that, but no event device is created.
That's the reason of my first message : except tm6000-dvb, should I load 
another module? It feels like something is preventing the event device 
from being created.

cat /proc/bus/input/devices gives :

I: Bus=0003 Vendor=046d Product=c018 Version=0111
N: Name="Logitech USB Optical Mouse"
P: Phys=usb-0000:00:1a.0-1.3/input0
S: 
Sysfs=/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input0
U: Uniq=
H: Handlers=mouse0 event0
B: EV=17
B: KEY=70000 0 0 0 0
B: REL=103
B: MSC=10

I: Bus=0003 Vendor=0461 Product=0010 Version=0110
N: Name="NOVATEK USB Keyboard"
P: Phys=usb-0000:00:1a.0-1.4/input0
S: 
Sysfs=/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input1
U: Uniq=
H: Handlers=sysrq kbd event1
B: EV=120013
B: KEY=1000000000007 ff9f207ac14057ff febeffdfffefffff fffffffffffffffe
B: MSC=10
B: LED=7

I: Bus=0003 Vendor=0461 Product=0010 Version=0110
N: Name="NOVATEK USB Keyboard"
P: Phys=usb-0000:00:1a.0-1.4/input1
S: 
Sysfs=/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.1/input/input2
U: Uniq=
H: Handlers=kbd event2
B: EV=13
B: KEY=2000000 39fad941d001 1e000000000000 0
B: MSC=10

I: Bus=0010 Vendor=001f Product=0001 Version=0100
N: Name="PC Speaker"
P: Phys=isa0061/input0
S: Sysfs=/devices/platform/pcspkr/input/input3
U: Uniq=
H: Handlers=kbd event3
B: EV=40001
B: SND=6

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=PNP0C0C/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input4
U: Uniq=
H: Handlers=kbd event4
B: EV=3
B: KEY=10000000000000 0

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=LNXPWRBN/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
U: Uniq=
H: Handlers=kbd event5
B: EV=3
B: KEY=10000000000000 0

I: Bus=0003 Vendor=046d Product=08ad Version=0100
N: Name="zc3xx"
P: Phys=usb-0000:00:1a.0-1.5/input0
S: Sysfs=/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/input/input6
U: Uniq=
H: Handlers=kbd event6
B: EV=3
B: KEY=100000 0 0 0

Good night

Massis
