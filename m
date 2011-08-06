Return-path: <linux-media-owner@vger.kernel.org>
Received: from wrz3028.rz.uni-wuerzburg.de ([132.187.3.28]:51945 "EHLO
	mailrelay.rz.uni-wuerzburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213Ab1HFPPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Aug 2011 11:15:47 -0400
Received: from virusscan.mail (localhost [127.0.0.1])
	by mailrelay.mail (Postfix) with ESMTP id 2C8095AC4B
	for <linux-media@vger.kernel.org>; Sat,  6 Aug 2011 16:44:45 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by virusscan.mail (Postfix) with ESMTP id 2ADD25AC3C
	for <linux-media@vger.kernel.org>; Sat,  6 Aug 2011 16:44:45 +0200 (CEST)
Received: from achter.swolter.sdf1.org (188-193-179-36-dynip.superkabel.de [188.193.179.36])
	by mailmaster.uni-wuerzburg.de (Postfix) with ESMTPSA id E8D1D5D0CE
	for <linux-media@vger.kernel.org>; Sat,  6 Aug 2011 16:44:42 +0200 (CEST)
Received: from steve by achter.swolter.sdf1.org with local (Exim 4.76)
	(envelope-from <swolter@sdf.lonestar.org>)
	id 1Qpi7J-00031j-8G
	for linux-media@vger.kernel.org; Sat, 06 Aug 2011 16:44:45 +0200
Date: Sat, 6 Aug 2011 16:44:45 +0200
From: Steve Wolter <swolter@sdf.lonestar.org>
To: linux-media@vger.kernel.org
Subject: Support for Hauppauge WinTV HVR-3300
Message-ID: <20110806144444.GA11588@achter.swolter.sdf1.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear linux-media list,

I have recently bought a Hauppauge WinTV HVR-3300 and am trying to make
it run with Linux.

Going by the output of lspci -v [1], I tried to go with the cx23885, which
doesn't recognize the card:

[24296.910574] cx23885 driver version 0.0.2 loaded
[24296.910612] cx23885 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IR=
Q 16
[24296.910620] cx23885[0]: Your board isn't known (yet) to the driver.
[24296.910621] cx23885[0]: Try to pick one of the existing card configs via
[24296.910623] cx23885[0]: card=3D<n> insmod option.  Updating to the latest
[24296.910625] cx23885[0]: version might help as well.
[...]
[24296.911165] CORE cx23885[0]: subsystem: 0070:53f1, board: UNKNOWN/GENERI=
C [card=3D0,autodetected]
[24297.037221] cx23885_dev_checkrevision() Hardware revision =3D 0xd0
[24297.037228] cx23885[0]/0: found at 0000:01:00.0, rev: 4, irq: 16, latenc=
y: 0, mmio: 0xfe400000
[24297.037236] cx23885 0000:01:00.0: setting latency timer to 64
[24297.037304] cx23885 0000:01:00.0: irq 48 for MSI/MSI-X

Seems like some work is necessary to do here, which I'd be willing to do.
Can anyone suggest which might be the most similar card or what I should try
to write a driver for this?

Best regards, Steve

[1] Output of lspci -v

01:00.0 Multimedia video controller: Conexant Systems, Inc. CX23887/8 PCIe =
Broadcast Audio and Video Decoder with 3D Comb (rev 04)
        Subsystem: Hauppauge computer works Inc. Device 53f1
        Flags: bus master, fast devsel, latency 0, IRQ 48
        Memory at fe400000 (64-bit, non-prefetchable) [size=3D2M]
        Capabilities: <access denied>
        Kernel driver in use: cx23885



--=20
 Steve Wolter ( W=FCrzburg Univ.) | Web page: http://swolter.sdf1.org
                                | vCard:    http://swolter.sdf1.org/swolter=
=2Evcf
 A witty saying proves nothing. | Schedule: http://swolter.sdf1.org/sched.c=
gi
    -- Voltaire (1694-1778)     | E-mail:   swolter@sdf.lonestar.org

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOPVNc7ZhDb8MHkiIRAuoLAJ4lw7FLwTqjdq3nFceUNrANzkYt3wCfWaR7
iwB7On38fPrsRFBNZe29HGQ=
=HaVd
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
