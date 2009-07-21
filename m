Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54764 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752977AbZGUG1J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 02:27:09 -0400
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 21 Jul 2009 08:27:06 +0200
From: "Martin Schmid" <Schmid.Nuenchritz@gmx.de>
Message-ID: <20090721062706.12230@gmx.net>
MIME-Version: 1.0
Subject: [question] calculations in register 0x13 to 0x18 in ves1820.c
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi to all,

one question about the frontend ves1820.c.
Why are these calculations in register 0x13, 0x14, 0x15, 0x16, 0x17 and 0x18 made?
For example, function FE_READ_SIGNAL_STRENGT. Why is the content of register 0x17 shifted 8 bit to the left and then concatenate with itself?

Best regards,
Martin Schmid

-- 
Neu: GMX Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://portal.gmx.net/de/go/dsl02
