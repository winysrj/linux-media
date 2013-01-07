Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60611 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab3AGLi5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jan 2013 06:38:57 -0500
Received: from mailout-de.gmx.net ([10.1.76.27]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LxrcA-1SxxpM1OuC-015EyR for
 <linux-media@vger.kernel.org>; Mon, 07 Jan 2013 12:38:56 +0100
Date: Mon, 7 Jan 2013 12:38:55 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: linux-media@vger.kernel.org
Subject: cx88 WRITERM instruction
Message-ID: <20130107113855.GA15241@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm trying to add precise timestamps to the cx88 driver but I
somehow fail to use the WRITERM instruction correctly. Has anyone
ever successfully used that RISC instruction? Is there a bit that
needs to be flipped to actually make it perform writes to the PCI
bus?

I know it is executed because I get a RISC_RD_BERR_INT if I
replace the third word with junk but no matter what I do the target
memory stays untouched (yes, it is coherent memory and I use the DMA
address).

Thanks,

  Daniel
