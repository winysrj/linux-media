Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52304 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbaGLAh6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 20:37:58 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>,
	Thiago Santos <ts.santos@sisa.samsung.com>
Subject: [PATCH 0/3] Fix interval length on ISDB-T doc/driver
Date: Fri, 11 Jul 2014 21:37:45 -0300
Message-Id: <1405125468-4748-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The interleaving ISDB-T representation was utter broken:

dib8000 driver were using interleave=3 on some parts, and interleave=4
on others; net result is that interleaving=4 or 8 were broking there.

mb86a20s were using guard time as interleaving length.

Other drivers don't implement it.

Userspace (libdvbv5) were expecting a value of 0, 1, 2, 4.

Docbook were confusing.

A previous patch fixed the dib8000 driver. Let's now fix the
documentation and mb86a20s. This way, this field can be reliable.

Mauro Carvalho Chehab (3):
  DocBook: Fix ISDB-T Interleaving property
  mb86a20s: Fix Interleaving
  mb86a20s: Fix the code that estimates the measurement interval

 Documentation/DocBook/media/dvb/dvbproperty.xml | 44 ++++++++++++++++++++++---
 drivers/media/dvb-frontends/mb86a20s.c          | 26 +++++----------
 2 files changed, 48 insertions(+), 22 deletions(-)

-- 
1.9.3

