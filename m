Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:40481 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab0KLOO5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 09:14:57 -0500
Date: Fri, 12 Nov 2010 15:14:53 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Subject: Raw mode for SAA7134_BOARD_ENCORE_ENLTV_FM53?
Message-ID: <20101112141453.GA15756@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

as far as I could tell, you wrote the initial support for
SAA7134_BOARD_ENCORE_ENLTV_FM53 in
drivers/media/video/saa7134/saa7134-input.c, right?

It appears to be the only user of ir-functions.c left in that driver and
I'm wondering if it could be converted to use raw_decode with a patch
similar to what you committed for SAA7134_BOARD_ASUSTeK_P7131_ANALOG?

-- 
David Härdeman
