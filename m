Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gomeisa.profiz.com ([62.142.120.210])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <peter.parkkali@iki.fi>) id 1KECKh-00075v-Gp
	for linux-dvb@linuxtv.org; Thu, 03 Jul 2008 02:05:59 +0200
Message-Id: <1997F341-DFDB-47A9-9158-65BA7D26133D@iki.fi>
From: Peter Parkkali <peter.parkkali@iki.fi>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Thu, 3 Jul 2008 03:05:04 +0300
Subject: [linux-dvb] af9015 driver fails on ubuntu 8.04 / alink dtu-m
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Since upgrading to Ubuntu 8.04 (Linux 2.6.24-19), I haven't been able  
to get Antti's af9015 driver to work with the a-link's "DTU(m)" dongle  
(USB 15a4:9016). I'm using the latest version from http://linuxtv.org/hg/ 
~anttip/af9015/ . An older version of the driver did work earlier this  
year on Ubuntu 7.10 with the same stick, however.

Scanning for channels works, but it causes a lot of messages in the  
kernel logs:

Jul  3 02:38:46 ubuntu kernel: [ 1745.903351] af9015_i2c_xfer: UNLOCK  
pid:4208 38 38
[....]
Jul  3 02:38:47 ubuntu kernel: [ 1746.820990] af9015_i2c_xfer: UNLOCK  
pid:4208 38 38
Jul  3 02:38:48 ubuntu kernel: [ 1747.461001] af9015_pid_filter: set  
pid filter, index 0, pid 0, onoff 1
Jul  3 02:38:48 ubuntu kernel: [ 1747.466755] af9015_pid_filter_ctrl:  
onoff:1
Jul  3 02:38:48 ubuntu kernel: [ 1747.470952] af9015_pid_filter: set  
pid filter, index 1, pid 11, onoff 1
[....]
Jul  3 02:38:48 ubuntu kernel: [ 1747.640762] af9015_pid_filter: set  
pid filter, index 6, pid 104, onoff 0
Jul  3 02:38:49 ubuntu kernel: [ 1748.424545] af9015_pid_filter: set  
pid filter, index 1, pid 11, onoff 0
Jul  3 02:38:49 ubuntu kernel: [ 1748.527314] af9015_pid_filter: set  
pid filter, index 2, pid 10, onoff 0
Jul  3 02:38:49 ubuntu kernel: [ 1748.621281] af9015_i2c_xfer: UNLOCK  
pid:4208 38 38
[....]
Jul  3 02:39:20 ubuntu kernel: [ 1779.381070] af9015_i2c_xfer: UNLOCK  
pid:4208 38 38
Jul  3 02:39:20 ubuntu kernel: [ 1779.404057] af9015_i2c_xfer: UNLOCK  
pid:4208 38 38
Jul  3 02:39:21 ubuntu kernel: [ 1780.045943] af9015_pid_filter: set  
pid filter, index 0, pid 0, onoff 1
Jul  3 02:39:21 ubuntu kernel: [ 1780.051827] af9015_pid_filter_ctrl:  
onoff:1
Jul  3 02:39:21 ubuntu kernel: [ 1780.055967] af9015_pid_filter: set  
pid filter, index 1, pid 11, onoff 1
Jul  3 02:39:21 ubuntu kernel: [ 1780.061960] af9015_pid_filter: set  
pid filter, index 2, pid 10, onoff 1
.... and so on.



Trying to stream out a channel with VLC gives a lot of errors, until  
it finally segfaults, after about 30 seconds. For the time it runs,  
the stream does have a bit of image and sound, but 90% of it is garbled.

$ vlc  .tzap/channels.conf -- 
sout='#duplicate{dst=std{access=http,mux=ts,dst=:8080}}'
[....]
libdvbpsi error (PSI decoder): TS discontinuity (received 14, expected  
8) for PID 18
libdvbpsi error (PSI decoder): TS discontinuity (received 5, expected  
4) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 9, expected  
10) for PID 18
libdvbpsi error (PSI decoder): TS duplicate (received 5, expected 6)  
for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 9, expected  
10) for PID 18
[....]
Segmentation fault


At the same time, the kernel log shows more messages like these:

Jul  3 02:43:23 ubuntu kernel: [ 2022.583560] af9015_i2c_xfer: UNLOCK  
pid:4258 38 38
Jul  3 02:43:23 ubuntu kernel: [ 2022.591565] af9015_i2c_xfer: UNLOCK  
pid:4258 38 38
Jul  3 02:43:23 ubuntu kernel: [ 2022.595715] af9015_i2c_xfer: UNLOCK  
pid:4258 38 38
Jul  3 02:43:23 ubuntu kernel: [ 2022.610597] af9015_i2c_xfer: UNLOCK  
pid:4258 38 38
Jul  3 02:43:23 ubuntu kernel: [ 2022.614559] af9015_i2c_xfer: UNLOCK  
pid:4258 38 38
Jul  3 02:43:24 ubuntu kernel: [ 2023.330277] af9015_i2c_xfer: UNLOCK  
pid:4258 38 38
Jul  3 02:43:24 ubuntu kernel: [ 2023.336267] af9015_i2c_xfer: UNLOCK  
pid:4258 38 38
Jul  3 02:43:24 ubuntu kernel: [ 2023.340258] af9015_i2c_xfer: UNLOCK  
pid:4258 38 38
Jul  3 02:43:24 ubuntu kernel: [ 2023.341712] af9015_pid_filter: set  
pid filter, index 0, pid 0, onoff 1
Jul  3 02:43:24 ubuntu kernel: [ 2023.348281] af9015_pid_filter_ctrl:  
onoff:1
Jul  3 02:43:24 ubuntu kernel: [ 2023.447222] af9015_i2c_xfer: UNLOCK  
pid:4258 38 38
Jul  3 02:43:24 ubuntu kernel: [ 2023.491201] af9015_i2c_xfer: UNLOCK  
pid:4258 38 38
Jul  3 02:43:25 ubuntu kernel: [ 2024.508943] af9015_pid_filter: set  
pid filter, index 1, pid 11, onoff 1
Jul  3 02:43:25 ubuntu kernel: [ 2024.515162] af9015_pid_filter: set  
pid filter, index 2, pid 12, onoff 1
Jul  3 02:43:25 ubuntu kernel: [ 2024.525347] af9015_pid_filter: set  
pid filter, index 3, pid 100, onoff 1
Jul  3 02:43:25 ubuntu kernel: [ 2024.651686] af9015_pid_filter: set  
pid filter, index 4, pid 200, onoff 1
Jul  3 02:43:26 ubuntu kernel: [ 2024.856038] af9015_pid_filter: set  
pid filter, index 5, pid 28a, onoff 1
Jul  3 02:43:26 ubuntu kernel: [ 2024.865944] af9015_pid_filter: set  
pid filter, index 6, pid 403, onoff 1
Jul  3 02:43:26 ubuntu kernel: [ 2024.885846] af9015_pid_filter: set  
pid filter, index 7, pid 911, onoff 1
Jul  3 02:43:37 ubuntu kernel: [ 2036.709263] vlc[4256]: segfault at  
00000000 eip b7c05283 esp b32aedfc error 4
Jul  3 02:43:37 ubuntu kernel: [ 2036.740405] af9015_pid_filter: set  
pid filter, index 0, pid 0, onoff 0
Jul  3 02:43:37 ubuntu kernel: [ 2036.746009] af9015_pid_filter: set  
pid filter, index 1, pid 11, onoff 0
Jul  3 02:43:37 ubuntu kernel: [ 2036.756052] af9015_pid_filter: set  
pid filter, index 2, pid 12, onoff 0
Jul  3 02:43:37 ubuntu kernel: [ 2036.762030] af9015_pid_filter: set  
pid filter, index 3, pid 100, onoff 0
Jul  3 02:43:37 ubuntu kernel: [ 2036.768026] af9015_pid_filter: set  
pid filter, index 4, pid 200, onoff 0
Jul  3 02:43:37 ubuntu kernel: [ 2036.774014] af9015_pid_filter: set  
pid filter, index 5, pid 28a, onoff 0
Jul  3 02:43:37 ubuntu kernel: [ 2036.780002] af9015_pid_filter: set  
pid filter, index 6, pid 403, onoff 0
Jul  3 02:43:37 ubuntu kernel: [ 2036.791922] af9015_pid_filter: set  
pid filter, index 7, pid 911, onoff 0
Jul  3 02:43:38 ubuntu kernel: [ 2037.016841] af9015_i2c_xfer: UNLOCK  
pid:4258 38 38
Jul  3 02:43:38 ubuntu kernel: [ 2037.022833] af9015_i2c_xfer: UNLOCK  
pid:4258 38 38
Jul  3 02:43:38 ubuntu kernel: [ 2037.026832] af9015_i2c_xfer: UNLOCK  
pid:4258 38 38
Jul  3 02:43:38 ubuntu kernel: [ 2037.034828] af9015_i2c_xfer: UNLOCK  
pid:4258 38 38


FYI, here are the boot-time messages from when the driver got loaded:

[ 1601.993687] af9015_usb_probe: interface:0
[ 1601.996473] af9015_read_config: IR mode:1
[ 1601.998568] af9015_read_config: TS mode:0
[ 1602.000564] af9015_read_config: [0] xtal:2 set adc_clock:28000
[ 1602.007468] af9015_read_config: [0] IF1:36125
[ 1602.011524] af9015_read_config: [0] MT2060 IF1:1220
[ 1602.013538] af9015_read_config: [0] tuner id:130
[ 1602.015552] af9015_identify_state: reply:02
[ 1602.015574] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in  
warm state.
[ 1602.015828] dvb-usb: will use the device's hardware PID filter  
(table count: 32).
[ 1602.016541] DVB: registering new adapter (Afatech AF9015 DVB-T  
USB2.0 stick)
[ 1602.017016] af9015_af9013_frontend_attach: init I2C
[ 1602.017027] af9015_i2c_init:
[ 1602.048446] 00: 2c 75 9b 0b 00 00 00 00 a4 15 16 90 00 02 01 02
[ 1602.080560] 10: 00 80 00 fa fa 10 40 ef 01 30 31 30 31 31 30 30
[ 1602.113428] 20: 34 30 36 30 30 30 30 31 ff ff ff ff ff ff ff ff
[ 1602.151399] 30: 00 00 3a 01 00 08 02 00 1d 8d c4 04 82 ff ff ff
[ 1602.184406] 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
[ 1602.221380] 50: ff ff ff ff ff 24 00 00 04 03 09 04 10 03 41 00
[ 1602.263395] 60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00
[ 1602.295365] 70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00
[ 1602.327362] 80: 31 00 30 00 31 00 31 00 30 00 30 00 34 00 30 00
[ 1602.359463] 90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
[ 1602.391320] a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1602.423312] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1602.455330] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1602.487278] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1602.519275] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1602.551258] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1603.327043] af9013: firmware version:4.95.0
[ 1603.350954] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
[ 1603.351179] af9015_tuner_attach:
[ 1603.828808] af9015_i2c_xfer: UNLOCK pid:2617 38 38
[ 1603.832843] MT2060: successfully identified (IF1 = 1220)
[ 1603.853122] NET: Registered protocol family 17
[ 1604.424571] af9015_i2c_xfer: UNLOCK pid:2617 38 38
[ 1604.425103] input: IR-receiver inside an USB DVB receiver as / 
devices/pci0000:00/0000:00:1f.2/usb1/1-1/input/input4
[ 1604.505122] dvb-usb: schedule remote query interval to 150 msecs.
[ 1604.505155] dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully  
initialized and connected.
[ 1604.505169] af9015_init:
[ 1604.505176] af9015_init_endpoint: USB speed:2
[ 1604.549523] af9015_download_ir_table:
[ 1604.801493] usbcore: registered new interface driver dvb_usb_af9015


-- 
Peter


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
