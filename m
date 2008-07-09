Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alftorino@gmail.com>) id 1KGby4-0001W2-E2
	for linux-dvb@linuxtv.org; Wed, 09 Jul 2008 17:52:33 +0200
Received: by py-out-1112.google.com with SMTP id a29so1511550pyi.0
	for <linux-dvb@linuxtv.org>; Wed, 09 Jul 2008 08:52:27 -0700 (PDT)
Message-ID: <2a3b30ff0807090852o18c6631eya9faf39157d29c90@mail.gmail.com>
Date: Wed, 9 Jul 2008 17:52:26 +0200
From: "Hal far" <alftorino@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] problem with wintv 1110 & linux 2.6.24.5
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1416689800=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1416689800==
Content-Type: multipart/alternative;
	boundary="----=_Part_1852_1005689.1215618746722"

------=_Part_1852_1005689.1215618746722
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

hi @ all,
I have a problem   with wintv 1110 & linux 2.6.24.5 .
The dvb card doesn't works.  When I run the scan  command
it doesn't found some channel available.

command : scan -a 0 file_frq
output :>>>
tune to:
474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
.....

The configuration seem to be good, all essential  modules are  loaded in the
kernel.
command: lsmod  | grep saa
saa7146_vv             48768  2 budget_av,dvb_ttpci
saa7146                19080  6
budget,budget_av,budget_ci,budget_core,dvb_ttpci,saa7146_vv
saa7134_dvb            18316  0
videobuf_dvb            8580  1 saa7134_dvb
tda1004x               19076  2 saa7134_dvb
saa7134_alsa           15040  0
saa7134               124240  2 saa7134_dvb,saa7134_alsa
compat_ioctl32          5120  1 saa7134
videobuf_dma_sg        14852  5
saa7146_vv,saa7134_dvb,videobuf_dvb,saa7134_alsa,saa7134
videobuf_core          18436  4
saa7146_vv,videobuf_dvb,saa7134,videobuf_dma_sg
ir_kbd_i2c             11408  1 saa7134
snd_pcm                72068  4
snd_pcm_oss,saa7134_alsa,snd_ens1371,snd_ac97_codec
ir_common              34308  3 budget_ci,saa7134,ir_kbd_i2c
videodev               29824  2 saa7146_vv,saa7134
v4l2_common            19200  4 saa7146_vv,tuner,saa7134,videodev
snd                    47716  11
snd_seq_oss,snd_seq,snd_pcm_oss,snd_mixer_oss,saa7134_alsa,snd_ens1371,snd_rawmidi,snd_seq_device,snd_ac97_codec,snd_pcm,snd_timer
v4l1_compat            17668  3 saa7146_vv,saa7134,videodev
i2c_core               22528  19
budget,budget_av,budget_ci,budget_core,dvb_ttpci,ttpci_eeprom,ves1820,tda827x,saa7134_dvb,tda1004x,tuner,tea5767,tda8290,tuner_simple,mt20xx,tea5761,saa7134,ir_kbd_i2c,i2c_piix4


In the directory  /dev there are the devices video and dvb..
command :  ls /dev/dvb/adapter0/
demux0  dvr0  frontend0  net0

command ls /dev/video*
/dev/video@  /dev/video0@

I have installed the v4l-dvb  and dvb-apps  from mercurial avaible at this
address
http://www.linuxtv.org/repo/. and in the /lib/firmware I copied the file
dvb-fe-tda10046.fw.

Now I don't know I fix this problem.

I attach the output of dmesg below
command: dmesg | grep DVB
saa7133[0]: subsystem: 0070:6701, board: Hauppauge WinTV-HVR1110
DVB-T/Hybrid [card=104,insmod option]
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...


command: dmesg | grep saa
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:06:0e.0, rev: 209, irq: 19, latency: 64, mmio:
0xfebff800
saa7133[0]: subsystem: 0070:6701, board: Hauppauge WinTV-HVR1110
DVB-T/Hybrid [card=104,insmod option]
saa7133[0]: board init: gpio is 6400000
ir-kbd-i2c: HVR 1110 detected at i2c-0/0-0071/ir0 [saa7133[0]]
saa7133[0]: i2c eeprom 00: 70 00 01 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 aa ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 60 ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c scan: found device @ 0x10  [???]
saa7133[0]: i2c scan: found device @ 0x96  [???]
saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
saa7133[0]: i2c scan: found device @ 0xe0  [???]
saa7133[0]: i2c scan: found device @ 0xe2  [???]
saa7133[0]: i2c scan: found device @ 0xe4  [???]
saa7133[0]: i2c scan: found device @ 0xe6  [???]
tuner 0-004b: chip found @ 0x96 (saa7133[0])
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 19 registered as card -1
DVB: registering new adapter (saa7133[0])
saa7146: register extension 'dvb'.
saa7146: register extension 'budget_ci dvb'.
saa7146: register extension 'budget_av'.
saa7146: register extension 'budget dvb'.


command : dmesg | grep tda
tda8290 0-004b: setting tuner address to 61
tuner 0-004b: type set to tda8290+75a
tda8290 0-004b: setting tuner address to 61
tuner 0-004b: type set to tda8290+75a
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok


Somebody can you help me?

thanks

------=_Part_1852_1005689.1215618746722
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

hi @ all,<br>I have a problem&nbsp;&nbsp; with wintv 1110 &amp; linux <a href="http://2.6.24.5">2.6.24.5</a> .<br>The dvb card doesn&#39;t works.&nbsp; When I run the scan&nbsp; command <br>it doesn&#39;t found some channel available. <br><br>
command : scan -a 0 file_frq<br>output :&gt;&gt;&gt; <br>tune to: 474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE<br>WARNING: filter timeout pid 0x0011<br>
WARNING: filter timeout pid 0x0000<br>WARNING: filter timeout pid 0x0010<br>.....<br><br>The configuration seem to be good, all essential&nbsp; modules are&nbsp; loaded in the kernel.<br>command: lsmod&nbsp; | grep saa<br>saa7146_vv&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 48768&nbsp; 2 budget_av,dvb_ttpci<br>
saa7146&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 19080&nbsp; 6 budget,budget_av,budget_ci,budget_core,dvb_ttpci,saa7146_vv<br>saa7134_dvb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 18316&nbsp; 0<br>videobuf_dvb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8580&nbsp; 1 saa7134_dvb<br>tda1004x&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 19076&nbsp; 2 saa7134_dvb<br>
saa7134_alsa&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15040&nbsp; 0<br>saa7134&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 124240&nbsp; 2 saa7134_dvb,saa7134_alsa<br>compat_ioctl32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5120&nbsp; 1 saa7134<br>videobuf_dma_sg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14852&nbsp; 5 saa7146_vv,saa7134_dvb,videobuf_dvb,saa7134_alsa,saa7134<br>
videobuf_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 18436&nbsp; 4 saa7146_vv,videobuf_dvb,saa7134,videobuf_dma_sg<br>ir_kbd_i2c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 11408&nbsp; 1 saa7134<br>snd_pcm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 72068&nbsp; 4 snd_pcm_oss,saa7134_alsa,snd_ens1371,snd_ac97_codec<br>ir_common&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 34308&nbsp; 3 budget_ci,saa7134,ir_kbd_i2c<br>
videodev&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 29824&nbsp; 2 saa7146_vv,saa7134<br>v4l2_common&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 19200&nbsp; 4 saa7146_vv,tuner,saa7134,videodev<br>snd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 47716&nbsp; 11 snd_seq_oss,snd_seq,snd_pcm_oss,snd_mixer_oss,saa7134_alsa,snd_ens1371,snd_rawmidi,snd_seq_device,snd_ac97_codec,snd_pcm,snd_timer<br>
v4l1_compat&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 17668&nbsp; 3 saa7146_vv,saa7134,videodev<br>i2c_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 22528&nbsp; 19 budget,budget_av,budget_ci,budget_core,dvb_ttpci,ttpci_eeprom,ves1820,tda827x,saa7134_dvb,tda1004x,tuner,tea5767,tda8290,tuner_simple,mt20xx,tea5761,saa7134,ir_kbd_i2c,i2c_piix4<br>
<br><br>In the directory&nbsp; /dev there are the devices video and dvb..<br>command :&nbsp; ls /dev/dvb/adapter0/<br>demux0&nbsp; dvr0&nbsp; frontend0&nbsp; net0<br><br>command ls /dev/video*<br>/dev/video@&nbsp; /dev/video0@<br><br>I have installed the v4l-dvb&nbsp; and dvb-apps&nbsp; from mercurial avaible at this address<br>
<a href="http://www.linuxtv.org/repo/">http://www.linuxtv.org/repo/</a>. and in the /lib/firmware I copied the file dvb-fe-tda10046.fw.<br><br>Now I don&#39;t know I fix this problem.<br><br>I attach the output of dmesg below<br>
command: dmesg | grep DVB<br>saa7133[0]: subsystem: 0070:6701, board: Hauppauge WinTV-HVR1110 DVB-T/Hybrid [card=104,insmod option]<br>DVB: registering new adapter (saa7133[0])<br>DVB: registering frontend 0 (Philips TDA10046H DVB-T)...<br>
<br><br>command: dmesg | grep saa<br>saa7130/34: v4l2 driver version 0.2.14 loaded<br>saa7133[0]: found at 0000:06:0e.0, rev: 209, irq: 19, latency: 64, mmio: 0xfebff800<br>saa7133[0]: subsystem: 0070:6701, board: Hauppauge WinTV-HVR1110 DVB-T/Hybrid [card=104,insmod option]<br>
saa7133[0]: board init: gpio is 6400000<br>ir-kbd-i2c: HVR 1110 detected at i2c-0/0-0071/ir0 [saa7133[0]]<br>saa7133[0]: i2c eeprom 00: 70 00 01 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92<br>saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff ff ff ff ff ff<br>
saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 aa ff ff ff ff<br>saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 60 ff ff ff ff ff ff<br>
saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>
saa7133[0]: i2c scan: found device @ 0x10&nbsp; [???]<br>saa7133[0]: i2c scan: found device @ 0x96&nbsp; [???]<br>saa7133[0]: i2c scan: found device @ 0xa0&nbsp; [eeprom]<br>saa7133[0]: i2c scan: found device @ 0xe0&nbsp; [???]<br>saa7133[0]: i2c scan: found device @ 0xe2&nbsp; [???]<br>
saa7133[0]: i2c scan: found device @ 0xe4&nbsp; [???]<br>saa7133[0]: i2c scan: found device @ 0xe6&nbsp; [???]<br>tuner 0-004b: chip found @ 0x96 (saa7133[0])<br>saa7133[0]: registered device video0 [v4l2]<br>saa7133[0]: registered device vbi0<br>
saa7133[0]: registered device radio0<br>saa7134 ALSA driver for DMA sound loaded<br>saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 19 registered as card -1<br>DVB: registering new adapter (saa7133[0])<br>saa7146: register extension &#39;dvb&#39;.<br>
saa7146: register extension &#39;budget_ci dvb&#39;.<br>saa7146: register extension &#39;budget_av&#39;.<br>saa7146: register extension &#39;budget dvb&#39;.<br><br><br>command : dmesg | grep tda<br>tda8290 0-004b: setting tuner address to 61<br>
tuner 0-004b: type set to tda8290+75a<br>tda8290 0-004b: setting tuner address to 61<br>tuner 0-004b: type set to tda8290+75a<br>tda1004x: setting up plls for 48MHz sampling clock<br>tda1004x: found firmware revision 29 -- ok<br>
<br><br>Somebody can you help me?<br><br>thanks <br><br><br>

------=_Part_1852_1005689.1215618746722--


--===============1416689800==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1416689800==--
