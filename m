Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57014 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaK0XhY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 18:37:24 -0500
Received: by mail-pa0-f52.google.com with SMTP id eu11so5619047pac.25
        for <linux-media@vger.kernel.org>; Thu, 27 Nov 2014 15:37:23 -0800 (PST)
Message-ID: <5477B5AD.20509@igel.co.jp>
Date: Fri, 28 Nov 2014 08:37:17 +0900
From: Takanari Hayama <taki@igel.co.jp>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 2/2] v4l: vsp1: Always enable virtual RPF when BRU
 is in use
References: <1417051502-30169-1-git-send-email-taki@igel.co.jp> <1417051502-30169-3-git-send-email-taki@igel.co.jp> <6244918.ULpQcsacKi@avalon>
In-Reply-To: <6244918.ULpQcsacKi@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 11/28/14, 5:03 AM, Laurent Pinchart wrote:
> Hi Hayama-san,
> 
> Thank you for the patch.
> 
> On Thursday 27 November 2014 10:25:02 Takanari Hayama wrote:
>> Regardless of a number of inputs, we should always enable virtual RPF
>> when BRU is used. This allows the case when there's only one input to
>> BRU, and a size of the input is smaller than a size of an output of BRU.
>>
>> Signed-off-by: Takanari Hayama <taki@igel.co.jp>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I've applied the patch to my tree. I'll wait for your reply regarding my 
> comments to the first patch and will then send a pull request for both.

Thank you. As I already mentioned in my other email, I'm all good with
your suggestions.

>> ---
>>  drivers/media/platform/vsp1/vsp1_wpf.c | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c
>> b/drivers/media/platform/vsp1/vsp1_wpf.c index 6e05776..cb17c4d 100644
>> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
>> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
>> @@ -92,19 +92,20 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int
>> enable) return 0;
>>  	}
>>
>> -	/* Sources. If the pipeline has a single input configure it as the
>> -	 * master layer. Otherwise configure all inputs as sub-layers and
>> -	 * select the virtual RPF as the master layer.
>> +	/* Sources. If the pipeline has a single input and BRU is not used,
>> +	 * configure it as the master layer. Otherwise configure all
>> +	 * inputs as sub-layers and select the virtual RPF as the master
>> +	 * layer.
>>  	 */
>>  	for (i = 0; i < pipe->num_inputs; ++i) {
>>  		struct vsp1_rwpf *input = pipe->inputs[i];
>>
>> -		srcrpf |= pipe->num_inputs == 1
>> +		srcrpf |= (!pipe->bru && pipe->num_inputs == 1)
>>  			? VI6_WPF_SRCRPF_RPF_ACT_MST(input->entity.index)
>>
>>  			: VI6_WPF_SRCRPF_RPF_ACT_SUB(input->entity.index);
>>
>>  	}
>>
>> -	if (pipe->num_inputs > 1)
>> +	if (pipe->bru || pipe->num_inputs > 1)
>>  		srcrpf |= VI6_WPF_SRCRPF_VIRACT_MST;
>>
>>  	vsp1_wpf_write(wpf, VI6_WPF_SRCRPF, srcrpf);
> 

Cheers,
Takanari Hayama, Ph.D. (taki@igel.co.jp)
IGEL Co.,Ltd.
http://www.igel.co.jp/
