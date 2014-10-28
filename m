Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbaJ1PA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 11:00:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 00/13] lgdt3306a: Fix several sparse/smatch/CodingStyle issues
Date: Tue, 28 Oct 2014 13:00:35 -0200
Message-Id: <cover.1414507927.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The submitted lgdt3306a driver was not in a good shape for merging.
However, as most of the issues are trivial, I solved them.

There are still a few remaining issues:

- As reported by checkpatch.pl:
	WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?

  Who will maintain it?

- There's currently no driver using this demod;

- It is still using DVBv3 stats. I can fix it, but I need the patches that
  will add support for the boards that use this demod in order to take a
  look on it;

- It uses its own log implementation.

For now, I'll be merging this on a topic branch, until the above issues
get fixed.

Mauro Carvalho Chehab (13):
  [media] lgdt3306a: Use hexadecimal values in lowercase
  [media] lgdt3306a: Use IS_ENABLED() for attach function
  [media] lgdt3306a: one bit fields should be unsigned
  [media] lgdt3306a: don't go past the buffer
  [media] lgdt3306a: properly handle I/O errors
  [media] lgdt3306a: Remove FSF address
  [media] lbdt3306a: rework at printk macros
  [media] lbdt3306a: simplify the lock status check
  [media] lgdt3306a: Don't use else were not needed
  [media] lbdt3306a: remove uneeded braces
  [media] lgdt3306a: constify log tables
  [media] lgdt3306a: Break long lines
  [media] lgdt3306a: Minor source code cleanups

 drivers/media/dvb-frontends/lgdt3306a.c | 979 ++++++++++++++++++--------------
 drivers/media/dvb-frontends/lgdt3306a.h |  18 +-
 2 files changed, 549 insertions(+), 448 deletions(-)

-- 
1.9.3

