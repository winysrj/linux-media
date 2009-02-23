Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f176.google.com ([209.85.218.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <henrik.list@gmail.com>) id 1LbWVa-0006Dq-7A
	for linux-dvb@linuxtv.org; Mon, 23 Feb 2009 09:49:51 +0100
Received: by bwz24 with SMTP id 24so4485997bwz.17
	for <linux-dvb@linuxtv.org>; Mon, 23 Feb 2009 00:49:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <af2e95fa0902221140ha93378j5b6d36e654e9ee8a@mail.gmail.com>
References: <af2e95fa0902221140ha93378j5b6d36e654e9ee8a@mail.gmail.com>
Date: Mon, 23 Feb 2009 09:49:16 +0100
Message-ID: <af2e95fa0902230049r45268845o6f589b9ef153465b@mail.gmail.com>
From: Henrik Beckman <henrik.list@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Twinhan mantis, any CAM support in progress
Reply-To: linux-media@vger.kernel.org
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

Any work in progress for CAM support on the 2033?

Currently using, http://mercurial.intuxication.org/hg/s2-liplianin but
I=B4ll switch to whatever has or will have CAM.

Card info,
 25.180805] Mantis 0000:00:07.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   25.180843] Mantis 0000:00:07.0: setting latency timer to 64
[   25.180856] irq: 18, latency: 64
[   25.180858]  memory: 0xfdffd000, mmio: 0xf8840000
[   25.180865] found a VP-2033 PCI DVB-C device on (00:07.0),
[   25.180870]     Mantis Rev 1 [1822:0008], irq: 18, latency: 64
[   25.180876]     memory: 0xfdffd000, mmio: 0xf8840000
[   25.184211]     MAC Address=3D[00:08:ca:1a:f0:60]
<snip>
[   25.704672] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
[   25.706090] TDA10021: i2c-addr =3D 0x0c, id =3D 0x7c
[   25.706107] mantis_frontend_init (0): found Philips CU1216 DVB-C
frontend (TDA10021) @ 0x0c
[   25.706117] mantis_frontend_init (0): Mantis DVB-C Philips CU1216
frontend attach success
[   25.710822] DVB: registering adapter 0 frontend 0 (Philips TDA10021 DVB-=
C)...
[   25.712780] mantis_ca_init (0): Registering EN50221 device
[   25.714818] mantis_ca_init (0): Registered EN50221 device
[   25.714844] mantis_hif_init (0): Adapter(0) Initializing Mantis
Host Interface




/Henrik

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
