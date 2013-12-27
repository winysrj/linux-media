Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47930 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab3L0RKF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Dec 2013 12:10:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VwavC-0007ig-OB
	for linux-media@vger.kernel.org; Fri, 27 Dec 2013 18:10:02 +0100
Received: from erft-d932e6b3.pool.mediaways.net ([217.50.230.179])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 27 Dec 2013 18:10:02 +0100
Received: from andre.puschmann by erft-d932e6b3.pool.mediaways.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 27 Dec 2013 18:10:02 +0100
To: linux-media@vger.kernel.org
From: Andre Puschmann <andre.puschmann@tu-ilmenau.de>
Subject: Problem getting a TT-Budget S2-1600 PCI to work due I2C errors
Date: Fri, 27 Dec 2013 17:12:16 +0100
Message-ID: <l9k8sk$jka$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

I am having problems getting a brand new Technotrend S2-1600 PCI to
work. The card is being detected and seems to start loading the
appropriate modules. However, loading the frontend driver fails due to
some I2C errors. I am running the latest media-build drivers on a 3.11
kernel (Ubuntu 13.04) with the verbose parameter set to 4. Here is the
kernel output I get:

[    9.713022] stv090x_attach: Create New Internal Structure!
[    9.713028] stv090x_setup: Initializing STV0903
[    9.713029] stv090x_write_regs [0xf416]: 5c
[    9.713201] stv090x_write_regs: Reg=[0xf416], Data=[0x5c ...],
Count=1, Status=-121
[    9.713202] stv090x_setup: I/O error
[    9.713203] stv090x_attach: Error setting up device
[    9.713207] budget: A frontend driver was not found for device
[1131:7146] subsystem [13c2:101c]

Any idea why I2C fails? Maybe timing issues or a broken card?


Cheers
Andre

