Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:58055 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbbFAJ2Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 05:28:24 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 57D442A007E
	for <linux-media@vger.kernel.org>; Mon,  1 Jun 2015 11:28:18 +0200 (CEST)
Message-ID: <556C25B2.4060402@xs4all.nl>
Date: Mon, 01 Jun 2015 11:28:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Final set of compile/sparse fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This set fixes the final compilation and sparse warnings (except for a few remaining
sparse warnings for which I have no obvious solution).

It also improves timestamp handling in the davinci drivers.

Regards,

	Hans

The following changes since commit c1c3c85ddf60a6d97c122d57d385b4929fcec4b3:

  [media] DocBook: fix FE_SET_PROPERTY ioctl arguments (2015-06-01 06:10:15 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2n

for you to fetch changes up to 4dc825912fb78205a3ec5c6d43f9d517569d6adc:

  media: s5p-mfc: fix sparse warnings (2015-06-01 11:19:45 +0200)

----------------------------------------------------------------
Lad, Prabhakar (4):
      media: davinci_vpfe: clear the output_specs
      media: davinci_vpfe: set minimum required buffers to three
      media: davinci_vpfe: use monotonic timestamp
      media: davinci: vpbe: use v4l2_get_timestamp()

Marek Szyprowski (1):
      media: s5p-mfc: fix sparse warnings

 drivers/media/platform/davinci/vpbe_display.c        |  9 ++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c      |  4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c      |  4 ++--
 drivers/staging/media/davinci_vpfe/dm365_resizer.c   |  1 +
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h |  2 --
 drivers/staging/media/davinci_vpfe/vpfe_video.c      | 18 +++++-------------
 6 files changed, 12 insertions(+), 26 deletions(-)
