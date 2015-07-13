Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-236.synserver.de ([212.40.185.236]:1071 "EHLO
	smtp-out-236.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbbGMLBh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 07:01:37 -0400
Message-ID: <55A39A8E.8010803@metafoo.de>
Date: Mon, 13 Jul 2015 13:01:34 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/5] [media] adv7604: Deliver resolution change events
 to userspace
References: <1435164631-19924-1-git-send-email-lars@metafoo.de> <1435164631-19924-4-git-send-email-lars@metafoo.de> <55A37E99.4060902@xs4all.nl>
In-Reply-To: <55A37E99.4060902@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/13/2015 11:02 AM, Hans Verkuil wrote:
>> +static int adv76xx_subscribe_event(struct v4l2_subdev *sd,
>> +				   struct v4l2_fh *fh,
>> +				   struct v4l2_event_subscription *sub)
>> +{
>> +	switch (sub->type) {
>> +	case V4L2_EVENT_SOURCE_CHANGE:
>> +		return v4l2_src_change_event_subdev_subscribe(sd, fh, sub);
>> +	case V4L2_EVENT_CTRL:
>> +		return v4l2_event_subdev_unsubscribe(sd, fh, sub);
>
> This should be v4l2_ctrl_subdev_subscribe_event() of course. I'll fix this in
> the patch before sending the pull request. Ditto for the adv7842 patch.

Thanks.


