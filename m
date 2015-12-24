Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:39426 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbbLXM7c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2015 07:59:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Dec 2015 13:59:30 +0100
From: hverkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	magnus.damm@gmail.com, hans.verkuil@cisco.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk, linux-media-owner@vger.kernel.org
Subject: Re: [PATCH v2 2/2] media: adv7604: update timings on change of input
 signal
In-Reply-To: <1491106.CZOxgP2rDa@avalon>
References: <1450794122-31293-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1450794122-31293-3-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1491106.CZOxgP2rDa@avalon>
Message-ID: <b8b9c951d78719e219d2a53f029df009@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-12-24 12:47, Laurent Pinchart wrote:
> Hi Ulrich,
> 
> (With a question for Hans below)
> 
> Thank you for the patch.
> 
> On Tuesday 22 December 2015 15:22:02 Ulrich Hecht wrote:
>> Without this, .get_selection will always return the boot-time state.
>> 
>> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
>> ---
>>  drivers/media/i2c/adv7604.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>> 
>> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
>> index 8ad5c28..dcd659b 100644
>> --- a/drivers/media/i2c/adv7604.c
>> +++ b/drivers/media/i2c/adv7604.c
>> @@ -1945,6 +1945,7 @@ static int adv76xx_isr(struct v4l2_subdev *sd, 
>> u32
>> status, bool *handled) u8 fmt_change_digital;
>>  	u8 fmt_change;
>>  	u8 tx_5v;
>> +	int ret;
>> 
>>  	if (irq_reg_0x43)
>>  		io_write(sd, 0x44, irq_reg_0x43);
>> @@ -1968,6 +1969,14 @@ static int adv76xx_isr(struct v4l2_subdev *sd, 
>> u32
>> status, bool *handled)
>> 
>>  		v4l2_subdev_notify_event(sd, &adv76xx_ev_fmt);
>> 
>> +		/* update timings */
>> +		ret = adv76xx_query_dv_timings(sd, &state->timings);
> 
> I'm not too familiar with the DV timings API, but I'm not sure this is
> correct. This would result in g_dv_timings returning the detected 
> timings,
> while we have the dedicated query_dv_timings operation for that. Hans, 
> could
> you comment on this ? How do query_dv_timings and g_dv_timings interact 
> ? The
> API documentation isn't very clear about that.

This code is wrong. If a format/timings change is detected the driver 
can send
an event, but it should never change the current timings. The 
application has
to call the query function first, then set the detected new timings. You 
can't
just change timings on the fly since that often means changes to buffer 
sizes
as well, and changing buffer sizes on the fly is very dangerous.

So if a change is detected, send the V4L2_EVENT_SOURCE_CHANGE event. In 
response
the application will call QUERY_DV_TIMINGS and, if valid new timings are 
detected,
S_DV_TIMINGS. Usually this will require the stop streaming, set the new 
timings,
allocate new buffers and start streaming sequence.

Regards,

     Hans

> 
>> +		if (ret == -ENOLINK) {
>> +			/* no signal, fall back to default timings */
>> +			state->timings = (struct v4l2_dv_timings)
>> +				V4L2_DV_BT_CEA_640X480P59_94;
>> +		}
>> +
>>  		if (handled)
>>  			*handled = true;
>>  	}

