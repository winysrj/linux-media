Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout07.t-online.de ([194.25.134.83]:34205 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbZBQAqI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 19:46:08 -0500
From: "Andreas Witte" <andreaz@t-online.de>
To: <linux-media@vger.kernel.org>
Subject: Sometimes no lock on digivox miniII (Ver3.0)
Date: Tue, 17 Feb 2009 01:45:44 +0100
Message-ID: <016001c99099$11476f20$33d64d60$@de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Content-Language: de
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello List,

after changing my system to newer hardware (and use the latest driver for
af9015), it
seems the device didnt get a lock sometimes (mostly in the case the system
is started up).
I use the stick together with mythtv. If i get the partial lock, i restart
mythbackend or 
switch channel - then i get the lock. If i get it just the first time the
stick is working 
fine for the whole day. Only the very first channelpick after system start
seems to be the 
problem.

I cant reproduce this at all. Sometimes it works, sometimes not. Anybody
else seeing this? 
Im on gentoo with 2.6.28 kernel.

Any Ideas?

Regards,
Andreas


