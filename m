Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50541 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757490Ab2EaWzI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 May 2012 18:55:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SaEGm-0004qO-6h
	for linux-media@vger.kernel.org; Fri, 01 Jun 2012 00:55:05 +0200
Received: from barracuda.ghs.com ([209.234.187.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 01 Jun 2012 00:55:04 +0200
Received: from jason by barracuda.ghs.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 01 Jun 2012 00:55:04 +0200
To: linux-media@vger.kernel.org
From: Jason Miller <jason@milr.com>
Subject: Support for old Intel webcam
Date: Tue, 29 May 2012 18:46:09 +0000 (UTC)
Message-ID: <loom.20120529T203303-181@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have an old Intel webcam that shows up as:

Bus 002 Device 005: ID 8086:0431 Intel Corp. Intel Pro Video PC Camera

My hazy memory says that this used to work on linux with the spca_50x driver,
though I think I had to add the vendor/device ID manually to the driver.  Is
there any way to determine which chip is used in the camera so I can try doing
so again?

-Jason

