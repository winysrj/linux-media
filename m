Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42933 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbcEYM0A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 08:26:00 -0400
Date: Wed, 25 May 2016 09:25:50 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: mchehab@infradead.org, LMML <linux-media@vger.kernel.org>
Subject: [ANNONCE] Kaffeine ported to Qt5/KF5
Message-ID: <20160525092550.702bee78@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

As Kaffeine is the GUI application I use to test DVB cards, I've been working
for a while to improve it. 

Initially, I changed it to use libdvbv5, allowing it to work properly with
devices that support multiple delivery systems on the same frontend and to
support other standards like ISDB-T.

Today, I completed another milestone: Kaffeine is now poarted from Qt4/KDE 4
to Qt5/KDE Foundations 5!

While I'm working to merge those patches at Kaffeine upstream, you
can test what I've done so far at:
	https://git.linuxtv.org/mchehab/kaffeine.git/log/?h=kde5

If you prefer to keep using Qt 4/KDE 4, you could use the master
branch instead:
	https://git.linuxtv.org/mchehab/kaffeine.git/log/

Personally, I think that the visual with KDE 5 is better, but the
functionality should be the same on both versions.

PS.: There is one caveat with Qt5: the VLC backend, used to play
videos, don't work fine with Xinput2 mouse changes that happened
with qt5.5. This is a known bug, and there is a fix at VLC, but
only for Qt4:
	https://mailman.videolan.org/pipermail/vlc-commits/2015-October/032674.html

This is harmless for Digital TV play, but it is annoying for DVD,
because it breaks DVD Menus. While this is not fixed, the
workaround is to compile Qt5 without Xinput2, using the --no-xinput2
./configure option and re-building Qt5.

Please test and report any bugs to me, c/c the media ML.

Enjoy!
Mauro
