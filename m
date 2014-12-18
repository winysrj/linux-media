Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:52077 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaLROsF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 09:48:05 -0500
Message-ID: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
Subject: [RFC PATCH 0/5] media: rcar_vin: Fixes for buffer management
From: Ben Hutchings <ben.hutchings@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 18 Dec 2014 14:47:50 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a re-submission of patches previously sent and archived at
<http://thread.gmane.org/gmane.linux.ports.sh.devel/37184/>.  Will has
rebased onto 3.18 and added a further patch to address Hans' review
comments.

The driver continues to works for single frame capture, and no longer
provokes a WARNing.  However, video capture has regressed (a gstreamer
capture pipeline yields a zero-length file).

Ben.

Ian Molton (4):
  media: rcar_vin: Dont aggressively retire buffers
  media: rcar_vin: Ensure all in-flight buffers are returned to error
    state before stopping.
  media: rcar_vin: Fix race condition terminating stream
  media: rcar_vin: Clean up rcar_vin_irq

William Towle (1):
  media: rcar_vin: move buffer management to .stop_streaming handler

 drivers/media/platform/soc_camera/rcar_vin.c |  109 ++++++++++++++------------
 1 file changed, 59 insertions(+), 50 deletions(-)

-- 
1.7.10.4



