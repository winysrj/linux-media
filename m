Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:32977 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752377AbeC1TEx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 15:04:53 -0400
Subject: Re: [PATCH 02/15] v4l: vsp1: Remove outdated comment
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180226214516.11559-3-laurent.pinchart+renesas@ideasonboard.com>
 <0a055333-78b0-a64b-ef97-c1706b7b56b9@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <0829c7b9-e05b-fe27-b632-005074c86de3@ideasonboard.com>
Date: Wed, 28 Mar 2018 20:04:49 +0100
MIME-Version: 1.0
In-Reply-To: <0a055333-78b0-a64b-ef97-c1706b7b56b9@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/03/18 13:27, Kieran Bingham wrote:
> Hi Laurent,
> 
> Thank you for the patch.
> 
> On 26/02/18 21:45, Laurent Pinchart wrote:
>> The entities in the pipeline are all started when the LIF is setup.
>> Remove the outdated comment that state otherwise.
>>
>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> I'll start with the easy ones :-)

In fact, couldn't this patch be squashed into [PATCH 01/15] in this series ?

--
Kieran


> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
>> ---
>>  drivers/media/platform/vsp1/vsp1_drm.c | 6 +-----
>>  1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
>> index e31fb371eaf9..a1f2ba044092 100644
>> --- a/drivers/media/platform/vsp1/vsp1_drm.c
>> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
>> @@ -221,11 +221,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>>  		return -EPIPE;
>>  	}
>>  
>> -	/*
>> -	 * Enable the VSP1. We don't start the entities themselves right at this
>> -	 * point as there's no plane configured yet, so we can't start
>> -	 * processing buffers.
>> -	 */
>> +	/* Enable the VSP1. */
>>  	ret = vsp1_device_get(vsp1);
>>  	if (ret < 0)
>>  		return ret;
>>
