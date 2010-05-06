Return-path: <linux-media-owner@vger.kernel.org>
Received: from ryu.zarb.org ([212.85.158.22]:53857 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab0EFJCl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 May 2010 05:02:41 -0400
Subject: stv090x vs stv0900
From: Pascal Terjan <pterjan@mandriva.com>
To: Manu Abraham <abraham.manu@gmail.com>,
	"Igor M. Liplianin" <liplianin@netup.ru>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 06 May 2010 10:46:17 +0200
Message-ID: <1273135577.16031.11.camel@plop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I was adding support for a non working version of DVBWorld HD 2104

It is listed on
http://www.linuxtv.org/wiki/index.php/DVBWorld_HD_2104_FTA_USB_Box as :

=====
for new solution : 2104B (Sharp0169 Tuner)

      * STV6110A tuner
      * ST0903 demod
      * Cyrix CY7C68013A USB controller
=====

The 2104A is supposed to be working and also have ST0903 but uses
stv0900, so I tried using it too but did not manage to get it working.

I now have some working code by using stv090x + stv6110x (copied config
from budget) but I am wondering why do we have 2 drivers for stv0900,
and is stv0900 supposed to handle stv0903 devices or is either the code
or the wki wrong about 2104A?

Also, are they both maintained ? I wrote a patch to add get_frontend to
stv090x but stv0900 also does not have it and I don't know which one
should get new code.

And stv6110x seems to also handle stv6110 which also exists as a
separate module...

