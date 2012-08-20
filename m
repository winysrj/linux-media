Return-path: <linux-media-owner@vger.kernel.org>
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:16059
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824Ab2HTDDz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Aug 2012 23:03:55 -0400
Date: Mon, 20 Aug 2012 11:03:40 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: javier Martin <javier.martin@vista-silicon.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
	<sakari.ailus@maxwell.research.nokia.com>,
	<kyungmin.park@samsung.com>, <s.nawrocki@samsung.com>,
	<laurent.pinchart@ideasonboard.com>, <mchehab@infradead.org>,
	<s.hauer@pengutronix.de>, <p.zabel@pengutronix.de>,
	<linuxzsc@gmail.com>, <shawn.guo@linaro.org>
Subject: Re: [v7] media: coda: Add driver for Coda video codec.
Message-ID: <20120820030339.GB4011@b20223-02.ap.freescale.net>
References: <1343043061-24327-1-git-send-email-javier.martin@vista-silicon.com>
 <20120803082442.GE29944@b20223-02.ap.freescale.net>
 <201208031047.01174.hverkuil@xs4all.nl>
 <20120803090329.GA15809@b20223-02.ap.freescale.net>
 <CACKLOr2XRz5edR0ZEE3UFD5enbUEMi+OkfRsn1JvOmh=NBqt8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACKLOr2XRz5edR0ZEE3UFD5enbUEMi+OkfRsn1JvOmh=NBqt8A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Did the patch get picked? I didn't see it on
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git


Still, how did you test this v4l2 device?

Thanks
Richard

On Fri, Aug 03, 2012 at 01:21:02PM +0200, javier Martin wrote:
> Hi Richard,
> thank you for your review.
> 
> This patch has been reviewed and acked by several people:
> 
>     Reviewed-by: Philipp Zabel<p.zabel@pengutronix.de>
>     Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>     Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> For this reason a pull request has already been sent to Mauro recently:
> 
> http://patchwork.linuxtv.org/patch/13483/
> 
> 
> >> In this case I personally don't think it will be easier to read if this line is split up.
> > My point here is checkpatch.
> > total: 2 errors, 30 warnings, 2086 lines checked
> 
> Thank you for noticing this. I have solved it in my tree so that Mauro
> can pull for 3.7.
> 
> You can find it here:
> 
> https://github.com/jmartinc/video_visstrim.git  for_3.6
> 
> Regarding your i.MX6 question, maybe Philippe will be able to help you
> since I am only interested on i.MX27. However, the driver was
> developed considering much of his suggestions so that adding support
> for different chips later is as straightforward as possible.
> 
> -- 
> Javier Martin
> Vista Silicon S.L.
> CDTUC - FASE C - Oficina S-345
> Avda de los Castros s/n
> 39005- Santander. Cantabria. Spain
> +34 942 25 32 60
> www.vista-silicon.com
> 

