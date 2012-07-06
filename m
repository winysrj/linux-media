Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41408 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab2GFXIY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 19:08:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SnHdM-0002DX-OL
	for linux-media@vger.kernel.org; Sat, 07 Jul 2012 01:08:20 +0200
Received: from btm70.neoplus.adsl.tpnet.pl ([83.29.158.70])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 07 Jul 2012 01:08:20 +0200
Received: from acc.for.news by btm70.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 07 Jul 2012 01:08:20 +0200
To: linux-media@vger.kernel.org
From: Marx <acc.for.news@gmail.com>
Subject: Re: pctv452e
Date: Sat, 07 Jul 2012 00:23:02 +0200
Message-ID: <835kc9-7p4.ln1@wuwek.kopernik.gliwice.pl>
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi> <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl> <4FF5A350.9070509@iki.fi> <r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl> <4FF6B121.6010105@iki.fi> <9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver doesn't work good.
I've took out the second card, so there is only pctv452e connected.
It worked the same way as usually.
At first driver was playing some SD channels (encrypted and FTA - no 
matter), it even played one HD channel for the first time ever, but 
after it it refused to play any more channels. I've restarted computer, 
but it didn't help.

Logs from boot:
Jul  6 18:22:11 wuwek kernel: [    5.948597] input: HD-Audio Generic 
HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.1/sound/card0/input3
Jul  6 18:22:11 wuwek kernel: [    6.121534] input: HDA ATI SB Line as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input4
Jul  6 18:22:11 wuwek kernel: [    6.121770] input: HDA ATI SB Rear Mic 
as /devices/pci0000:00/0000:00:14.2/sound/card1/input5
Jul  6 18:22:11 wuwek kernel: [    6.123094] input: HDA ATI SB Line Out 
CLFE as /devices/pci0000:00/0000:00:14.2/sound/card1/input6
Jul  6 18:22:11 wuwek kernel: [    6.125812] input: HDA ATI SB Line Out 
Surround as /devices/pci0000:00/0000:00:14.2/sound/card1/input7
Jul  6 18:22:11 wuwek kernel: [    6.126523] input: HDA ATI SB Line Out 
Front as /devices/pci0000:00/0000:00:14.2/sound/card1/input8
Jul  6 18:22:11 wuwek kernel: [    6.276933] usb 1-4: dvb_usbv2: found a 
'PCTV HDTV USB' in warm state
Jul  6 18:22:11 wuwek kernel: [    6.276945] pctv452e_power_ctrl: 1
Jul  6 18:22:11 wuwek kernel: [    6.277544] usbcore: registered new 
interface driver dvb_usb_pctv452e
Jul  6 18:22:11 wuwek kernel: [    6.278000] usb 1-4: dvb_usbv2: will 
pass the complete MPEG2 transport stream to the software demuxer
Jul  6 18:22:11 wuwek kernel: [    6.278041] DVB: registering new 
adapter (PCTV HDTV USB)
Jul  6 18:22:11 wuwek kernel: [    6.342525] stb0899_attach: Attaching 
STB0899
Jul  6 18:22:11 wuwek kernel: [    6.375893] DVB: registering adapter 0 
frontend 0 (STB0899 Multistandard)...
ul  6 18:22:11 wuwek kernel: [    6.399122] stb6100_attach: Attaching 
STB6100
Jul  6 18:22:11 wuwek kernel: [    6.399137] pctv452e_power_ctrl: 0
Jul  6 18:22:11 wuwek kernel: [    6.399152] usb 1-4: dvb_usbv2: 'PCTV 
HDTV USB' successfully initialized and connected
Jul  6 18:22:11 wuwek kernel: [    7.959465] Adding 2097148k swap on 
/dev/sda2.  Priority:-1 extents:1 across:2097148k
Jul  6 18:22:11 wuwek kernel: [    8.009082] EXT4-fs (sda1): re-mounted. 
Opts: (null)
Jul  6 18:22:11 wuwek kernel: [    8.393422] EXT4-fs (sda1): re-mounted. 
Opts: errors=remount-ro
Jul  6 18:22:11 wuwek kernel: [    8.507454] loop: module loaded
Jul  6 18:22:11 wuwek kernel: [    8.535684] nf_conntrack version 0.5.0 
(16384 buckets, 65536 max)
Jul  6 18:22:11 wuwek kernel: [    8.609385] w83627ehf: Found NCT6775F 
chip at 0x290
Jul  6 18:22:11 wuwek kernel: [    8.609767] hwmon_vid: Unknown VRM 
version of your x86 CPU
Jul  6 18:22:11 wuwek kernel: [   10.634908] EXT4-fs (sda3): mounted 
filesystem with ordered data mode. Opts: errors=remount-ro
Jul  6 18:22:11 wuwek kernel: [   10.715194] EXT4-fs (sda4): mounted 
filesystem with ordered data mode. Opts: errors=remount-ro
Jul  6 18:22:11 wuwek kernel: [   13.602684] Netfilter messages via 
NETLINK v0.30.
Jul  6 18:22:11 wuwek kernel: [   13.782616] ip_set: protocol 6
Jul  6 18:22:11 wuwek kernel: [   15.613353] xt_nfacct: Unknown symbol 
nfnl_acct_put (err 0)
Jul  6 18:22:11 wuwek kernel: [   15.613451] xt_nfacct: Unknown symbol 
nfnl_acct_update (err 0)
Jul  6 18:22:11 wuwek kernel: [   15.613522] xt_nfacct: Unknown symbol 
nfnl_acct_find_get (err 0)
Jul  6 18:22:11 wuwek kernel: [   16.475299] xt_time: kernel timezone is 
+0200
Jul  6 18:22:11 wuwek kernel: [   20.154987] ip_tables: (C) 2000-2006 
Netfilter Core Team
Jul  6 18:22:11 wuwek kernel: [   21.228305] ip6_tables: (C) 2000-2006 
Netfilter Core Team
Jul  6 18:22:11 wuwek kernel: [   22.182152] Bridge firewalling registered
Jul  6 18:22:11 wuwek kernel: [   22.685996] r8169 0000:04:00.0: eth6: 
link down
Jul  6 18:22:11 wuwek kernel: [   22.686014] r8169 0000:04:00.0: eth6: 
link down
Jul  6 18:22:11 wuwek kernel: [   22.686366] IPv6: ADDRCONF(NETDEV_UP): 
eth6: link is not ready
Jul  6 18:22:11 wuwek kernel: [   34.686600] r8169 0000:04:00.0: eth6: 
link up
Jul  6 18:22:11 wuwek kernel: [   34.687111] IPv6: 
ADDRCONF(NETDEV_CHANGE): eth6: link becomes ready
Jul  6 18:22:11 wuwek kernel: [   41.261271] RPC: Registered named UNIX 
socket transport module.
Jul  6 18:22:11 wuwek kernel: [   41.261279] RPC: Registered udp 
transport module.
Jul  6 18:22:11 wuwek kernel: [   41.261282] RPC: Registered tcp 
transport module.
Jul  6 18:22:11 wuwek kernel: [   41.261284] RPC: Registered tcp NFSv4.1 
backchannel transport module.
Jul  6 18:22:11 wuwek kernel: [   41.308018] FS-Cache: Loaded
Jul  6 18:22:11 wuwek kernel: [   41.361383] NFS: Registering the 
id_resolver key type
Jul  6 18:22:11 wuwek kernel: [   41.361424] Key type id_resolver registered
Jul  6 18:22:11 wuwek kernel: [   41.361441] FS-Cache: Netfs 'nfs' 
registered for caching
Jul  6 18:22:11 wuwek kernel: [   41.382507] Installing knfsd (copyright 
(C) 1996 okir@monad.swb.de).
Jul  6 18:22:11 wuwek kernel: [   42.230080] fuse init (API version 7.19)
Jul  6 18:22:12 wuwek kernel: [   44.555179] Bluetooth: Core ver 2.16
Jul  6 18:22:12 wuwek kernel: [   44.555244] NET: Registered protocol 
family 31
Jul  6 18:22:12 wuwek kernel: [   44.555250] Bluetooth: HCI device and 
connection manager initialized
Jul  6 18:22:12 wuwek kernel: [   44.555258] Bluetooth: HCI socket layer 
initialized
Jul  6 18:22:12 wuwek kernel: [   44.555264] Bluetooth: L2CAP socket 
layer initialized
Jul  6 18:22:12 wuwek kernel: [   44.555277] Bluetooth: SCO socket layer 
initialized
Jul  6 18:22:12 wuwek kernel: [   44.563557] Bluetooth: RFCOMM TTY layer 
initialized
Jul  6 18:22:12 wuwek kernel: [   44.563574] Bluetooth: RFCOMM socket 
layer initialized
Jul  6 18:22:12 wuwek kernel: [   44.563580] Bluetooth: RFCOMM ver 1.11
Jul  6 18:22:12 wuwek kernel: [   44.607847] Bluetooth: BNEP (Ethernet 
Emulation) ver 1.3
Jul  6 18:22:12 wuwek kernel: [   44.607859] Bluetooth: BNEP filters: 
protocol multicast
Jul  6 18:22:37 wuwek kernel: [   68.930295] pctv452e_power_ctrl: 1
Jul  6 18:22:38 wuwek kernel: [   70.193508] I2C error -121; AA 0B  CC 
00 01 -> 55 0B  CC 00 00.
Jul  6 18:22:38 wuwek kernel: [   70.206124] I2C error -121; AA 22  CC 
00 01 -> 55 22  CC 00 00.
Jul  6 18:22:38 wuwek kernel: [   70.265624] I2C error -121; AA 3D  CC 
00 01 -> 55 3D  CC 00 00.
Jul  6 18:22:39 wuwek kernel: [   71.089388] I2C error -121; AA 2E  CC 
00 01 -> 55 2E  CC 00 00.
Jul  6 18:22:39 wuwek kernel: [   71.102003] I2C error -121; AA 45  CC 
00 01 -> 55 45  CC 00 00.
Jul  6 18:22:39 wuwek kernel: [   71.161129] I2C error -121; AA 60  CC 
00 01 -> 55 60  CC 00 00.
Jul  6 18:22:40 wuwek kernel: [   71.988892] I2C error -121; AA 51  CC 
00 01 -> 55 51  CC 00 00.
Jul  6 18:22:40 wuwek kernel: [   72.001508] I2C error -121; AA 68  CC 
00 01 -> 55 68  CC 00 00.
Jul  6 18:22:40 wuwek kernel: [   72.060753] I2C error -121; AA 83  CC 
00 01 -> 55 83  CC 00 00.
Jul  6 18:22:41 wuwek kernel: [   72.888518] I2C error -121; AA 74  CC 
00 01 -> 55 74  CC 00 00.
Jul  6 18:22:41 wuwek kernel: [   72.901013] I2C error -121; AA 8B  CC 
00 01 -> 55 8B  CC 00 00.
Jul  6 18:22:41 wuwek kernel: [   72.960507] I2C error -121; AA A6  CC 
00 01 -> 55 A6  CC 00 00.
Jul  6 18:22:42 wuwek kernel: [   73.788147] I2C error -121; AA 97  CC 
00 01 -> 55 97  CC 00 00.
Jul  6 18:22:42 wuwek kernel: [   73.801143] I2C error -121; AA AE  CC 
00 01 -> 55 AE  CC 00 00.


HD channels desire better signal, but i'm sure signal is ok because it's 
twin setup and on second port I have traditional tuner which works ok 
with all channels.

Original problem - it's rather long story. To say it short: I have 4 DVB 
tuners and none of them works reliable. I'm able to make each of them 
recognized, scan channels etc. To concentrate on pctv452e: it works from 
the beginning the same way as I've written above. It outputs endlessly 
i2c errors, usually allows to switch 4-5 times channels and then it 
stops working. What is strange - scan works, szap2 works on some 
channels, on others doesn't work.

Let's get for example FTA channel Mango 24.
Mango 24;TVN:11393:v:S13.0E:27500:517=2:700=pol@4:581:0:4316:318:1000:0

wuwek:~# szap -n 51 -r
reading channels from file '/root/.szap/channels.conf'
zapping to 51 'Mango 24;TVN':
sat 0, frequency = 11393 MHz V, symbolrate 27500000, vpid = 0x0205, apid 
= 0x02bc sid = 0x0245
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01c6 | snr 0095 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1f | signal 01c6 | snr 0094 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1f | signal 01c6 | snr 0095 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1f | signal 01c6 | snr 0094 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK

but it doesn't now play in VDR.

Unplug and plug again USB cable:
Jul  7 00:05:53 wuwek kernel: [20664.576589] pctv452e_power_ctrl: 0
Jul  7 00:06:08 wuwek kernel: [20679.752198] usb 1-4: USB disconnect, 
device number 2
Jul  7 00:06:08 wuwek kernel: [20679.752728] usb 1-4: dvb_usbv2: 
usb_bulk_msg() failed=-19
Jul  7 00:06:08 wuwek kernel: [20679.752779] I2C error -19; AA E6  10 04 
00 -> AA E6  10 04 00.
Jul  7 00:06:08 wuwek kernel: [20679.752876] usb 1-4: dvb_usbv2: 
usb_bulk_msg() failed=-19
Jul  7 00:06:08 wuwek kernel: [20679.752909] I2C error -19; AA E7  D0 03 
00 -> AA E7  D0 03 00.

Device isn't recognized. Again the same:

Jul  7 00:09:29 wuwek kernel: [20880.538582] INFO: task khubd:83 blocked 
for more than 120 seconds.
Jul  7 00:09:29 wuwek kernel: [20880.538624] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  7 00:09:29 wuwek kernel: [20880.538669] khubd           D f72fe064 
     0    83      2 0x00000000
Jul  7 00:09:29 wuwek kernel: [20880.538683]  f5bf4180 00000046 00000000 
f72fe064 c1115e10 f6e13208 c14989c0 c14989c0
Jul  7 00:09:29 wuwek kernel: [20880.538704]  f6d774c0 f71b1600 f6d774c0 
f71b1608 f6d774c0 00000282 f6cbe1e0 f71b1600
Jul  7 00:09:29 wuwek kernel: [20880.538723]  f6cbe1e0 f6d77540 00000246 
c12d22a6 00000246 00000246 c104408a 00000002
Jul  7 00:09:29 wuwek kernel: [20880.538742] Call Trace:
Jul  7 00:09:29 wuwek kernel: [20880.538763]  [<c1115e10>] ? 
remove_dir+0x20/0x25
Jul  7 00:09:29 wuwek kernel: [20880.538780]  [<c12d22a6>] ? 
_raw_spin_lock_irqsave+0x11/0x30
Jul  7 00:09:29 wuwek kernel: [20880.538797]  [<c104408a>] ? 
prepare_to_wait+0x57/0x5f
Jul  7 00:09:29 wuwek kernel: [20880.538880]  [<f8542751>] ? 
dvb_dmxdev_release+0x5a/0xf0 [dvb_core]
Jul  7 00:09:29 wuwek kernel: [20880.538895]  [<c1043f3e>] ? 
bit_waitqueue+0x47/0x47
Jul  7 00:09:29 wuwek kernel: [20880.538926]  [<f84b46c1>] ? 
dvb_usb_adapter_dvb_exit+0x31/0x48 [dvb_usbv2]
Jul  7 00:09:29 wuwek kernel: [20880.538956]  [<f84b5055>] ? 
dvb_usbv2_disconnect+0xc9/0x128 [dvb_usbv2]
Jul  7 00:09:29 wuwek kernel: [20880.539025]  [<c1206845>] ? 
rpm_suspend+0x3ed/0x3ed
Jul  7 00:09:29 wuwek kernel: [20880.539038]  [<c120721b>] ? 
pm_schedule_suspend+0x8e/0x8e
Jul  7 00:09:29 wuwek kernel: [20880.539113]  [<f82564da>] ? 
usb_unbind_interface+0x46/0x106 [usbcore]
Jul  7 00:09:29 wuwek kernel: [20880.539147]  [<c120070f>] ? 
__device_release_driver+0x60/0x97
Jul  7 00:09:29 wuwek kernel: [20880.539160]  [<c120075b>] ? 
device_release_driver+0x15/0x1e
Jul  7 00:09:29 wuwek kernel: [20880.539173]  [<c120020b>] ? 
bus_remove_device+0xa1/0xb0
Jul  7 00:09:29 wuwek kernel: [20880.539185]  [<c11feb9a>] ? 
device_del+0xe6/0x130
Jul  7 00:09:29 wuwek kernel: [20880.539236]  [<f8254d02>] ? 
usb_disable_device+0x56/0x13a [usbcore]
Jul  7 00:09:29 wuwek kernel: [20880.539283]  [<f824f99d>] ? 
usb_disconnect+0x61/0xb2 [usbcore]
Jul  7 00:09:29 wuwek kernel: [20880.539331]  [<f8250e2e>] ? 
hub_thread+0x4bd/0xc72 [usbcore]
Jul  7 00:09:29 wuwek kernel: [20880.539346]  [<c1043f3e>] ? 
bit_waitqueue+0x47/0x47
Jul  7 00:09:29 wuwek kernel: [20880.539393]  [<f8250971>] ? 
usb_remote_wakeup+0x25/0x25 [usbcore]
Jul  7 00:09:29 wuwek kernel: [20880.539406]  [<c1043cb9>] ? 
kthread+0x69/0x6e
Jul  7 00:09:29 wuwek kernel: [20880.539420]  [<c1043c50>] ? 
kthread_worker_fn+0x106/0x106
Jul  7 00:09:29 wuwek kernel: [20880.539433]  [<c12d70fe>] ? 
kernel_thread_helper+0x6/0x10

Reboot doesn't help either. While device registered correctly, it still 
doesnt work in VDR. I was trying to disconnect USB and power from 
device, and then reconnect - didn't help.
So while it was working at the morning for a while, I didn't change 
anything important and now it doesn't work at all.
I suspect that if I disconnect device for a longer time, reboot, it will 
work for a few minutes as usually.

I don't know what can i do next.
Marx

