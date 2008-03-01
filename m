Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s36.bay0.hotmail.com ([65.54.246.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rikardw@hotmail.com>) id 1JVQuU-0005lw-8s
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 13:33:50 +0100
Message-ID: <BAY118-W56E0462131FD39ABADE685BF150@phx.gbl>
From: Rikard Wissing <rikardw@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Sat, 1 Mar 2008 12:33:15 +0000
MIME-Version: 1.0
Subject: [linux-dvb] Tuning fails with Twinhan DVB-C AD-CP300 (Mantis 2033)
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


Hi there,

I've got the following card: http://www.twinhan.com/product_cable_2033.asp

I am running Ubunu 7.10 with kernel 2.6.22-14-generic

I have compiled and installed the latest drivers from http://jusst.de/hg/ma=
ntis and it seems to detect the card correctly but when scanning for channe=
ls it fails.
The card works correctly in windows.

This is what dmesg gives me:
...
[ 4022.137802] found a VP-2033 PCI DVB-C device on (05:05.0),
[ 4022.137803]     Mantis Rev 1 [1822:0008], irq: 23, latency: 64
[ 4022.137805]     memory: 0xfdaff000, mmio: 0xf8abc000
[ 4022.140491]     MAC Address=3D[00:08:ca:1c:2e:4b]
[ 4022.140502] mantis_alloc_buffers (0): DMA=3D0x2e830000 cpu=3D0xee830000 =
size=3D65536
[ 4022.140506] mantis_alloc_buffers (0): RISC=3D0x2e819000 cpu=3D0xee819000=
 size=3D1000
[ 4022.140508] DVB: registering new adapter (Mantis dvb adapter)
[ 4022.656841] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
[ 4022.658236] TDA10021: i2c-addr =3D 0x0c, id =3D 0x7d
[ 4022.658238] mantis_frontend_init (0): found Philips CU1216 DVB-C fronten=
d (TDA10021) @ 0x0c
[ 4022.658240] mantis_frontend_init (0): Mantis DVB-C Philips CU1216 fronte=
nd attach success
[ 4022.658243] DVB: registering frontend 0 (Philips TDA10021 DVB-C)...
...

When trying to scan it simply gives me the following result:

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 370000000 6875000 0 3
>>> tune to: 370000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
WARNING:>>> tuning failed!!!
>>> tune to: 370000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64 (tuning faile=
d)
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
>>> tuning status =3D=3D 0x00
WARNING:>>> tuning failed!!!

Is there any way i can debug the driver to see where it goes wrong?
If there is anything i can do, I would be glad to help out.

Any help would be greatly appreciated.

Best regards,
Rikard Wissing

_________________________________________________________________
M=F6rkt och kallt? Kanske Barcelona?
http://search.live.com/results.aspx?q=3DBarcelona+reseguide&form=3DQBRE
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
