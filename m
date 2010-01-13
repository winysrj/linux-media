Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1078 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987Ab0AMG7R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 01:59:17 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Karsten Keil <isdn@linux-pingi.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Samuel Chessman <chessman@tux.org>,
	linux-media@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/3] A few #define TRUE/FALSE removals
Date: Tue, 12 Jan 2010 22:59:12 -0800
Message-Id: <cover.1263365754.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Joe Perches (3):
  drivers/net/tlan: Remove TRUE/FALSE defines, use bool
  drivers/isdn/mISDN/dsp_ecdis.h: Remove #define TRUE/FALSE, use bool
  drivers/media/dvb/frontends/si21xx.c: Remove #define TRUE/FALSE, use bool

 drivers/isdn/mISDN/dsp_ecdis.h       |   20 +++++++----------
 drivers/media/dvb/frontends/si21xx.c |   38 ++++++++++++++-------------------
 drivers/net/tlan.c                   |   28 ++++++++++++------------
 drivers/net/tlan.h                   |    3 --
 4 files changed, 38 insertions(+), 51 deletions(-)

