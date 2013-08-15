Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42080 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740Ab3HOOPs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Aug 2013 10:15:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1V9yL5-0002P3-9r
	for linux-media@vger.kernel.org; Thu, 15 Aug 2013 16:15:47 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 15 Aug 2013 16:15:47 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 15 Aug 2013 16:15:47 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: OMAP3 ISP DQBUF hangs
Date: Thu, 15 Aug 2013 14:15:28 +0000 (UTC)
Message-ID: <loom.20130815T161444-925@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm working with an OMAP3 DM3730 processor module with a ov3640 camera
module attached on parallel interface. I'm using Linux 3.5 and an
application which builds the pipeline and grabs an image like the
"media-ctl" and the "yavta" tools.

I configured the pipeline to:

sensor->ccdc->memory

When I call ioctl with DQBUF the calling functions are:

isp_video_dqbuf -> omap3isp_video_queue_dqbuf -> isp_video_buffer_wait ->
wait_event_interruptible

The last function waits until the state of the buffer will be reseted
somehow. Can someone tell my which function sets the state of the buffer? Am
I missing an interrupt?

Best Regards, Tom

