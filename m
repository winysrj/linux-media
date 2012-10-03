Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:56619 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab2JCIcF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Oct 2012 04:32:05 -0400
Message-ID: <506BF7F5.7080605@ti.com>
Date: Wed, 3 Oct 2012 14:01:49 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [GIT PULL FOR v3.7] Davinci VPFE bug fix
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Can you please pull the following patch for VPFE, Which
fixes build error for VPFE driver.

Thanks and Regards,
--Prabhakar Lad

The following changes since commit 2425bb3d4016ed95ce83a90b53bd92c7f31091e4:

  em28xx: regression fix: use DRX-K sync firmware requests on em28xx
(2012-10-02 17:15:22 -0300)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git vpfe_3.7_pull

Lad, Prabhakar (1):
      media: davinci: vpfe: fix build error

 drivers/media/platform/davinci/vpfe_capture.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)
