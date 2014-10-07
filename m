Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <serrin19@outlook.com>) id 1XbPPM-0006UR-H4
	for linux-dvb@linuxtv.org; Tue, 07 Oct 2014 09:42:10 +0200
Received: from blu004-omc3s19.hotmail.com ([65.55.116.94])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-8) with esmtps
	[UNKNOWN:AES256-SHA256:256] for <linux-dvb@linuxtv.org>
	id 1XbPPK-00011b-m3; Tue, 07 Oct 2014 09:42:08 +0200
Message-ID: <BLU436-SMTP239E92C64A0D3C95BF40975C5A20@phx.gbl>
Date: Tue, 7 Oct 2014 17:41:59 +1000
From: serrin <serrin19@outlook.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Linux Mint 17 + Hauppauge HVR-2200 (saa7164) problems
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

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

I didn't figure out how to apply the patch using the patch file, so I 
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
caution to the wind and use the latest kernel instead) and recompiled 
the linux TV drivers, this time changing both rev 2 and rev 3 to 
v4l-saa7164-1.0.2-3.fw (and the file sizes as well) instead of the NXP 
file (I did a cursory search of all the other files in the linuxtv 
source files but there was no mention of the NXP7164 file in any of the 
files with saa7164 in their names) but once again, it was asking where 
the NXP file is (similar file not found? error).

Putting the NXP file in /lib/firmware/ folder gives me image corrupt 
error, which is strange, as I didn't once mention the NXP file. I assume 
that the need for the NXP file has since been encorporated into the 
kernel without the need to compile linuxtv drivers?

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

I'm at my wit's end, can anybody help me? All I want to do is record 
some TV! Also is any of my trouble shooting incorrect? Should I not have 
renamed those files? I'm pretty new to Linux so I have no idea what I'm 
doing. What is the purpose of the /etc/modprobe.d/ folder, or rather 
what does puting the options file in that folder do? I can provide more 
details if needed. Thank you for your time.

Yours sincerely

serrin

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
