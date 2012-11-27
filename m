Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:37055 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754177Ab2K0Lbj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 06:31:39 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Tue, 27 Nov 2012 03:32:39 -0800
Subject: RE: [PATCH 04/15] [media] marvell-ccic: reset ccic phy when stop
 streaming for stability
Message-ID: <477F20668A386D41ADCC57781B1F70430D1367C8D7@SC-VEXCH1.marvell.com>
References: <1353677603-24071-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271152240.22273@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1211271152240.22273@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

Thanks for your review!


>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Tuesday, 27 November, 2012 18:57
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH 04/15] [media] marvell-ccic: reset ccic phy when stop streaming for
>stability
>
>On Fri, 23 Nov 2012, Albert Wang wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch adds the reset ccic phy operation when stop streaming.
>>
>> Without reset ccic phy, the next start streaming may be unstable.
>>
>> Also need add CCIC2 definition when PXA688/PXA2128 support dual ccics.
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> ---
>>  drivers/media/platform/marvell-ccic/mcam-core.c  |    5 +++++
>>  drivers/media/platform/marvell-ccic/mcam-core.h  |    2 ++
>>  drivers/media/platform/marvell-ccic/mmp-driver.c |   25 ++++++++++++++++++++++
>>  3 files changed, 32 insertions(+)
>>
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c
>> b/drivers/media/platform/marvell-ccic/mcam-core.c
>> index b111f0d..760e8ea 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
>> @@ -1053,6 +1053,11 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
>>  		return -EINVAL;
>>  	mcam_ctlr_stop_dma(cam);
>>  	/*
>> +	 * Reset the CCIC PHY after stopping streaming,
>> +	 * otherwise, the CCIC may be unstable.
>> +	 */
>> +	cam->ctlr_reset(cam);
>
>Aren't you breaking the cafe driver by calling .ctrl_reset() without checking for NULL? Same
>holds for your .calc_dphy() callback too.
>
Sorry, it's our mistake.
We will fix it soon.

>> +	/*
>>  	 * VB2 reclaims the buffers, so we need to forget
>>  	 * about them.
>>  	 */
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h
>> b/drivers/media/platform/marvell-ccic/mcam-core.h
>> index 0df6b1c..40368f6 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
>> @@ -103,6 +103,7 @@ struct mcam_camera {
>>  	short int use_smbus;	/* SMBUS or straight I2c? */
>>  	enum mcam_buffer_mode buffer_mode;
>>
>> +	int ccic_id;
>>  	/* MIPI support */
>>  	int bus_type;
>>  	int (*dphy)[3];
>> @@ -119,6 +120,7 @@ struct mcam_camera {
>>  	void (*plat_power_up) (struct mcam_camera *cam);
>>  	void (*plat_power_down) (struct mcam_camera *cam);
>>  	void (*calc_dphy)(struct mcam_camera *cam);
>> +	void (*ctlr_reset)(struct mcam_camera *cam);
>>
>>  	/*
>>  	 * Everything below here is private to the mcam core and diff --git
>> a/drivers/media/platform/marvell-ccic/mmp-driver.c
>> b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> index 80977b0..20046d0 100755
>> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
>> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> @@ -103,6 +103,7 @@ static struct mmp_camera *mmpcam_find_device(struct
>platform_device *pdev)
>>  #define CPU_SUBSYS_PMU_BASE	0xd4282800
>>  #define REG_CCIC_DCGCR		0x28	/* CCIC dyn clock gate ctrl reg */
>>  #define REG_CCIC_CRCR		0x50	/* CCIC clk reset ctrl reg	*/
>> +#define REG_CCIC2_CRCR		0xf4	/* CCIC2 clk reset ctrl reg	*/
>>
>>  static void mcam_clk_set(struct mcam_camera *mcam, int on)  { @@
>> -174,6 +175,28 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
>>  	mcam_clk_set(mcam, 0);
>>  }
>>
>> +void mcam_ctlr_reset(struct mcam_camera *mcam) {
>> +	unsigned long val;
>> +	struct mmp_camera *cam = mcam_to_cam(mcam);
>> +
>> +	if (mcam->ccic_id) {
>> +		/*
>> +		 * Using CCIC2
>> +		 */
>> +		val = ioread32(cam->power_regs + REG_CCIC2_CRCR);
>> +		iowrite32(val & ~0x2, cam->power_regs + REG_CCIC2_CRCR);
>> +		iowrite32(val | 0x2, cam->power_regs + REG_CCIC2_CRCR);
>> +	} else {
>> +		/*
>> +		 * Using CCIC1
>> +		 */
>> +		val = ioread32(cam->power_regs + REG_CCIC_CRCR);
>> +		iowrite32(val & ~0x2, cam->power_regs + REG_CCIC_CRCR);
>> +		iowrite32(val | 0x2, cam->power_regs + REG_CCIC_CRCR);
>> +	}
>> +}
>> +
>>  /*
>>   * calc the dphy register values
>>   * There are three dphy registers being used.
>> @@ -301,9 +324,11 @@ static int mmpcam_probe(struct platform_device *pdev)
>>  	mcam = &cam->mcam;
>>  	mcam->plat_power_up = mmpcam_power_up;
>>  	mcam->plat_power_down = mmpcam_power_down;
>> +	mcam->ctlr_reset = mcam_ctlr_reset;
>>  	mcam->calc_dphy = mmpcam_calc_dphy;
>>  	mcam->dev = &pdev->dev;
>>  	mcam->use_smbus = 0;
>> +	mcam->ccic_id = pdev->id;
>>  	mcam->bus_type = pdata->bus_type;
>>  	mcam->dphy = &(pdata->dphy);
>>  	mcam->mipi_enabled = 0;
>> --
>> 1.7.9.5
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer http://www.open-technology.de/
