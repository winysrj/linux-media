Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:35279 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752253AbcKNQwu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 11:52:50 -0500
Subject: Re: [PATCH 3/5] media: Add new SDR formats SC16, SC18 & SC20
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "crope@iki.fi" <crope@iki.fi>
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1478706284-59134-4-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <502a606c-2d66-4257-af17-7b7f35f2c839@xs4all.nl>
 <SG2PR06MB1038A5C7419F6EDE6B880A1BC3BC0@SG2PR06MB1038.apcprd06.prod.outlook.com>
Cc: Chris Paterson <Chris.Paterson2@renesas.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5bcf8db2-2e7f-83a2-0fc1-3653e89ffe3e@xs4all.nl>
Date: Mon, 14 Nov 2016 17:52:34 +0100
MIME-Version: 1.0
In-Reply-To: <SG2PR06MB1038A5C7419F6EDE6B880A1BC3BC0@SG2PR06MB1038.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/14/2016 05:20 PM, Ramesh Shanmugasundaram wrote:
> Hi Hans,
> 
> Thanks for the review comments.
> 
>> Subject: Re: [PATCH 3/5] media: Add new SDR formats SC16, SC18 & SC20
>>
>> On 11/09/2016 04:44 PM, Ramesh Shanmugasundaram wrote:
>>> This patch adds support for the three new SDR formats. These formats
>>> were prefixed with "sliced" indicating I data constitutes the top half
>>> and Q data constitutes the bottom half of the received buffer.
>>
>> The standard terminology for video formats is "planar". I am leaning
>> towards using that here as well.
>>
>> Any opinions on this?
> 
> Shall I rename the formats as "PC16", "PC18" & "PC20"?

Sounds reasonable to me!

	Hans

> For formats that do IQ IQ IQ... I shall use the regular formats "CUXX" when I introduce them.
> 
> Thanks,
> Ramesh
> 
>>
>> 	Hans
>>
>>>
>>> V4L2_SDR_FMT_SCU16BE - 14-bit complex (I & Q) unsigned big-endian
>>> sample inside 16-bit. V4L2 FourCC: SC16
>>>
>>> V4L2_SDR_FMT_SCU18BE - 16-bit complex (I & Q) unsigned big-endian
>>> sample inside 18-bit. V4L2 FourCC: SC18
>>>
>>> V4L2_SDR_FMT_SCU20BE - 18-bit complex (I & Q) unsigned big-endian
>>> sample inside 20-bit. V4L2 FourCC: SC20
>>>
>>> Signed-off-by: Ramesh Shanmugasundaram
>>> <ramesh.shanmugasundaram@bp.renesas.com>
>>> ---
>>>  drivers/media/v4l2-core/v4l2-ioctl.c | 3 +++
>>>  include/uapi/linux/videodev2.h       | 3 +++
>>>  2 files changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
>>> b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> index 181381d..d36b386 100644
>>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> @@ -1207,6 +1207,9 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc
>> *fmt)
>>>  	case V4L2_SDR_FMT_CS8:		descr = "Complex S8"; break;
>>>  	case V4L2_SDR_FMT_CS14LE:	descr = "Complex S14LE"; break;
>>>  	case V4L2_SDR_FMT_RU12LE:	descr = "Real U12LE"; break;
>>> +	case V4L2_SDR_FMT_SCU16BE:	descr = "Sliced Complex U16BE"; break;
>>> +	case V4L2_SDR_FMT_SCU18BE:	descr = "Sliced Complex U18BE"; break;
>>> +	case V4L2_SDR_FMT_SCU20BE:	descr = "Sliced Complex U20BE"; break;
>>>  	case V4L2_TCH_FMT_DELTA_TD16:	descr = "16-bit signed deltas"; break;
>>>  	case V4L2_TCH_FMT_DELTA_TD08:	descr = "8-bit signed deltas"; break;
>>>  	case V4L2_TCH_FMT_TU16:		descr = "16-bit unsigned touch data";
>> break;
>>> diff --git a/include/uapi/linux/videodev2.h
>>> b/include/uapi/linux/videodev2.h index 4364ce6..34a9c30 100644
>>> --- a/include/uapi/linux/videodev2.h
>>> +++ b/include/uapi/linux/videodev2.h
>>> @@ -666,6 +666,9 @@ struct v4l2_pix_format {
>>>  #define V4L2_SDR_FMT_CS8          v4l2_fourcc('C', 'S', '0', '8') /*
>> complex s8 */
>>>  #define V4L2_SDR_FMT_CS14LE       v4l2_fourcc('C', 'S', '1', '4') /*
>> complex s14le */
>>>  #define V4L2_SDR_FMT_RU12LE       v4l2_fourcc('R', 'U', '1', '2') /*
>> real u12le */
>>> +#define V4L2_SDR_FMT_SCU16BE	  v4l2_fourcc('S', 'C', '1', '6') /*
>> sliced complex u16be */
>>> +#define V4L2_SDR_FMT_SCU18BE	  v4l2_fourcc('S', 'C', '1', '8') /*
>> sliced complex u18be */
>>> +#define V4L2_SDR_FMT_SCU20BE	  v4l2_fourcc('S', 'C', '2', '0') /*
>> sliced complex u20be */
>>>
>>>  /* Touch formats - used for Touch devices */
>>>  #define V4L2_TCH_FMT_DELTA_TD16	v4l2_fourcc('T', 'D', '1', '6') /* 16-
>> bit signed deltas */
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
