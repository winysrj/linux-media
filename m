Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-181.synserver.de ([212.40.185.181]:1100 "EHLO
	smtp-out-181.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440Ab2HFOdB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 10:33:01 -0400
Message-ID: <501FD69D.7070702@metafoo.de>
Date: Mon, 06 Aug 2012 16:37:17 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Julia Lawall <Julia.Lawall@lip6.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media/video/mx2_emmaprp.c: use devm_kzalloc and
 devm_clk_get
References: <1344104607-18805-1-git-send-email-Julia.Lawall@lip6.fr> <20120806142323.GO4352@mwanda> <20120806142650.GT4403@mwanda>
In-Reply-To: <20120806142650.GT4403@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/06/2012 04:26 PM, Dan Carpenter wrote:
> On Mon, Aug 06, 2012 at 05:23:23PM +0300, Dan Carpenter wrote:
>> On Sat, Aug 04, 2012 at 08:23:27PM +0200, Julia Lawall wrote:
>>> @@ -922,12 +920,7 @@ static int emmaprp_probe(struct platform_device *pdev)
>>>  
>>>  	platform_set_drvdata(pdev, pcdev);
>>>  
>>> -	if (devm_request_mem_region(&pdev->dev, res_emma->start,
>>> -	    resource_size(res_emma), MEM2MEM_NAME) == NULL)
>>> -		goto rel_vdev;
>>> -
>>> -	pcdev->base_emma = devm_ioremap(&pdev->dev, res_emma->start,
>>> -					resource_size(res_emma));
>>> +	pcdev->base_emma = devm_request_and_ioremap(&pdev->dev, res_emma);
>>>  	if (!pcdev->base_emma)
>>>  		goto rel_vdev;
>>
>> This was in the original code, but there is a "ret = -ENOMEM;"
>> missing here, and again a couple lines down in the original code.
>>
> 
> Or should that be -EIO instead of -ENOMEM?  I'm not sure.

-ENXIO is usually used in such a case.

- Lars
