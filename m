Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53717 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758301Ab0G3CRZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 22:17:25 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: [PATCH 0/9 v2] IR: few fixes, additions and ENE driver
Date: Fri, 30 Jul 2010 05:17:02 +0300
Message-Id: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is third revision of my patchset.

Notable changes:

* Added whitespace fixes from Jarod Wilson
* 4 new bugs fixed (patches 04-07). Now in-kernel decoding
  works perfectly with all protocols it supports.
* lirc interface additions cleaned up.
  no more wrong support for timeout reports
  new ioctl for learning mode
  still need to add carrier detect, timeout reports, and rx filter
* replaced int with bool in my driver, plus few cleanups.
* added myself to maintainers of the ene driver
* added another PNP ID to ene driver

Best regards,
	Maxim Levitsky


