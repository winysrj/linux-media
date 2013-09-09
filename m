Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10595 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3IIJAG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 05:00:06 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MSU000WHP03XD40@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Sep 2013 10:00:03 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Pawel Osciak' <posciak@chromium.org>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
 <1377829038-4726-17-git-send-email-posciak@chromium.org>
 <52204058.6070008@xs4all.nl>
 <CACHYQ-oGaAS1TVLqm-wRsPSg5xDqBTuvj9PcMAmu5vEc-aVb1A@mail.gmail.com>
 <522D7E3E.8070104@xs4all.nl>
 <CACHYQ-ph7eBPkr38c__Wpr_ixPChQQi5tYJENrR3GAfyDzcThQ@mail.gmail.com>
In-reply-to: <CACHYQ-ph7eBPkr38c__Wpr_ixPChQQi5tYJENrR3GAfyDzcThQ@mail.gmail.com>
Subject: RE: [PATCH v1 16/19] v4l: Add encoding camera controls.
Date: Mon, 09 Sep 2013 11:00:02 +0200
Message-id: <04c001cead3a$f8ea0dc0$eabe2940$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Pawel Osciak [mailto:posciak@chromium.org]
> Sent: Monday, September 09, 2013 9:59 AM
> 
> On Mon, Sep 9, 2013 at 4:52 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On 09/09/2013 05:48 AM, Pawel Osciak wrote:
> >> Hi Hans,
> >> Thanks for the comments, one question inline.
> >>
> >> On Fri, Aug 30, 2013 at 3:48 PM, Hans Verkuil <hverkuil@xs4all.nl>
> wrote:
> >>> On 08/30/2013 04:17 AM, Pawel Osciak wrote:
> >>>> Add defines for controls found in UVC 1.5 encoding cameras.
> >>>>
> >>>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> >>>> ---
> >>>>  drivers/media/v4l2-core/v4l2-ctrls.c | 29
> +++++++++++++++++++++++++++++
> >>>>  include/uapi/linux/v4l2-controls.h   | 31
> +++++++++++++++++++++++++++++++
> >>>>  2 files changed, 60 insertions(+)
> >>>>
> >>>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> >>>> b/drivers/media/v4l2-core/v4l2-ctrls.c
> >>>> index c3f0803..0b3a632 100644
> >>>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> >>>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> >>>> @@ -781,6 +781,35 @@ const char *v4l2_ctrl_get_name(u32 id)
> >>>>       case V4L2_CID_AUTO_FOCUS_STATUS:        return "Auto Focus,
> Status";
> >>>>       case V4L2_CID_AUTO_FOCUS_RANGE:         return "Auto Focus,
> Range";
> >>>>
> >>>> +     case V4L2_CID_ENCODER_MIN_FRAME_INTERVAL: return "Encoder,
> min. frame interval";
> >>>> +     case V4L2_CID_ENCODER_RATE_CONTROL_MODE: return "Encoder,
> rate control mode";
> >>>> +     case V4L2_CID_ENCODER_AVERAGE_BITRATE:  return "Encoder,
> average bitrate";
> >>>> +     case V4L2_CID_ENCODER_CPB_SIZE:         return "Encoder, CPB
> size";
> >>>> +     case V4L2_CID_ENCODER_PEAK_BIT_RATE:    return "Encoder,
> peak bit rate";
> >>>> +     case V4L2_CID_ENCODER_QP_PARAM_I:       return "Encoder, QP
> param for I frames";
> >>>> +     case V4L2_CID_ENCODER_QP_PARAM_P:       return "Encoder, QP
> param for P frames";
> >>>> +     case V4L2_CID_ENCODER_QP_PARAM_BG:      return "Encoder, QP
> param for B/G frames";
> >>>
> >>> A lot of these exist already. E.g.
> V4L2_CID_MPEG_VIDEO_MPEG4_I/P/B_FRAME_QP.
> >>>
> >>> Samsung added support for many of these parameters for their MFC
> >>> encoder (including
> >>> VP8 support) so you should use them as well. As mentioned in
> >>> v4l2-controls.h the MPEG part of the control name is historical.
> Interpret it as 'CODEC', not MPEG.
> >>>
> >>
> >> We have QP controls separately for H264, H263 and MPEG4. Why is that?
> >> Which one should I use for VP8? Shouldn't we unify them instead?
> >
> > I can't quite remember the details, so I've CCed Kamil since he added
> those controls.
> > At least the H264 QP controls are different from the others as they
> > have a different range. What's the range for VP8?
> >
> 
> Yes, it differs, 0-127.
> But I feel this is pretty unfortunate, is it a good idea to multiply
> controls to have one per format when they have different ranges
> depending on the selected format in general? Perhaps a custom handler
> would be better?
> 
> > I'm not sure why the H263/MPEG4 controls weren't unified: it might be
> > that since the
> > H264 range was different we decided to split it up per codec. But I
> > seem to remember that there was another reason as well.
> >

We had a discussion about this on linux-media mailing list. It can be found
here:
http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/326
06
In short, it is a mix of two reasons: one - the valid range is different for
different formats and second - implementing controls which have different
min/max
values depending on format was not easy.

On the one hand I am thinking that now, when we have more codecs, it would
be better
to have a single control, on the other hand what about backward
compatibility?
Is there a graceful way to merge H263 and H264 QP controls?

Best wishes,
Kamil

