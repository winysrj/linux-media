Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:59880 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab2GDTi3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2012 15:38:29 -0400
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 1EEA52DD17
	for <linux-media@vger.kernel.org>; Wed,  4 Jul 2012 21:38:25 +0200 (CEST)
Received: from zimbra29-e5.priv.proxad.net (unknown [172.20.243.179])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 049CE4B00BF
	for <linux-media@vger.kernel.org>; Wed,  4 Jul 2012 21:37:48 +0200 (CEST)
Date: Wed, 4 Jul 2012 21:37:47 +0200 (CEST)
From: lerda.p@free.fr
To: linux-media@vger.kernel.org
Message-ID: <737300808.5736727.1341430667820.JavaMail.root@zimbra29-e5.priv.proxad.net>
In-Reply-To: <56234736.5722493.1341430150547.JavaMail.root@zimbra29-e5.priv.proxad.net>
Subject: CrystalHD - Add 32 bits layer compatibility for 64 bits processor
 mode - patch
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_5736725_1959159119.1341430667818"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------=_Part_5736725_1959159119.1341430667818
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit


This patch attached hereafter add mainly the CONFIG_COMPAT 32 bits compatibility layer to the linux crystalhd repository code git://linuxtv.org/jarod/crystalhd.git release: fdd2f19ac739a3db1fd7469ea19ceaefe0822e5a, and fixes minor bugs.

I hope it may be useful.

Changes:
Add 32 bits layer compatibility for 64 bits processor mode. Enums in headers are modified for better compatibility with kernel source code. Some general minor fixes added too.
This works fine while using ia32 mode on a x86-64 kernel, and I hope with the new x32 abi too.


Best Regards,
Patrick LERDA.

------=_Part_5736725_1959159119.1341430667818
Content-Type: application/x-xz; name=crystalhd-20120704-r0.patch.xz
Content-Disposition: attachment; filename=crystalhd-20120704-r0.patch.xz
Content-Transfer-Encoding: base64

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
j+mU+7HEZ/sCAAAAAARZWg==
------=_Part_5736725_1959159119.1341430667818--
