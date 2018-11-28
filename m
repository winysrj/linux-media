Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44582 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeK2Fxq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 00:53:46 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1308D55A
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2018 19:51:07 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v4.20] R-Car VSP1 regression fix
Date: Wed, 28 Nov 2018 20:51:34 +0200
Message-ID: <4411475.WBGayxEKp0@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit a7c3a0d5f8d8cd5cdb32c06d4d68f5b4e4d2104b:

  media: mediactl docs: Fix licensing message (2018-11-27 13:52:46 -0500)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git tags/vsp1-fixes-20181128

for you to fetch changes up to cab35a9c77adda8f971a7d1d74b21c0df98ffafe:

  media: vsp1: Fix LIF buffer thresholds (2018-11-28 20:38:50 +0200)

----------------------------------------------------------------
VSP1 regression fixes for v4.20

----------------------------------------------------------------
Laurent Pinchart (1):
      media: vsp1: Fix LIF buffer thresholds

 drivers/media/platform/vsp1/vsp1_lif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Regards,

Laurent Pinchart
