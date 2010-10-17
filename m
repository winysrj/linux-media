Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <tanerinux@gmail.com>) id 1P7PeY-0006EI-NA
	for linux-dvb@linuxtv.org; Sun, 17 Oct 2010 11:35:43 +0200
Received: from mail-iw0-f182.google.com ([209.85.214.182])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1P7PeX-0005hB-97; Sun, 17 Oct 2010 11:35:42 +0200
Received: by iwn41 with SMTP id 41so1766266iwn.41
	for <linux-dvb@linuxtv.org>; Sun, 17 Oct 2010 02:35:39 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 17 Oct 2010 12:35:39 +0300
Message-ID: <AANLkTi=je4TkUs2yKtoVv-XBKyuzt0rQfoO6XYaN1UMN@mail.gmail.com>
From: =?ISO-8859-9?Q?Taner_Ta=FE?= <tanerinux@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Proftuners S2-8000 support
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1175795409=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============1175795409==
Content-Type: multipart/alternative; boundary=90e6ba6141d062beb90492ccc823

--90e6ba6141d062beb90492ccc823
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I have recently purchased Proftuners S2-8000 PCI-e card which consist of :

* CX23885 pci-e interface
* STB6100 Frontend
* STV0900 Demodulator

Vendor company supposed that card has Linux support via an additional patch
in their support page. I applied patch v4l-dvb and s2-liplianin
repositories. Patch applied and compiled modules loaded via success, but
could not able to work properly. I got mass of log messages below during
launch VDR application.

Insructions: http://www.proftuners.com/driver8000.html
Patch: http://www.proftuners.com/sites/default/files/prof8000.patch

kernel.log
-----------------------------------
stv0900_search:
stv0900_algo
stv0900_set_symbol_rate: Mclk 4500000, SR 1000000, Dmd 0
stv0900_set_tuner: Frequency=1146000
stv0900_set_tuner: Bandwidth=72000000
stv0900_algo: NO AGC1, POWERI, POWERQ
Search Fail
stv0900_read_status:
stv0900_status: locked = 0
stv0900_get_mclk_freq: Calculated Mclk = 4500000
TS bitrate = 0 Mbit/sec
DEMOD LOCK FAIL
stv0900_search:
stv0900_algo
stv0900_set_symbol_rate: Mclk 4500000, SR 1000000, Dmd 0
stv0900_set_tuner: Frequency=1146000
stv0900_set_tuner: Bandwidth=72000000
stv0900_algo: NO AGC1, POWERI, POWERQ
Search Fail
stv0900_read_status:
stv0900_status: locked = 0
stv0900_get_mclk_freq: Calculated Mclk = 4500000
TS bitrate = 0 Mbit/sec
DEMOD LOCK FAIL
-----------------------------------

Here is the log messages during card has detected:

-----------------------------------
Octt 16 17:27:39 localhost kernel: cx23885 driver version 0.0.2 loaded
Oct 16 17:27:39 localhost kernel: cx23885 0000:03:00.0: PCI INT A ->
Link[LN2A] -> GSI 18 (level, low) -> IRQ 18
Oct 16 17:27:39 localhost kernel: CORE cx23885[0]: subsystem: 8000:3034,
board: Prof Revolution DVB-S2 8000 [card=29,autodetected]
Oct 16 17:03:34 localhost kernel: cx23885_dvb_register() allocating 1
frontend(s)
Oct 16 17:03:34 localhost kernel: cx23885[0]: cx23885 based dvb card
Oct 16 17:03:34 localhost kernel: stv0900_init_internal
Oct 16 17:03:34 localhost kernel: stv0900_init_internal: Create New Internal
Structure!
Oct 16 17:03:34 localhost kernel: stv0900_st_dvbs2_single
Oct 16 17:03:34 localhost kernel: stv0900_stop_all_s2_modcod
Oct 16 17:03:34 localhost kernel: stv0900_activate_s2_modcod_single
Oct 16 17:03:34 localhost kernel: stv0900_set_ts_parallel_serial
Oct 16 17:03:34 localhost kernel: stv0900_set_mclk: Mclk set to 135000000,
Quartz = 27000000
Oct 16 17:03:34 localhost kernel: stv0900_get_mclk_freq: Calculated Mclk =
4500000
Oct 16 17:03:34 localhost kernel: stv0900_get_mclk_freq: Calculated Mclk =
4500000
Oct 16 17:03:34 localhost kernel: stv0900_attach: Attaching STV0900
demodulator(0)
Oct 16 17:03:34 localhost kernel: stb6100_attach: Attaching STB6100
Oct 16 17:03:34 localhost kernel: DVB: registering new adapter (cx23885[0])
Oct 16 17:03:34 localhost kernel: DVB: registering adapter 0 frontend 0
(STV0900 frontend)...
Oct 16 17:03:34 localhost kernel: cx23885_dev_checkrevision() Hardware
revision = 0xb0
Oct 16 17:03:34 localhost kernel: cx23885[0]/0: found at 0000:03:00.0, rev:
2, irq: 18, latency: 0, mmio: 0xfbe00000
Oct 16 17:03:34 localhost kernel: cx23885 0000:03:00.0: setting latency
timer to 64
-----------------------------------

Kernel: 2.6.35  x64
Distro: Archlinux/Gentoo x64
App: VDR 1.7.16

Thanks.

--90e6ba6141d062beb90492ccc823
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>I have recently purchased Proftuners S2-8000 PCI-e card which co=
nsist of :<br><br>* CX23885 pci-e interface<br>* STB6100 Frontend<br>* STV0=
900 Demodulator<br><br>Vendor company supposed that card has Linux support =
via an additional patch in their support page. I applied patch v4l-dvb and =
s2-liplianin repositories. Patch applied and compiled modules loaded via su=
ccess, but could not able to work properly. I got mass of log messages belo=
w during launch VDR application.<br>
<br>Insructions: <a href=3D"http://www.proftuners.com/driver8000.html">http=
://www.proftuners.com/driver8000.html</a><br>Patch: <a href=3D"http://www.p=
roftuners.com/sites/default/files/prof8000.patch">http://www.proftuners.com=
/sites/default/files/prof8000.patch</a><br>
<br>kernel.log<br>-----------------------------------<br>stv0900_search: <b=
r>stv0900_algo<br>stv0900_set_symbol_rate: Mclk 4500000, SR 1000000, Dmd 0<=
br>stv0900_set_tuner: Frequency=3D1146000<br>stv0900_set_tuner: Bandwidth=
=3D72000000<br>
stv0900_algo: NO AGC1, POWERI, POWERQ<br>
Search Fail<br>stv0900_read_status: <br>stv0900_status: locked =3D 0<br>stv=
0900_get_mclk_freq: Calculated Mclk =3D 4500000<br>TS bitrate =3D 0 Mbit/se=
c <br>DEMOD LOCK FAIL<br>stv0900_search: <br>stv0900_algo<br>stv0900_set_sy=
mbol_rate: Mclk 4500000, SR 1000000, Dmd 0<br>

stv0900_set_tuner: Frequency=3D1146000<br>stv0900_set_tuner: Bandwidth=3D72=
000000<br>stv0900_algo: NO AGC1, POWERI, POWERQ<br>Search Fail<br>stv0900_r=
ead_status: <br>stv0900_status: locked =3D 0<br>stv0900_get_mclk_freq: Calc=
ulated Mclk =3D 4500000<br>

TS bitrate =3D 0 Mbit/sec <br>DEMOD LOCK FAIL<br>--------------------------=
---------<br><br>Here is the log messages during card has detected:<br><br>=
-----------------------------------<br>Octt 16 17:27:39 localhost kernel: c=
x23885 driver version 0.0.2 loaded<br>
Oct 16 17:27:39 localhost kernel: cx23885 0000:03:00.0: PCI INT A -&gt; Lin=
k[LN2A] -&gt; GSI 18 (level, low) -&gt; IRQ 18<br>
Oct 16 17:27:39 localhost kernel: CORE cx23885[0]: subsystem: 8000:3034,
 board: Prof Revolution DVB-S2 8000 [card=3D29,autodetected]<br>Oct 16 17:0=
3:34 localhost kernel: cx23885_dvb_register() allocating 1 frontend(s)<br>
Oct 16 17:03:34 localhost kernel: cx23885[0]: cx23885 based dvb card<br>Oct=
 16 17:03:34 localhost kernel: stv0900_init_internal<br>Oct 16 17:03:34 loc=
alhost kernel: stv0900_init_internal: Create New Internal Structure!<br>
Oct 16 17:03:34 localhost kernel: stv0900_st_dvbs2_single<br>Oct 16 17:03:3=
4 localhost kernel: stv0900_stop_all_s2_modcod<br>
Oct 16 17:03:34 localhost kernel: stv0900_activate_s2_modcod_single<br>Oct =
16 17:03:34 localhost kernel: stv0900_set_ts_parallel_serial<br>Oct 16 17:0=
3:34 localhost kernel: stv0900_set_mclk: Mclk set to 135000000, Quartz =3D =
27000000<br>

Oct 16 17:03:34 localhost kernel: stv0900_get_mclk_freq: Calculated Mclk =
=3D 4500000<br>Oct 16 17:03:34 localhost kernel: stv0900_get_mclk_freq: Cal=
culated Mclk =3D 4500000<br>Oct 16 17:03:34 localhost kernel: stv0900_attac=
h: Attaching STV0900 demodulator(0) <br>

Oct 16 17:03:34 localhost kernel: stb6100_attach: Attaching STB6100 <br>Oct=
 16 17:03:34 localhost kernel: DVB: registering new adapter (cx23885[0])<br=
>Oct 16 17:03:34 localhost kernel: DVB: registering adapter 0 frontend 0 (S=
TV0900 frontend)...<br>

Oct 16 17:03:34 localhost kernel: cx23885_dev_checkrevision() Hardware revi=
sion =3D 0xb0<br>Oct 16 17:03:34 localhost kernel: cx23885[0]/0: found at 0=
000:03:00.0, rev: 2, irq: 18, latency: 0, mmio: 0xfbe00000<br>Oct 16 17:03:=
34 localhost kernel: cx23885 0000:03:00.0: setting latency timer to 64<br>
-----------------------------------<br><br>Kernel: 2.6.35=A0 x64<br>Distro:=
 Archlinux/Gentoo x64<br>App: VDR 1.7.16<br><br>Thanks.<br><br>

--90e6ba6141d062beb90492ccc823--


--===============1175795409==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1175795409==--
