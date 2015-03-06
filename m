Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12193 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbbCFKQe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2015 05:16:34 -0500
Message-ID: <54F97E7E.1000109@atmel.com>
Date: Fri, 6 Mar 2015 18:16:30 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] media: atmel-isi: move the peripheral clock to start/stop_stream()
 function
References: <1425531661-20040-1-git-send-email-josh.wu@atmel.com> <1425531661-20040-2-git-send-email-josh.wu@atmel.com> <16387779.aQaQKCyNOp@avalon>
In-Reply-To: <16387779.aQaQKCyNOp@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/5/2015 6:39 PM, Laurent Pinchart wrote:
> Hi Josh,
>
> Thank you for the patch.
>
> On Thursday 05 March 2015 13:00:59 Josh Wu wrote:
>> As the clock_start/stop() use to control the mclk for the sensor not the
>> ISI peripheral clock.
>> So we move them to start/stop_stream() function.
> Then the driver will access registers with the peripheral clock disabled, for
> instance in isi_camera_set_fmt() (calling configure_geometry),
> isi_camera_set_bus_param() or atmel_isi_probe(). Isn't that a problem ? Or are
> all registers guaranteed to be accessible (and retained) when the clock is
> disabled ?

So far, I don't see any problem yet. But I'd like to be sure of that. 
I'll give you the feedback after more test.
Thanks for make me head up.

Best Regards,
Josh Wu

>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>>
>>   drivers/media/platform/soc_camera/atmel-isi.c | 12 ++++++------
>>   1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
>> b/drivers/media/platform/soc_camera/atmel-isi.c index 1208818..eb179e7
>> 100644
>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
>> @@ -386,6 +386,10 @@ static int start_streaming(struct vb2_queue *vq,
>> unsigned int count) struct atmel_isi *isi = ici->priv;
>>   	int ret;
>>
>> +	ret = clk_prepare_enable(isi->pclk);
>> +	if (ret)
>> +		return ret;
>> +
>>   	/* Reset ISI */
>>   	ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
>>   	if (ret < 0) {
>> @@ -445,6 +449,8 @@ static void stop_streaming(struct vb2_queue *vq)
>>   	ret = atmel_isi_wait_status(isi, WAIT_ISI_DISABLE);
>>   	if (ret < 0)
>>   		dev_err(icd->parent, "Disable ISI timed out\n");
>> +
>> +	clk_disable_unprepare(isi->pclk);
>>   }
>>
>>   static struct vb2_ops isi_video_qops = {
>> @@ -723,14 +729,9 @@ static int isi_camera_clock_start(struct
>> soc_camera_host *ici) struct atmel_isi *isi = ici->priv;
>>   	int ret;
>>
>> -	ret = clk_prepare_enable(isi->pclk);
>> -	if (ret)
>> -		return ret;
>> -
>>   	if (!IS_ERR(isi->mck)) {
>>   		ret = clk_prepare_enable(isi->mck);
>>   		if (ret) {
>> -			clk_disable_unprepare(isi->pclk);
>>   			return ret;
>>   		}
>>   	}
>> @@ -745,7 +746,6 @@ static void isi_camera_clock_stop(struct soc_camera_host
>> *ici)
>>
>>   	if (!IS_ERR(isi->mck))
>>   		clk_disable_unprepare(isi->mck);
>> -	clk_disable_unprepare(isi->pclk);
>>   }
>>
>>   static unsigned int isi_camera_poll(struct file *file, poll_table *pt)

