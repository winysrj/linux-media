Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52815 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab2GJMIZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 08:08:25 -0400
From: "Lad, Prabhakar" <prabhakar.lad@ti.com>
To: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>
CC: "'LMML'" <linux-media@vger.kernel.org>,
	"'dlos'" <davinci-linux-open-source@linux.davincidsp.com>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL] Videobuf dma-contig fix for v3.5
Date: Tue, 10 Jul 2012 12:08:17 +0000
Message-ID: <4665BC9CC4253445B213A010E6DC7B35CE0005@DBDE01.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
 Please pull the following videobuf dma-contig fix for v3.5

Thanks and Regards,
--Prabhakar Lad

The following changes since commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a:

  Linux 3.5-rc6 (2012-07-07 17:23:56 -0700)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git pull_videobuf_core_fix

Lad, Prabhakar (1):
      videobuf-dma-contig: restore buffer mapping for uncached bufers

 drivers/media/video/videobuf-dma-contig.c |   53 +++++++++++++++++-----------
 1 files changed, 32 insertions(+), 21 deletions(-)
