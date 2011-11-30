Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42212 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab1K3VOe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 16:14:34 -0500
Received: by eaak14 with SMTP id k14so1228007eaa.19
        for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 13:14:33 -0800 (PST)
Message-ID: <1322687666.2476.7.camel@tvbox>
Subject: [PATCH 0/3] it913x add support for 9005 versions
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Wed, 30 Nov 2011 21:14:26 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Malcolm Priestley (3):
  [For 3.3] dvb-usb-it913x multi firmware loader
  [for 3.3] add support for IT9135 9005 devices
  [For 3.3] it913x dvb-get-firmware update

 Documentation/dvb/get_dvb_firmware      |   22 +++++++++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 drivers/media/dvb/dvb-usb/it913x.c      |   69 +++++++++++++++++++++---------
 3 files changed, 70 insertions(+), 22 deletions(-)

-- 
1.7.7.1



