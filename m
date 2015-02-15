Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:54728 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbbBOMLo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2015 07:11:44 -0500
From: Silvan Jegen <s.jegen@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Silvan Jegen <s.jegen@gmail.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 0/2] [media] mantis: Fix goto labels
Date: Sun, 15 Feb 2015 13:11:03 +0100
Message-Id: <1424002265-16865-1-git-send-email-s.jegen@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I found two issues regarding goto labels in the mantis driver
when checking a smatch warning and addressed them in two separate
patches. Please be aware that these patches have only been compile-tested
since I do not have access to the corresponding hardware.

Silvan Jegen (2):
  [media] mantis: Move jump label to activate dead code
  [media] mantis: Use correct goto labels for cleanup on error

 drivers/media/pci/mantis/mantis_cards.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.2.2

