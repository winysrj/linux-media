Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:42476 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383Ab2FGXxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jun 2012 19:53:49 -0400
Received: from [209.86.224.32] (helo=elwamui-cypress.atl.sa.earthlink.net)
	by elasmtp-scoter.atl.sa.earthlink.net with esmtpa (Exim 4.67)
	(envelope-from <sitten74490@mypacks.net>)
	id 1ScmWT-0000SF-Bw
	for linux-media@vger.kernel.org; Thu, 07 Jun 2012 19:53:49 -0400
Message-ID: <28466140.1339113229381.JavaMail.root@elwamui-cypress.atl.sa.earthlink.net>
Date: Thu, 7 Jun 2012 19:53:49 -0400 (GMT-04:00)
From: sitten74490@mypacks.net
To: linux-media@vger.kernel.org
Subject: hdpvr lockup with audio dropouts
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Apparently there is a known issue where the HD-PVR cannot handle the loss of audio signal over SPDIF while recording.  If this happens, the unit locks up requiring it to be power cycled before it can be used again. This behavior can easily be reproduced by pulling the SPDIF cable during recording.  My question is this:  are there any changes that could be made to the hdpvr driver that would make it more tolerant of brief audio dropouts?
