Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55248 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbaGUQ2X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 12:28:23 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/3] Fix support for PCTV 340e
Date: Mon, 21 Jul 2014 13:28:12 -0300
Message-Id: <1405960095-29408-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for PCTV340e was broken for a long time. The regression
happened due to changeset 6fe1099c7aec.

The above changeset was right, as it improves device tuning, but
there's a bug at xc4000 get_frequency(): instead of returning
the tuned frequency, it was returning the frequency minus an
offset.

While there, I noticed that the firmware name was wrong (or
not updated), as the xc4000 firmware main source is:
	http://www.kernellabs.com/firmware/xc4000/

So, add support for both firmware names, trying first:
	dvb-fe-xc4000-1.4.1.fw
If it fails, try the previous firmware name:
	dvb-fe-xc4000-1.4.fw

This way, we warrand backward compatibility.

Mauro Carvalho Chehab (3):
  xc4000: Update firmware name
  xc4000: add module meta-tag with the firmware names
  xc4000: Fix get_frequency()

 drivers/media/tuners/xc4000.c | 47 ++++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 14 deletions(-)

-- 
1.9.3

