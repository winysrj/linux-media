Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd6204.kasserver.com ([85.13.131.2]:50068 "EHLO
	dd6204.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaANKyV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 05:54:21 -0500
Received: from [192.168.178.28] (p4FD556A4.dip0.t-ipconnect.de [79.213.86.164])
	by dd6204.kasserver.com (Postfix) with ESMTPSA id 6AE3AD200EE
	for <linux-media@vger.kernel.org>; Tue, 14 Jan 2014 11:54:20 +0100 (CET)
Message-ID: <52D516A0.4040500@datenparkplatz.de>
Date: Tue, 14 Jan 2014 11:51:12 +0100
From: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: DVBSky-cards - M88DS3103 / M88TS2020
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since we got support for Montage M88DS3103 DVB-S/S2 demodulator driver
with commit 395d00d1ca8947887fd0fbdec4fff90c4da21877:

There is a number of popular DVB S/S2 cards from company DVBSky based on

RF: Montage M88TS2020
Demodulator: 2nd generation Montage M88DS3103
PCIe Bridge: Conexant CX23885

(http://linuxtv.org/wiki/index.php/DVBSky)

There also is a previously existing manufacturer-supplied patch against
mainline kernel 3.12 with different implementation of m88ds3103 driver
files, but with correct PCI IDs etc. that add support for these cards:

http://www.dvbsky.net/download/linux/kernel-3.12.5-dvbsky.patch.tar.gz
(Via: http://www.dvbsky.net/Support.html)

Are there any major tasks left with regard to support/inclusion for
these cards in mainline/linux-media?


Regards,
Ulrich
