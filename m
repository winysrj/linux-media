Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:51840 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbbKRPDx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 10:03:53 -0500
To: linux-media@vger.kernel.org
From: Robert <wslegend@web.de>
Subject: [BUG] TechniSat SkyStar S2 - problem tuning DVB-S2 channels
Message-ID: <564C9355.1090203@web.de>
Date: Wed, 18 Nov 2015 16:03:49 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am using a "TechniSat SkyStar S2" DVB-S2 card. Drivers for this card
are included in the kernel tree since 4.2. Unfortunately, i can't tune
to ANY DVB-S2 channels with this new in-tree driver. DVB-S channels are
working fine. Id[1] of the commit which introduced support for this card.

Before 4.2 arrived i have used this[2] patch with which DVB-S2 channels
where tuneable without any problems. This patch works even with 4.3
after i have converted the fe_ structs to enums.

If you need anything to debug this behaviour, i will be at your disposal.

Thanks,
Robert

[1] 5afc9a25be8d4e627cf07aa8a7500eafe3664b94
[2] http://vdr-portal.de/index.php?page=Attachment&attachmentID=34585
