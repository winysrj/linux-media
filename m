Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52701 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781AbcDVNRZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 09:17:25 -0400
Subject: Re: [PATCH 2/6] sta2x11_vip: fix s_std
To: Federico Vaga <federico.vaga@gmail.com>
References: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
 <1461330222-34096-3-git-send-email-hverkuil@xs4all.nl>
 <146136747.clRru94iZt@number-5>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <571A2460.7010203@xs4all.nl>
Date: Fri, 22 Apr 2016 15:17:20 +0200
MIME-Version: 1.0
In-Reply-To: <146136747.clRru94iZt@number-5>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/22/2016 03:15 PM, Federico Vaga wrote:
> Acked-by: Federico Vaga <federico.vaga@gmail.com>
> 
> It sounds fine to me (even the ADV7180 patch). Unfortunately I do not have the 
> hardware to test it.

Your Ack will have to suffice :-)

Can you Ack the adv7180 patch as well? Would be nice.

Regards,

	Hans

> 
> On Friday, April 22, 2016 03:03:38 PM Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The s_std ioctl was broken in this driver, partially due to the
>> changes to the adv7180 driver (this affected the handling of
>> V4L2_STD_ALL) and partially because the new standard was never
>> stored in vip->std.
>>
>> The handling of V4L2_STD_ALL has been rewritten to just call querystd
>> and the new standard is now stored correctly.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Federico Vaga <federico.vaga@gmail.com>
>> ---
>>  drivers/media/pci/sta2x11/sta2x11_vip.c | 26 ++++++++++----------------
>>  1 file changed, 10 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c
>> b/drivers/media/pci/sta2x11/sta2x11_vip.c index 753411c..c79623c 100644
>> --- a/drivers/media/pci/sta2x11/sta2x11_vip.c
>> +++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
>> @@ -444,27 +444,21 @@ static int vidioc_querycap(struct file *file, void
>> *priv, static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id
>> std) {
>>  	struct sta2x11_vip *vip = video_drvdata(file);
>> -	v4l2_std_id oldstd = vip->std, newstd;
>> +	v4l2_std_id oldstd = vip->std;
>>  	int status;
>>
>> -	if (V4L2_STD_ALL == std) {
>> -		v4l2_subdev_call(vip->decoder, video, s_std, std);
>> -		ssleep(2);
>> -		v4l2_subdev_call(vip->decoder, video, querystd, &newstd);
>> -		v4l2_subdev_call(vip->decoder, video, g_input_status, &status);
>> -		if (status & V4L2_IN_ST_NO_SIGNAL)
>> +	/*
>> +	 * This is here for backwards compatibility only.
>> +	 * The use of V4L2_STD_ALL to trigger a querystd is non-standard.
>> +	 */
>> +	if (std == V4L2_STD_ALL) {
>> +		v4l2_subdev_call(vip->decoder, video, querystd, &std);
>> +		if (std == V4L2_STD_UNKNOWN)
>>  			return -EIO;
>> -		std = vip->std = newstd;
>> -		if (oldstd != std) {
>> -			if (V4L2_STD_525_60 & std)
>> -				vip->format = formats_60[0];
>> -			else
>> -				vip->format = formats_50[0];
>> -		}
>> -		return 0;
>>  	}
>>
>> -	if (oldstd != std) {
>> +	if (vip->std != std) {
>> +		vip->std = std;
>>  		if (V4L2_STD_525_60 & std)
>>  			vip->format = formats_60[0];
>>  		else
> 

