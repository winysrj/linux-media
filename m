Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42078 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755035AbZFIL7M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 07:59:12 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] SE401 clean up
To: linux-media@vger.kernel.org, mchehab@infradead.org
Date: Tue, 09 Jun 2009 13:54:45 +0100
Message-ID: <20090609125408.10098.45945.stgit@t61.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tidy up the SE401 driver
---

Alan Cox (2):
      se401: Fix unsafe use of sprintf with identical source/destination
      se401: Fix coding style


 drivers/media/video/se401.c |  882 ++++++++++++++++++++++---------------------
 drivers/media/video/se401.h |    7 
 2 files changed, 456 insertions(+), 433 deletions(-)

-- 
	I'd prefer the trees to be separate for testing purposes: it 
	doens't	make much sense to have SMP support as a normal kernel 
	feature when most people won't have SMP anyway"
			-- Linus Torvalds
