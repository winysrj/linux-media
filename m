Return-path: <linux-media-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:57267 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab0GTHAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jul 2010 03:00:54 -0400
Received: from 2009.localnet (unknown [193.140.74.52])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: ozan@pardus.org.tr)
	by lider.pardus.org.tr (Postfix) with ESMTPSA id 1DFB0A7ABAA
	for <linux-media@vger.kernel.org>; Tue, 20 Jul 2010 09:46:00 +0300 (EEST)
From: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
To: linux-media@vger.kernel.org
Subject: length of card field in v4l2_capability
Date: Tue, 20 Jul 2010 10:01:35 +0300
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007201001.35418.ozan@pardus.org.tr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

the card field in struct v4l2_capability has a length equal to 32 which leads 
to weird card names like this:

Avermedia PCI pure analog (M135

which is defined as:

.name           = "Avermedia PCI pure analog (M135A)",

in saa7134/saa7134-cards.c.

Is there a way to get the full card name from v4l2 or should that field 
enlarged to fit the current card names?

Thanks,

---
Ozan Çağlayan
TUBITAK/UEKAE - Pardus Linux
http://www.pardus.org.tr/eng
