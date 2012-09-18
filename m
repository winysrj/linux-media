Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42267 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab2IRL4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 07:56:41 -0400
From: "Lad, Prabhakar" <prabhakar.lad@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
	"prabhakar.csengg@gmail.com" <prabhakar.csengg@gmail.com>
Subject: [GIT PULL FOR v3.7] Davinci VPIF cleanup and feature enhancement
Date: Tue, 18 Sep 2012 11:56:04 +0000
Message-ID: <4665BC9CC4253445B213A010E6DC7B35CF5A26@DBDE01.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Can you please pull the following patches for vpif, Which
involves driver cleanup and replace preset by timings API.

Thanks and Regards,
--Prabhakar Lad

The following changes since commit 36aee5ff9098a871bda38dbbdad40ad59f6535cf:

  [media] ir-rx51: Adjust dependencies (2012-09-15 19:44:30 -0300)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git vpif_driver_cleanup

Dror Cohen (1):
      media/video: vpif: fixing function name start to vpif_config_params

Hans Verkuil (2):
      vpif: replace preset with the timings API.
      davinci: vpif: remove unwanted header file inclusion

Lad, Prabhakar (2):
      media: davinci: vpif: add check for NULL handler
      davinci: vpif: capture/display: fix race condition

 drivers/media/platform/davinci/vpif.c         |   22 +++--
 drivers/media/platform/davinci/vpif.h         |    4 +-
 drivers/media/platform/davinci/vpif_capture.c |  133 ++++++-------------------
 drivers/media/platform/davinci/vpif_capture.h |    6 +-
 drivers/media/platform/davinci/vpif_display.c |  121 ++++------------------
 drivers/media/platform/davinci/vpif_display.h |    6 +-
 6 files changed, 69 insertions(+), 223 deletions(-)
