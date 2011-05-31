Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37981 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1EaHwK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 03:52:10 -0400
Received: by wya21 with SMTP id 21so3085752wya.19
        for <linux-media@vger.kernel.org>; Tue, 31 May 2011 00:52:09 -0700 (PDT)
Subject: Re: [beagleboard] [PATCH v4 2/2] Add support for mt9p031 (LI-5M03 module) in Beagleboard xM.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@beagleboard.org>
In-Reply-To: <1306744637-9051-2-git-send-email-javier.martin@vista-silicon.com>
Date: Tue, 31 May 2011 09:52:05 +0200
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, carlighting@yahoo.co.nz,
	mch_kot@yahoo.com.cn,
	Javier Martin <javier.martin@vista-silicon.com>
Content-Transfer-Encoding: 7bit
Message-Id: <8EFA38E5-E9C6-4C2E-A552-3E7D07DBC596@beagleboard.org>
References: <1306744637-9051-1-git-send-email-javier.martin@vista-silicon.com> <1306744637-9051-2-git-send-email-javier.martin@vista-silicon.com>
To: beagleboard@googlegroups.com
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Op 30 mei 2011, om 10:37 heeft Javier Martin het volgende geschreven:

> Since isp clocks have not been exposed yet, this patch
> includes a temporal solution for testing mt9p031 driver
> in Beagleboard xM.

When compiling both as Y I get:

[    4.231628] mt9p031 2-0048: Failed to reset the camera
[    4.237030] omap3isp omap3isp: Failed to power on: -121
[    4.242523] mt9p031 2-0048: Failed to power on device: -121
[    4.248474] isp_register_subdev_group: Unable to register subdev mt9p031

regards,

Koen
