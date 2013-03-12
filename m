Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:63471 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab3CLKHn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 06:07:43 -0400
Date: Tue, 12 Mar 2013 11:07:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Libin Yang <lbyang@marvell.com>
cc: Albert Wang <twang13@marvell.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: [REVIEW PATCH V4 01/12] [media] marvell-ccic: add MIPI support
 for marvell-ccic driver
In-Reply-To: <A63A0DC671D719488CD1A6CD8BDC16CF230B65F82E@SC-VEXCH4.marvell.com>
Message-ID: <Pine.LNX.4.64.1303121044490.680@axis700.grange>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-2-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1303042128390.20206@axis700.grange>
 <A63A0DC671D719488CD1A6CD8BDC16CF230B65F82E@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Libin

On Tue, 12 Mar 2013, Libin Yang wrote:

> Hi Guennadi,
> 
> Thanks for your careful review. Please help see my comments below.
> 
> >-----Original Message-----
> >From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> >Sent: Tuesday, March 05, 2013 5:35 AM
> >To: Albert Wang
> >Cc: corbet@lwn.net; Linux Media Mailing List; Libin Yang
> >Subject: Re: [REVIEW PATCH V4 01/12] [media] marvell-ccic: add MIPI support for
> >marvell-ccic driver
> >
> >Hi Albert
> >
> >A general comment first: I have no idea about this hardware, so, feel free
> >to ignore all my hardware-handling related comments. But just from looking
> >your handling of the pll1 clock does seem a bit fishy to me. You acquire
> >and release the clock in the generic mcam code, but only use it in the mmp
> >driver. Is it really needed centrally? Wouldn't it suffice to only acquire
> >it in mmp? Same goes for your mcam_config_mipi() function - is it really
> >needed centrally? But as I said, maybe I'm just missing something.
> 
> [Libin] For the mcam_config_mipi() function, it is used to config mipi 
> in the soc. All boards need to configure it if they are using MIPI based 
> on Marvell CCIC. So I think this function should be in the mcam-core.
> 
> For the pll1, I think you are right. Actually, it is board based. MMP 
> based boards are using pll1 to calculate the dphy. And I can not 
> guarantee that all boards need pll1. It seems putting pll1 in the 
> mmp-driver is more reasonable. But do you remember, in the previous 
> patch review, you mentioned that it is better to keep the reference to 
> the clock until clean up, because other components may change it. So 
> what I design is: get pll1 and hold it in the open and release it 
> automatically with devm (It may be better to release the pll1 when 
> closing the camera). The problem is in mmp-driver, there is no such 
> point to get the pll1. The open action is in the mcam-core. If I move 
> getting pll1 to the probe function of mmp-driver and putting it in 
> remove, it means camera driver will hold the pll1 all the time. Do you 
> have some suggestions?

Wouldn't it be possible to acquire the clock in mmpcam_power_up() like

struct mmp_camera {
	...
+	struct clk *mipi;
};

static int mmpcam_probe(struct platform_device *pdev)
{
	...
+	cam->mipi = ERR_PTR(-EINVAL);
	...

-static void mmpcam_power_up(struct mcam_camera *mcam)
+static int mmpcam_power_up(struct mcam_camera *mcam)
{
	...
+	if (mcam->bus_type == V4L2_MBUS_CSI2 && IS_ERR(cam->mipi)) {
+		cam->mipi = devm_clk_get(mcam->dev, "mipi");
+		if (IS_ERR(cam->mipi))
+			return PTR_ERR(cam->mipi);
+	}

Yes, it might be good to change the return type of .plat_power_up() to int 
in a separate patch first. And I think a clock name like "mipi" is better 
suitable here, since, as you say, not on all hardware it will be pll1.

> [snip]
> 
> >
> >> +	if (ret < 0)
> >> +		return ret;
> >>  	mcam_ctlr_irq_enable(cam);
> >>  	cam->state = S_STREAMING;
> >>  	if (!test_bit(CF_SG_RESTART, &cam->flags))
> >> @@ -1551,6 +1602,16 @@ static int mcam_v4l_open(struct file *filp)
> >>  		mcam_set_config_needed(cam, 1);
> >>  	}
> >>  	(cam->users)++;
> >> +	if (cam->bus_type == V4L2_MBUS_CSI2) {
> >> +		cam->pll1 = devm_clk_get(cam->dev, "pll1");
> >> +		if (IS_ERR_OR_NULL(cam->pll1) && cam->dphy[2] == 0) {
> >
> >So, is CSI2 mode only supported with enabled CONFIG_HAVE_CLK? It looks a
> >bit susppicious, but, I think, this might be valid here - you really need
> >a clock, from which you can read a valid rate to use CSI2, right?
> >Otherwise you cannot configure dphy.
> 
> [Libin] If dphy[2] is initialized, it is OK pll1 is not used. Please see 
> the related comments below in the function mmpcam_calc_dphy()

yes, ok, makes sense.

> >
> >> + */
> >> +void mmpcam_calc_dphy(struct mcam_camera *mcam)
> >> +{
> >> +	struct mmp_camera *cam = mcam_to_cam(mcam);
> >> +	struct mmp_camera_platform_data *pdata = cam->pdev->dev.platform_data;
> >> +	struct device *dev = &cam->pdev->dev;
> 
> [snip]
> 
> >> +	}
> >> +
> >> +	/*
> >> +	 * pll1 will never be changed, it is a fixed value
> >> +	 */
> >> +
> >> +	if (IS_ERR_OR_NULL(mcam->pll1))
> >> +		return;
> >
> >All this function does is calculate dphy[] array values, right? And these
> >values are only used if CSI2 is activated. And CSI2 can only be activated
> >if an open() has been successful. And you only succeed a CSI2-mode open()
> >if a clock can be acquired. So, the above check is redundant?
> 
> [Libin] pll1 is used to calculate dphy[2]. If dphy[2] is initialized 
> then pll1 being NULL is OK. Please see the open function. If pll1 is not 
> NULL, then we will calculate the dphy[2] based on pll1.

Ok, makes sense too.

> >
> >> +
> >> +	/* get the escape clk, this is hard coded */
> >> +	tx_clk_esc = (clk_get_rate(mcam->pll1) / 1000000) / 12;
> >> +
> >> +	/*
> >> +	 * dphy[2] - CSI2_DPHY6:
> >> +	 * bit 0 ~ bit 7: CK Term Enable
> >> +	 *  Time for the Clock Lane receiver to enable the HS line
> 
> Regards,
> Libin

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
