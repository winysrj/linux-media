Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53387 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320Ab2K1Gdx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 01:33:53 -0500
From: Libin Yang <lbyang@marvell.com>
To: Albert Wang <twang13@marvell.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 27 Nov 2012 22:30:33 -0800
Subject: RE: [PATCH 12/15] [media] marvell-ccic: add soc_camera support in
 mmp driver
Message-ID: <A63A0DC671D719488CD1A6CD8BDC16CF230A8D79A7@SC-VEXCH4.marvell.com>
References: <1353677666-24361-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271620370.22273@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D1367C90D@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D1367C90D@SC-VEXCH1.marvell.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Guennadi,

Please see my comments below.

Regards,
Libin 

>-----Original Message-----
>From: Albert Wang
>Sent: Wednesday, November 28, 2012 12:06 AM
>To: Guennadi Liakhovetski
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: RE: [PATCH 12/15] [media] marvell-ccic: add soc_camera support in mmp driver
>
>Hi, Guennadi
>
>
>>-----Original Message-----
>>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>>Sent: Tuesday, 27 November, 2012 23:54
>>To: Albert Wang
>>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>>Subject: Re: [PATCH 12/15] [media] marvell-ccic: add soc_camera support in mmp
>>driver
>>
[snip]

>>>
>>>  	mcam = &cam->mcam;
>>> +	spin_lock_init(&mcam->dev_lock);
>>>  	mcam->plat_power_up = mmpcam_power_up;
>>>  	mcam->plat_power_down = mmpcam_power_down;
>>>  	mcam->ctlr_reset = mcam_ctlr_reset;
>>>  	mcam->calc_dphy = mmpcam_calc_dphy;
>>>  	mcam->dev = &pdev->dev;
>>>  	mcam->use_smbus = 0;
>>> +	mcam->card_name = pdata->name;
>>> +	mcam->mclk_min = pdata->mclk_min;
>>> +	mcam->mclk_src = pdata->mclk_src;
>>> +	mcam->mclk_div = pdata->mclk_div;
>>
>>Actually you don't really have to copy everything from platform data to your private
>>driver object during probing. You can access your platform data also at run-time. So,
>>maybe you can survive without adding these
>>.mclk_* struct members?
>>
>Yes, make sense. :)

[Libin] We add such members because we need use these variables in the file mcam-core-soc.c. In the mcam-core-soc.c, the pdata is invisible. I think we can split the probe function and copy them in the file mcam-core-soc.c as you suggested.

[snip]

>>> +	int chip_id;
>>>  	/*
>>>  	 * MIPI support
>>>  	 */
>>> --
>>> 1.7.9.5
>>>
>>
>>Thanks
>>Guennadi
>>---
>>Guennadi Liakhovetski, Ph.D.
>>Freelance Open-Source Software Developer
>>http://www.open-technology.de/
