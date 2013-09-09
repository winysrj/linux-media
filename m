Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1859 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3IIHwp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 03:52:45 -0400
Message-ID: <522D7E3E.8070104@xs4all.nl>
Date: Mon, 09 Sep 2013 09:52:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Pawel Osciak <posciak@chromium.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	k.debski@samsung.com
Subject: Re: [PATCH v1 16/19] v4l: Add encoding camera controls.
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-17-git-send-email-posciak@chromium.org> <52204058.6070008@xs4all.nl> <CACHYQ-oGaAS1TVLqm-wRsPSg5xDqBTuvj9PcMAmu5vEc-aVb1A@mail.gmail.com>
In-Reply-To: <CACHYQ-oGaAS1TVLqm-wRsPSg5xDqBTuvj9PcMAmu5vEc-aVb1A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/2013 05:48 AM, Pawel Osciak wrote:
> Hi Hans,
> Thanks for the comments, one question inline.
> 
> On Fri, Aug 30, 2013 at 3:48 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 08/30/2013 04:17 AM, Pawel Osciak wrote:
>>> Add defines for controls found in UVC 1.5 encoding cameras.
>>>
>>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>>> ---
>>>  drivers/media/v4l2-core/v4l2-ctrls.c | 29 +++++++++++++++++++++++++++++
>>>  include/uapi/linux/v4l2-controls.h   | 31 +++++++++++++++++++++++++++++++
>>>  2 files changed, 60 insertions(+)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>>> index c3f0803..0b3a632 100644
>>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>>> @@ -781,6 +781,35 @@ const char *v4l2_ctrl_get_name(u32 id)
>>>       case V4L2_CID_AUTO_FOCUS_STATUS:        return "Auto Focus, Status";
>>>       case V4L2_CID_AUTO_FOCUS_RANGE:         return "Auto Focus, Range";
>>>
>>> +     case V4L2_CID_ENCODER_MIN_FRAME_INTERVAL: return "Encoder, min. frame interval";
>>> +     case V4L2_CID_ENCODER_RATE_CONTROL_MODE: return "Encoder, rate control mode";
>>> +     case V4L2_CID_ENCODER_AVERAGE_BITRATE:  return "Encoder, average bitrate";
>>> +     case V4L2_CID_ENCODER_CPB_SIZE:         return "Encoder, CPB size";
>>> +     case V4L2_CID_ENCODER_PEAK_BIT_RATE:    return "Encoder, peak bit rate";
>>> +     case V4L2_CID_ENCODER_QP_PARAM_I:       return "Encoder, QP param for I frames";
>>> +     case V4L2_CID_ENCODER_QP_PARAM_P:       return "Encoder, QP param for P frames";
>>> +     case V4L2_CID_ENCODER_QP_PARAM_BG:      return "Encoder, QP param for B/G frames";
>>
>> A lot of these exist already. E.g. V4L2_CID_MPEG_VIDEO_MPEG4_I/P/B_FRAME_QP.
>>
>> Samsung added support for many of these parameters for their MFC encoder (including
>> VP8 support) so you should use them as well. As mentioned in v4l2-controls.h the
>> MPEG part of the control name is historical. Interpret it as 'CODEC', not MPEG.
>>
> 
> We have QP controls separately for H264, H263 and MPEG4. Why is that?
> Which one should I use for VP8? Shouldn't we unify them instead?

I can't quite remember the details, so I've CCed Kamil since he added those controls.
At least the H264 QP controls are different from the others as they have a different
range. What's the range for VP8?

I'm not sure why the H263/MPEG4 controls weren't unified: it might be that since the
H264 range was different we decided to split it up per codec. But I seem to remember
that there was another reason as well.

Regards,

	Hans
