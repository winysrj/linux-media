Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41734 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752081AbeEGVdI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 17:33:08 -0400
Date: Tue, 8 May 2018 00:33:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RESEND] [media] omap3isp: support 64-bit version of
 omap3isp_stat_data
Message-ID: <20180507213305.kfxabgkdvf7xwt7m@valkosipuli.retiisi.org.uk>
References: <20180425213044.1535393-1-arnd@arndb.de>
 <2922276.lKgGZtlCEW@avalon>
 <20180507131906.rdvcmvim5gvi5odk@valkosipuli.retiisi.org.uk>
 <CAK8P3a2+Xi8VF7B40zev1CT55HCNE92+MsPEiaGj7tOXEV57dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2+Xi8VF7B40zev1CT55HCNE92+MsPEiaGj7tOXEV57dg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 07, 2018 at 04:36:45PM -0400, Arnd Bergmann wrote:
> On Mon, May 7, 2018 at 9:19 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > On Mon, May 07, 2018 at 04:17:32PM +0300, Laurent Pinchart wrote:
> >> On Thursday, 26 April 2018 00:30:10 EEST Arnd Bergmann wrote:
> >> > +int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
> >> > +                                   struct omap3isp_stat_data_time32 *data)
> >> > +{
> >> > +   struct omap3isp_stat_data data64;
> >> > +   int ret;
> >> > +
> >> > +   ret = omap3isp_stat_request_statistics(stat, &data64);
> >> > +
> >> > +   data->ts.tv_sec = data64.ts.tv_sec;
> >> > +   data->ts.tv_usec = data64.ts.tv_usec;
> >> > +   memcpy(&data->buf, &data64.buf, sizeof(*data) - sizeof(data->ts));
> >> > +
> >> > +   return ret;
> >>
> >> We could return immediately after omap3isp_stat_request_statistics() if the
> >> function fails, but that's no big deal, the error path is clearly a cold path.
> 
> I looked at it again and briefly thought that it would leak kernel stack
> data in my version and changing it would be required to avoid that,
> but I do see now that the absence of the INFO_FL_ALWAYS_COPY
> flag makes it safe after all.
> 
> I agree that returning early here would be nicer here, I'll leave it up to
> Sakari to fold in that change if he likes.

I agree with the change; actually the data64 struct will be left untouched
if there's an error so changing this doesn't seem to make a difference.
Private IOCTLs have always_copy == false, so the argument struct isn't
copied back to the kernel.

The diff is here. Let me know if something went wrong...

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index dfee8eaf2226..47353fee26c3 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -519,12 +519,14 @@ int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
 	int ret;
 
 	ret = omap3isp_stat_request_statistics(stat, &data64);
+	if (ret)
+		return ret;
 
 	data->ts.tv_sec = data64.ts.tv_sec;
 	data->ts.tv_usec = data64.ts.tv_usec;
 	memcpy(&data->buf, &data64.buf, sizeof(*data) - sizeof(data->ts));
 
-	return ret;
+	return 0;
 }
 
 /*

> 
> >> > @@ -165,7 +167,14 @@ struct omap3isp_h3a_aewb_config {
> >> >   * @config_counter: Number of the configuration associated with the data.
> >> >   */
> >> >  struct omap3isp_stat_data {
> >> > +#ifdef __KERNEL__
> >> > +   struct {
> >> > +           __s64   tv_sec;
> >> > +           __s64   tv_usec;
> >> > +   } ts;
> >>
> >> I share Sakari's comment about this method implying a little-endian system,
> >> but as the SoCs that integrate this device are all little-endian, that's not a
> >> problem in practice.
> 
> To clarify: the version I have here does *not* imply a little-endian system,
> it is supposed to work on both little-endian and big-endian builds, and
> endianess is not a property of the SoC either -- you should be able to
> build a big-endian kernel and run it on OMAP3 (aside from bugs in other
> drivers). Using 'long' here instead of __s64 would however make this
> interface broken on big-endian builds since the glibc definition of timeval
> does include extra padding on big-endian machines to make the structure
> compatible between 32-bit and 64-bit ABIs.

Ah, there you go. :-)

> 
> >> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>
> >> If you agree with the small comment about header ordering, let's get this
> >> patch finally merged.
> >
> > I can make the change locally in my tree, no need to resend.
> >
> > Thanks.
> 
> Thanks a lot!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
