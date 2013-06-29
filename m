Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57398 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab3F2T57 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Jun 2013 15:57:59 -0400
Received: from mailout-de.gmx.net ([10.1.76.20]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LkDn2-1UHCgu12Ec-00c9SD for
 <linux-media@vger.kernel.org>; Sat, 29 Jun 2013 21:57:58 +0200
Message-ID: <1372535877.2338.14.camel@nicisha>
Subject: occasional problems with Technotrend TT-connect CT3650+CI
From: Martin Maurer <martinmaurer@gmx.at>
To: linux-media@vger.kernel.org
Date: Sat, 29 Jun 2013 21:57:57 +0200
Content-Type: multipart/mixed; boundary="=-HwpM5r8A21QCXRtqWXms"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-HwpM5r8A21QCXRtqWXms
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Hi all,

I use the card CT3650 with the CI slot together with Mythtv (USB Card
with integrated CI slot). Mostly this works fine, but every few
recordings of encrypted programs fail. The logs hint that there is some
problem with the CI initialization. Mythtv apparently doesn't correctly
detect that the recording failed, as the recording remains marked as
"Still recording" in the web-interface. The file size is 0 bytes.
After such a recording fails it usually happens, that the next recording
is fine again without any intervention by me.

I already replaced the USB cable by another one to rule this out. Don't
want to replace the card unless I am sure that it is faulty.

Some data:
I am using Ubuntu 12.04.2 LTS
uname -a: Linux ashanta 3.5.0-26-generic #42~precise1-Ubuntu SMP Mon Mar
11 22:19:42 UTC 2013 i686 i686 i386 GNU/Linux

---------------------------
Today a recording failed at 10:06 AM:

Dmesg output: 
[Sat Jun 29 09:56:50 2013] dvb_ca adapter 0: DVB CAM detected and
initialised successfully
[Sat Jun 29 10:02:15 2013] dvb_ca adapter 0: DVB CAM link initialisation
failed :(
[Sat Jun 29 10:56:47 2013] dvb_ca adapter 0: DVB CAM detected and
initialised successfully

Mythtv output:
see attachment

lsmod:
see attachment
---------------------------

Other interesting dmesg messages:
[Thu Jun 27 18:39:22 2013] dvb_ca adapter 0: CAM tried to send a buffer
larger than the link buffer size (49087 > 128)!
...
[Fri Jun 28 02:44:48 2013] dvb_ca adapter 0: Invalid PC card inserted :(
...
[Sat Jun 29 11:13:01 2013] dvb_ca adapter 0: DVB CAM link initialisation
failed :(
...

Anything I can do provide further data?
In my opinion it would be interesting to discover such situations and
automatically retry without the client programs (as mythtv) noticing it.

thanks,
Martin

--=-HwpM5r8A21QCXRtqWXms
Content-Disposition: attachment; filename="mythtv.log"
Content-Type: text/x-log; name="mythtv.log"; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Jun 29 09:53:34 ashanta mythbackend[21466]: N Expire autoexpire.cpp:263 (CalcParams) AutoExpire: CalcParams(): Max required Free Spac
e: 1.0 GB w/freq: 15 min
Jun 29 09:56:16 ashanta mythbackend[21466]: I HouseKeeping housekeeper.cpp:225 (RunHouseKeeping) Running housekeeping thread
Jun 29 09:56:46 ashanta mythbackend[21466]: E DVBCam dvbdev/dvbci.cpp:479 (RecvTPDU) ERROR: CAM: Read failed: slot 0, tcid 1
Jun 29 09:56:51 ashanta mythbackend[21466]: N DVBRead dtvsignalmonitor.cpp:354 (HandlePMT) DTVSM(/dev/dvb/adapter0/frontend0): PMT sa
ys program 11150 is encrypted
Jun 29 09:56:53 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x197a status: Encryp
ted
Jun 29 09:56:54 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x1978 status: Encryp
ted
Jun 29 09:56:54 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x1978 status: Unknow
n
Jun 29 09:56:54 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x197a status: Unknow
n
Jun 29 09:59:28 ashanta mythbackend[21466]: I Scheduler scheduler.cpp:2035 (HandleReschedule) Reschedule requested for id -1.
Jun 29 09:59:30 ashanta mythbackend[21466]: I Scheduler scheduler.cpp:2095 (HandleReschedule) Scheduled 48 items in 1.4 = 0.97 match 
+ 0.46 place
Jun 29 10:01:21 ashanta mythbackend[21466]: I HouseKeeping housekeeper.cpp:225 (RunHouseKeeping) Running housekeeping thread
Jun 29 10:02:16 ashanta mythbackend[21466]: N DVBRead dtvsignalmonitor.cpp:354 (HandlePMT) DTVSM(/dev/dvb/adapter0/frontend0): PMT sa
ys program 11110 is encrypted
Jun 29 10:02:18 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17ea status: Encrypted
Jun 29 10:02:19 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17e8 status: Encrypted
Jun 29 10:02:20 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17eb status: Encrypted
Jun 29 10:02:20 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17e9 status: Encrypted
Jun 29 10:02:28 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:02:29 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:03:01 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:03:01 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:03:06 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:03:08 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:03:20 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:03:20 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:03:28 ashanta mythbackend[21466]: I Scheduler scheduler.cpp:2035 (HandleReschedule) Reschedule requested for id -1.
Jun 29 10:03:29 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:03:29 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:03:29 ashanta mythbackend[21466]: I Scheduler scheduler.cpp:2095 (HandleReschedule) Scheduled 48 items in 1.4 = 0.97 match + 0.46 place
Jun 29 10:03:41 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:03:41 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:04:13 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:04:13 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:04:21 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:04:22 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:04:51 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:04:52 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:05:10 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:05:11 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:05:17 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:05:17 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:05:29 ashanta mythbackend[21466]: I TVRecEvent tv_rec.cpp:1544 (HandlePendingRecordings) TVRec(1): ASK_RECORDING 1 29 0 0
Jun 29 10:05:29 ashanta mythbackend[21466]: I Scheduler scheduler.cpp:2035 (HandleReschedule) Reschedule requested for id 0.
Jun 29 10:05:30 ashanta mythbackend[21466]: I TVRecEvent tv_rec.cpp:1544 (HandlePendingRecordings) TVRec(2): ASK_RECORDING 2 29 0 0
Jun 29 10:05:30 ashanta mythbackend[21466]: I Scheduler scheduler.cpp:2095 (HandleReschedule) Scheduled 48 items in 0.5 = 0.00 match + 0.46 place
Jun 29 10:05:36 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:05:36 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:05:41 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:05:42 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:05:44 ashanta mythbackend[21466]: I CoreContext mythdbcon.cpp:395 (PurgeIdleConnections) New DB connection, total: 13
Jun 29 10:05:45 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:05:45 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:06:00 ashanta mythbackend[21466]: I TVRecEvent tv_rec.cpp:1030 (HandleStateChange) TVRec(1): Changing from None to RecordingOnly
Jun 29 10:06:00 ashanta mythbackend[21466]: I TVRecEvent tv_rec.cpp:3503 (TuningCheckForHWChange) TVRec(1): HW Tuner: 1->1
Jun 29 10:06:01 ashanta mythbackend[21466]: N Scheduler autoexpire.cpp:263 (CalcParams) AutoExpire: CalcParams(): Max required Free Space: 3.0 GB w/freq: 14 min
Jun 29 10:06:01 ashanta mythbackend[21466]: I Scheduler scheduler.cpp:2514 (HandleRecordingStatusChange) Tuning recording: "Pippi Langstrumpf": channel 1995 on cardid 1, sourceid 1
Jun 29 10:06:01 ashanta mythbackend[21466]: N DVBRead dtvsignalmonitor.cpp:354 (HandlePMT) DTVSM(/dev/dvb/adapter0/frontend0): PMT says program 11110 is encrypted
Jun 29 10:06:02 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17ea status: Encrypted
Jun 29 10:06:04 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17e8 status: Encrypted
Jun 29 10:06:04 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17e9 status: Encrypted
Jun 29 10:06:04 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17eb status: Encrypted
Jun 29 10:06:25 ashanta mythbackend[21466]: I HouseKeeping housekeeper.cpp:225 (RunHouseKeeping) Running housekeeping thread
Jun 29 10:06:30 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:06:30 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:06:53 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:06:54 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:07:21 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:07:21 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:08:11 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:08:11 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:09:11 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:09:11 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:09:21 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:09:21 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:09:34 ashanta mythbackend[21466]: N Expire autoexpire.cpp:263 (CalcParams) AutoExpire: CalcParams(): Max required Free Space: 3.0 GB w/freq: 14 min
Jun 29 10:10:00 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:10:00 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:10:11 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:10:11 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:10:29 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted
Jun 29 10:10:29 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Unknown
Jun 29 10:10:37 ashanta mythbackend[21466]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x17de status: Encrypted

--=-HwpM5r8A21QCXRtqWXms
Content-Disposition: attachment; filename="lsmod.txt"
Content-Type: text/plain; name="lsmod.txt"; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Module                  Size  Used by
btrfs                 749989  0 
zlib_deflate           26623  1 btrfs
libcrc32c              12544  1 btrfs
ufs                    78132  0 
qnx4                   13192  0 
hfsplus                83581  0 
hfs                    49480  0 
minix                  31538  0 
ntfs                  100207  0 
msdos                  17133  0 
jfs                   175096  0 
xfs                   758540  0 
reiserfs              235181  0 
ext2                   67991  0 
usblp                  17893  0 
bnep                   17791  2 
rfcomm                 38104  0 
bluetooth             189585  10 bnep,rfcomm
parport_pc             32115  0 
ppdev                  12850  0 
dm_crypt               22572  0 
snd_hda_codec_hdmi     31778  1 
snd_hda_codec_realtek    64959  1 
microcode              18396  0 
snd_hda_intel          32983  1 
snd_hda_codec         116477  3 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel
snd_hwdep              13277  1 snd_hda_codec
snd_pcm                81124  3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
rc_tt_1500             12455  0 
tda10048               18427  1 
snd_seq_midi           13133  0 
tda827x                17779  2 
snd_rawmidi            25426  1 snd_seq_midi
tda10023               13160  1 
snd_seq_midi_event     14476  1 snd_seq_midi
dvb_usb_ttusb2         22653  19 
dvb_usb                23899  1 dvb_usb_ttusb2
dvb_core               99289  2 dvb_usb_ttusb2,dvb_usb
rc_core                21295  4 rc_tt_1500,dvb_usb_ttusb2,dvb_usb
snd_seq                51594  2 snd_seq_midi,snd_seq_midi_event
shpchp                 32326  0 
psmouse                91022  0 
snd_timer              28932  2 snd_pcm,snd_seq
snd_seq_device         14138  3 snd_seq_midi,snd_rawmidi,snd_seq
serio_raw              13032  0 
nvidia              10962664  30 
snd                    62675  12 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
soundcore              14636  1 snd
snd_page_alloc         14109  2 snd_hda_intel,snd_pcm
wmi                    18745  0 
i2c_nforce2            12907  0 
mac_hid                13078  0 
it87                   29428  0 
hwmon_vid              12724  1 it87
coretemp               13362  0 
lp                     17456  0 
parport                40931  3 parport_pc,ppdev,lp
r8169                  56853  0 
ahci                   25621  2 
libahci                26166  1 ahci

--=-HwpM5r8A21QCXRtqWXms--

