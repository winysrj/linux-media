Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35312 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751527AbdF0F6c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 01:58:32 -0400
Date: Tue, 27 Jun 2017 08:57:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, s-anna@ti.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org
Subject: Re: [PATCH] media: omap3isp: handle NULL return of
 omap3isp_video_format_info() in ccdc_is_shiftable().
Message-ID: <20170627055756.GX12407@valkosipuli.retiisi.org.uk>
References: <a601fdb6d224f2e4f1a3c1249ebf8438f4b8b5ce.1498499658.git.hns@goldelico.com>
 <20170626201253.GU12407@valkosipuli.retiisi.org.uk>
 <87FCA101-D678-45E9-BD68-25819B9EF443@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87FCA101-D678-45E9-BD68-25819B9EF443@goldelico.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nikolaus,

On Tue, Jun 27, 2017 at 07:46:51AM +0200, H. Nikolaus Schaller wrote:
> Hi,
> 
> > Am 26.06.2017 um 22:12 schrieb Sakari Ailus <sakari.ailus@iki.fi>:
> > 
> > Hi Nikolaus,
> > 
> > On Mon, Jun 26, 2017 at 07:54:19PM +0200, H. Nikolaus Schaller wrote:
> >> If a camera module driver specifies a format that is not
> >> supported by omap3isp this ends in a NULL pointer
> >> dereference instead of a simple fail.
> > 
> > Has this happened in practice?
> 
> Yes. I wouldn't have noticed it otherwise.
> 
> It happens with a new ov965x driver just submitted for review.
> It seems to provide some format that the omap3isp does not understand.
> 
> I can send you a console stack log if needed.

No need to. I think indeed what was missed is that the code may come from
elsewhere than the omap3isp driver pads themselves where it already has been
validated. Adding a comment saying that wouldn't hurt IMO.

I think the following change should be probably made as well. Feel free to
merge to the same patch.

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 7207558..71de993 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1160,7 +1160,8 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	if (!v4l2_subdev_call(sensor, pad, get_fmt, NULL, &fmt_src)) {
 		fmt_info = omap3isp_video_format_info(fmt_src.format.code);
-		depth_in = fmt_info->width;
+		if (fmt_info)
+			depth_in = fmt_info->width;
 	}
 
 	fmt_info = omap3isp_video_format_info(format->code);

> 
> > If it does, it is probably a driver bug ---
> > the formats on its pads should be recognised by the driver.
> 
> > 
> > WARN_ON() around the condition would be good to avoid silently ignoring such
> > issues.
> > 
> > I wonder what Laurent thinks.
> > 
> >> 
> >> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> >> ---
> >> drivers/media/platform/omap3isp/ispccdc.c | 3 +++
> >> 1 file changed, 3 insertions(+)
> >> 
> >> diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
> >> index 2fb755f20a6b..dcf16ee7c612 100644
> >> --- a/drivers/media/platform/omap3isp/ispccdc.c
> >> +++ b/drivers/media/platform/omap3isp/ispccdc.c
> >> @@ -2397,6 +2397,9 @@ static bool ccdc_is_shiftable(u32 in, u32 out, unsigned int additional_shift)
> >> 	in_info = omap3isp_video_format_info(in);
> >> 	out_info = omap3isp_video_format_info(out);
> >> 
> >> +	if (!in_info || !out_info)
> >> +		return false;
> >> +
> >> 	if ((in_info->flavor == 0) || (out_info->flavor == 0))
> >> 		return false;
> >> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
