Return-path: <mchehab@pedra>
Received: from blu0-omc2-s30.blu0.hotmail.com ([65.55.111.105]:24750 "EHLO
	blu0-omc2-s30.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027Ab1D1JuK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2011 05:50:10 -0400
Message-ID: <BLU0-SMTP10113A0C16BB863060C95CED89B0@phx.gbl>
To: linux-media@vger.kernel.org
Subject: dibusb device with lock problems
CC: pb@linuxtv.org, grafgrimm77@gmx.de, castet.matthieu@free.fr
From: Lou <tuxoholic@hotmail.de>
Date: Thu, 28 Apr 2011 11:50:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

hello Patrick,

Did you have the time to look into this issue? I noticed tuning is more 
reliable using a devel vdr (1.7.17): this vdr version seems to use a good 
strategy if the device fails to lock in it's first attempt. The stable vdr 
(1.6.0), kaffeine (1.2) and tzap still fail to lock with kernel 2.6.32/2.6.38 
in most cases, if I retune the device I'll finally get the lock with tzap and 
kaffeine.

Again I'm sending a copy of this to the people affected by this bug or 
involved with the introducing code change: Can you confirm/deny this sort of 
behaviour with your device - what device is this, and what player (version) 
are you using?

Thanks for your cooperation.

Lou @ vdr-portal
