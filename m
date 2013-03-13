Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:51002 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755550Ab3CMCiI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 22:38:08 -0400
From: Libin Yang <lbyang@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Albert Wang <twang13@marvell.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 12 Mar 2013 19:34:07 -0700
Subject: RE: [REVIEW PATCH V4 01/12] [media] marvell-ccic: add MIPI support
 for marvell-ccic driver
Message-ID: <A63A0DC671D719488CD1A6CD8BDC16CF230B6F4819@SC-VEXCH4.marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-2-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1303042128390.20206@axis700.grange>
 <A63A0DC671D719488CD1A6CD8BDC16CF230B65F82E@SC-VEXCH4.marvell.com>
 <Pine.LNX.4.64.1303121044490.680@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1303121044490.680@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Tuesday, March 12, 2013 6:08 PM
>To: Libin Yang
>Cc: Albert Wang; corbet@lwn.net; Linux Media Mailing List
>Subject: RE: [REVIEW PATCH V4 01/12] [media] marvell-ccic: add MIPI support for
>marvell-ccic driver
>
>Hi Libin
>

>> >
>> >A general comment first: I have no idea about this hardware, so, feel free
>> >to ignore all my hardware-handling related comments. But just from looking
>> >your handling of the pll1 clock does seem a bit fishy to me. You acquire
>> >and release the clock in the generic mcam code, but only use it in the mmp
>> >driver. Is it really needed centrally? Wouldn't it suffice to only acquire
>> >it in mmp? Same goes for your mcam_config_mipi() function - is it really
>> >needed centrally? But as I said, maybe I'm just missing something.
>>
>> [Libin] For the mcam_config_mipi() function, it is used to config mipi
>> in the soc. All boards need to configure it if they are using MIPI based
>> on Marvell CCIC. So I think this function should be in the mcam-core.
>>
>> For the pll1, I think you are right. Actually, it is board based. MMP
>> based boards are using pll1 to calculate the dphy. And I can not
>> guarantee that all boards need pll1. It seems putting pll1 in the
>> mmp-driver is more reasonable. But do you remember, in the previous
>> patch review, you mentioned that it is better to keep the reference to
>> the clock until clean up, because other components may change it. So
>> what I design is: get pll1 and hold it in the open and release it
>> automatically with devm (It may be better to release the pll1 when
>> closing the camera). The problem is in mmp-driver, there is no such
>> point to get the pll1. The open action is in the mcam-core. If I move
>> getting pll1 to the probe function of mmp-driver and putting it in
>> remove, it means camera driver will hold the pll1 all the time. Do you
>> have some suggestions?
>
>Wouldn't it be possible to acquire the clock in mmpcam_power_up() like
>
>struct mmp_camera {
>	...
>+	struct clk *mipi;
>};
>
>static int mmpcam_probe(struct platform_device *pdev)
>{
>	...
>+	cam->mipi = ERR_PTR(-EINVAL);
>	...
>
>-static void mmpcam_power_up(struct mcam_camera *mcam)
>+static int mmpcam_power_up(struct mcam_camera *mcam)
>{
>	...
>+	if (mcam->bus_type == V4L2_MBUS_CSI2 && IS_ERR(cam->mipi)) {
>+		cam->mipi = devm_clk_get(mcam->dev, "mipi");
>+		if (IS_ERR(cam->mipi))
>+			return PTR_ERR(cam->mipi);
>+	}
>
>Yes, it might be good to change the return type of .plat_power_up() to int
>in a separate patch first. And I think a clock name like "mipi" is better
>suitable here, since, as you say, not on all hardware it will be pll1.

[Libin] It is reasonable to acquire the clock in mmpcam_power_up() and release it in mmpcam_power_down(). So we can get the clock when opening and put the clock when closing. Using "mipi" is a good suggestion. And I'd like to put "mipi" clock in the struct mmp_camera, as it is platform related.

>
>> [snip]
>>
>> >

Regards,
Libin
