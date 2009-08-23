Return-path: <linux-media-owner@vger.kernel.org>
Received: from tanaris.0x539.de ([78.46.103.116]:33014 "EHLO tanaris.0x539.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933519AbZHWMuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 08:50:35 -0400
Received: from kelgar.0x539.de ([85.10.226.115])
	by tanaris.0x539.de with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <pkern@kelgar.0x539.de>)
	id 1MfCM5-0002NK-NV
	for linux-media@vger.kernel.org; Sun, 23 Aug 2009 14:39:29 +0200
Received: from pkern by kelgar.0x539.de with local (Exim 4.69)
	(envelope-from <pkern@kelgar.0x539.de>)
	id 1MfCM1-0006cl-KS
	for linux-media@vger.kernel.org; Sun, 23 Aug 2009 14:39:25 +0200
Date: Sun, 23 Aug 2009 14:39:25 +0200
From: Philipp Kern <pkern@debian.org>
To: linux-media@vger.kernel.org
Subject: Suspend with saa7146/TT-Budget-C-CI PCI
Message-ID: <20090823123925.GA24805@kelgar.0x539.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I have to admit that this particular PCI card (see below for lspci) never
came back properly from suspend.  Nowadays it no longer floods the kernel
message buffer when coming back from sleep, but only if the PCI adapter
is used afterwards and even then it now stops when I kill the application.
So it's time to debug it a bit, I guess.

When trying to use the DVB adapter from kaffeine after suspend I am greeted
with this in dmesg:

[ 3016.796083] stv0297_writereg: writereg error (reg == 0x80, val == 0x01, ret == -121)
[ 3016.856103] stv0297_writereg: writereg error (reg == 0x80, val == 0x00, ret == -121)
[ 3016.916111] stv0297_writereg: writereg error (reg == 0x81, val == 0x01, ret == -121)
[ 3016.976091] stv0297_writereg: writereg error (reg == 0x81, val == 0x00, ret == -121)
[ 3017.036114] stv0297_writereg: writereg error (reg == 0x00, val == 0x09, ret == -121)
[ 3017.096109] stv0297_writereg: writereg error (reg == 0x01, val == 0x69, ret == -121)
[ 3017.156112] stv0297_writereg: writereg error (reg == 0x03, val == 0x00, ret == -121)
[ 3017.216121] stv0297_writereg: writereg error (reg == 0x04, val == 0x00, ret == -121)
[ 3017.276112] stv0297_writereg: writereg error (reg == 0x07, val == 0x00, ret == -121)
[ 3017.336123] stv0297_writereg: writereg error (reg == 0x08, val == 0x00, ret == -121)

This looks very much like dvbc_philips_tdm1316l_inittab.  -121 suggests
EREMOTEIO as failure reason.  I guess this means that the i2c device
stopped accepting requests and needs a reset?

The relevant frontend code is this:

    ret = i2c_transfer(state->i2c, &msg, 1);

    if (ret != 1)
        dprintk("%s: writereg error (reg == 0x%02x, val == 0x%02x, "
                "ret == %i)\n", __func__, reg, data, ret);

Is it possible that the i2c adapter is only initialized on module insertion,
but needs a reinit after coming back from suspend to clear this EREMOTEIO
failure?

Please Cc me on replies.

Kind regards,
Philipp Kern


lspci -vv:

03:07.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Technotrend Systemtechnik GmbH Device 1010
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (3750ns min, 9500ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at fdcff000 (32-bit, non-prefetchable) [size=512]
	Kernel driver in use: budget_ci dvb

dmesg of saa7146 init:

[   21.641493] saa7146: register extension 'budget_ci dvb'.
[   21.641655]   alloc irq_desc for 21 on node 0
[   21.641658]   alloc kstat_irqs on node 0
[   21.641670] budget_ci dvb 0000:03:07.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   21.641753] IRQ 21/: IRQF_DISABLED is not guaranteed on shared IRQs
[   21.641819] saa7146: found saa7146 @ mem ffffc9000064e000 (revision 1, irq 21) (0x13c2,0x1010).
[   21.641893] saa7146 (0): dma buffer size 192512
[   21.641929] DVB: registering new adapter (TT-Budget-C-CI PCI)
[   21.642072] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input7
[   21.646355] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   21.646432] HDA Intel 0000:01:05.1: setting latency timer to 64
[   21.677036] adapter has MAC addr = 00:d0:5c:04:78:43
[   21.677407] input: Budget-CI dvb ir receiver saa7146 (0) as /devices/pci0000:00/0000:00:14.4/0000:03:07.0/input/input8
[   21.932904] DVB: registering adapter 0 frontend 0 (ST STV0297 DVB-C)...


--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqROHwACgkQ7Ro5M7LPzdhY+wCfbMgSZvgZGq1NxkeftzBmINeb
JJYAn3rT11Qbw8Zl49VeBDQSCQmQCtu7
=iUiC
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
