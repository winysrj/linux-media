Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33034 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbbFMG5p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Jun 2015 02:57:45 -0400
Received: from avalon.localnet (a91-152-136-245.elisa-laajakaista.fi [91.152.136.245])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id D3F0E2000E
	for <linux-media@vger.kernel.org>; Sat, 13 Jun 2015 08:56:53 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.2] Miscellaneous VSP1 changes
Date: Sat, 13 Jun 2015 09:58:25 +0300
Message-ID: <16874925.kT9TOMUjy3@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

If there's still time to get them in v4.2, could you please pull the following 
patches ?

The following changes since commit e42c8c6eb456f8978de417ea349eef676ef4385c:

  [media] au0828: move dev->boards atribuition to happen earlier (2015-06-10 
12:39:35 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/next

for you to fetch changes up to a61f3619a7ac6d09428cabb8332464cbb45385da:

  media: uapi: vsp1: Use __u32 instead of u32 (2015-06-13 09:56:29 +0300)

----------------------------------------------------------------
Joe Perches (1):
      media: uapi: vsp1: Use __u32 instead of u32

Laurent Pinchart (1):
      MAINTAINERS: Add entry for the Renesas VSP1 driver

 MAINTAINERS               | 9 +++++++++
 include/uapi/linux/vsp1.h | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

-- 
Regards,

Laurent Pinchart

