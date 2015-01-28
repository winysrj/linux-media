Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:56810 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755793AbbA1Ucw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 15:32:52 -0500
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] dvb_net: general cleaning
Date: Wed, 28 Jan 2015 10:05:49 -0800
Message-Id: <cover.1422468185.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use more common kernel mechanisms

Joe Perches (3):
  dvb_net: Use vsprintf %pM extension to print Ethernet addresses
  dvb_net: Use standard debugging facilities
  dvb_net: Convert local hex dump to print_hex_dump_debug

 drivers/media/dvb-core/dvb_net.c | 88 ++++++++++++----------------------------
 1 file changed, 26 insertions(+), 62 deletions(-)

-- 
2.1.2

