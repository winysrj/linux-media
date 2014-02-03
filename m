Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4710 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaBCJL7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Feb 2014 04:11:59 -0500
Message-ID: <52EF5D50.4010107@xs4all.nl>
Date: Mon, 03 Feb 2014 10:11:44 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 15/17] v4l: add RF tuner channel bandwidth control
References: <1391264674-4395-1-git-send-email-crope@iki.fi> <1391264674-4395-16-git-send-email-crope@iki.fi> <52EF5CA7.9050303@xs4all.nl>
In-Reply-To: <52EF5CA7.9050303@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/03/2014 10:08 AM, Hans Verkuil wrote:
> Hi Antti,
> 
> On 02/01/2014 03:24 PM, Antti Palosaari wrote:
>> Modern silicon RF tuners has one or more adjustable filters on
>> signal path, in order to filter noise from desired radio channel.
>>
>> Add channel bandwidth control to tell the driver which is radio
>> channel width we want receive. Filters could be then adjusted by
>> the driver or hardware, using RF frequency and channel bandwidth
>> as a base of filter calculations.
>>
>> On automatic mode (normal mode), bandwidth is calculated from sampling
>> rate or tuning info got from userspace. That new control gives
>> possibility to set manual mode and let user have more control for
>> filters.
>>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>  drivers/media/v4l2-core/v4l2-ctrls.c | 4 ++++
>>  include/uapi/linux/v4l2-controls.h   | 2 ++
>>  2 files changed, 6 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index d201f61..e44722b 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -865,6 +865,8 @@ const char *v4l2_ctrl_get_name(u32 id)
>>  	case V4L2_CID_MIXER_GAIN:		return "Mixer Gain";
>>  	case V4L2_CID_IF_GAIN_AUTO:		return "IF Gain, Auto";
>>  	case V4L2_CID_IF_GAIN:			return "IF Gain";
>> +	case V4L2_CID_BANDWIDTH_AUTO:		return "Channel Bandwidth, Auto";
>> +	case V4L2_CID_BANDWIDTH:		return "Channel Bandwidth";
>>  	default:
>>  		return NULL;
>>  	}
>> @@ -917,6 +919,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>>  	case V4L2_CID_LNA_GAIN_AUTO:
>>  	case V4L2_CID_MIXER_GAIN_AUTO:
>>  	case V4L2_CID_IF_GAIN_AUTO:
>> +	case V4L2_CID_BANDWIDTH_AUTO:
>>  		*type = V4L2_CTRL_TYPE_BOOLEAN;
>>  		*min = 0;
>>  		*max = *step = 1;
>> @@ -1078,6 +1081,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>>  	case V4L2_CID_LNA_GAIN:
>>  	case V4L2_CID_MIXER_GAIN:
>>  	case V4L2_CID_IF_GAIN:
>> +	case V4L2_CID_BANDWIDTH:
> 
> Booleans never have the slider flag set (they are represented as a checkbox, so a slider
> makes no sense).

v4l2-compliance will actually complain about this. It is useful to add support for
swradio to v4l2-compliance as it helps you test v4l2 compliance of drivers.

Regards,

	Hans
