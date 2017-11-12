Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54742 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdKLQig (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Nov 2017 11:38:36 -0500
Subject: Re: [PATCH v2] media: vsp1: Prevent suspending and resuming DRM
 pipelines
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
 <c1f99c379343a52a4923b3bf74a9e366f4e89dcb.1505898862.git-series.kieran.bingham+renesas@ideasonboard.com>
 <12283788.m7AaoQf6S4@avalon>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
Message-ID: <2e94b8b2-267e-1392-ca2d-4bb0e79ade66@ideasonboard.com>
Date: Sun, 12 Nov 2017 16:38:31 +0000
MIME-Version: 1.0
In-Reply-To: <12283788.m7AaoQf6S4@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/11/17 04:28, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Wednesday, 20 September 2017 12:16:54 EET Kieran Bingham wrote:
>> When used as part of a display pipeline, the VSP is stopped and
>> restarted explicitly by the DU from its suspend and resume handlers.
>> There is thus no need to stop or restart pipelines in the VSP suspend
>> and resume handlers, and doing so would cause the hardware to be
>> left in a misconfigured state.
>>
>> Ensure that the VSP suspend and resume handlers do not affect DRM
>> based pipelines.
> 
> s/DRM-base/DRM-based/

-ENOMATCH


> 
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>  drivers/media/platform/vsp1/vsp1_drv.c | 16 ++++++++++++++--
>>  1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c
>> b/drivers/media/platform/vsp1/vsp1_drv.c index 962e4c304076..ed25ba9d551b
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_drv.c
>> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
>> @@ -571,7 +571,13 @@ static int __maybe_unused vsp1_pm_suspend(struct device
>> *dev) {
>>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
>>
>> -	vsp1_pipelines_suspend(vsp1);
>> +	/*
>> +	 * When used as part of a display pipeline, the VSP is stopped and
>> +	 * restarted explicitly by the DU
> 
> s/DU/DU./
> 
>> +	 */
>> +	if (!vsp1->drm)
>> +		vsp1_pipelines_suspend(vsp1);
>> +
>>  	pm_runtime_force_suspend(vsp1->dev);
>>
>>  	return 0;
>> @@ -582,7 +588,13 @@ static int __maybe_unused vsp1_pm_resume(struct device
>> *dev) struct vsp1_device *vsp1 = dev_get_drvdata(dev);
>>
>>  	pm_runtime_force_resume(vsp1->dev);
>> -	vsp1_pipelines_resume(vsp1);
>> +
>> +	/*
>> +	 * When used as part of a display pipeline, the VSP is stopped and
>> +	 * restarted explicitly by the DU
> 
> s/DU/DU./
> 
> Apart from that,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks,

I'll add the full-stops and repost a v2.1 with your RB tag.

> 
>> +	 */
>> +	if (!vsp1->drm)
>> +		vsp1_pipelines_resume(vsp1);
>>
>>  	return 0;
>>  }
> 
