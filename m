Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46471 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab2I0X0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 19:26:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Antoine Reversat <a.reversat@gmail.com>
Subject: Re: [PATCH v2] omap3isp: Use monotonic timestamps for statistics buffers
Date: Fri, 28 Sep 2012 01:26:59 +0200
Message-ID: <7333085.5OLvXndp9j@avalon>
In-Reply-To: <5064ADCE.3000708@iki.fi>
References: <1347659868-17398-1-git-send-email-laurent.pinchart@ideasonboard.com> <20120927135233.3acd00a5@redhat.com> <5064ADCE.3000708@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 27 September 2012 22:49:34 Sakari Ailus wrote:
> Mauro Carvalho Chehab wrote:
> > Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> >> V4L2 buffers use the monotonic clock, while statistics buffers use wall
> >> time. This makes it difficult to correlate video frames and statistics.
> >> 
> >> Switch statistics buffers to the monotonic clock to fix this, and
> >> replace struct timeval with struct timespec.
> >> 
> >> Reported-by: Antoine Reversat <a.reversat@gmail.com>
> >> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> ---
> >> 
> >>   drivers/media/platform/omap3isp/ispstat.c |    2 +-
> >>   drivers/media/platform/omap3isp/ispstat.h |    2 +-
> >>   include/linux/omap3isp.h                  |    7 ++++++-
> >>   3 files changed, 8 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/drivers/media/platform/omap3isp/ispstat.c
> >> b/drivers/media/platform/omap3isp/ispstat.c index b8640be..bb21c4e
> >> 100644
> >> --- a/drivers/media/platform/omap3isp/ispstat.c
> >> +++ b/drivers/media/platform/omap3isp/ispstat.c
> >> @@ -256,7 +256,7 @@ static int isp_stat_buf_queue(struct ispstat *stat)
> >> 
> >>   	if (!stat->active_buf)
> >>   	
> >>   		return STAT_NO_BUF;
> >> 
> >> -	do_gettimeofday(&stat->active_buf->ts);
> >> +	ktime_get_ts(&stat->active_buf->ts);
> >> 
> >>   	stat->active_buf->buf_size = stat->buf_size;
> >>   	if (isp_stat_buf_check_magic(stat, stat->active_buf)) {
> >> 
> >> diff --git a/drivers/media/platform/omap3isp/ispstat.h
> >> b/drivers/media/platform/omap3isp/ispstat.h index 9b7c865..8221d0c
> >> 100644
> >> --- a/drivers/media/platform/omap3isp/ispstat.h
> >> +++ b/drivers/media/platform/omap3isp/ispstat.h
> >> @@ -50,7 +50,7 @@ struct ispstat_buffer {
> >> 
> >>   	struct iovm_struct *iovm;
> >>   	void *virt_addr;
> >>   	dma_addr_t dma_addr;
> >> 
> >> -	struct timeval ts;
> >> +	struct timespec ts;
> >> 
> >>   	u32 buf_size;
> >>   	u32 frame_number;
> >>   	u16 config_counter;
> >> 
> >> diff --git a/include/linux/omap3isp.h b/include/linux/omap3isp.h
> >> index c090cf9..263a0c0 100644
> >> --- a/include/linux/omap3isp.h
> >> +++ b/include/linux/omap3isp.h
> >> @@ -27,6 +27,11 @@
> >> 
> >>   #ifndef OMAP3_ISP_USER_H
> >>   #define OMAP3_ISP_USER_H
> >> 
> >> +#ifdef __KERNEL__
> >> +#include <linux/time.h>     /* need struct timespec */
> >> +#else
> >> +#include <sys/time.h>
> >> +#endif
> >> 
> >>   #include <linux/types.h>
> >>   #include <linux/videodev2.h>
> >> 
> >> @@ -164,7 +169,7 @@ struct omap3isp_h3a_aewb_config {
> >> 
> >>    * @config_counter: Number of the configuration associated with the
> >>    data.
> >>    */
> >>   
> >>   struct omap3isp_stat_data {
> >> 
> >> -	struct timeval ts;
> >> +	struct timespec ts;
> > 
> > NACK. That breaks userspace API, as this structure is part of an ioctl.
> > 
> > It is too late to touch here. Please keep timeval. It is ok to fill it
> > with a mononotic time, but replacing it is an API breakage.
> 
> I beg to present a differing opinion.
> 
> The timestamp that has been taken from a realtime clock has NOT been
> useful to begin with in this context: the OMAP3ISP driver has used
> monotonic time on video buffers since the very beginning of its
> existence in mainline kernel. As no-one has complained about this ---
> except Antoine very recently --- I'm pretty certain we wouldn't be
> breaking any application by changing this. The statistics timestamp is
> only useful when it's comparable to other timestamps (from video buffers
> and events), which this patch achieves.

I second this opinion. We're not chaging the size of the omap3isp_stat_data 
structure here, and I'm very confident that there's currently no user of the 
ts field.

-- 
Regards,

Laurent Pinchart

