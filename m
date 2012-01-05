Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:51806 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2AELZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 06:25:07 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: [GIT PULL] davinci vpbe pull request
Date: Thu, 5 Jan 2012 11:24:53 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F7501A3CF@DBDE01.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
 Can you please pull these vpbe patches which add the support for
 DM365 and DM355 display?

 The 3 vpbe patches were sent to you as a pull request earlier. Please  see this mail:
 http://linux.omap.com/pipermail/davinci-linux-open-source/2011-November/023496.html

 I have now rebased these to 3.2 since my earlier pull request was  not based on commits on Linus's tree.
 As a result they look like recent commits, but have actually been  around for a long time.

 Thx,
 -Manju

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:
  Linus Torvalds (1):
        Linux 3.2

are available in the git repository at:

  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for-mauro-v3.3

Manjunath Hadli (3):
      davinci vpbe: add dm365 VPBE display driver changes
      davinci vpbe: add dm365 and dm355 specific OSD changes
      davinci vpbe: add VENC block changes to enable dm365 and dm355

 drivers/media/video/davinci/vpbe.c      |   48 +++-
 drivers/media/video/davinci/vpbe_osd.c  |  473 ++++++++++++++++++++++++++++---  drivers/media/video/davinci/vpbe_venc.c |  205 ++++++++++++--
 include/media/davinci/vpbe.h            |   16 +
 include/media/davinci/vpbe_venc.h       |    4 +
 5 files changed, 678 insertions(+), 68 deletions(-)
