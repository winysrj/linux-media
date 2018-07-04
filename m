Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:38605 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934645AbeGDMcB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 08:32:01 -0400
Subject: Re: [PATCH] vivid: fix gain when autogain is on
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>
References: <b7ae30af-dcaa-f8ef-4171-e73cb0107884@xs4all.nl>
 <20180704091506.0a85686c@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8f2a9a45-8645-bcb9-5680-2fc81f5c98ff@xs4all.nl>
Date: Wed, 4 Jul 2018 14:31:58 +0200
MIME-Version: 1.0
In-Reply-To: <20180704091506.0a85686c@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/07/18 14:16, Mauro Carvalho Chehab wrote:
> Em Fri, 29 Jun 2018 11:40:41 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> In the vivid driver you want gain to continuous change while autogain
>> is on. However, dev->jiffies_vid_cap doesn't actually change. It probably
>> did in the past, but changes in the code caused this to be a fixed value
>> that is only set when you start streaming.
>>
>> Replace it by jiffies, which is always changing.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>> diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
>> index 6b0bfa091592..6eb8ad7fb12c 100644
>> --- a/drivers/media/platform/vivid/vivid-ctrls.c
>> +++ b/drivers/media/platform/vivid/vivid-ctrls.c
>> @@ -295,7 +295,7 @@ static int vivid_user_vid_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>>
>>  	switch (ctrl->id) {
>>  	case V4L2_CID_AUTOGAIN:
>> -		dev->gain->val = dev->jiffies_vid_cap & 0xff;
>> +		dev->gain->val = (jiffies / HZ) & 0xff;
> 
> Manipulating jiffies directly like the above is not a good idea.

Why not? There are HZ jiffies in one second, so this changes the
gain value once a second.

Regards,

	Hans

> 
> Better to use, instead:
> 
> 	dev->gain->val = (jiffies_to_msecs(jiffies) / 1000) & 0xff;
> 
> I'll change the code when applying the patch.
> 
> 
> Thanks,
> Mauro
> 
