Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61230 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2BJIQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 03:16:49 -0500
Date: Fri, 10 Feb 2012 09:16:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de
Subject: Re: [PATCH v4 3/4] media i.MX27 camera: improve discard buffer
 handling.
In-Reply-To: <CACKLOr0p_ggtftXu1G1VbG7g+ZBvD4H707NY4o8-tAz6kP5epw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1202100915350.5787@axis700.grange>
References: <1328609682-18014-1-git-send-email-javier.martin@vista-silicon.com>
 <CACKLOr0ioy2rxKY7PUBDCBPaQG0FUv0Drt-GNgBnNmFDt05T-w@mail.gmail.com>
 <Pine.LNX.4.64.1202092328450.18719@axis700.grange>
 <CACKLOr0p_ggtftXu1G1VbG7g+ZBvD4H707NY4o8-tAz6kP5epw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Fri, 10 Feb 2012, javier Martin wrote:

[snip]

> I'd rather you merge this as it is, because it really fixes a driver
> which is currently buggy. I'll send a clean up series adressing the
> following issues next week:
> 1. Eliminate the unwanted "goto".
> 2. Use list_first_entry() macro.
> 3. Use spin_lock() in ISR.
> 4. Return IRQ_NONE if list is empty and no status bit is set.
> 5. Integrate discard buffers in a more efficient way.

Ok, let's do that.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
