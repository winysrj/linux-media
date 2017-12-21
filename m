Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:36237 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753350AbdLUMWz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 07:22:55 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, rjkm@metzlerbros.de, d.scheller@gmx.net,
        jasmin@anw.at
Subject: [PATCH V2 0/3] Add timers to en50221 protocol driver
Date: Thu, 21 Dec 2017 13:22:36 +0000
Message-Id: <1513862559-19725-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Some (older) CAMs are really slow in accepting data. I got sometimes the 
already known error "CAM tried to send a buffer larger than the ecount 
size". I could track it down to the dvb_ca_en50221_write_data function not 
waiting between sending the data length high/low and data bytes. In fact
the CAM reported a WR error, which triggered later on the mentioned error.
 
The problem is that a simple module parameter can't be used to solve this
by adding timer values, because the protocol handler is used for any CI
interface. A module parameter would be influence all the CAMs on all CI
interfaces. Thus individual timer definitions per CI interface and CAM are
required.
There are two possibilities to implement that, ioctl's and SysFS.
ioctl's require changes in usermode programs and it may take a lot of time
to get this implemented there.
SysFS can be used by simple "cat" and "echo" commands and can be therefore
simply controlled by scripting, which is immediately available.

I decided to go for the SysFS approach, but the required device to add the
SysFS files was not available in the "struct dvb_device". The first patch
of this series adds this device to the structure and also the setting code.

The second patch adds the functions to create the SysFS nodes for all
timers and the new timeouts in the en50221 protocol driver.

The third patch adds the SysFS node documentation.

Jasmin Jessich (3):
  media: dvb-core: Store device structure in dvb_register_device
  media: dvb-core: Added timers for dvb_ca_en50221_write_data
  media: dvb-core: Added documentation for ca sysfs timer nodes

 Documentation/ABI/testing/sysfs-class-ca        |  63 +++++++++++
 Documentation/media/uapi/dvb/ca-sysfs-nodes.rst |  85 +++++++++++++++
 Documentation/media/uapi/dvb/ca.rst             |   1 +
 drivers/media/dvb-core/dvb_ca_en50221.c         | 132 +++++++++++++++++++++++-
 drivers/media/dvb-core/dvbdev.c                 |   1 +
 drivers/media/dvb-core/dvbdev.h                 |   4 +-
 6 files changed, 284 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-ca
 create mode 100644 Documentation/media/uapi/dvb/ca-sysfs-nodes.rst

-- 
2.7.4
