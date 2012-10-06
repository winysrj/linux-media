Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab2JFOjX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Oct 2012 10:39:23 -0400
Date: Sat, 6 Oct 2012 11:39:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Rob Herring <rob.herring@calxeda.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 27/34] media: mx2_camera: remove cpu_is_xxx by using
 platform_device_id
Message-ID: <20121006113905.3facece0@redhat.com>
In-Reply-To: <20121006082638.GB20231@S2101-09.ap.freescale.net>
References: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org>
	<1348123547-31082-28-git-send-email-shawn.guo@linaro.org>
	<20120927160321.56420910@redhat.com>
	<20121006082638.GB20231@S2101-09.ap.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 6 Oct 2012 16:26:40 +0800
Shawn Guo <shawn.guo@linaro.org> escreveu:

> On Thu, Sep 27, 2012 at 04:03:21PM -0300, Mauro Carvalho Chehab wrote:
> > It seems that it depends on some stuff that got merged via the arm tree.
> > 
> > Not sure what would the better way to handle that, as applying it via -arm
> > will likely generate conflicts when merging from both trees upstream.
> > 
> > If this change is not urgent, maybe it would be better to apply it after
> > the end of the merge window, via either one of the trees.
> > 
> That's the original plan, having it merged via arm-soc tree at the end
> of 3.7 merge window.  But I was told by arm-soc folks that we already
> have enough conflicts to sort out for this window, and we do not want
> any more.  And we have to postpone it to 3.8.
> 
> I will publish a topic branch for this series after 3.7-rc1 comes out.

Ok. Btw, as expected, the patch doesn't apply cleanly anymore, due to the
file renames. Waiting for 3.7-rc1 seems to be the right thing to do here.


-- 
Regards,
Mauro
