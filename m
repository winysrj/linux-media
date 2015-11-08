Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35973 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbbKHWmj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Nov 2015 17:42:39 -0500
Received: from lakka.kapsi.fi ([2001:1bc8:1004::1] ident=Debian-exim)
	by mail.kapsi.fi with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <ojs@kapsi.fi>)
	id 1ZvYfQ-0003Nk-Mb
	for linux-media@vger.kernel.org; Mon, 09 Nov 2015 00:42:32 +0200
Received: from ojs by lakka.kapsi.fi with local (Exim 4.80)
	(envelope-from <ojs@lakka.kapsi.fi>)
	id 1ZvYfQ-0003zV-Is
	for linux-media@vger.kernel.org; Mon, 09 Nov 2015 00:42:32 +0200
Date: Mon, 9 Nov 2015 00:42:32 +0200
From: Juhani Simola <ojs@iki.fi>
To: linux-media@vger.kernel.org
Subject: Initial scan data for fi-htv network
Message-ID: <20151108224232.GA21961@lakka.kapsi.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Lasse Lindqvist instructed me to submit DVB scan data to this address in 
this bug report thread: https://bugs.kde.org/show_bug.cgi?id=310257. I 
managed to get a full initial scan set using w_scan -fc -c FI -x. The 
following initial scan list finds all channels in fi-HTV cable network 
as of 11/2015:

C 146000000 6900000 NONE QAM256
C 378000000 6900000 NONE QAM256
C 386000000 6900000 NONE QAM256
C 394000000 6900000 NONE QAM256
C 178000000 6900000 NONE QAM256
C 186000000 6900000 NONE QAM256
C 194000000 6900000 NONE QAM256
C 202000000 6900000 NONE QAM256
C 210000000 6900000 NONE QAM256
C 218000000 6900000 NONE QAM256
C 226000000 6900000 NONE QAM256
C 242000000 6900000 NONE QAM256
C 258000000 6900000 NONE QAM256
C 266000000 6900000 NONE QAM256
C 162000000 6900000 NONE QAM256
C 154000000 6900000 NONE QAM256
C 170000000 6900000 NONE QAM256
C 274000000 6900000 NONE QAM128
C 250000000 6900000 NONE QAM256
C 290000000 6900000 NONE QAM256
C 298000000 6900000 NONE QAM256
C 306000000 6900000 NONE QAM256
C 314000000 6900000 NONE QAM256
C 322000000 6900000 NONE QAM256
C 338000000 6900000 NONE QAM256
C 346000000 6900000 NONE QAM256
C 354000000 6900000 NONE QAM256
C 362000000 6900000 NONE QAM256
C 370000000 6900000 NONE QAM256

The up-to-date multiplex and channel info can also be found here: 
http://dvb.welho.fi/cable.php

The operator has changed its name from HTV to DNA Welho some years ago.

Best regards,
Juhani Simola
