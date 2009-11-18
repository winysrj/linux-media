Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42731 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbZKRMxk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 07:53:40 -0500
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH/RFC v2] V4L core cleanups HG tree
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Wed, 18 Nov 2009 13:54:06 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181354.06529.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

the V4L cleanup patches are now available from

http://linuxtv.org/hg/~pinchartl/v4l-dvb-cleanup

The tree will be rebased if needed (or rather dropped and recreated as hg 
doesn't provide a rebase operation), so please don't pull from it yet if you 
don't want to have to throw the patches away manually later.

I've incorporated the comments received so far and went through all the 
patches to spot bugs that could have sneaked in.

Please test the code against the driver(s) you maintain. The changes are 
small, *should* not create any issue, but the usual bug can still sneak in.

I can't wait for an explicit ack from all maintainers (mostly because I don't 
know you all), so I'll send a pull request in a week if there's no blocking 
issue. I'd like this to get in 2.6.33 if possible.

--
Regards,

Laurent Pinchart
