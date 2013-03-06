Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:51692 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756967Ab3CFONd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 09:13:33 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Wed, 6 Mar 2013 06:10:28 -0800
Subject: RE: [REVIEW PATCH V4 01/12] [media] marvell-ccic: add MIPI support
 for marvell-ccic driver
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D8DAA87@SC-VEXCH1.marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-2-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1303051119210.25837@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1303051119210.25837@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Tuesday, 05 March, 2013 18:21
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [REVIEW PATCH V4 01/12] [media] marvell-ccic: add MIPI support for
>marvell-ccic driver
>
>Oh, one more thing occurred to me after looking at your another patch:
>
>On Thu, 7 Feb 2013, Albert Wang wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch adds the MIPI support for marvell-ccic.
>> Board driver should determine whether using MIPI or not.
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> ---
>>  drivers/media/platform/marvell-ccic/mcam-core.c  |   66 +++++++++++++
>>  drivers/media/platform/marvell-ccic/mcam-core.h  |   28 +++++-
>>  drivers/media/platform/marvell-ccic/mmp-driver.c |  113 +++++++++++++++++++++-
>>  include/media/mmp-camera.h                       |   10 ++
>>  4 files changed, 214 insertions(+), 3 deletions(-)
>
>[snip]
>
>> @@ -183,8 +285,18 @@ static int mmpcam_probe(struct platform_device *pdev)
>>  	mcam = &cam->mcam;
>>  	mcam->plat_power_up = mmpcam_power_up;
>>  	mcam->plat_power_down = mmpcam_power_down;
>> +	mcam->calc_dphy = mmpcam_calc_dphy;
>>  	mcam->dev = &pdev->dev;
>>  	mcam->use_smbus = 0;
>> +	mcam->bus_type = pdata->bus_type;
>> +	mcam->dphy = pdata->dphy;
>> +	/* mosetly it won't happen. dphy is an array in pdata, but in case .. */
>> +	if (unlikely(mcam->dphy == NULL)) {
>
>There's no such case - you did define it as an array, this will never be
>NULL.
>
Yes, we will change it.

>> +		ret = -EINVAL;
>> +		goto out_free;
>> +	}
>> +	mcam->mipi_enabled = 0;
>> +	mcam->lane = pdata->lane;
>>  	mcam->chip_id = V4L2_IDENT_ARMADA610;
>>  	mcam->buffer_mode = B_DMA_sg;
>>  	spin_lock_init(&mcam->dev_lock);
>> @@ -223,7 +335,6 @@ static int mmpcam_probe(struct platform_device *pdev)
>>  	 * Find the i2c adapter.  This assumes, of course, that the
>>  	 * i2c bus is already up and functioning.
>>  	 */
>> -	pdata = pdev->dev.platform_data;
>>  	mcam->i2c_adapter = platform_get_drvdata(pdata->i2c_device);
>>  	if (mcam->i2c_adapter == NULL) {
>>  		ret = -ENODEV;
>> diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
>> index 7611963..813efe2 100755
>> --- a/include/media/mmp-camera.h
>> +++ b/include/media/mmp-camera.h
>> @@ -1,3 +1,4 @@
>> +#include <media/v4l2-mediabus.h>
>>  /*
>>   * Information for the Marvell Armada MMP camera
>>   */
>> @@ -6,4 +7,13 @@ struct mmp_camera_platform_data {
>>  	struct platform_device *i2c_device;
>>  	int sensor_power_gpio;
>>  	int sensor_reset_gpio;
>> +	enum v4l2_mbus_type bus_type;
>> +	/*
>> +	 * MIPI support
>> +	 */
>> +	int dphy[3];		/* DPHY: CSI2_DPHY3, CSI2_DPHY5, CSI2_DPHY6 */
>> +	int dphy3_algo;		/* Exist 2 algos for calculate CSI2_DPHY3 */
>> +	int mipi_enabled;	/* MIPI enabled flag */
>> +	int lane;		/* ccic used lane number; 0 means DVP mode */
>> +	int lane_clk;
>>  };
>> --
>> 1.7.9.5
>>
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

Thanks
Albert Wang
86-21-61092656
