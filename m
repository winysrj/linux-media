Return-path: <linux-media-owner@vger.kernel.org>
Received: from crow.cadsoft.de ([217.86.189.86]:52239 "EHLO raven.cadsoft.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbZERUwr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 16:52:47 -0400
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id n4IKXqmg016232
	for <linux-media@vger.kernel.org>; Mon, 18 May 2009 22:33:52 +0200
Message-ID: <4A11C62F.9020208@cadsoft.de>
Date: Mon, 18 May 2009 22:33:51 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [DVB] compiling av7110 firmware into driver fails
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I always compile the current av7110 firmware into my driver,
so that I can have different driver/firmware versions to test
with. This used to work by doing

CONFIG_DVB_AV7110_FIRMWARE=y
CONFIG_DVB_AV7110_FIRMWARE_FILE="/home/kls/vdr/firmware/FW.current"

in the v4l/.config file (where FW.current is a symlink to the
current firmware version).

With driver version c29ce3e2fc6a (2009-04-25) this still worked,
but with 0018ed9bbca3 (2009-05-16) it doesn't work any more.
Am I doing something wrong, or has this been broken?

Klaus
