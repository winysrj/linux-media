Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:52866 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3ADKZg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 05:25:36 -0500
Date: Fri, 4 Jan 2013 11:25:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Libin Yang <lbyang@marvell.com>
cc: Albert Wang <twang13@marvell.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH V3 03/15] [media] marvell-ccic: add clock tree support
 for marvell-ccic driver
In-Reply-To: <A63A0DC671D719488CD1A6CD8BDC16CF230AFE224B@SC-VEXCH4.marvell.com>
Message-ID: <Pine.LNX.4.64.1301041042560.28515@axis700.grange>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
 <1355565484-15791-4-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1301011633530.31619@axis700.grange>
 <A63A0DC671D719488CD1A6CD8BDC16CF230AFE224B@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Libin

On Thu, 3 Jan 2013, Libin Yang wrote:

> Hi Guennadi,
> 
> Thanks for your review. Please see my comments below.
> 
> >-----Original Message-----
> >From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> >Sent: Wednesday, January 02, 2013 12:06 AM
> >To: Albert Wang
> >Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
> >Subject: Re: [PATCH V3 03/15] [media] marvell-ccic: add clock tree support for
> >marvell-ccic driver
> >
> >On Sat, 15 Dec 2012, Albert Wang wrote:
> >
> >> From: Libin Yang <lbyang@marvell.com>
> >>
> >> This patch adds the clock tree support for marvell-ccic.
> >>
> >> Each board may require different clk enabling sequence.
> >> Developer need add the clk_name in correct sequence in board driver
> >> to use this feature.
> >>
> >> Signed-off-by: Libin Yang <lbyang@marvell.com>
> >> Signed-off-by: Albert Wang <twang13@marvell.com>
> >> ---
> >>  drivers/media/platform/marvell-ccic/mcam-core.h  |    4 ++
> >>  drivers/media/platform/marvell-ccic/mmp-driver.c |   57 +++++++++++++++++++++-
> >>  include/media/mmp-camera.h                       |    5 ++
> >>  3 files changed, 65 insertions(+), 1 deletion(-)
> >>
> [snip]
> 
> >> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c
> >b/drivers/media/platform/marvell-ccic/mmp-driver.c
> >> index 603fa0a..2c4dce3 100755
> >> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
> >> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
> [snip]
> 
> >> +
> >> +	mcam_clk_set(mcam, 0);
> >>  }
> >>
> >>  /*
> >> @@ -202,7 +223,7 @@ void mmpcam_calc_dphy(struct mcam_camera *mcam)
> >>  	 * pll1 will never be changed, it is a fixed value
> >>  	 */
> >>
> >> -	if (IS_ERR(mcam->pll1))
> >> +	if (IS_ERR_OR_NULL(mcam->pll1))
> >
> >Why are you changing this? If this really were needed, you should do this
> >already in the previous patch, where you add these lines. But I don't
> >think this is a good idea, don't think Russell would like this :-) NULL is
> >a valid clock. Only a negative error is a failure. In fact, if you like,
> >you could initialise .pll1 to ERR_PTR(-EINVAL) in your previous patch in
> >mmpcam_probe().
> 
> In the below code, we will use platform related clk_get_rate() to get the rate. 
> In the function we do not judge the clk is NULL or not. If we do not judge here, 
> we need judge for NULL in the later, otherwise, error may happen. Or do you
> think it is better that we should judge the pointer in the function clk_get_rate()?

I think, there is a problem here. Firstly, if you really want to check for 
"clock API not supported" or a similar type of condition by checking 
get_clk() return value for NULL, you should do this immediately in the 
patch, where you add this code: in "[PATCH V3 02/15] [media] marvell-ccic: 
add MIPI support for marvell-ccic driver." Secondly, it's probably ok to 
check this to say - no clock, co reason to try to use it, in which case 
you skip calculating your ->dphy[2] value, and it remains == 0, 
presumably, is this what you want to have? But, I think, there's a bigger 
problem in your patch #02/15: you don't check for mcam->dphy != NULL. So, 
I think, this has to be fixed in that patch, not here.

[snip]

> >> +{
> >> +	unsigned int i;
> >> +
> >> +	if (NR_MCAM_CLK < pdata->clk_num) {
> >> +		dev_err(mcam->dev, "Too many mcam clocks defined\n");
> >> +		mcam->clk_num = 0;
> >> +		return;
> >> +	}
> >> +
> >> +	if (init) {
> >> +		for (i = 0; i < pdata->clk_num; i++) {
> >> +			if (pdata->clk_name[i] != NULL) {
> >> +				mcam->clk[i] = devm_clk_get(mcam->dev,
> >> +						pdata->clk_name[i]);
> >
> >Sorry, no. Passing clock names in platform data doesn't look right to me.
> >Clock names are a property of the consumer device, not of clock supplier.
> >Also, your platform tells you to get clk_num clocks, you fail to get one
> >of them, you don't continue trying the rest and just return with no error.
> >This seems strange, usually a failure to get clocks, that the platform
> >tells you to get, is fatal.
> 
> I agree that after failing to get the clk, we should return error
> instead of just returning. 
> 
> For the clock names, the clock names are different on different platforms.
> So we need platform data passing the clock names. Do you have any suggestions?

I think you should use the same names on all platforms. As I said, those 
are names of _consumer_ clocks, not of supplier. And the consumer on all 
platforms is the same - your camera unit. If you cannot remove existing 
clock entries for compatibility reasons you, probably, can just add clock 
lookup entries for them. In the _very_ worst case, maybe make a table of 
clock names and, depending on the SoC type use one of them, but that's 
really also not very apropriate, not sure, whether that would be accepted.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
