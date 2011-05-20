Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36713 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933861Ab1ETP5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 11:57:42 -0400
Received: by wya21 with SMTP id 21so2834342wya.19
        for <linux-media@vger.kernel.org>; Fri, 20 May 2011 08:57:41 -0700 (PDT)
Subject: Re: [beagleboard] [PATCH v2 2/2] OMAP3BEAGLE: Add support for mt9p031 sensor driver.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@beagleboard.org>
In-Reply-To: <1305899272-31839-2-git-send-email-javier.martin@vista-silicon.com>
Date: Fri, 20 May 2011 17:57:34 +0200
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, carlighting@yahoo.co.nz,
	linux-arm-kernel@lists.infradead.org,
	Javier Martin <javier.martin@vista-silicon.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <DDCBBAA2-C49C-4952-9D1B-519D8A3AB41E@beagleboard.org>
References: <1305899272-31839-1-git-send-email-javier.martin@vista-silicon.com> <1305899272-31839-2-git-send-email-javier.martin@vista-silicon.com>
To: "beagleboard@googlegroups.com Board" <beagleboard@googlegroups.com>,
	Jason Kridner <jkridner@beagleboard.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Op 20 mei 2011, om 15:47 heeft Javier Martin het volgende geschreven:

> isp.h file has to be included as a temporal measure
> since clocks of the isp are not exposed yet.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
> arch/arm/mach-omap2/board-omap3beagle.c |  127 ++++++++++++++++++++++++++++++-

Javier,

In previous patch sets we put that in a seperate file (omap3beagle-camera.c) so we don't clutter up the board file with all the different sensor drivers. Would it make sense to do the same with the current patches? It looks like MCF cuts down a lot on the boilerplace needed already.

regards,

Koen