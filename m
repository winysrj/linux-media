Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web8327.mail.in.yahoo.com ([202.43.219.198])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <sudha_sjshm1985@yahoo.co.in>) id 1JbTvN-0003JW-W7
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 05:59:51 +0100
Date: Tue, 18 Mar 2008 04:59:08 +0000 (GMT)
From: sudha rani <sudha_sjshm1985@yahoo.co.in>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <943853.50507.qm@web8327.mail.in.yahoo.com>
Subject: [linux-dvb] Reg:problem with Nova-s-plus card
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi

I have been trying to scan the channels using =

Hauppauge wintv nova-s-plus card (conexant Chipset no
cx23883-39) on RHEL im getting the output as "No such
device or address" what is this?Could you please help
me with this?  I have provided the version info below
and my findings below.
 =

Thanks in advance...  =

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Im using =


RHEL 3.4.4
Kernel version 2.6.9
Hauppauge wintv nova-s-plus card (Chipset no
cx23883-39)
 =

after inserting the information about the card to
cx88-cards.c

when i run xawtv =96hwscan, I see the following output

This is xawtv -3.95, running on Linux | i686
(2.6.9-prep)

looking for available devices port 69-69

type : X video, image scaler.

name : intel(R) video overlay

driver =3D /dev/video0 ; device =3D Hauppauge Nova-s-Plus
DVB-S

when i'm tring to scan the following FATAL message is
came
using '/dev/dvb/adapter0/frontend0' and
'/dev/dvb/adapter0/demux0'
main:1882: FATAL: failed to open
'/dev/dvb/adapter0/frontend0': 6 No such device or
address

The following is the output of dmesg:

Linux video capture interface: v1.00
cx2388x v4l2 driver version 0.0.4 loaded
ACPI: PCI interrupt 0000:01:0a.0[A] -> GSI 21 (level,
low) -> IRQ 217
cx8800[0]: found at 0000:01:0a.0, rev: 5, irq: 217,
latency: 64, mmio: 0xfa000000
cx8800[0]: subsystem: 0070:9202, board: Hauppauge
Nova-S-Plus DVB-S [card=3D37,autodetected]
cx8800[0]: i2c register ok
cx8800[0]: registered device video0 [v4l2]
cx8800[0]: registered device vbi0
cx8800[0]: cx88: tvaudio thread started
IA-32 Microcode Update Driver v1.14 unregistered
cx8800[0]: AUD_STATUS: 0x36 [mono/pilot c1]
ctl=3DBTSC_FORCE_MONO
cx8800[0]: AUD_STATUS: 0x36 [mono/pilot c1]
ctl=3DBTSC_FORCE_MONO
ip_tables: (C) 2000-2002 Netfilter core team
ip_tables: (C) 2000-2002 Netfilter core team
e100: eth0: e100_watchdog: link up, 100Mbps,
full-duplex
cx8800[0]: AUD_STATUS: 0x36 [mono/pilot c1]
ctl=3DBTSC_FORCE_MONO
eth0: no IPv6 routers present
mdrbdr: disagrees about version of symbol
struct_module
cx8800[0]: AUD_STATUS: 0x36 [mono/pilot c1]
ctl=3DBTSC_FORCE_MONO
lp: driver loaded but no devices found
cx8800[0]: AUD_STATUS: 0x36 [mono/pilot c1]
ctl=3DBTSC_FORCE_MONO
tveeprom: Encountered bad packet header [17]. Corrupt
or not a Hauppauge eeprom.
cx8800[0]: i2c attach [client=3Dtveeprom]
ivtv: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D START IN=
IT IVTV
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
ivtv: version 0.4.0 (tagged release) loading
ivtv: Linux version: 2.6.9-prep SMP 686 REGPARM
4KSTACKS gcc-3.4
ivtv: In case of problems please include the debug
info
ivtv: between the START INIT IVTV and END INIT IVTV
lines when
ivtv: mailing the ivtv-devel mailinglist.
ivtv: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D END INIT=
 IVTV
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


The following is the output of lsmod | grep cx88:

cx8800 47388 0
cx88xx 29188 1 cx8800
video_buf 24836 3 saa7146_vv,cx8800,cx88xx
i2c_algo_bit 12808 2 ivtv,cx8800
v4l1_compat 16260 2 saa7146_vv,cx8800
v4l2_common 10240 2 saa7146_vv,cx8800
btcx_risc 8840 2 cx8800,cx88xx
videodev 13952 3 saa7146_vv,ivtv,cx8800
i2c_core 26240 30
dvb_usb_dibusb_mb,dvb_usb,b2c2_flexcop,dvb_ttusb_budget,budget_av,budget_ci=
,budget,budget_core,
dvb_ttpci,ttpci_eeprom,nxt2002,stv0297,mt352,mt312,cx22702,cx24110,tda8083,=
l64781,dib3000_common,
tda10021,tda1004x,ves1820,stv0299,cx22700,sp8870,ves1x93,tveeprom,cx8800,cx=
88xx,i2c_algo_bit
 =



      Explore your hobbies and interests. Go to http://in.promos.yahoo.com/=
groups

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
