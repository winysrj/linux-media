Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab2AILbd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 06:31:33 -0500
Date: Mon, 9 Jan 2012 12:31:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	lethal@linux-sh.org, hans.verkuil@cisco.com, s.hauer@pengutronix.de
Subject: Re: [PATCH] media i.MX27 camera: properly detect frame loss.
In-Reply-To: <CACKLOr0W+_k7NaRpqwFHjXP99-4kr+diFt3SqHG_6FUpDdMqNw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1201091229230.674@axis700.grange>
References: <1325494293-3968-1-git-send-email-javier.martin@vista-silicon.com>
 <CACKLOr0W+_k7NaRpqwFHjXP99-4kr+diFt3SqHG_6FUpDdMqNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Mon, 9 Jan 2012, javier Martin wrote:

> Hi Guennadi,
> this is the patch I mentioned that fixes sequence count so that it
> complies with v4l2 API.
> 
> Will you please merge?

Don't worry, I haven't forgotten about it. You rate it as a fix, so, I'll 
have another look at it and if nothing is wrong with it, it should be ok 
to go in after -rc1 or -rc2.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
