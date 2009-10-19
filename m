Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:49606 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbZJSQqX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 12:46:23 -0400
Received: by ywh40 with SMTP id 40so2692915ywh.33
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2009 09:46:27 -0700 (PDT)
Message-ID: <4ADC97DE.60407@Gmail.com>
Date: Mon, 19 Oct 2009 17:46:22 +0100
From: Stephen Bainbridge <bainbridge.stephen@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Regression: Nebula DigiTV DVB-T (PCI) no longer works
References: <1341f2f50910150746k383a77ccg3e26c6bd170d5fee@mail.gmail.com>
In-Reply-To: <1341f2f50910150746k383a77ccg3e26c6bd170d5fee@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

My Nebula DigiTV DVB-T (PCI) card no longer works. It's on a
multi-boot Kubuntu system and works fine when I boot into Intrepid
(v2.6.27-11-generic#1 SMP i686), but it does not work with Jaunty
(v2.6.28-11-generic i686). I've also tried a beta of the latest Kubuntu
release Karmic and that also does not work. I've tried both i686 and
x64 variants and its the same.

I did a clean install and when I try to scan for channels using Kaffeine
it gets nothing and displays the following:

fred@cartman:/media$ kaffeine
kbuildsycoca running...
Reusing existing ksycoca
/dev/dvb/adapter0/frontend0 : opened ( Zarlink MT352 DVB-T )
0 EPG plugins loaded for device 0:0.
Loaded epg data : 0 events (0 msecs)
fred@cartman:/media$ DvbCam::probe(): /dev/dvb/adapter0/ca0: : No such
file or directory
Using DVB device 0:0 "Zarlink MT352 DVB-T"
tuning DVB-T to 177500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
.FE_READ_STATUS: Remote I/O error

Transponders: 1/57
scanMode=0
it's dvb 2!

Invalid section length or timeout: pid=17


Invalid section length or timeout: pid=0

Frontend closed
Using DVB device 0:0 "Zarlink MT352 DVB-T"
tuning DVB-T to 184500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
.FE_READ_STATUS: Remote I/O error



/var/log/messages looks like:

Apr 27 21:52:36 cartman kernel: [   10.928721] bttv: driver version
0.9.17 loaded
Apr 27 21:52:36 cartman kernel: [   10.928726] bttv: using 8 buffers
with 2080k (520 pages) each for capture
Apr 27 21:52:36 cartman kernel: [   10.928782] bttv: Bt8xx card found (0).
Apr 27 21:52:36 cartman kernel: [   10.928802] bttv 0000:05:07.0: PCI
INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
Apr 27 21:52:36 cartman kernel: [   10.928812] bttv0: Bt878 (rev 17)
at 0000:05:07.0, irq: 17, latency: 32, mmio: 0xd2000000
Apr 27 21:52:36 cartman kernel: [   10.929515] bttv0: detected: Nebula
Electronics DigiTV [card=104], PCI subsystem ID is 0071:0101
Apr 27 21:52:36 cartman kernel: [   10.929520] bttv0: using: Nebula
Electronics DigiTV [card=104,autodetected]
Apr 27 21:52:36 cartman kernel: [   10.929654] bttv0: tuner absent
Apr 27 21:52:36 cartman kernel: [   10.929719] bttv0: registered device video1
Apr 27 21:52:36 cartman kernel: [   10.929742] bttv0: registered device vbi0
Apr 27 21:52:36 cartman kernel: [   10.929760] bttv0: PLL: 28636363 =>
35468950 .. ok
Apr 27 21:52:36 cartman kernel: [   10.961077] bttv0: add subdevice "dvb0"
Apr 27 21:52:36 cartman kernel: [   10.961206] input: bttv IR
(card=104) as /devices/pci0000:00/0000:00:
09.0/0000:05:07.0/input/input6
Apr 27 21:52:36 cartman kernel: [   10.994975] synaptics was reset on
resume, see synaptics_resume_reset if you have trouble on resume
Apr 27 21:52:36 cartman kernel: [   11.013425] bt878: AUDIO driver
version 0.0.0 loaded
Apr 27 21:52:36 cartman kernel: [   11.013628] bt878: Bt878 AUDIO
function found (0).
Apr 27 21:52:36 cartman kernel: [   11.013645] bt878 0000:05:07.1: PCI
INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
Apr 27 21:52:36 cartman kernel: [   11.013648] bt878_probe: card
id=[0x1010071],[ Nebula Electronics DigiTV ] has DVB functions.
Apr 27 21:52:36 cartman kernel: [   11.013655] bt878(0): Bt878 (rev
17) at 05:07.1, irq: 17, latency: 32, memory: 0xd2001000
Apr 27 21:52:36 cartman kernel: [   11.018482] scsi 6:0:0:0:
Direct-Access     VIA-P    VT6205-DevB      2.82 PQ: 0 ANSI: 2
Apr 27 21:52:36 cartman kernel: [   11.019101] scsi 6:0:0:1:
Direct-Access     VIA-P    VT6205-DevM      2.82 PQ: 0 ANSI: 2
Apr 27 21:52:36 cartman kernel: [   11.021611] sd 6:0:0:0: [sdc]
Attached SCSI removable disk
Apr 27 21:52:36 cartman kernel: [   11.021740] sd 6:0:0:0: Attached
scsi generic sg4 type 0
Apr 27 21:52:36 cartman kernel: [   11.022689] sd 6:0:0:1: [sdd]
Attached SCSI removable disk
Apr 27 21:52:36 cartman kernel: [   11.022772] sd 6:0:0:1: Attached
scsi generic sg5 type 0
Apr 27 21:52:36 cartman kernel: [   11.050652] DVB: registering new
adapter (bttv0)
Apr 27 21:52:36 cartman kernel: [   11.058791] usbcore: registered new
interface driver snd-usb-audio
Apr 27 21:52:36 cartman kernel: [   11.142234] ACPI: PCI Interrupt
Link [APCJ] enabled at IRQ 22
Apr 27 21:52:36 cartman kernel: [   11.142241] Intel ICH 0000:00:04.0:
PCI INT A -> Link[APCJ] -> GSI 22 (level, low) -> IRQ 22
Apr 27 21:52:36 cartman kernel: [   11.308995] DVB: registering
adapter 0 frontend 0 (Zarlink MT352 DVB-T)...
A
.
.
.
Apr 27 21:54:50 cartman kernel: [  149.693129] mt352_read_register:
readreg error (reg=137, ret==-6)
Apr 27 21:54:50 cartman kernel: [  149.693715] mt352_read_register:
readreg error (reg=138, ret==-6)
Apr 27 21:54:53 cartman kernel: [  152.692542] mt352_write() to reg 89
failed (err = -6)!
Apr 27 21:55:01 cartman kernel: [  160.599305] mt352_read_register:
readreg error (reg=137, ret==-6)
Apr 27 21:55:01 cartman kernel: [  160.599806] mt352_read_register:
readreg error (reg=138, ret==-6)
Apr 27 21:55:01 cartman kernel: [  160.600787] mt352_write() to reg 51
failed (err = -6)!
Apr 27 21:55:01 cartman kernel: [  160.601285] mt352_write() to reg 5d
failed (err = -6)!
Apr 27 21:55:01 cartman kernel: [  160.700793] mt352_read_register:
readreg error (reg=0, ret==-6)
Apr 27 21:55:02 cartman kernel: [  161.085569] mt352_read_register:
readreg error (reg=20, ret==-6)
Apr 27 21:55:02 cartman kernel: [  161.086069] mt352_read_register:
readreg error (reg=21, ret==-6)
Apr 27 21:55:02 cartman kernel: [  161.086867] mt352_read_register:
readreg error (reg=9, ret==-6)
Apr 27 21:55:02 cartman kernel: [  161.090498] mt352_read_register:
readreg error (reg=0, ret==-6)
Apr 27 21:55:02 cartman kernel: [  161.404535] mt352_read_register:
readreg error (reg=0, ret==-6)
Apr 27 21:55:02 cartman kernel: [  161.405039] mt352_write() to reg 51
failed (err = -6)!
Apr 27 21:55:02 cartman kernel: [  161.405536] mt352_write() to reg 5d
failed (err = -6)!


Any pointers how this may be resolved ?

Regards,
Steve

