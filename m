Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39088 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab0HZPXZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 11:23:25 -0400
Received: by fxm13 with SMTP id 13so1352807fxm.19
        for <linux-media@vger.kernel.org>; Thu, 26 Aug 2010 08:23:23 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 26 Aug 2010 11:23:22 -0400
Message-ID: <AANLkTi=w7BuKe1T7e4Tb20+HoBE6a+6ai2h8Mex0inv+@mail.gmail.com>
Subject: saa7164 analog driver crash
From: James Crow <crow.jamesm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

First of all I would like to thank Steven Toth for working on the
driver for the HVR-2250 cards. I bought one some time ago as an
eventual replacement for mt PVR-500 and it seems that time may be
approaching. I noticed that analog support had been added and wanted
to try it out.

Second, I hope this is the correct list for problems with this driver.

I am running Ubuntu 9.10 amd64 with kernel version:
 linux-image-2.6.31-22-generic        2.6.31-22.63

I downloaded the saa7164 tree with analog support yesterday
(8-25-2010). I compiled it (excluding the firedtv driver) and
installed it.

The first boot complained of missing firmware so I put that in place
and booted again.

On the second boot the system ran for almost 4 minutes before I
restarted it because of a crash.

On the third boot the system ran for a some time. It eventually
crashed after almost an hour. During that time there were several
kernel crashes logged in the system log.

I have two other dvb cards in this system. Both of the are Pinnacle
800i ATSC/ClearQAM and frame grabber analog devices. MythTV 0.23 is
installed on this machine and the HVR-2250 is dvb devices 0 & 1. They
are also the first two devices used by Myth.

A recording started at 9:00AM on dvb0 which is one of the HVR-2250 devices.

If there is any other information I can provide that would help track
down the cause please let me know.

Thanks,
James


james@james-desktop:~$ grep saa7164 messages | head -n 50
Aug 25 09:11:43 crowbar kernel: [    9.777440] saa7164 driver loaded
Aug 25 09:11:43 crowbar kernel: [    9.777554] saa7164 0000:02:00.0:
PCI INT A -> GSI 16 (level, low) -> IRQ 16
Aug 25 09:11:43 crowbar kernel: [    9.777765] CORE saa7164[0]:
subsystem: 0070:8891, board: Hauppauge WinTV-HVR2250
[card=7,autodetected]
Aug 25 09:11:43 crowbar kernel: [    9.777770] saa7164[0]/0: found at
0000:02:00.0, rev: 129, irq: 16, latency: 0, mmio: 0xf7800000
Aug 25 09:11:43 crowbar kernel: [    9.777777] IRQ 16/saa7164[0]:
IRQF_DISABLED is not guaranteed on shared IRQs
Aug 25 09:11:43 crowbar kernel: [    9.980027]
saa7164_downloadfirmware() Waiting for firmware upload
(NXP7164-2010-03-10.1.fw)
Aug 25 09:11:43 crowbar kernel: [    9.980030] saa7164 0000:02:00.0:
firmware: requesting NXP7164-2010-03-10.1.fw
Aug 25 09:15:02 crowbar kernel: [  212.124385] Modules linked in:
isofs udf crc_itu_t binfmt_misc s5h1409 cx88_dvb cx88_vp3054_i2c
nls_cp437 cifs videobuf_dvb rc_pinnacle_pctv_hd snd_hda_codec_via
xc5000 snd_hda_intel snd_hda_codec tuner snd_hwdep snd_seq_dummy
mceusb cx88_alsa snd_seq_oss snd_pcm_oss snd_seq_midi snd_mixer_oss
snd_rawmidi cx8802 cx8800 snd_pcm snd_seq_midi_event cx88xx saa7164(-)
snd_seq snd_timer i2c_algo_bit it87 dvb_core hwmon_vid ir_common
v4l2_common snd_seq_device ir_core videodev amd64_edac_mod snd
lirc_mceusb iptable_filter soundcore videobuf_dma_sg v4l1_compat
adm1021 ip_tables lirc_dev snd_page_alloc videobuf_core
v4l2_compat_ioctl32 edac_core xfs lp ppdev nvidia(P) asus_atk0110
psmouse btcx_risc i2c_piix4 tveeprom parport_pc serio_raw parport
exportfs x_tables usb_storage ohci1394 ieee1394 r8169 mii
Aug 25 09:15:02 crowbar kernel: [  212.124502] RIP:
0010:[<ffffffffa0b5af61>]  [<ffffffffa0b5af61>]
saa7164_cmd_set+0x41/0x1b0 [saa7164]
Aug 25 09:15:02 crowbar kernel: [  212.124646]  [<ffffffffa0b5b1ba>]
saa7164_cmd_send+0xea/0x860 [saa7164]
Aug 25 09:15:02 crowbar kernel: [  212.124705]  [<ffffffffa0b5d054>]
saa7164_api_set_debug+0x44/0x110 [saa7164]
Aug 25 09:15:02 crowbar kernel: [  212.124724]  [<ffffffffa0b65234>]
saa7164_finidev+0x50/0x235 [saa7164]
Aug 25 09:15:02 crowbar kernel: [  212.124793]  [<ffffffffa0b651e2>]
saa7164_fini+0x1e/0x20 [saa7164]
Aug 25 09:16:19 crowbar kernel: [   10.037029] saa7164 driver loaded
Aug 25 09:16:19 crowbar kernel: [   10.037248] saa7164 0000:02:00.0:
PCI INT A -> GSI 16 (level, low) -> IRQ 16
Aug 25 09:16:19 crowbar kernel: [   10.037448] CORE saa7164[0]:
subsystem: 0070:8891, board: Hauppauge WinTV-HVR2250
[card=7,autodetected]
Aug 25 09:16:19 crowbar kernel: [   10.037452] saa7164[0]/0: found at
0000:02:00.0, rev: 129, irq: 16, latency: 0, mmio: 0xf7800000
Aug 25 09:16:19 crowbar kernel: [   10.037460] IRQ 16/saa7164[0]:
IRQF_DISABLED is not guaranteed on shared IRQs
Aug 25 09:16:19 crowbar kernel: [   10.290027]
saa7164_downloadfirmware() Waiting for firmware upload
(NXP7164-2010-03-10.1.fw)
Aug 25 09:16:19 crowbar kernel: [   10.290030] saa7164 0000:02:00.0:
firmware: requesting NXP7164-2010-03-10.1.fw
Aug 25 09:16:19 crowbar kernel: [   10.825740]
saa7164_downloadfirmware() firmware read 4019072 bytes.
Aug 25 09:16:19 crowbar kernel: [   10.825742]
saa7164_downloadfirmware() firmware loaded.
Aug 25 09:16:19 crowbar kernel: [   10.825748]
saa7164_downloadfirmware() SecBootLoader.FileSize = 4019072
Aug 25 09:16:19 crowbar kernel: [   10.825753]
saa7164_downloadfirmware() FirmwareSize = 0x1fd6
Aug 25 09:16:19 crowbar kernel: [   10.825755]
saa7164_downloadfirmware() BSLSize = 0x0
Aug 25 09:16:19 crowbar kernel: [   10.825756]
saa7164_downloadfirmware() Reserved = 0x0
Aug 25 09:16:19 crowbar kernel: [   10.825757]
saa7164_downloadfirmware() Version = 0x1661c00
Aug 25 09:16:23 crowbar kernel: [   18.520023] saa7164_downloadimage()
Image downloaded, booting...
Aug 25 09:16:23 crowbar kernel: [   18.630022] saa7164_downloadimage()
Image booted successfully.
Aug 25 09:16:26 crowbar kernel: [   21.000031] saa7164_downloadimage()
Image downloaded, booting...
Aug 25 09:16:27 crowbar kernel: [   22.440022] saa7164_downloadimage()
Image booted successfully.
Aug 25 09:16:27 crowbar kernel: [   22.491428] saa7164[0]: Hauppauge
eeprom: model=88061
Aug 25 09:16:28 crowbar kernel: [   23.325480] DVB: registering new
adapter (saa7164)
Aug 25 09:16:32 crowbar kernel: [   26.928567] DVB: registering new
adapter (saa7164)
Aug 25 09:16:32 crowbar kernel: [   26.928789] saa7164[0]: registered
device video2 [mpeg]
Aug 25 09:16:32 crowbar kernel: [   27.158220] saa7164[0]: registered
device video3 [mpeg]
Aug 25 09:16:32 crowbar kernel: [   27.368459] saa7164[0]: registered
device vbi2 [vbi]
Aug 25 09:16:32 crowbar kernel: [   27.368475] saa7164[0]: registered
device vbi3 [vbi]
Aug 25 09:16:42 crowbar kernel: [   37.382611] saa7164[0]-FWMSG:
0-00:01:16.333;thread 0xd1833363;dbgtmmhSysPwstMan;switching off
analog reception...
Aug 25 09:17:33 crowbar kernel: [   88.243602] saa7164[0]-FWMSG:
0-00:02:07.183;thread 0xd181f363;mhStreamHdl;Received SET_CUR DMA
State to ACQUIRE
Aug 25 09:17:33 crowbar kernel: [   88.246319] saa7164[0]-FWMSG:
.183;thread 0xd181f363;mhStreamHdl;Received SET_CUR DMA State to PAUSE
Aug 25 09:17:33 crowbar kernel: [   88.430521] Modules linked in:
isofs udf crc_itu_t binfmt_misc tda18271 s5h1411 s5h1409 nls_cp437
cx88_dvb cifs cx88_vp3054_i2c videobuf_dvb snd_hda_codec_via
rc_pinnacle_pctv_hd xc5000 snd_hda_intel snd_hda_codec snd_hwdep tuner
cx88_alsa snd_pcm_oss saa7164 snd_mixer_oss cx8800 snd_pcm cx8802
dvb_core snd_seq_dummy cx88xx snd_seq_oss mceusb snd_seq_midi
snd_rawmidi snd_seq_midi_event i2c_algo_bit it87 snd_seq v4l2_common
hwmon_vid snd_timer ir_common videodev snd_seq_device ir_core
v4l1_compat xfs lirc_mceusb snd adm1021 iptable_filter videobuf_dma_sg
v4l2_compat_ioctl32 ppdev soundcore exportfs lirc_dev parport_pc
videobuf_core btcx_risc tveeprom amd64_edac_mod lp ip_tables psmouse
snd_page_alloc nvidia(P) edac_core serio_raw parport i2c_piix4
asus_atk0110 x_tables usb_storage ohci1394 ieee1394 r8169 mii
Aug 25 09:17:33 crowbar kernel: [   88.430557] RIP:
0010:[<ffffffffa0bd5fac>]  [<ffffffffa0bd5fac>]
saa7164_buffer_cfg_port+0xdc/0x280 [saa7164]
Aug 25 09:17:33 crowbar kernel: [   88.430599]  [<ffffffffa0bcded9>]
saa7164_dvb_start_feed+0xb9/0x310 [saa7164]
Aug 25 09:17:33 crowbar kernel: [   88.463603] saa7164[0]-FWMSG:
0-00:02:07.350;thread 0xd181f363;mhStreamHdl;Received SET_CUR DMA
State to ACQUIRE
Aug 25 09:26:19 crowbar kernel: [  604.000060] saa7164[0]-FWMSG:
Aug 25 09:26:29 crowbar kernel: [  614.000062] saa7164[0]-FWMSG:
Aug 25 09:26:39 crowbar kernel: [  624.000063] saa7164[0]-FWMSG:
Aug 25 09:26:49 crowbar kernel: [  634.000064] saa7164[0]-FWMSG:
Aug 25 09:26:50 crowbar kernel: [  644.000061] saa7164[0]-FWMSG:
