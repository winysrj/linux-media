Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53179 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab3LJKmq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 05:42:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VqKm4-00016E-3M
	for linux-media@vger.kernel.org; Tue, 10 Dec 2013 11:42:44 +0100
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 10 Dec 2013 11:42:44 +0100
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 10 Dec 2013 11:42:44 +0100
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: use other formats from ov3640 camera sensor through the isp pipeline
Date: Tue, 10 Dec 2013 10:42:22 +0000 (UTC)
Message-ID: <loom.20131210T113548-646@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am using the ov3640 camera sensor along with the isp pipeline and
configured it like: sensor->ccdc->memory

My sensor supports more formats like rgb565 and so. Does anyone have an idea
how I could manage to set these formats out of the users application? If I
understand it right, the isp pipeline will not allow a format the ccdc sink
pad does not know.

Regards, Tom

