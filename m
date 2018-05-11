Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:63189 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750758AbeEKOQk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 10:16:40 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 0/2] rcar-vin: Fix potential buffer overrun root cause
Date: Fri, 11 May 2018 16:15:39 +0200
Message-Id: <20180511141541.3164-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Commit 015060cb7795eac3 ("media: rcar-vin: enable field toggle after a 
set number of lines for Gen3") was an attempt to fix the issue of 
writing outside the capture buffer for VIN Gen3. Unfortunately it only 
fixed a symptom of a problem to such a degree I could no longer 
reproduce it.

Jacopo on the other hand working on a different setup still ran into the 
issue. And he even figured out the root cause of the issue. When I 
submitted the original VIN Gen3 support I had when addressing a review 
comment missed to keep the crop and compose dimensions in sync with the 
requested format resulting in the DMA engine not properly stopping 
before writing outside the buffer.

This series reverts the incorrect fix in 1/2 and applies a correct one 
in 2/2. I think this should be picked up for v4.18.

Niklas Söderlund (2):
  Revert "media: rcar-vin: enable field toggle after a set number of
    lines for Gen3"
  rcar-vin: fix crop and compose handling for Gen3

 drivers/media/platform/rcar-vin/rcar-dma.c  | 20 +++++---------------
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  6 ++++++
 2 files changed, 11 insertions(+), 15 deletions(-)

-- 
2.17.0
