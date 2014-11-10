Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:35323 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbaKJJN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 04:13:56 -0500
Message-ID: <546081CB.7090209@xs4all.nl>
Date: Mon, 10 Nov 2014 10:13:47 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 3/3] adv7604: Correct G/S_EDID behaviour
References: <1415363697-32583-1-git-send-email-hverkuil@xs4all.nl> <1415363697-32583-4-git-send-email-hverkuil@xs4all.nl> <CAL8zT=h_=1A=0KGy50oKXrB8PWNVr5rfhbZWqJD4VD1wLDgp=A@mail.gmail.com>
In-Reply-To: <CAL8zT=h_=1A=0KGy50oKXrB8PWNVr5rfhbZWqJD4VD1wLDgp=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/07/2014 09:34 PM, Jean-Michel Hautbois wrote:
> Hi Hans,
> 
> 2014-11-07 13:34 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> In order to have v4l2-compliance tool pass the G/S_EDID some modifications
>> where needed in the driver.
>> In particular, the edid.reserved zone must be blanked.
>>
>> Based on a patch from Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
>> but reworked it a bit. It should use edid.present instead of edid.blocks as the
>> check whether edid data is present.
> 
> I may have missed it, but you did not implement it using edid.present
> in the code below... ?

I should have said: 'It should use 'data' (which depends on edid.present) instead of...'

The edid.present usage is not seen in this patch, so that was a bit confusing.
I've updated the commit log for the final version I'm using in my pull request.

Regards,

	Hans

> 
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/i2c/adv7604.c | 37 ++++++++++++++++++-------------------
>>  1 file changed, 18 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
>> index 47795ff..d64fbd9 100644
>> --- a/drivers/media/i2c/adv7604.c
>> +++ b/drivers/media/i2c/adv7604.c
>> @@ -1997,19 +1997,7 @@ static int adv7604_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
>>         struct adv7604_state *state = to_state(sd);
>>         u8 *data = NULL;
>>
>> -       if (edid->pad > ADV7604_PAD_HDMI_PORT_D)
>> -               return -EINVAL;
>> -       if (edid->blocks == 0)
>> -               return -EINVAL;
>> -       if (edid->blocks > 2)
>> -               return -EINVAL;
>> -       if (edid->start_block > 1)
>> -               return -EINVAL;
>> -       if (edid->start_block == 1)
>> -               edid->blocks = 1;
>> -
>> -       if (edid->blocks > state->edid.blocks)
>> -               edid->blocks = state->edid.blocks;
>> +       memset(edid->reserved, 0, sizeof(edid->reserved));
>>
>>         switch (edid->pad) {
>>         case ADV7604_PAD_HDMI_PORT_A:
>> @@ -2021,14 +2009,24 @@ static int adv7604_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
>>                 break;
>>         default:
>>                 return -EINVAL;
>> -               break;
>>         }
>> -       if (!data)
>> +
>> +       if (edid->start_block == 0 && edid->blocks == 0) {
>> +               edid->blocks = state->edid.blocks;
>> +               return 0;
>> +       }
>> +
>> +       if (data == NULL)
>>                 return -ENODATA;
>>
>> -       memcpy(edid->edid,
>> -              data + edid->start_block * 128,
>> -              edid->blocks * 128);
>> +       if (edid->start_block >= state->edid.blocks)
>> +               return -EINVAL;
>> +
>> +       if (edid->start_block + edid->blocks > state->edid.blocks)
>> +               edid->blocks = state->edid.blocks - edid->start_block;
>> +
>> +       memcpy(edid->edid, data + edid->start_block * 128, edid->blocks * 128);
>> +
>>         return 0;
>>  }
>>
>> @@ -2068,6 +2066,8 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
>>         int err;
>>         int i;
>>
>> +       memset(edid->reserved, 0, sizeof(edid->reserved));
>> +
>>         if (edid->pad > ADV7604_PAD_HDMI_PORT_D)
>>                 return -EINVAL;
>>         if (edid->start_block != 0)
>> @@ -2164,7 +2164,6 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
>>                 return -EIO;
>>         }
>>
>> -
>>         /* enable hotplug after 100 ms */
>>         queue_delayed_work(state->work_queues,
>>                         &state->delayed_work_enable_hotplug, HZ / 10);
>> --
>> 2.1.1
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

