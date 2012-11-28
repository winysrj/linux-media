Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:54394 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961Ab2K1CO0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 21:14:26 -0500
From: Libin Yang <lbyang@marvell.com>
To: Albert Wang <twang13@marvell.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 27 Nov 2012 18:14:06 -0800
Subject: RE: [PATCH 03/15] [media] marvell-ccic: add clock tree support for
 marvell-ccic driver
Message-ID: <A63A0DC671D719488CD1A6CD8BDC16CF230A8D7846@SC-VEXCH4.marvell.com>
References: <1353677595-24034-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271145320.22273@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D1367C8D5@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D1367C8D5@SC-VEXCH1.marvell.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Guennadi,

Thanks for your suggestion, please see my comments below.

Best Regards,
Libin 

>>-----Original Message-----
>>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>>Sent: Tuesday, 27 November, 2012 18:50
>>To: Albert Wang
>>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>>Subject: Re: [PATCH 03/15] [media] marvell-ccic: add clock tree support for marvell-ccic
>>driver
>>
>>> +		mcam->clk_num = pdata->clk_num;
>>> +	} else {
>>> +		for (i = 0; i < pdata->clk_num; i++) {
>>> +			if (mcam->clk[i]) {
>>> +				clk_put(mcam->clk[i]);
>>> +				mcam->clk[i] = NULL;
>>> +			}
>>> +		}
>>> +		mcam->clk_num = 0;
>>> +	}
>>> +}
>>
>>Don't think I like this. IIUC, your driver should only try to use clocks, that it knows about,
>>not some random clocks, passed from the platform data. So, you should be using explicit
>>clock names. In your platform data you can set whether a specific clock should be used or
>>not, but not pass clock names down. Also you might want to consider using devm_clk_get()
>>and be more careful with error handling.
>>
>OK, we will try to enhance it.

[Libin] Because there are some boards using mmp chip, and the clock names on different board may be totally different. And also this is why the clock number is not definite. To support more boards, the dynamic names are used instead of the static names.
>
>>>
>>>  static int mmpcam_probe(struct platform_device *pdev)  { @@ -290,6
