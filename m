Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:53639 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab2DJMe6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 08:34:58 -0400
Date: Tue, 10 Apr 2012 14:34:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: alex gershgorin <alexgershgorin@gmail.com>
cc: Sascha Hauer <s.hauer@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-fbdev@vger.kernel.org
Subject: Re: mx3fb overlay support
In-Reply-To: <CAJP5LRNwPXx_sQ=uX4AZDz9HvLdF_nRcoVXBkAWmidVpbdby9g@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1204101420050.7641@axis700.grange>
References: <CAJP5LRNwPXx_sQ=uX4AZDz9HvLdF_nRcoVXBkAWmidVpbdby9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex

On Tue, 10 Apr 2012, alex gershgorin wrote:

> Hi Guennadi,
> 
> In mx3fb current version overlay does not supporting,
> I came across a patch 3/4 v4 i.MX31: framebuffer driver that you submitted
> in 2008,
> there was support Overlay, but for some reason in the next versions overlay
> support has been removed.
> 
> As you understand this is necessary if we want to use the foreground and
> background Planes.
> in my case, one has to display live video, and other graphics.
> 
> I would like to hear your opinion, if may reuse a part of this patch,
> and add overlay support to mx3fb current version.

Maybe this note in the original commit message explains the reason: 
"Overlay support is included but has never been tested." ;-)

> if necessary, I am ready to provide any assistance :-)

Sure, please, re-add it, test, fix, any improvements are welcome.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
