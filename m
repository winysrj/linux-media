Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm3-vm0.bullet.mail.ird.yahoo.com ([77.238.189.213]:22189 "EHLO
	nm3-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755835Ab3FVOIR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jun 2013 10:08:17 -0400
Message-ID: <1371910047.2617.YahooMailNeo@web171902.mail.ir2.yahoo.com>
Date: Sat, 22 Jun 2013 15:07:27 +0100 (BST)
From: Franz Schrober <franzschrober@yahoo.de>
Reply-To: Franz Schrober <franzschrober@yahoo.de>
Subject: de-Primacom initial tuning data doesn't work anymore
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kaffeine-user@lists.sourceforge.net"
	<kaffeine-user@lists.sourceforge.net>,
	"pkg-kde-extras@lists.alioth.debian.org"
	<pkg-kde-extras@lists.alioth.debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I wanted to watch TV today with kaffeine 1.2.2-2 from debian and noticed that it didn't work anymore. Also scans even after the update of the initial tuning data didn't show all tv stations. Just replacing the entry for dvb-c/de-Primacom in ~/.kde/share/apps/kaffeine/scanfile.dvb with the one from http://narfation.org/misc/dvbc/de-Primacom fixed the problem for me after the next scan for tv stations.

