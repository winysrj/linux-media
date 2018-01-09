Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:35067 "EHLO
        homiemail-a118.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751686AbeAIQik (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 11:38:40 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/2] New Hauppauge USB devices
Date: Tue,  9 Jan 2018 10:38:34 -0600
Message-Id: <1515515916-32108-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Included is support for the following two USB devices:
- Hauppauge USB HVR935C - DVB-C/T/T2 + analog
- Hauppauge USB HVR975 - ATSC/QAM + analog

Brad Love (2):
  cx231xx: Add support for Hauppauge HVR-935
  cx231xx: Add support for Hauppauge HVR-975

 drivers/media/usb/cx231xx/cx231xx-cards.c |  84 ++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 136 ++++++++++++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx.h       |   2 +
 3 files changed, 222 insertions(+)

-- 
2.7.4
