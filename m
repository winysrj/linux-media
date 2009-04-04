Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:2287 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZDDMYt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 08:24:49 -0400
Date: Sat, 4 Apr 2009 14:24:27 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Andy Walls <awalls@radix.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>
Subject: [PATCH 0/6] ir-kbd-i2c conversion to the new i2c binding model
Message-ID: <20090404142427.6e81f316@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Here finally comes my conversion of ir-kbd-i2c to the new i2c binding
model. I've split it into 6 pieces for easier review. Firstly there are
2 preliminary patches:

media-video-01-cx18-fix-i2c-error-handling.patch
media-video-02-ir-kbd-i2c-dont-abuse-client-name.patch

Then 2 patches doing the actual conversion:

media-video-03-ir-kbd-i2c-convert-to-new-style.patch
media-video-04-configure-ir-receiver.patch

And lastly 2 patches cleaning up saa7134-input thanks to the new
possibilities offered by the conversion:

media-video-05-saa7134-input-cleanup-msi-ir.patch
media-video-06-saa7134-input-cleanup-avermedia-cardbus.patch

This patch set is against the v4l-dvb repository, but I didn't pay
attention to the compatibility issues. I simply build-tested it on
2.6.27 and 2.6.29.

This patch set touches many different drivers and I can't test any of
them. My only TV card with an IR receiver doesn't make use of
ir-kbd-i2c. So I would warmly welcome testers. The more testing my
changes can get, the better.

And of course I welcome reviews and comments as well. I had to touch
many drivers I don't know anything about so it is possible that I
missed something.

I'll post all 6 patches as replies to this post. They can also be
temporarily downloaded from:
  http://jdelvare.pck.nerim.net/linux/ir-kbd-i2c/
Additionally I've put a combined patch there, to make testing easier:
  http://jdelvare.pck.nerim.net/linux/ir-kbd-i2c/ir-kbd-i2c-conversion-ALL-IN-ONE.patch
But for review the individual patches are much better.

Thanks,
-- 
Jean Delvare
