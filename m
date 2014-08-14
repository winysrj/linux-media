Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:36793 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaHNJcu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:32:50 -0400
Received: from [10.61.209.179] ([10.61.209.179])
	(authenticated bits=0)
	by aer-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id s7E9WmIX004625
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 14 Aug 2014 09:32:49 GMT
Message-ID: <53EC8240.5080801@cisco.com>
Date: Thu, 14 Aug 2014 11:32:48 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.18] tw68: add new driver for tw68xx grabber cards
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 0f3bf3dc1ca394a8385079a5653088672b65c5c4:
                                                                                                                                       
   [media] cx23885: fix UNSET/TUNER_ABSENT confusion (2014-08-01 15:30:59 -0300)
                                                                                                                                       
are available in the git repository at:
                                                                                                                                       
   git://linuxtv.org/hverkuil/media_tree.git tw68
                                                                                                                                       
for you to fetch changes up to 64889b98f7ed20ab630a47eff4a5847c3aa0555e:
                                                                                                                                       
   MAINTAINERS: add tw68 entry (2014-08-10 10:36:10 +0200)
                                                                                                                                       
----------------------------------------------------------------
Hans Verkuil (2):
       tw68: add support for Techwell tw68xx PCI grabber boards
       MAINTAINERS: add tw68 entry
                                                                                                                                       
  MAINTAINERS                         |    8 +
  drivers/media/pci/Kconfig           |    1 +
  drivers/media/pci/Makefile          |    1 +
  drivers/media/pci/tw68/Kconfig      |   10 +
  drivers/media/pci/tw68/Makefile     |    3 +
  drivers/media/pci/tw68/tw68-core.c  |  458 ++++++++++++++++++++++++++++++++++++++
  drivers/media/pci/tw68/tw68-reg.h   |  195 ++++++++++++++++
  drivers/media/pci/tw68/tw68-risc.c  |  230 +++++++++++++++++++
  drivers/media/pci/tw68/tw68-video.c | 1082 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/pci/tw68/tw68.h       |  235 ++++++++++++++++++++
  10 files changed, 2223 insertions(+)
  create mode 100644 drivers/media/pci/tw68/Kconfig
  create mode 100644 drivers/media/pci/tw68/Makefile
  create mode 100644 drivers/media/pci/tw68/tw68-core.c
  create mode 100644 drivers/media/pci/tw68/tw68-reg.h
  create mode 100644 drivers/media/pci/tw68/tw68-risc.c
  create mode 100644 drivers/media/pci/tw68/tw68-video.c
  create mode 100644 drivers/media/pci/tw68/tw68.h
