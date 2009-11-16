Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:45723 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbZKPLiy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 06:38:54 -0500
Received: from kabelnet-198-154.juropnet.hu ([91.147.198.154])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1N9zTQ-0001Q0-DM
	for linux-media@vger.kernel.org; Mon, 16 Nov 2009 12:10:26 +0100
Message-ID: <4B0133A0.2090904@mailbox.hu>
Date: Mon, 16 Nov 2009 12:12:32 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Newbie question about choosing a TV tuner card for Linux
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi! Can someone give me advice on which of these PCI TV tuner cards I
should buy for use on Linux ? All are from a similar price range, but
I do not know how they compare in terms of Linux support and picture
quality.

 - Leadtek DTV 1800H
   A relatively cheap card based on CX2388x and XC3028 (?). I read it is
   a good value for the price, and may be supported on Linux, although
   some tricks/patches could be needed to get it to work.
 - Leadtek DTV 2000H
   Similar to the above card, but is an older model, the tuner is an
   FMD1216 in a tin can, and it is somewhat more expensive. Is that only
   because of more bundled Windows software, or is the different tuner a
   better one quality-wise ? How does the Linux support compare ?
 - AVerMedia Hybrid PCI+FM (A16AR or A16D)
   I think the cards currently available with this name are the newer
   A16D version, which uses SAA713x and XC3028. I would assume it is not
   a better card than the DTV 1800H, but the SAA713x is better supported
   on Linux ?
 - AVerMedia Studio 703 (M17H)
   This is an analogue-only card (not necessarily a problem, since not
   many DVB-T channels can be received where I live), and the only
   information I found about it is that it uses a "Philips/NXP" chipset.
   It is not included in the CARDLIST files of the kernel, so maybe it
   is not supported on Linux ?

