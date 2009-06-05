Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2m5.poczta.onet.pl ([213.180.138.33]:59720 "EHLO
	smtp2m5.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZFEGU2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2009 02:20:28 -0400
Received: from 77-254-128-175.adsl.inetia.pl ([77.254.128.175]:48055 "EHLO
	jarek-desktop.localnet" rhost-flags-OK-OK-OK-FAIL) by ps2.mod5.onet
	with ESMTPSA id S50351014AbZFEGU2ZZ4I0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2009 08:20:28 +0200
From: =?iso-8859-2?q?Jaros=B3aw_Huba?= <jarhuba2@poczta.onet.pl>
Reply-To: jarhuba2@poczta.onet.pl
To: Manu Abraham <abraham.manu@gmail.com>
Subject: Re: Question about driver for Mantis
Date: Fri, 5 Jun 2009 08:20:21 +0200
Cc: linux-media@vger.kernel.org
References: <200905230810.39344.jarhuba2@poczta.onet.pl> <200905231957.45456.jarhuba2@poczta.onet.pl> <1a297b360905231126g5053b828i3049fc810d94ba85@mail.gmail.com>
In-Reply-To: <1a297b360905231126g5053b828i3049fc810d94ba85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200906050820.21970.jarhuba2@poczta.onet.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Quick fix, do a make menuconfig: navigate through the menus, disable
> au0828 support and try again.
>
> Regards,
> Manu
> --

I have to disable almost all other drivers to compile Mantis.
During short test I didn't find any critical bugs. I tested it under Kaffeine 
development version, so no DVB-S2 testing, I can't use DiSqC, but it can be 
Kaffeine bug or weak signal from second satelite.
No critical hangs at all, no kernel panic.
In my opinion this driver can be included into main DVB tree.
It would be great to see it in linux 2.6.31 (I tested Mantis under 2.6.30 
rc7).

Jarek

