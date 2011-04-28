Return-path: <mchehab@pedra>
Received: from csmtp1.one.com ([195.47.247.21]:13847 "EHLO csmtp1.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab1D1Pmd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2011 11:42:33 -0400
Received: from Jantjes-MacBook.local (ip51ce01a5.speed.planet.nl [81.206.1.165])
	by csmtp1.one.com (Postfix) with ESMTP id 06C61180A6A78
	for <linux-media@vger.kernel.org>; Thu, 28 Apr 2011 15:42:31 +0000 (UTC)
Message-ID: <4DB98AE7.6020404@x34.nl>
Date: Thu, 28 Apr 2011 17:42:31 +0200
From: Jan <jan@x34.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: "new" tt s-1500 diseqc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear list,

I try to get the "new" tt-1500 model using the BSBE1-D01A tuner to work with a diseqc switch.

Currently I am working with a Gentoo 2.6.36 kernel patched with this patch 
(http://www.mail-archive.com/linux-media@vger.kernel.org/msg29871.html) by Oliver Endriss. This runs 
great if the card is directly connected to the dish.

Once connected trough a diseqc switch dvblast-1.2.0 no longer gets a lock. Where this was possible 
when using the "old" tt-1500 using the BSBE1-502A tuner.

Does anyone have the "new" tt-1500 working using a diseqc switch?

Regards,

Jan
