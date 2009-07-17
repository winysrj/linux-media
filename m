Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:37239 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbZGQU3i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 16:29:38 -0400
Subject: [PATCH 0/3] ir-kbd-i2c, cx18: IR devices for CX23418 boards
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Mark Lord <lkml@rtr.ca>,
	Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 16:29:45 -0400
Message-Id: <1247862585.10066.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean,

The following patch series is my preliminary cut at getting the cx18
bridge driver supported IR devices set up properly by the cx18 driver to
allow use by ir-kbd-i2c, lirc_i2c, lirc_pvr150, and lirc_zilog for both
old and new (>= 2.6.30) kernels.

They are:

1/3: ir-kbd-i2c: Allow use of ir-kdb-i2c internal get_key funcs and set ir_type
2/3: cx18: Add i2c initialization for Z8F0811/Hauppage IR transceivers
3/3: ir-kbd-i2c: Add support for Z8F0811/Hauppage IR transceivers

Please take a look and tell me what's wrong.  I put specific points of
concern I have before each patch.

If this works for both ir-kbd-i2c and lirc_*, then I can add similar
logic to fix up ivtv (at least for Zilog Z8 microcontroller IR devices).

Regards,
Andy

