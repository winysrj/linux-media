Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:44411 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438Ab3AATbZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 14:31:25 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Tue, 1 Jan 2013 11:31:15 -0800
Subject: RE: [PATCH V3 02/15] [media] marvell-ccic: add MIPI support for
 marvell-ccic driver
Message-ID: <477F20668A386D41ADCC57781B1F70430D13EA8814@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
 <1355565484-15791-3-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1301011600060.31619@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1301011600060.31619@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

Happy New Year!

Thank you for your review!

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Tuesday, 01 January, 2013 23:28
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 02/15] [media] marvell-ccic: add MIPI support for marvell-ccic
>driver
>
>Hi Albert
>
>Looks quite good to me, thanks for addressing my comments! Just a minor
>nitpick below:
>
>On Sat, 15 Dec 2012, Albert Wang wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch adds the MIPI support for marvell-ccic.
>> Board driver should determine whether using MIPI or not.
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> ---
>
>A general request for future revisions: it would help if you could list changes
>since the last version here - after any Sob's and the "---" line.
>
>>  drivers/media/platform/marvell-ccic/mcam-core.c  |   70 ++++++++++++++++++++
>>  drivers/media/platform/marvell-ccic/mcam-core.h  |   24 ++++++-
>>  drivers/media/platform/marvell-ccic/mmp-driver.c |   75 +++++++++++++++++++++-
>>  include/media/mmp-camera.h                       |   10 +++
>>  4 files changed, 177 insertions(+), 2 deletions(-)
>
>[snip]
>
>> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c
>b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> index c4c17fe..603fa0a 100755
>> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
>> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
>
>[snip]
>
>> @@ -183,8 +251,14 @@ static int mmpcam_probe(struct platform_device *pdev)
>>  	mcam = &cam->mcam;
>>  	mcam->plat_power_up = mmpcam_power_up;
>>  	mcam->plat_power_down = mmpcam_power_down;
>> +	mcam->calc_dphy = mmpcam_calc_dphy;
>> +	mcam->pll1 = NULL;
>
>Strictly speaking this is not needed, it's allocated using kzalloc(). Kinda
>pointless to use kzalloc() and then explicitly initialise each field,
>including 0 / NULL...
>
[Albert Wang] OK, We will update it.

>>  	mcam->dev = &pdev->dev;
>>  	mcam->use_smbus = 0;
>> +	mcam->bus_type = pdata->bus_type;
>> +	mcam->dphy = pdata->dphy;
>> +	mcam->mipi_enabled = 0;
>
>ditto
>
>> +	mcam->lane = pdata->lane;
>>  	mcam->chip_id = V4L2_IDENT_ARMADA610;
>>  	mcam->buffer_mode = B_DMA_sg;
>>  	spin_lock_init(&mcam->dev_lock);
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
