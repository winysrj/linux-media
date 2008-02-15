Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obardenh@cisco.com>) id 1JQ4Uj-00042m-Nl
	for linux-dvb@linuxtv.org; Fri, 15 Feb 2008 18:37:05 +0100
Received: from ams-core-1.cisco.com (ams-core-1.cisco.com [144.254.224.150])
	by ams-dkim-2.cisco.com (8.12.11/8.12.11) with ESMTP id m1FHaXfF020823
	for <linux-dvb@linuxtv.org>; Fri, 15 Feb 2008 18:36:33 +0100
Received: from xbh-ams-332.emea.cisco.com (xbh-ams-332.cisco.com
	[144.254.231.87])
	by ams-core-1.cisco.com (8.12.10/8.12.6) with ESMTP id m1FHaNpE009728
	for <linux-dvb@linuxtv.org>; Fri, 15 Feb 2008 17:36:33 GMT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Fri, 15 Feb 2008 18:36:26 +0100
Message-ID: <7FA4B8777C810C4B8F3ABBB47DF0F37506396A85@xmb-ams-332.emea.cisco.com>
From: "Oliver Bardenheier (obardenh)" <obardenh@cisco.com>
To: <linux-dvb@linuxtv.org>
Subject: [linux-dvb] (multiproto) Skystar HD is not working anymore (No
	LNBP21 found)
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi all,

I've the fear that my DVB-S2 skystar HD is broken.
I already showed bad picture with distortions on RTL-transponder.
Since today I don't get it running anymore.
Any ideas ??


OmniVision ov7670 sensor driver, at your service
Linux video capture interface: v2.00
saa7146: register extension 'budget dvb'.
saa7146: register extension 'budget_ci dvb'.
ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 22 (level, low) -> IRQ 19
saa7146: found saa7146 @ mem f8f82c00 (revision 1, irq 19) (0x13c2,0x1019).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget S2-3200 PCI)
adapter has MAC addr =3D 00:d0:5c:61:80:f7
input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input6
irq 19: nobody cared (try booting with the "irqpoll" option)
 [<c0148466>] __report_bad_irq+0x36/0x7d
 [<c0148647>] note_interrupt+0x19a/0x1d7
 [<c0147bad>] handle_IRQ_event+0x1a/0x3f
 [<c0148b92>] handle_fasteoi_irq+0x86/0xa7
 [<c0104ee0>] do_IRQ+0x5c/0x74
 [<c0103823>] common_interrupt+0x23/0x28
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
handlers:
[<f8eec585>] (interrupt_hw+0x0/0x216 [saa7146])
Disabling IRQ #19
stb0899_write_regs [0xf1b6]: 02
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
stb0899_write_regs: Reg=3D[0xf1b6], Data=3D[0x02 ...], Count=3D1, Status=3D=
-5
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
_stb0899_read_reg: Read error, Reg=3D[0xf000], Status=3D-5
stb0899_get_dev_id: ID reg=3D[0xfffb]
stb0899_get_dev_id: Device ID=3D[15], Release=3D[11]
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
_stb0899_read_s2reg ERR(1), Device=3D[0xf3fc], Base address=3D[0x00000400],=
 Offset=3D[0xf334], Status=3D-5
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
_stb0899_read_s2reg ERR(1), Device=3D[0xf3fc], Base address=3D[0x00000400],=
 Offset=3D[0xf33c], Status=3D-5
stb0899_get_dev_id: Demodulator Core ID=3D[=FF=FF=FF=FB], Version=3D[-5]
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
_stb0899_read_s2reg ERR(1), Device=3D[0xfafc], Base address=3D[0x00000800],=
 Offset=3D[0xfa2c], Status=3D-5
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
_stb0899_read_s2reg ERR(1), Device=3D[0xfafc], Base address=3D[0x00000800],=
 Offset=3D[0xfa34], Status=3D-5
stb0899_get_dev_id: FEC Core ID=3D[=FF=FF=FF=FB], Version=3D[-5]
stb0899_attach: Attaching STB0899 =

stb6100_attach: Attaching STB6100 =

saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
frontend_init: No LNBP21 found!
stb0899_release: Release Frontend
budget-ci: A frontend driver was not found for device 1131/7146 subsystem 1=
3c2/1019
saa7146: register extension 'budget_patch dvb'.
saa7146: register extension 'dvb'.
saa7146: register extension 'budget_av'.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
