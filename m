Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:39277 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751244AbeDVLGk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 07:06:40 -0400
Subject: Re: [PATCH 04/15] media: pxa_camera: remove the dmaengine compat need
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <20180402142656.26815-1-robert.jarzmik@free.fr>
 <20180402142656.26815-5-robert.jarzmik@free.fr>
 <871sf8z7f4.fsf@belgarion.home>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dcd81a87-ca7a-3bc8-c457-320d4ce60a83@xs4all.nl>
Date: Sun, 22 Apr 2018 13:06:34 +0200
MIME-Version: 1.0
In-Reply-To: <871sf8z7f4.fsf@belgarion.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/21/2018 09:27 PM, Robert Jarzmik wrote:
> Robert Jarzmik <robert.jarzmik@free.fr> writes:
> 
>> From: Robert Jarzmik <robert.jarzmik@renault.com>
>>
>> As the pxa architecture switched towards the dmaengine slave map, the
>> old compatibility mechanism to acquire the dma requestor line number and
>> priority are not needed anymore.
>>
>> This patch simplifies the dma resource acquisition, using the more
>> generic function dma_request_slave_channel().
>>
>> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
>> ---
>>  drivers/media/platform/pxa_camera.c | 22 +++-------------------
>>  1 file changed, 3 insertions(+), 19 deletions(-)
> Hans, could I have your ack please ?

Done.

	Hans

> 
> Cheers.
> 
> --
> Robert
> 
> PS: The submitted patch
>>
>> diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
>> index c71a00736541..4c82d1880753 100644
>> --- a/drivers/media/platform/pxa_camera.c
>> +++ b/drivers/media/platform/pxa_camera.c
>> @@ -2357,8 +2357,6 @@ static int pxa_camera_probe(struct platform_device *pdev)
>>  		.src_maxburst = 8,
>>  		.direction = DMA_DEV_TO_MEM,
>>  	};
>> -	dma_cap_mask_t mask;
>> -	struct pxad_param params;
>>  	char clk_name[V4L2_CLK_NAME_SIZE];
>>  	int irq;
>>  	int err = 0, i;
>> @@ -2432,34 +2430,20 @@ static int pxa_camera_probe(struct platform_device *pdev)
>>  	pcdev->base = base;
>>  
>>  	/* request dma */
>> -	dma_cap_zero(mask);
>> -	dma_cap_set(DMA_SLAVE, mask);
>> -	dma_cap_set(DMA_PRIVATE, mask);
>> -
>> -	params.prio = 0;
>> -	params.drcmr = 68;
>> -	pcdev->dma_chans[0] =
>> -		dma_request_slave_channel_compat(mask, pxad_filter_fn,
>> -						 &params, &pdev->dev, "CI_Y");
>> +	pcdev->dma_chans[0] = dma_request_slave_channel(&pdev->dev, "CI_Y");
>>  	if (!pcdev->dma_chans[0]) {
>>  		dev_err(&pdev->dev, "Can't request DMA for Y\n");
>>  		return -ENODEV;
>>  	}
>>  
>> -	params.drcmr = 69;
>> -	pcdev->dma_chans[1] =
>> -		dma_request_slave_channel_compat(mask, pxad_filter_fn,
>> -						 &params, &pdev->dev, "CI_U");
>> +	pcdev->dma_chans[1] = dma_request_slave_channel(&pdev->dev, "CI_U");
>>  	if (!pcdev->dma_chans[1]) {
>>  		dev_err(&pdev->dev, "Can't request DMA for Y\n");
>>  		err = -ENODEV;
>>  		goto exit_free_dma_y;
>>  	}
>>  
>> -	params.drcmr = 70;
>> -	pcdev->dma_chans[2] =
>> -		dma_request_slave_channel_compat(mask, pxad_filter_fn,
>> -						 &params, &pdev->dev, "CI_V");
>> +	pcdev->dma_chans[2] = dma_request_slave_channel(&pdev->dev, "CI_V");
>>  	if (!pcdev->dma_chans[2]) {
>>  		dev_err(&pdev->dev, "Can't request DMA for V\n");
>>  		err = -ENODEV;
