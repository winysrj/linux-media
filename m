Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60143 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab1LQT7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 14:59:38 -0500
Received: by ggdk6 with SMTP id k6so3432997ggd.19
        for <linux-media@vger.kernel.org>; Sat, 17 Dec 2011 11:59:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALJK-QjChFbX7NH0qNhvaz=Hp8JfKENJMsLOsETiYO9ZyV_BOg@mail.gmail.com>
References: <CALJK-QhGrjC9K8CasrUJ-aisZh8U_4-O3uh_-dq6cNBWUx_4WA@mail.gmail.com>
	<4EE9AA21.1060101@gmail.com>
	<CALJK-QjxDpC8Y_gPXeAJaT2si_pRREiuTW=T8CWSTxGprRhfkg@mail.gmail.com>
	<4EEAFF47.5040003@gmail.com>
	<CALJK-Qhpk7NtSezrft_6+4FZ7Y35k=41xrc6ebxf2DzEH6KCWw@mail.gmail.com>
	<4EECB2C2.8050701@gmail.com>
	<4EECE392.5080000@gmail.com>
	<CALJK-QjChFbX7NH0qNhvaz=Hp8JfKENJMsLOsETiYO9ZyV_BOg@mail.gmail.com>
Date: Sat, 17 Dec 2011 21:59:37 +0200
Message-ID: <CALJK-QjZ92zTXwTBs-vUc7RN0AT+aUKMi0H5M5GEgKBXYpBgZw@mail.gmail.com>
Subject: Re: Hauppauge HVR-930C problems
From: Mihai Dobrescu <msdobrescu@gmail.com>
To: Fredrik Lingvall <fredrik.lingvall@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 17, 2011 at 9:53 PM, Mihai Dobrescu <msdobrescu@gmail.com> wrote:
> On Sat, Dec 17, 2011 at 8:46 PM, Fredrik Lingvall
> <fredrik.lingvall@gmail.com> wrote:
>> On 12/17/11 16:18, Fredrik Lingvall wrote:
>>
>> On 12/16/11 19:35, Mihai Dobrescu wrote:
>>
>> Please excuse the dumbness of the question, but, could you direct me
>> to the repository having these patches applied?
>>
>>
>> No it's not a dumpness question - I have struggeled with this too.
>>
>> First I got confused which kernel source to use. There are two git repos
>> mentioned on the linuxtv.org site:
>>
>> 1) on http://linuxtv.org/repo/
>>
>> ~ # git clone
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git v4l-dvb
>>
>> and 2) on http://git.linuxtv.org/media_tree.git
>>
>> ~ # git clone git://github.com/torvalds/linux.git v4l-dvb
>>
>>
>> I'm also a bit confused on how to get the linux-media tree. My guess was to
>> do a
>>
>>  # cd v4l-dvb
>>  # git remote add linuxtv git://linuxtv.org/media_tree.git
>>  # git remote update
>>
>>
>> They also now and then create tar-files, and right know I'm testing the one
>> from 2011-12-13, That is,
>>
>> ~ # cd /usr/src
>> src # git clone git://github.com/torvalds/linux.git v4l-dvb
>> src # wget
>> http://linuxtv.org/downloads/drivers/linux-media-2011-12-13.tar.bz2
>> src # cd v4l-dvb
>> v4l-dvb # tar xvjf ../linux-media-2011-12-13.tar.bz2
>>
>> Then configure and build the kernel:make menuconfig (enable the drivers
>> etc), make -j2 && make modules_install & make install
>> and add the new kernel to lilo/grub etc and reboot.
>>
>> The media tree don't build cleanly on the stock Gentoo kernel (3.0.6) so
>> that's why I'm using Linux' dev kernel (which is the one recommended on
>> Linuxtv). However, not everything works with this kernel (I can't emerge
>> virtualbox for example).
>>
>> /Fredrik
>>
>> Mihai,
>>
>> I got some success. I did this,
>>
>> # cd /usr/src (for example)
>>
>> # git clone git://linuxtv.org/media_build.git
>>
>> # emerge dev-util/patchutils
>> # emerge Proc-ProcessTable
>>
>> # cd media_build
>> # ./build
>> # make install
>>
>> Which will install the latest driver on your running kernel (just in case
>> make sure /usr/src/linux points to your running kernel sources). Then
>> reboot.
>>
>> You should now see that (among other) modules have loaded:
>>
>> # lsmod
>>
>> <snip>
>>
>> em28xx                 93528  1 em28xx_dvb
>> v4l2_common             5254  1 em28xx
>> videobuf_vmalloc        4167  1 em28xx
>> videobuf_core          15151  2 em28xx,videobuf_vmalloc
>>
>> Then try w_scan and dvbscan etc. I got mythtv to scan too now. There were
>> some warnings and timeouts and I'm not sure if this is normal or not.
>>
>> You can also do a dmesg -c while scanning to monitor the changes en the
>> kernel log.
>>
>> Regards,
>>
>> /Fredrik
>>
>>
>
> In my case I have:
>
> lsmod |grep em2
> em28xx_dvb             12608  0
> dvb_core               76187  1 em28xx_dvb
> em28xx                 82436  1 em28xx_dvb
> v4l2_common             5087  1 em28xx
> videodev               70123  2 em28xx,v4l2_common
> videobuf_vmalloc        3783  1 em28xx
> videobuf_core          12991  2 em28xx,videobuf_vmalloc
> rc_core                11695  11
> rc_hauppauge,ir_lirc_codec,ir_mce_kbd_decoder,ir_sanyo_decoder,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,em28xx,ir_nec_decoder
> tveeprom               12441  1 em28xx
> i2c_core               14232  9
> xc5000,drxk,em28xx_dvb,em28xx,v4l2_common,videodev,tveeprom,nvidia,i2c_i801
>
> yet, w_scan founds nothing.

Additionally: dmesg -c

[139676.064539] usb 1-4: new high speed USB device number 8 using ehci_hcd
[139676.180076] usb 1-4: New USB device found, idVendor=2040, idProduct=1605
[139676.180081] usb 1-4: New USB device strings: Mfr=0, Product=1,
SerialNumber=2
[139676.180085] usb 1-4: Product: WinTV HVR-930C
[139676.180087] usb 1-4: SerialNumber: 4034564214
[139676.646185] WARNING: You are using an experimental version of the
media stack.
[139676.646187]         As the driver is backported to an older
kernel, it doesn't offer
[139676.646188]         enough quality for its usage in production.
[139676.646189]         Use it with care.
[139676.646190] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[139676.646192]         bcc072756e4467dc30e502a311b1c3adec96a0e4
[media] STV0900: Query DVB frontend delivery capabilities
[139676.646193]         6bad3aeb8cc542b90ae62b35caca44305cd93ef5
[media] STV090x: Query DVB frontend delivery capabilities
[139676.646195]         61d4f9c918c591e4f7970ef29bafb302664be466
[media] STB0899: Query DVB frontend delivery capabilities
[139676.660297] IR NEC protocol handler initialized
[139676.680225] Linux media interface: v0.10
[139676.683437] Linux video capture interface: v2.00
[139676.683440] WARNING: You are using an experimental version of the
media stack.
[139676.683442]         As the driver is backported to an older
kernel, it doesn't offer
[139676.683443]         enough quality for its usage in production.
[139676.683444]         Use it with care.
[139676.683444] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[139676.683446]         bcc072756e4467dc30e502a311b1c3adec96a0e4
[media] STV0900: Query DVB frontend delivery capabilities
[139676.683447]         6bad3aeb8cc542b90ae62b35caca44305cd93ef5
[media] STV090x: Query DVB frontend delivery capabilities
[139676.683449]         61d4f9c918c591e4f7970ef29bafb302664be466
[media] STB0899: Query DVB frontend delivery capabilities
[139676.696111] em28xx: New device WinTV HVR-930C @ 480 Mbps
(2040:1605, interface 0, class 0)
[139676.696114] em28xx: Audio Vendor Class interface 0 found
[139676.696194] em28xx #0: chip ID is em2884
[139676.703415] IR RC5(x) protocol handler initialized
[139676.705418] IR RC6 protocol handler initialized
[139676.710803] IR JVC protocol handler initialized
[139676.712494] IR Sony protocol handler initialized
[139676.714320] IR SANYO protocol handler initialized
[139676.716281] IR MCE Keyboard/mouse protocol handler initialized
[139676.718857] lirc_dev: IR Remote Control driver registered, major 242
[139676.719402] IR LIRC bridge handler initialized
[139676.748897] em28xx #0: Identified as Hauppauge WinTV HVR 930C (card=81)
[139676.774076] Registered IR keymap rc-hauppauge
[139676.774197] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1a.7/usb1/1-4/rc/rc0/input11
[139676.774296] rc0: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1a.7/usb1/1-4/rc/rc0
[139676.774774] em28xx #0: Config register raw data: 0x80
[139676.774777] em28xx #0: v4l2 driver version 0.1.3
[139676.779864] em28xx #0: V4L2 video device registered as video0
[139676.779930] usbcore: registered new interface driver em28xx
[139676.779933] em28xx driver loaded
[139676.797250] WARNING: You are using an experimental version of the
media stack.
[139676.797251]         As the driver is backported to an older
kernel, it doesn't offer
[139676.797252]         enough quality for its usage in production.
[139676.797253]         Use it with care.
[139676.797253] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[139676.797254]         bcc072756e4467dc30e502a311b1c3adec96a0e4
[media] STV0900: Query DVB frontend delivery capabilities
[139676.797255]         6bad3aeb8cc542b90ae62b35caca44305cd93ef5
[media] STV090x: Query DVB frontend delivery capabilities
[139676.797256]         61d4f9c918c591e4f7970ef29bafb302664be466
[media] STB0899: Query DVB frontend delivery capabilities
[139677.984918] drxk: detected a drx-3913k, spin A2, xtal 20.250 MHz
[139678.023334] drxk: Could not load firmware file
dvb-usb-hauppauge-hvr930c-drxk.fw.
[139678.023339] drxk: Copy dvb-usb-hauppauge-hvr930c-drxk.fw to your
hotplug directory!
[139678.060239] DRXK driver version 0.9.4300
[139678.085891] xc5000 5-0061: creating new instance
[139678.086696] xc5000: Successfully identified at address 0x61
[139678.086699] xc5000: Firmware has not been loaded previously
[139678.086703] DVB: registering new adapter (em28xx #0)
[139678.086707] DVB: registering adapter 0 frontend 0 (DRXK DVB-C)...
[139678.086814] DVB: registering adapter 0 frontend 1 (DRXK DVB-T)...
[139678.087344] em28xx #0: Successfully loaded em28xx-dvb
[139678.087351] Em28xx: Initialized (Em28xx dvb Extension) extension

[139814.622283] xc5000: waiting for firmware upload
(dvb-fe-xc5000-1.6.114.fw)...
[139814.656121] xc5000: firmware read 12401 bytes.
[139814.656125] xc5000: firmware uploading...
[139815.023695] xc5000: firmware upload complete...

...  and many lines like this:

[139821.805077] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[139821.805081] drxk: 02 00 00 00 10 00 05 00 03 02
..........
[139824.283290] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[139824.283295] drxk: 02 00 00 00 10 00 05 00 03 02
..........
[139826.832503] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[139826.832508] drxk: 02 00 00 00 10 00 05 00 03 02
..........
[139829.358709] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[139829.358714] drxk: 02 00 00 00 10 00 05 00 03 02
..........
[139831.903899] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[139831.903904] drxk: 02 00 00 00 10 00 05 00 03 02
..........
[139834.436225] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[139834.436230] drxk: 02 00 00 00 10 00 05 00 03 02
..........
[139836.973273] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[139836.973279] drxk: 02 00 00 00 10 00 05 00 03 02
..........
[139839.512616] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[139839.512621] drxk: 02 00 00 00 10 00 05 00 03 02
..........
[139842.050811] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[139842.050816] drxk: 02 00 00 00 10 00 05 00 03 02
..........
