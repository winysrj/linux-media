Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37539 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab2AHWPK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jan 2012 17:15:10 -0500
Received: by wgbdr10 with SMTP id dr10so1105081wgb.1
        for <linux-media@vger.kernel.org>; Sun, 08 Jan 2012 14:15:08 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 8 Jan 2012 23:15:08 +0100
Message-ID: <CADR1r6jbuGD5hecgC-gzVda1G=vCcOn4oMsf5TxcyEVWsWdVuQ@mail.gmail.com>
Subject: [DVB Digital Devices Cine CT V6] status support
From: Martin Herrman <martin.herrman@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear list-members,

I'm building a HTPC based on Linux and searching for an DVB-C tuner card that:
- fits the mobo (only pci-e/usb available, not pci or firewire)
- fits the case (antec fusion remote, big enough)
- is supported by linux
- is dual tuner
- supports encrypted HD content
- provides good quality

digital devices cine ct v6 seems to be a perfect solution, together
with a softcam based on smargo cartreader.

http://shop.digital-devices.de/epages/62357162.sf/en_GB/?ObjectPath=/Shops/62357162/Categories/HDTV_Karten_fuer_Mediacenter/Cine_PCIe_Serie/DVBC_T

But.. is this card supported by the Linux kernel?

In 3.2.0-rc7 kernel I have found the driver for most of the digital
devices cards, which includes the Cine S2 v6, but not the Cine CT v6.
(I have also found some experimental drivers for CI moduels in the
staging drivers section).

On the other hand, this discussion seems to indicate that drivers for
Cine CT v6 should be working at this time:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg37183.html

Can you give me an update on the status of a possibly existing driver
for Cine CT v6?

Much thanks in advance,

Martin
