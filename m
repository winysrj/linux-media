Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37618 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752305AbcHSN75 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:59:57 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by tschai.lan (Postfix) with ESMTPSA id 721FD1800DD
        for <linux-media@vger.kernel.org>; Fri, 19 Aug 2016 15:59:52 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Add atmel-isc driver
Message-ID: <d385fd92-1b21-aa0a-519d-02dac35ec776@xs4all.nl>
Date: Fri, 19 Aug 2016 15:59:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New Atmel ISC driver.

Regards,

	Hans

The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git atmel-isc

for you to fetch changes up to 25e7f8102f1c6a7ea4461124ea65709ba8423773:

  MAINTAINERS: atmel-isc: add entry for Atmel ISC (2016-08-19 15:52:42 +0200)

----------------------------------------------------------------
Songjun Wu (3):
      atmel-isc: add the Image Sensor Controller code
      atmel-isc: DT binding for Image Sensor Controller driver
      MAINTAINERS: atmel-isc: add entry for Atmel ISC

 Documentation/devicetree/bindings/media/atmel-isc.txt |   65 ++
 MAINTAINERS                                           |    8 +
 drivers/media/platform/Kconfig                        |    1 +
 drivers/media/platform/Makefile                       |    2 +
 drivers/media/platform/atmel/Kconfig                  |    9 +
 drivers/media/platform/atmel/Makefile                 |    1 +
 drivers/media/platform/atmel/atmel-isc-regs.h         |  165 +++++
 drivers/media/platform/atmel/atmel-isc.c              | 1514 +++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 1765 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/atmel-isc.txt
 create mode 100644 drivers/media/platform/atmel/Kconfig
 create mode 100644 drivers/media/platform/atmel/Makefile
 create mode 100644 drivers/media/platform/atmel/atmel-isc-regs.h
 create mode 100644 drivers/media/platform/atmel/atmel-isc.c
