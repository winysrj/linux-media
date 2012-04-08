Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab2DHPRW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Apr 2012 11:17:22 -0400
Message-ID: <4F81AC7C.5070403@redhat.com>
Date: Sun, 08 Apr 2012 17:19:24 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 09/10] uvcvideo: Properly report the inactive flag for
 inactive controls
References: <1332676610-14953-1-git-send-email-hdegoede@redhat.com> <1332676610-14953-10-git-send-email-hdegoede@redhat.com> <4797188.KPbmRBAMVG@avalon>
In-Reply-To: <4797188.KPbmRBAMVG@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/28/2012 11:12 AM, Laurent Pinchart wrote:
> Hi Hans,
>
> Thanks for the patch.
>
> On Sunday 25 March 2012 13:56:49 Hans de Goede wrote:
>> Note the unused in this patch slave_ids addition to the mappings will get
>> used in a follow up patch to generate control change events for the slave
>> ctrls when their flags change due to the master control changing value.
>>
>> Signed-off-by: Hans de Goede<hdegoede@redhat.com>
>> ---
>>   drivers/media/video/uvc/uvc_ctrl.c |   33 +++++++++++++++++++++++++++++++++
>> drivers/media/video/uvc/uvcvideo.h |    4 ++++
>>   2 files changed, 37 insertions(+)
>>
>> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
>> b/drivers/media/video/uvc/uvc_ctrl.c index 742496f..91d9007 100644
>> --- a/drivers/media/video/uvc/uvc_ctrl.c
>> +++ b/drivers/media/video/uvc/uvc_ctrl.c
>
> [snip]
>
>> @@ -943,6 +961,8 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain
>> *chain, struct uvc_control_mapping *mapping,
>>   	struct v4l2_queryctrl *v4l2_ctrl)
>>   {
>> +	struct uvc_control_mapping *master_map;
>> +	struct uvc_control *master_ctrl = NULL;
>>   	struct uvc_menu_info *menu;
>>   	unsigned int i;
>>   	int ret = 0;
>> @@ -958,6 +978,19 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain
>> *chain, if (!(ctrl->info.flags&  UVC_CTRL_FLAG_SET_CUR))
>>   		v4l2_ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
>>
>> +	if (mapping->master_id)
>> +		master_ctrl = uvc_find_control(chain, mapping->master_id,
>> +					&master_map);
>
> As an optimization, do you think it would make sense to add a struct
> uvc_contro *master_ctrl field to struct uvc_control_mapping, and fill it in
> uvc_ctrl_init_ctrl() ? That would require a loop over the mappings at
> initialization time, but would get rid of the search operation at runtime. The
> master_ctrl->info.flags&  UVC_CTRL_FLAG_GET_CUR check would be performed at
> initialization time as well, and master_ctrl would be left NULL it the master
> control doesn't support the GET_CUR query.
>

I've just tried to implement this, and it is a bit tricky:
1) The looking up of master_id cannot be done from uvc_ctrl_init_ctrl(), since
all the mappings of the entity need to be added before the lookup can be done,
making it necessary to add another loop to uvc_ctrl_init_device().
2) Not only the ctrl itself, but also the mapping needs to be cached in the
uvc_control_mapping, since we need both.

Looking closer at things, I've opted to implement a simpler optimization,
replacing the uvc_find_control with a __uvc_find_control, since the master
and it slaves are always part of the same entity. This means we still do
some searching runtime, but a lot less.

I'll send an updated patchset with this change in it soon.

Regards,

Hans
