Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33637 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbbEYPed (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 11:34:33 -0400
Received: by wicmx19 with SMTP id mx19so43250497wic.0
        for <linux-media@vger.kernel.org>; Mon, 25 May 2015 08:34:32 -0700 (PDT)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/3] davinci_vpfe: minor cleanups
Date: Mon, 25 May 2015 16:34:26 +0100
Message-Id: <1432568069-11349-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Hi Hans,

These patch series includes minor cleanups for davinci vpfe
driver.

Lad, Prabhakar (3):
  media: davinci_vpfe: clear the output_specs
  media: davinci_vpfe: set minimum required buffers to three
  media: davinci_vpfe: use monotonic timestamp

 drivers/staging/media/davinci_vpfe/dm365_resizer.c   |  1 +
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h |  2 --
 drivers/staging/media/davinci_vpfe/vpfe_video.c      | 18 +++++-------------
 3 files changed, 6 insertions(+), 15 deletions(-)

-- 
2.1.4

