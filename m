Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43078 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab1EaH7r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 03:59:47 -0400
Received: by wya21 with SMTP id 21so3089688wya.19
        for <linux-media@vger.kernel.org>; Tue, 31 May 2011 00:59:46 -0700 (PDT)
Subject: Re: [beagleboard] [PATCH v4 2/2] Add support for mt9p031 (LI-5M03 module) in Beagleboard xM.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <8EFA38E5-E9C6-4C2E-A552-3E7D07DBC596@beagleboard.org>
Date: Tue, 31 May 2011 09:59:44 +0200
Cc: "beagleboard@googlegroups.com Board" <beagleboard@googlegroups.com>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Chris Rodley <carlighting@yahoo.co.nz>, mch_kot@yahoo.com.cn
Content-Transfer-Encoding: 7bit
Message-Id: <E9456CEE-9CC5-450F-BEC7-5E6D81D9466E@dominion.thruhere.net>
References: <1306744637-9051-1-git-send-email-javier.martin@vista-silicon.com> <1306744637-9051-2-git-send-email-javier.martin@vista-silicon.com> <8EFA38E5-E9C6-4C2E-A552-3E7D07DBC596@beagleboard.org>
To: Javier Martin <javier.martin@vista-silicon.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Op 31 mei 2011, om 09:52 heeft Koen Kooi het volgende geschreven:

> 
> Op 30 mei 2011, om 10:37 heeft Javier Martin het volgende geschreven:
> 
>> Since isp clocks have not been exposed yet, this patch
>> includes a temporal solution for testing mt9p031 driver
>> in Beagleboard xM.
> 
> When compiling both as Y I get:
> 
> [    4.231628] mt9p031 2-0048: Failed to reset the camera
> [    4.237030] omap3isp omap3isp: Failed to power on: -121
> [    4.242523] mt9p031 2-0048: Failed to power on device: -121
> [    4.248474] isp_register_subdev_group: Unable to register subdev mt9p031

I tried on an xM rev A2 and xM rev C, same error on both
