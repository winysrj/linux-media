Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:26050 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbZKBN2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 08:28:30 -0500
Received: by ey-out-2122.google.com with SMTP id d26so392072eyd.19
        for <linux-media@vger.kernel.org>; Mon, 02 Nov 2009 05:28:34 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 2 Nov 2009 13:28:33 +0000
Message-ID: <b3a495710911020528oe1df259yad30f3fb5f7868b4@mail.gmail.com>
Subject: 1164:1f08 YUAN High-Tech STK7700PH kernel crash in Ubuntu 9.10
From: Patrick Byrne <pjlbyrne@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have an Aopen MP45-DR mini-pc. I am trying to get a DVB-T card
working in it. The DVB card is a Mini-PCI express card. It fits on a
minicard slot inside the pc.

I can activate the 'Firmware for DVB cards' in the Hardware Drivers applet:

Oct 24 10:59:14 wulf kernel: [ 121.660518] usbcore: deregistering
interface driver dvb_usb_dib0700
Oct 24 10:59:14 wulf kernel: [ 121.692684] xc2028 6-0061: destroying instance
Oct 24 10:59:14 wulf kernel: [ 121.692899] dvb-usb: YUAN High-Tech
STK7700PH successfully deinitialized and disconnected.
Oct 24 10:59:14 wulf kernel: [ 121.830020] dib0700: loaded with
support for 9 different device-types
Oct 24 10:59:14 wulf kernel: [ 121.830217] dvb-usb: found a 'YUAN
High-Tech STK7700PH' in warm state.
Oct 24 10:59:14 wulf kernel: [ 121.830249] dvb-usb: will pass the
complete MPEG2 transport stream to the software demuxer.
Oct 24 10:59:14 wulf kernel: [ 121.830526] DVB: registering new
adapter (YUAN High-Tech STK7700PH)
Oct 24 10:59:14 wulf kernel: [ 122.073837] DVB: registering adapter 0
frontend 0 (DiBcom 7000PC)...
Oct 24 10:59:14 wulf kernel: [ 122.074000] xc2028 6-0061: creating new instance
Oct 24 10:59:14 wulf kernel: [ 122.074002] xc2028 6-0061: type set to
XCeive xc2028/xc3028 tuner
Oct 24 10:59:14 wulf kernel: [ 122.074061] input: IR-receiver inside
an USB DVB receiver as
/devices/pci0000:00/0000:00:1a.7/usb1/1-6/input/input8
Oct 24 10:59:14 wulf kernel: [ 122.074085] dvb-usb: schedule remote
query interval to 50 msecs.
Oct 24 10:59:14 wulf kernel: [ 122.074088] dvb-usb: YUAN High-Tech
STK7700PH successfully initialized and connected.
Oct 24 10:59:14 wulf kernel: [ 122.074223] usbcore: registered new
interface driver dvb_usb_dib0700

When I try to run dvbscan (or scan, or w_scan) I get this kernel crash:

Oct 24 11:00:16 wulf kernel: [ 183.791444] *pde = bb6dc067
Oct 24 11:00:16 wulf kernel: [ 183.791456] Modules linked in:
dvb_usb_dib0700 dib7000p dib7000m dvb_usb dvb_core dib3000mc
dibx000_common dib0070 binfmt_misc ppdev tuner_xc2028
snd_hda_codec_intelhdmi snd_hda_codec_realtek iptable_filter ip_tables
x_tables snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device
psmouse serio_raw snd soundcore snd_page_alloc lirc_mceusb lirc_dev lp
parport fbcon tileblit font bitblit softcursor usbhid i915 drm
i2c_algo_bit video output e1000e intel_agp agpgart [last unloaded:
dib0070]
Oct 24 11:00:16 wulf kernel: [ 183.791510]
Oct 24 11:00:16 wulf kernel: [ 183.791514] Pid: 1951, comm:
kdvb-ad-0-fe-0 Not tainted (2.6.31-14-generic #48-Ubuntu) i45GMx-I
Oct 24 11:00:16 wulf kernel: [ 183.791518] EIP: 0060:[<c03a8a13>]
EFLAGS: 00010202 CPU: 1
Oct 24 11:00:16 wulf kernel: [ 183.791522] EIP is at
_request_firmware+0x1f3/0x250
Oct 24 11:00:16 wulf kernel: [ 183.791525] EAX: 00000000 EBX: f5f62070
ECX: 00000001 EDX: c07068ec
Oct 24 11:00:16 wulf kernel: [ 183.791528] ESI: c07179ac EDI: f5c4fa70
EBP: f6419d30 ESP: f6419cfc
Oct 24 11:00:16 wulf kernel: [ 183.791536] DS: 007b ES: 007b FS: 00d8
GS: 00e0 SS: 0068
Oct 24 11:00:16 wulf kernel: [ 183.791541] 80000200 f6980c00 000000c0
03400000 00000006 f6419d69 00000006 00000000
Oct 24 11:00:16 wulf kernel: [ 183.791547] <0> f6419d94 fa614062
f4483900 00000000 00000000 f6419d3c c03a8b12 00000001
Oct 24 11:00:16 wulf kernel: [ 183.791552] <0> f6419dcc f84bc741
f6419e78 fa61485b 00000002 00000002 f55f86a8 f55f8000
Oct 24 11:00:16 wulf kernel: [ 183.791564] [<fa614062>] ?
dib0700_ctrl_wr+0x52/0x70 [dvb_usb_dib0700]
Oct 24 11:00:16 wulf kernel: [ 183.791567] [<c03a8b12>] ?
request_firmware+0x12/0x20
Oct 24 11:00:16 wulf kernel: [ 183.791572] [<f84bc741>] ?
load_all_firmwares+0x61/0x6b0 [tuner_xc2028]
Oct 24 11:00:16 wulf kernel: [ 183.791576] [<fa61485b>] ?
dib0700_i2c_xfer_legacy+0x17b/0x1a0 [dvb_usb_dib0700]
Oct 24 11:00:16 wulf kernel: [ 183.791581] [<fa614062>] ?
dib0700_ctrl_wr+0x52/0x70 [dvb_usb_dib0700]
Oct 24 11:00:16 wulf kernel: [ 183.791585] [<fa61485b>] ?
dib0700_i2c_xfer_legacy+0x17b/0x1a0 [dvb_usb_dib0700]
Oct 24 11:00:16 wulf kernel: [ 183.791589] [<f84bd68b>] ?
check_firmware+0x45b/0x870 [tuner_xc2028]
Oct 24 11:00:16 wulf kernel: [ 183.791593] [<f84bdb05>] ?
generic_set_freq+0x65/0x500 [tuner_xc2028]
Oct 24 11:00:16 wulf kernel: [ 183.791597] [<fa61489b>] ?
dib0700_i2c_xfer+0x1b/0x30 [dvb_usb_dib0700]
Oct 24 11:00:16 wulf kernel: [ 183.791601] [<c043c634>] ? i2c_transfer+0x94/0xc0
Oct 24 11:00:16 wulf kernel: [ 183.791605] [<fa5fd074>] ?
dib7000p_write_word+0x54/0x70 [dib7000p]
Oct 24 11:00:16 wulf kernel: [ 183.791609] [<f84be275>] ?
xc2028_set_params+0x185/0x276 [tuner_xc2028]
Oct 24 11:00:16 wulf kernel: [ 183.791613] [<fa5ff29b>] ?
dib7000p_set_frontend+0x4b/0x170 [dib7000p]
Oct 24 11:00:16 wulf kernel: [ 183.791617] [<c0150485>] ?
try_to_del_timer_sync+0x45/0x50
Oct 24 11:00:16 wulf kernel: [ 183.791626] [<fa5c8a41>] ?
dvb_frontend_swzigzag_autotune+0x111/0x260 [dvb_core]
Oct 24 11:00:16 wulf kernel: [ 183.791630] [<c013c347>] ?
try_to_wake_up+0xf7/0x350
Oct 24 11:00:16 wulf kernel: [ 183.791637] [<fa5c9601>] ?
dvb_frontend_swzigzag+0x1d1/0x260 [dvb_core]
Oct 24 11:00:16 wulf kernel: [ 183.791643] [<fa5ca007>] ?
dvb_frontend_thread+0x387/0x630 [dvb_core]
Oct 24 11:00:16 wulf kernel: [ 183.791647] [<c015c280>] ?
autoremove_wake_function+0x0/0x40
Oct 24 11:00:16 wulf kernel: [ 183.791654] [<fa5c9c80>] ?
dvb_frontend_thread+0x0/0x630 [dvb_core]
Oct 24 11:00:16 wulf kernel: [ 183.791657] [<c015bf8c>] ? kthread+0x7c/0x90
Oct 24 11:00:16 wulf kernel: [ 183.791659] [<c015bf10>] ? kthread+0x0/0x90
Oct 24 11:00:16 wulf kernel: [ 183.791662] [<c0104007>] ?
kernel_thread_helper+0x7/0x10
Oct 24 11:00:16 wulf kernel: [ 183.791703] ---[ end trace 47864f2e99ae2e14 ]---
Oct 24 11:02:11 wulf kerneloops-submit: Submitted 1 kernel oopses to
www.kerneloops.org
Oct 24 11:02:11 wulf kerneloops-submit: kerneloops.org: oops is posted
as http://www.kerneloops.org/submitresult.php?number=839270

Here is the output from w_scan:

 w_scan -c gb
w_scan version 20090808 (compiled for DVB API 5.0)
using settings for UNITED KINGDOM
DVB aerial
DVB-T GB
frontend_type DVB-T, channellist 6
output format vdr-1.6
Info: using DVB adapter auto detection.
 /dev/dvb/adapter0/frontend0 -> DVB-T "DiBcom 7000PC": good :-)
Using DVB-T frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.0
frontend DiBcom 7000PC supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
FEC_AUTO
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
Scanning 7MHz frequencies...
177500: (time: 00:00)

This is a fresh install of Ubuntu 9,10 a few hours ago.

ProblemType: KernelOops
Annotation: Your system might become unstable now and might need to be
restarted.
Architecture: i386
AudioDevicesInUse:
 USER PID ACCESS COMMAND
 /dev/snd/controlC0: pat 1496 F.... pulseaudio
CRDA: Error: [Errno 2] No such file or directory
Card0.Amixer.info:
 Card hw:0 'Intel'/'HDA Intel at 0xfdff4000 irq 22'
   Mixer name : 'Intel G45 DEVCTG'
   Components : 'HDA:10ec0888,a0a00647,00100001 HDA:80862802,80860101,00100000'
   Controls : 27
   Simple ctrls : 14
Date: Sat Oct 24 11:00:22 2009
DistroRelease: Ubuntu 9.10
Failure: oops
HibernationDevice: RESUME=UUID=6de8f1e4-8510-4f2e-9f75-eb9a7992b34d
InstallationMedia: Ubuntu 9.10 "Karmic Koala" - Release Candidate i386
(20091020.3)
IwConfig:
 lo no wireless extensions.

 eth0 no wireless extensions.
MachineType: AOpen i45GMx-I
Package: linux-image-2.6.31-14-generic 2.6.31-14.48
ProcCmdLine: BOOT_IMAGE=/boot/vmlinuz-2.6.31-14-generic
root=UUID=ce3bd47d-2d08-42c4-9663-d4237cfd580e ro quiet splash
ProcVersionSignature: Ubuntu 2.6.31-14.48-generic
RelatedPackageVersions:
 linux-backports-modules-2.6.31-14-generic N/A
 linux-firmware 1.24
RfKill:

SourcePackage: linux
Tags: kernel-oops
Title: BUG: unable to handle kernel NULL pointer dereference at 00000008
Uname: Linux 2.6.31-14-generic i686
dmi.bios.date: 12/05/2008
dmi.bios.vendor: Phoenix Technologies, LTD
dmi.bios.version: 6.00 PG
dmi.board.asset.tag: None
dmi.board.name: i45GMx-I
dmi.board.vendor: AOpen
dmi.board.version: 558EX10IG90
dmi.chassis.type: 3
dmi.chassis.vendor: AOpen
dmi.chassis.version: i45GMx-I
dmi.modalias: dmi:bvnPhoenixTechnologies,LTD:bvr6.00PG:bd12/05/2008:svnAOpen:pni45GMx-I:pvrNone:rvnAOpen:rni45GMx-I:rvr558EX10IG90:cvnAOpen:ct3:cvri45GMx-I:
dmi.product.name: i45GMx-I
dmi.product.version: None
dmi.sys.vendor: AOpen








I have registered this bug in launchpad
  https://bugs.launchpad.net/ubuntu/+source/linuxtv-dvb-apps/+bug/459677
but it doesn't seem to be getting any attention.

Can someone here please help, or advise, or direct me to where I might
get advice?

Thanks

Patrick Byrne
