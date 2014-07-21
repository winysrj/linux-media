Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4320 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbaGUJ3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 05:29:09 -0400
Message-ID: <53CCDD5D.40408@xs4all.nl>
Date: Mon, 21 Jul 2014 11:29:01 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH for v3.17] v4l2-ioctl: don't set PRIV_MAGIC unconditionally
 in g_fmt()
References: <53CBBFAB.6030907@xs4all.nl> <18748136.AVYGmbiGvH@avalon>
In-Reply-To: <18748136.AVYGmbiGvH@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/21/2014 11:11 AM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Sunday 20 July 2014 15:10:03 Hans Verkuil wrote:
>> Regression fix:
>>
>> V4L2_PIX_FMT_PRIV_MAGIC should only be set for the VIDEO_CAPTURE and
>> VIDEO_OUTPUT buffer types, and not for any others. In the case of
>> the win format this overwrites a pointer value that is passed in from
>> userspace.
>>
>> Since it is already set for the VIDEO_CAPTURE and VIDEO_OUTPUT cases
>> anyway this line can just be dropped.
> 
> It's set after calling the vidioc_g_fmt_vid_cap or vidioc_g_fmt_vid_out 
> operation, which means that driver will not see the flag being set. Couldn't 
> that be an issue ?

While I don't think it is necessary as such, it is better for consistency.
I'll post a new patch.

Regards,

	Hans

> 
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-ioctl.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
>> b/drivers/media/v4l2-core/v4l2-ioctl.c index e620387..c11a13d 100644
>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>> @@ -1143,8 +1143,6 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>> bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
>>  	int ret;
>>
>> -	p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>> -
>>  	/*
>>  	 * fmt can't be cleared for these overlay types due to the 'clips'
>>  	 * 'clipcount' and 'bitmap' pointers in struct v4l2_window.
> 

