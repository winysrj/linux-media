Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58057 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab1KLP52 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 10:57:28 -0500
Received: by wwe5 with SMTP id 5so2613032wwe.1
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 07:57:27 -0800 (PST)
Message-ID: <4ebe9767.8366b40a.1a27.4371@mx.google.com>
Subject: [PATCH 0/7] af9015 dual tuner and othe fixes from my builds.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Date: Sat, 12 Nov 2011 15:57:22 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is the lastest patches, for dual tuner and other fixes on the patchwork server.


Malcolm Priestley (7):
  af9015 Slow down download firmware
  af9015 Remove call to get config from probe.
  af9015/af9013 full pid filtering.
  af9013 frontend tuner bus lock and gate changes v2
  af9015 bus repeater
  af9013 Stop OFSM while channel changing.
  af9013 empty buffer overflow command.

 drivers/media/dvb/dvb-usb/af9015.c   |  220 +++++++++++++++++++++-------------
 drivers/media/dvb/frontends/af9013.c |   18 +++-
 drivers/media/dvb/frontends/af9013.h |    5 +-
 3 files changed, 158 insertions(+), 85 deletions(-)

-- 
1.7.5.4






