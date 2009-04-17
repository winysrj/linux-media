Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:18723 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZDQU3j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 16:29:39 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1Luvm2-0006J0-BJ
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Fri, 17 Apr 2009 23:39:02 +0200
Date: Fri, 17 Apr 2009 22:29:27 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH 0/6] ir-kbd-i2c conversion to the new i2c binding model (v2)
Message-ID: <20090417222927.7a966350@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Here comes an update of my conversion of ir-kbd-i2c to the new i2c
binding model. I've split it into 6 pieces for easier review. Firstly
there is 1 preliminary patch:

01-ir-kbd-i2c-dont-abuse-client-name.patch

Then 3 patches doing the actual conversion:

02-ir-kbd-i2c-convert-to-new-style.patch
03-configure-ir-receiver.patch
04-ir-kbd-i2c-dont-bind-to-unsupported-devices.patch

And lastly 2 patches cleaning up saa7134-input thanks to the new
possibilities offered by the conversion:

04-saa7134-input-cleanup-msi-ir.patch
05-saa7134-input-cleanup-avermedia-cardbus.patch

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

The main difference with my initial patch set is that the ir-kbd-i2c
devices are named ir_video instead of ir-kbd. The new name was chosen
neutral to make it clear that alternative drivers can bind to these
devices if so is the user's desire (lirc comes to mind). Such drivers
will need to be updated, but with the legacy binding model going away,
that had to happen anyway.

I'll post all 6 patches as replies to this post. They can also be
temporarily downloaded from:
  http://jdelvare.pck.nerim.net/linux/ir-kbd-i2c/
Additionally I've put a combined patch there, to make testing easier:
  http://jdelvare.pck.nerim.net/linux/ir-kbd-i2c/ir-kbd-i2c-conversion-ALL-IN-ONE.patch
But for review the individual patches are much better.

Thanks,
-- 
Jean Delvare
