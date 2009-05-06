Return-path: <linux-media-owner@vger.kernel.org>
Received: from sclnz.com ([203.167.202.17]:35287 "EHLO smtp.sclnz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbZEGAEZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2009 20:04:25 -0400
Received: from gecko (localhost.localdomain [127.0.0.1])
	by smtp.sclnz.com (8.13.8/8.13.8/Debian-3) with ESMTP id n470ZAqI015356
	for <linux-media@vger.kernel.org>; Thu, 7 May 2009 12:35:10 +1200
Message-ID: <4A02230C.5020800@sclnz.com>
Date: Thu, 07 May 2009 11:53:48 +1200
From: Spammers please <biteme@sclnz.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: CX24123 no FE_HAS_LOCK/tuning failed.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I've been struggling setting up my new HTPC.

I've got 2 cards, Hauppauge WinTV Nova-S-Plus in a machine with lots of 
grunt and memory,
a brand new LNB (old one was broken), freshly aligned dish (properly 
with a meter and all)
to the Optus D1 satellite.

I initially installed mythbuntu, and have upgraded it, it's now running 
kernel 2.6.27-11-generic.

I've downloaded/installed the latest v4l-dvb drivers, all to no avail.  
I can't get a frontend signal lock.

I've switched on some debugging and tried a few tweaks...

root@mythbox:/usr/src# tail /etc/modprobe.d/options
<snip>
options cx24123 debug=1
options cx88_dvb debug=1
options dvb_core debug=1 dvb_override_tune_delay=100 cam_debug=1


root@mythbox:~# tail -f /var/log/kern.log&
[1] 17472
root@mythbox:~# May  5 10:31:41 mythbox kernel: [  747.117627] CX24123: 
cx24123_set_fec: set FEC to 3/4
May  5 10:31:41 mythbox kernel: [  747.121714] CX24123: 
cx24123_set_symbolrate: srate=22500000, ratio=0x0038f7b8, 
sample_rate=50555000 sample_gain=1
May  5 10:31:41 mythbox kernel: [  747.121719] CX24123: 
cx24123_pll_tune: frequency=1883000
May  5 10:31:41 mythbox kernel: [  747.121720] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00100e3f
May  5 10:31:41 mythbox kernel: [  747.127951] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x000a0180
May  5 10:31:41 mythbox kernel: [  747.134200] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00000220
May  5 10:31:41 mythbox kernel: [  747.140447] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x001f4746
May  5 10:31:41 mythbox kernel: [  747.148332] CX24123: 
cx24123_pll_tune: pll tune VCA=1052223, band=544, pll=2049862
May  5 10:31:43 mythbox kernel: [  749.127989] cx88[0]/2-dvb: 
cx8802_dvb_advise_release
May  7 07:17:50 mythbox kernel: [161916.004021] Clocksource tsc unstable 
(delta = 62500833 ns)
!dvb
dvbtune -f 1183000 -s 22500 -p h -m
Using DVB card "Conexant CX24123/CX24109"
tuning DVB-S to L-Band:0, Pol:H Srate=22500000, 22kHz=off
ERROR setting tone
: Invalid argument
polling....
Getting frontend event
Overflow error, trying again (status = -1, errno = 75)FE_STATUS:
polling....
Getting frontend event
FE_STATUS:
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL
polling....
May  7 10:28:34 mythbox kernel: [173359.884352] function : dvb_dvr_open
May  7 10:28:34 mythbox kernel: [173359.885557] cx88[0]/2-dvb: 
cx8802_dvb_advise_acquire
May  7 10:28:34 mythbox kernel: [173359.885678] CX24123: cx24123_initfe: 
init frontend
May  7 10:28:34 mythbox kernel: [173359.907651] CX24123: CASE reached 
default with tone=-1
May  7 10:28:34 mythbox kernel: [173360.007741] CX24123: 
cx24123_set_frontend:
May  7 10:28:34 mythbox kernel: [173360.009162] CX24123: 
cx24123_set_inversion: inversion auto
May  7 10:28:34 mythbox kernel: [173360.011521] CX24123: 
cx24123_set_fec: set FEC to auto
May  7 10:28:34 mythbox kernel: [173360.015182] CX24123: 
cx24123_set_symbolrate: srate=22500000, ratio=0x0038f7b8, 
sample_rate=50555000 sample_gain=1
May  7 10:28:34 mythbox kernel: [173360.015186] CX24123: 
cx24123_pll_tune: frequency=1183000
May  7 10:28:34 mythbox kernel: [173360.015188] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00100e3f
May  7 10:28:34 mythbox kernel: [173360.021715] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x000a0180
May  7 10:28:34 mythbox kernel: [173360.028040] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00000201
May  7 10:28:34 mythbox kernel: [173360.034409] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x001f4492
May  7 10:28:34 mythbox kernel: [173360.042370] CX24123: 
cx24123_pll_tune: pll tune VCA=1052223, band=513, pll=2049170
polling....
polling....
polling....
polling....
polling....
polling....
polling....
polling....
and so on..

*I've created a tuning file for the OptusD1 satellite thus*

root@mythbox:/usr/src# cat ~tv/OptusD1
# Optus D1 satellite freeview
# freq pol sr fec
S 12456000 H 22500000 3/4
S 12483000 H 22500000 3/4

root@mythbox:/usr/src# scan -vvv ~tv/OptusD1
scanning /home/tv/OptusD1
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12456000 H 22500000 3
initial transponder 12483000 H 22500000 3
 >>> tune to: 12456:h:0:22500
DiSEqC: switch pos 0, 18V, hiband (index 3)
diseqc_send_msg:59: DiSEqC: e0 10 38 f3 00 00
 >>> tuning status == 0x01
May  7 11:47:42 mythbox kernel: [178107.632517] cx88[0]/2-dvb: 
cx8802_dvb_advise_acquire
May  7 11:47:42 mythbox kernel: [178107.632605] CX24123: cx24123_initfe: 
init frontend
May  7 11:47:42 mythbox kernel: [178107.654542] CX24123: 
cx24123_set_tone: setting tone off
May  7 11:47:42 mythbox kernel: [178107.670453] CX24123: 
cx24123_send_diseqc_msg:
May  7 11:47:42 mythbox kernel: [178107.819702] CX24123: 
cx24123_diseqc_send_burst:
May  7 11:47:42 mythbox kernel: [178107.938184] CX24123: 
cx24123_set_tone: setting tone on
May  7 11:47:42 mythbox kernel: [178107.988741] CX24123: 
cx24123_set_frontend:
May  7 11:47:42 mythbox kernel: [178107.990101] CX24123: 
cx24123_set_inversion: inversion auto
May  7 11:47:42 mythbox kernel: [178107.992419] CX24123: 
cx24123_set_fec: set FEC to 3/4
May  7 11:47:42 mythbox kernel: [178107.996507] CX24123: 
cx24123_set_symbolrate: srate=22500000, ratio=0x0038f7b8, 
sample_rate=50555000 sample_gain=1
May  7 11:47:42 mythbox kernel: [178107.996512] CX24123: 
cx24123_pll_tune: frequency=1856000
May  7 11:47:42 mythbox kernel: [178107.996514] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00100e3f
May  7 11:47:42 mythbox kernel: [178108.002777] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x000a0180
May  7 11:47:42 mythbox kernel: [178108.009058] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00000220
May  7 11:47:42 mythbox kernel: [178108.015323] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x001f472b
May  7 11:47:42 mythbox kernel: [178108.023215] CX24123: 
cx24123_pll_tune: pll tune VCA=1052223, band=544, pll=2049835
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
WARNING: >>> tuning failed!!!
 >>> tune to: 12456:h:0:22500 (tuning failed)
DiSEqC: switch pos 0, 18V, hiband (index 3)
diseqc_send_msg:59: DiSEqC: e0 10 38 f3 00 00
May  7 11:47:44 mythbox kernel: [178110.004396] CX24123: 
cx24123_set_tone: setting tone off
May  7 11:47:44 mythbox kernel: [178110.020424] CX24123: 
cx24123_send_diseqc_msg:
May  7 11:47:44 mythbox kernel: [178110.167715] CX24123: 
cx24123_diseqc_send_burst:
May  7 11:47:45 mythbox kernel: [178110.287152] CX24123: 
cx24123_set_tone: setting tone on
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
May  7 11:47:45 mythbox kernel: [178110.337675] CX24123: 
cx24123_set_frontend:
May  7 11:47:45 mythbox kernel: [178110.338996] CX24123: 
cx24123_set_inversion: inversion auto
May  7 11:47:45 mythbox kernel: [178110.341326] CX24123: 
cx24123_set_fec: set FEC to 3/4
May  7 11:47:45 mythbox kernel: [178110.345423] CX24123: 
cx24123_set_symbolrate: srate=22500000, ratio=0x0038f7b8, 
sample_rate=50555000 sample_gain=1
May  7 11:47:45 mythbox kernel: [178110.345429] CX24123: 
cx24123_pll_tune: frequency=1856000
May  7 11:47:45 mythbox kernel: [178110.345431] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00100e3f
May  7 11:47:45 mythbox kernel: [178110.351659] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x000a0180
May  7 11:47:45 mythbox kernel: [178110.357933] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00000220
May  7 11:47:45 mythbox kernel: [178110.364180] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x001f472b
May  7 11:47:45 mythbox kernel: [178110.372068] CX24123: 
cx24123_pll_tune: pll tune VCA=1052223, band=544, pll=2049835
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
WARNING: >>> tuning failed!!!
 >>> tune to: 12483:h:0:22500
DiSEqC: switch pos 0, 18V, hiband (index 3)
diseqc_send_msg:59: DiSEqC: e0 10 38 f3 00 00
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
May  7 11:47:47 mythbox kernel: [178112.352572] CX24123: 
cx24123_set_tone: setting tone off
May  7 11:47:47 mythbox kernel: [178112.368449] CX24123: 
cx24123_send_diseqc_msg:
May  7 11:47:47 mythbox kernel: [178112.515727] CX24123: 
cx24123_diseqc_send_burst:
May  7 11:47:47 mythbox kernel: [178112.634193] CX24123: 
cx24123_set_tone: setting tone on
May  7 11:47:47 mythbox kernel: [178112.684796] CX24123: 
cx24123_set_frontend:
May  7 11:47:47 mythbox kernel: [178112.686127] CX24123: 
cx24123_set_inversion: inversion auto
May  7 11:47:47 mythbox kernel: [178112.688434] CX24123: 
cx24123_set_fec: set FEC to 3/4
May  7 11:47:47 mythbox kernel: [178112.692538] CX24123: 
cx24123_set_symbolrate: srate=22500000, ratio=0x0038f7b8, 
sample_rate=50555000 sample_gain=1
May  7 11:47:47 mythbox kernel: [178112.692543] CX24123: 
cx24123_pll_tune: frequency=1883000
May  7 11:47:47 mythbox kernel: [178112.692545] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00100e3f
May  7 11:47:47 mythbox kernel: [178112.698796] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x000a0180
May  7 11:47:47 mythbox kernel: [178112.705044] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00000220
May  7 11:47:47 mythbox kernel: [178112.711296] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x001f4746
May  7 11:47:47 mythbox kernel: [178112.719186] CX24123: 
cx24123_pll_tune: pll tune VCA=1052223, band=544, pll=2049862
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
WARNING: >>> tuning failed!!!
 >>> tune to: 12483:h:0:22500 (tuning failed)
DiSEqC: switch pos 0, 18V, hiband (index 3)
diseqc_send_msg:59: DiSEqC: e0 10 38 f3 00 00
 >>> tuning status == 0x01
May  7 11:47:49 mythbox kernel: [178114.699667] CX24123: 
cx24123_set_tone: setting tone off
May  7 11:47:49 mythbox kernel: [178114.715549] CX24123: 
cx24123_send_diseqc_msg:
May  7 11:47:49 mythbox kernel: [178114.863702] CX24123: 
cx24123_diseqc_send_burst:
May  7 11:47:49 mythbox kernel: [178114.982202] CX24123: 
cx24123_set_tone: setting tone on
May  7 11:47:49 mythbox kernel: [178115.032731] CX24123: 
cx24123_set_frontend:
May  7 11:47:49 mythbox kernel: [178115.034064] CX24123: 
cx24123_set_inversion: inversion auto
May  7 11:47:49 mythbox kernel: [178115.036363] CX24123: 
cx24123_set_fec: set FEC to 3/4
May  7 11:47:49 mythbox kernel: [178115.040453] CX24123: 
cx24123_set_symbolrate: srate=22500000, ratio=0x0038f7b8, 
sample_rate=50555000 sample_gain=1
May  7 11:47:49 mythbox kernel: [178115.040457] CX24123: 
cx24123_pll_tune: frequency=1883000
May  7 11:47:49 mythbox kernel: [178115.040459] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00100e3f
May  7 11:47:49 mythbox kernel: [178115.046728] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x000a0180
May  7 11:47:49 mythbox kernel: [178115.052972] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00000220
May  7 11:47:49 mythbox kernel: [178115.059235] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x001f4746
May  7 11:47:49 mythbox kernel: [178115.067143] CX24123: 
cx24123_pll_tune: pll tune VCA=1052223, band=544, pll=2049862
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.
root@mythbox:/usr/src# May  7 11:47:51 mythbox kernel: [178117.046327] 
cx88[0]/2-dvb: cx8802_dvb_advise_release

*After much googling i suspect i have the same issue as this guy*

http://www.spinics.net/linux/lists/linux-dvb/msg29015.html

I've very much appreciate any pointers. </grovel>

Cheers, Rex
