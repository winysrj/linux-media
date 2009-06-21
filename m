Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:41856 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962AbZFUX5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2009 19:57:14 -0400
Received: from [209.86.224.52] (helo=mswamui-valley.atl.sa.earthlink.net)
	by elasmtp-dupuy.atl.sa.earthlink.net with esmtpa (Exim 4.67)
	(envelope-from <whelky-82852@mypacks.net>)
	id 1MIWuR-0003yN-CF
	for linux-media@vger.kernel.org; Sun, 21 Jun 2009 19:57:15 -0400
Message-ID: <24713386.1245628635222.JavaMail.root@mswamui-valley.atl.sa.earthlink.net>
Date: Sun, 21 Jun 2009 19:57:14 -0400 (EDT)
From: whelky-82852@mypacks.net
To: linux-media@vger.kernel.org
Subject: Hauppauge HVR-1250 IR Support? (CX23885)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was wondering if anyone is working on IR support for this card? I looked through cx23885-cards.c and its not supported.

627         switch (dev->board) {
628         case CX23885_BOARD_HAUPPAUGE_HVR1250:
629         case CX23885_BOARD_HAUPPAUGE_HVR1500:
630         case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
631         case CX23885_BOARD_HAUPPAUGE_HVR1800:
632         case CX23885_BOARD_HAUPPAUGE_HVR1200:
633         case CX23885_BOARD_HAUPPAUGE_HVR1400:
634                 /* FIXME: Implement me */
635                 break;

Thanks!

