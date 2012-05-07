Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out.abv.bg ([194.153.145.99]:51087 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194Ab2EGSTz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 14:19:55 -0400
Received: from nm23.abv.bg (nm23.ni.bg [192.168.151.172])
	by smtp-out.abv.bg (Postfix) with ESMTP id 4424F14EDB3
	for <linux-media@vger.kernel.org>; Mon,  7 May 2012 21:10:07 +0300 (EEST)
Received: from nm23.abv.bg (localhost.localdomain [127.0.0.1])
	by nm23.abv.bg (Postfix) with ESMTP id B6257239D4C
	for <linux-media@vger.kernel.org>; Mon,  7 May 2012 21:10:06 +0300 (EEST)
Date: Mon, 7 May 2012 21:10:06 +0300 (EEST)
From: "N. D." <named2@abv.bg>
To: linux-media@vger.kernel.org
Message-ID: <370939420.27387.1336414206737.JavaMail.apache@nm23.abv.bg>
Subject: tt3200 and fec=5/6
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I have a tt3200 and I am currently using stock 3.3.2 drivers. However I have trouble with a particular transponder on Astra23.5E, namely 11817 V27500 5/6 8PSK. Achieving a stable lock on the said transponder is virtually impossible for me. I have googled around and seen some infos that the tt3200 is not able to lock with FEC 5/6. Could someone confirm this? Or is there some patch to remedy this situation?
