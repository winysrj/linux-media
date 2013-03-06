Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:33831 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758230Ab3CFOQo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 09:16:44 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Wed, 6 Mar 2013 06:10:43 -0800
Subject: RE: [REVIEW PATCH V4 07/12] [media] marvell-ccic: switch to
 resource managed allocation and request
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D8DAA8A@SC-VEXCH1.marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-8-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1303051115560.25837@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1303051115560.25837@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi


>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Tuesday, 05 March, 2013 18:18
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [REVIEW PATCH V4 07/12] [media] marvell-ccic: switch to resource
>managed allocation and request
>
>Yet one more nitpick
>
>On Thu, 7 Feb 2013, Albert Wang wrote:
>
>> This patch switchs to resource managed allocation and request in mmp-driver.
>> It can remove free resource operations.
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> Acked-by: Jonathan Corbet <corbet@lwn.net>
>> ---
>>  drivers/media/platform/marvell-ccic/mmp-driver.c |   65 ++++++++--------------
>>  1 file changed, 22 insertions(+), 43 deletions(-)
>>
>> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c
>b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> index 818abf3..d355840 100755
>> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
>> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
>
>[snip]
>
>> @@ -374,14 +373,12 @@ static int mmpcam_probe(struct platform_device *pdev)
>>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>  	if (res == NULL) {
>>  		dev_err(&pdev->dev, "no iomem resource!\n");
>> -		ret = -ENODEV;
>> -		goto out_free;
>> +		return -ENODEV;
>>  	}
>> -	mcam->regs = ioremap(res->start, resource_size(res));
>> +	mcam->regs = devm_request_and_ioremap(&pdev->dev, res);
>
>Don't kill me, but they've recently invented devm_ioremap_resource(),
>which is essentially the same as devm_request_and_ioremap(), but also
>returns an error code and prints an error message, so, you wouldn't have
>to invent -ENODEV yourself and you don't need the dev_err() below.
>
OK, we will investigate devm_ioremap_resource() and use it if need.


>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

Thanks
Albert Wang
86-21-61092656
