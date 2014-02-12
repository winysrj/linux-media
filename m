Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:39584 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbaBLQHM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 11:07:12 -0500
Date: Wed, 12 Feb 2014 17:07:11 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: OMAP3 ISP capabilities
In-Reply-To: <17190750.bpa3L6qe94@avalon>
Message-ID: <alpine.DEB.2.01.1402121650200.6337@pmeerw.net>
References: <alpine.DEB.2.01.1402111543380.6474@pmeerw.net> <17190750.bpa3L6qe94@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

> > (3) it should be possible to use the ISP resizer input / output
> > (memory-to-memory) independently; it there any example code doing this?
 
> I haven't written any sample code as such for memory-to-memory operation. I 
> usually use the following media-ctl and yavta commands to test memory-to-
> memory resizing :

> yavta -f YUYV -s 2048x1536 -n 4 --capture=100 \
> 	`media-ctl -e "OMAP3 ISP resizer input"` > resizer-input.log 2>&1 &
> yavta -f YUYV -s 1024x768 -n 4 --capture=100 \
> 	`./media-ctl -e "OMAP3 ISP resizer output"` > resizer-output.log 2>&1 &

thanks for the suggestion; I didn't understand yavta/v4l enough to see how 
it can feed data to the ISP resizer input

p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)
