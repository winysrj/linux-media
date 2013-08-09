Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53028 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493Ab3HIMxk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 08:53:40 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?q?Alfredo=20Jes=C3=BAs=20Delaiti?=
	<alfredodelaiti@netscape.net>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 0/3] Add ISDB-T support on Mygica X8502/X8507
Date: Fri,  9 Aug 2013 09:53:24 -0300
Message-Id: <1376052807-8215-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is likely the final version of the patches that adds support
for Mygica X8502/X8507.

After bisecting the mb86a20s configs, I discovered that the failure
was due to a regression on setting the frontend to parallel mode.

So, I removed the dirty mb86a20s from this series, and added a
proper regression fix for mb86a20s. That probably means that the
cx88 and saa7134 ISDB-T devices based on mb86a20s were also broken.

I also addressed the issues pointed by Alfredo.

So, if nobody complains, I'll merge those patches soon.

The mb86a20s should be merged at the fixes tree.

The two other patches will follow their normal way upstream, for their 
addition on kernel 3.12.

Mauro Carvalho Chehab (3):
  cx23885-dvb: use a better approach to hook set_frontend
  mb86a20s: Fix TS parallel mode
  cx23885: Add DTV support for Mygica X8502/X8507 boards

 drivers/media/dvb-frontends/mb86a20s.c    | 16 +++++-----
 drivers/media/pci/cx23885/Kconfig         |  1 +
 drivers/media/pci/cx23885/cx23885-cards.c |  6 ++--
 drivers/media/pci/cx23885/cx23885-dvb.c   | 49 ++++++++++++++++++++++++++-----
 drivers/media/pci/cx23885/cx23885.h       |  2 ++
 5 files changed, 55 insertions(+), 19 deletions(-)

-- 
1.8.3.1

