Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu004-omc2s31.hotmail.com ([65.55.111.106]:60583 "EHLO
	BLU004-OMC2S31.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbaJMXLb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Oct 2014 19:11:31 -0400
Message-ID: <BLU437-SMTP32BE04CD60AF807B75686C5AC0@phx.gbl>
Date: Tue, 14 Oct 2014 09:11:24 +1000
From: serrin <serrin19@outlook.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge HVR-2200 (saa7164) problems (on Linux Mint 17)
References: <543C5B34.5090002@outlook.com>
In-Reply-To: <543C5B34.5090002@outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I recently built a HTPC/NAS server with linux mint 17. I reused my old 
DVB-T card from my desktop which was a Hauppauge HVR-2200 with NXP 
saa7164 IC. This is my first (serious) attempt at installing linux on a 
computer and everything went well until it came to getting this TV tuner 
to work.

I followed the instructions on the wiki 
(http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-2200) 
initially doing the "making it work easily" instructions as it looked 
simplier than compiling my own drivers.

Using the NXP7164-2010-03-10.1.fw firmware gave me the dreaded 
"saa7164_downloadimage() image corrupt" errors in the dmesg though (I 
figured out the card number using the instructions, it was 6), so I 
resigned myself to compiling the linuxtv drivers using the Steven Toth's 
patch and v4l-saa7164-1.0.2-3.fw.

I couldn't figure out how to apply the patch using the patch file, so I 
manually edited the file (drivers/media/pci/saa7164/saa7164-fw.c), but I 
kept getting the image corrupt message.

I deleted NXP7164-2010-03-10.1.fw as I figured and options from 
/etc/modprobe.d as the "making it work" set of instructions didn't 
mention either of them. However, it now was asking for 
NXP7164-2010-03-10.1.fw:

[    6.271462] saa7164 driver loaded
[    6.271499] saa7164 0000:01:00.0: enabling device (0000 -> 0002)
[    6.271587] CORE saa7164[0]: subsystem: 0070:8901, board: Hauppauge 
WinTV-HVR2200 [card=6,autodetected]
[    6.271590] saa7164[0]/0: found at 0000:01:00.0, rev: 129, irq: 16, 
latency: 0, mmio: 0xf7800000
[    6.287504] input: Xbox 360 Wireless Receiver (XBOX) as 
/devices/pci0000:00/0000:00:14.0/usb3/3-8/3-8:1.0/input/input18
[    6.287649] input: Xbox 360 Wireless Receiver (XBOX) as 
/devices/pci0000:00/0000:00:14.0/usb3/3-8/3-8:1.2/input/input19
[    6.287773] input: Xbox 360 Wireless Receiver (XBOX) as 
/devices/pci0000:00/0000:00:14.0/usb3/3-8/3-8:1.4/input/input20
[    6.287885] input: Xbox 360 Wireless Receiver (XBOX) as 
/devices/pci0000:00/0000:00:14.0/usb3/3-8/3-8:1.6/input/input21
[    6.287954] usbcore: registered new interface driver xpad
[    6.431062] saa7164_downloadfirmware() no first image
[    6.431069] saa7164_downloadfirmware() Waiting for firmware upload 
(NXP7164-2010-03-10.1.fw)
[    6.431088] saa7164 0000:01:00.0: Direct firmware load failed with 
error -2
[    6.431089] saa7164 0000:01:00.0: Falling back to user helper
[    6.553871] BTRFS info (device sda3): disk space caching is enabled
[    6.568484] AVX2 version of gcm_enc/dec engaged.
[    6.761377] BTRFS info (device sdf): disk space caching is enabled
[    6.929024] device-mapper: multipath: version 1.7.0 loaded
[    7.085935] iwlwifi 0000:04:00.0: request for firmware file 
'iwlwifi-7260-9.ucode' failed.
[    7.106496] saa7164_downloadfirmware() Upload failed. (file not found?)
[    7.106499] Failed to boot firmware, no features registered

Which was quite weird, so I put back NXP7164-2010-03-10.1.fw (without 
the options file) but then it just gave me the image corrupt error.

I was quite confused at this point, so I figured I'd try again with a 
fresh kernel file, ignoring the "making it work easily" instructions and 
just go with "making it work", so I upgraded to 3.16.3 (prior to this I 
was running 3.14 that came with LM17 Qiana but I decided to throw 
caution to the wind and use the latest stable kernel instead) and 
recompiled the linux TV drivers, this time changing both rev 2 and rev 3 
to v4l-saa7164-1.0.2-3.fw (and the file sizes as well) instead of the 
NXP file (I did a cursory search of all the other files in the linuxtv 
source files but there was no mention of the NXP7164 file in any of the 
files with saa7164 in their names) but once again, it was asking where 
the NXP file is (similar file not found? error).

Putting the NXP file in /lib/firmware/ folder gives me image corrupt 
error, which I thought was strange, as I didn't once mention the NXP 
file in the v4l drivers I compiled. I assume that the need for the NXP 
file has since been encorporated into the kernel without the need to 
compile linuxtv drivers?

I tried renaming v4l-saa7164-1.0.2-3.fw to NXP7164-2010-03-10.1.fw but 
it checks the file size and booting and refuses it:

[    7.214637] saa7164_downloadfirmware() firmware read 4038864 bytes.
[    7.214639] xc5000: firmware incorrect size
[    7.214720] Failed to boot firmware, no features registered

I tried renaming a few files actually, including HcwWiltF103.bin from 
the latest windows drivers (which Stephen Toth's extract.sh renames as 
v4l-saa7164-1.0.3.fw from an old set of windows drivers, from what I can 
tell of the code? I'm not 100% sure of this though, I also tried 
HcwWiltF.bin which becomes v4l-saa7164-1.0.2.fw) but none of them are 
the same size and they all get rejected.

I'm out of ideas, can anybody help me? All I want to do is record some 
TV. Also is any of my trouble shooting incorrect? Should I not have 
renamed those files? I'm pretty new to Linux so I have no idea what I'm 
doing. What is the purpose of the /etc/modprobe.d/ folder, or rather 
what does puting the options file in that folder do? I can provide more 
details if needed. Thank you for your time.

Yours sincerely

serrin
