Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm24-vm0.bullet.mail.ird.yahoo.com ([212.82.109.239]:44416 "HELO
	nm24-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751235Ab3G0KoF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jul 2013 06:44:05 -0400
References: <1371910047.2617.YahooMailNeo@web171902.mail.ir2.yahoo.com>
Message-ID: <1374921429.93450.YahooMailNeo@web171902.mail.ir2.yahoo.com>
Date: Sat, 27 Jul 2013 11:37:09 +0100 (BST)
From: Franz Schrober <franzschrober@yahoo.de>
Reply-To: Franz Schrober <franzschrober@yahoo.de>
Subject: Re: de-Primacom initial tuning data doesn't work anymore
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kaffeine-user@lists.sourceforge.net"
	<kaffeine-user@lists.sourceforge.net>,
	"pkg-kde-extras@lists.alioth.debian.org"
	<pkg-kde-extras@lists.alioth.debian.org>
In-Reply-To: <1371910047.2617.YahooMailNeo@web171902.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

bump



----- Ursprüngliche Message -----
Von: Franz Schrober <franzschrober@yahoo.de>
An: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>; "kaffeine-user@lists.sourceforge.net" <kaffeine-user@lists.sourceforge.net>; "pkg-kde-extras@lists.alioth.debian.org" <pkg-kde-extras@lists.alioth.debian.org>
CC: 
Gesendet: 16:07 Samstag, 22.Juni 2013
Betreff: de-Primacom initial tuning data doesn't work anymore

Hi,

I wanted to watch TV today with kaffeine 1.2.2-2 from debian and noticed that it didn't work anymore. Also scans even after the update of the initial tuning data didn't show all tv stations. Just replacing the entry for dvb-c/de-Primacom in ~/.kde/share/apps/kaffeine/scanfile.dvb with the one from http://narfation.org/misc/dvbc/de-Primacom fixed the problem for me after the next scan for tv stations.

