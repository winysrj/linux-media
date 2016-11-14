Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57889 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753090AbcKNK2a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 05:28:30 -0500
Subject: Re: [RFC 07/10] sunxi-cedrus: Add a MPEG 2 codec
To: Florent Revest <florent.revest@free-electrons.com>,
        linux-media@vger.kernel.org
References: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
 <1472117989-21455-8-git-send-email-florent.revest@free-electrons.com>
 <ff07bec7-1bc5-2a68-772c-f294daadef78@xs4all.nl>
Cc: linux-sunxi@googlegroups.com, maxime.ripard@free-electrons.com,
        posciak@chromium.org, hans.verkuil@cisco.com,
        thomas.petazzoni@free-electrons.com, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, wens@csie.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <30c6dc32-3026-5c37-c9dd-c41a020415bf@xs4all.nl>
Date: Mon, 14 Nov 2016 11:28:24 +0100
MIME-Version: 1.0
In-Reply-To: <ff07bec7-1bc5-2a68-772c-f294daadef78@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/14/2016 11:18 AM, Hans Verkuil wrote:
> On 08/25/2016 11:39 AM, Florent Revest wrote:
>> This patch introduces the support of MPEG2 video decoding to the
>> sunxi-cedrus video decoder driver.
>>
>> Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
>> ---
>>  drivers/media/platform/sunxi-cedrus/Makefile       |   2 +-
>>  drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c |  26 +++-
>>  .../platform/sunxi-cedrus/sunxi_cedrus_common.h    |   2 +
>>  .../media/platform/sunxi-cedrus/sunxi_cedrus_dec.c |  15 +-
>>  .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.c  |  17 ++-
>>  .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.h  |   4 +
>>  .../platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c     | 152 +++++++++++++++++++++
>>  7 files changed, 211 insertions(+), 7 deletions(-)
>>  create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c
>>
>> diff --git a/drivers/media/platform/sunxi-cedrus/Makefile b/drivers/media/platform/sunxi-cedrus/Makefile
>> index 14c2f7a..2d495a2 100644
>> --- a/drivers/media/platform/sunxi-cedrus/Makefile
>> +++ b/drivers/media/platform/sunxi-cedrus/Makefile
>> @@ -1,2 +1,2 @@
>>  obj-$(CONFIG_VIDEO_SUNXI_CEDRUS) += sunxi_cedrus.o sunxi_cedrus_hw.o \
>> -				    sunxi_cedrus_dec.o
>> +				    sunxi_cedrus_dec.o sunxi_cedrus_mpeg2.o
>> diff --git a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
>> index 17af34c..d1c957a 100644
>> --- a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
>> +++ b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
>> @@ -46,14 +46,31 @@ static int sunxi_cedrus_s_ctrl(struct v4l2_ctrl *ctrl)
>>  	struct sunxi_cedrus_ctx *ctx =
>>  		container_of(ctrl->handler, struct sunxi_cedrus_ctx, hdl);
>>  
>> -	v4l2_err(&ctx->dev->v4l2_dev, "Invalid control\n");
>> -	return -EINVAL;
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:
>> +		/* This is kept in memory and used directly. */
>> +		break;
>> +	default:
>> +		v4l2_err(&ctx->dev->v4l2_dev, "Invalid control\n");
> 
> Drop this, it's pointless since this cannot happen, and even if it could, there
> is nothing wrong about userspace passing an unknown control, that should just result in
> -EINVAL.
> 

Just to be clear: 'this' == the v4l2_err call.

Regards,

	Hans
