Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:54002 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891AbcCNNBc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 09:01:32 -0400
Subject: Re: [PATCH 1/2] v4l2-ioctl: simplify code
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
References: <1456741000-39069-1-git-send-email-hverkuil@xs4all.nl>
 <1456741000-39069-2-git-send-email-hverkuil@xs4all.nl>
 <20160314124243.GA24409@bigcity.dyn.berto.se>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56E6B401.5090504@xs4all.nl>
Date: Mon, 14 Mar 2016 13:52:17 +0100
MIME-Version: 1.0
In-Reply-To: <20160314124243.GA24409@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/14/2016 01:42 PM, Niklas Söderlund wrote:
> Hi Hans,
> 
> On 2016-02-29 11:16:39 +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Instead of a big if at the beginning, just check if g_selection == NULL
>> and call the cropcap op immediately and return the result.
>>
>> No functional changes in this patch.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-ioctl.c | 44 ++++++++++++++++++------------------
>>  1 file changed, 22 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
>> index 86c4c19..67dbb03 100644
>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>> @@ -2157,33 +2157,33 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
>>  				struct file *file, void *fh, void *arg)
>>  {
>>  	struct v4l2_cropcap *p = arg;
>> +	struct v4l2_selection s = { .type = p->type };
>> +	int ret;
>>  
>> -	if (ops->vidioc_g_selection) {
>> -		struct v4l2_selection s = { .type = p->type };
>> -		int ret;
>> +	if (ops->vidioc_g_selection == NULL)
>> +		return ops->vidioc_cropcap(file, fh, p);
> 
> I might be missing something but is there a guarantee 
> ops->vidioc_cropcap is not NULL here?

There is, either vidioc_g_selection or vidioc_cropcap will always be
non-NULL. Since g_selection == NULL it follows that cropcap != NULL.

But I admit that it isn't exactly obvious since the test that ensures
this is in determine_valid_ioctls() in v4l2-dev.c.

Regards,

	Hans
