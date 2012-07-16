Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40600 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2GPOdT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 10:33:19 -0400
Received: from avalon.localnet (unknown [91.178.115.48])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id D8E547B0D
	for <linux-media@vger.kernel.org>; Mon, 16 Jul 2012 16:33:18 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.6] uvcvideo fixes
Date: Mon, 16 Jul 2012 16:33:23 +0200
Message-ID: <6425711.7gs2P3ML9l@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following change since commit 931efdf58bd83af8d0578a6cc53421675daf6d41:

  Merge branch 'v4l_for_linus' into staging/for_v3.6 (2012-07-14 15:45:44 -0300)

is available in the git repository at:

  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Jayakrishnan Memana (1):
      uvcvideo: Reset the bytesused field when recycling an erroneous buffer

 drivers/media/video/uvc/uvc_queue.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

-- 
Regards,

Laurent Pinchart

