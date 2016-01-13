Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:36547 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbcAMQHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 11:07:47 -0500
Received: by mail-yk0-f179.google.com with SMTP id v14so399956385ykd.3
        for <linux-media@vger.kernel.org>; Wed, 13 Jan 2016 08:07:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1452697362.3605.8.camel@collabora.com>
References: <1452686611-145620-1-git-send-email-wuchengli@chromium.org> <1452697362.3605.8.camel@collabora.com>
From: =?UTF-8?B?V3UtQ2hlbmcgTGkgKOadjuWLmeiqoCk=?=
	<wuchengli@chromium.org>
Date: Thu, 14 Jan 2016 00:07:27 +0800
Message-ID: <CAOMLVLiDxkAdqsaAidxhZ=k4E=dHxe7+nOt1v7+fQrsDZG4Dow@mail.gmail.com>
Subject: Re: [PATCH] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Wu-Cheng Li <wuchengli@chromium.org>, pawel@osciak.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl, k.debski@samsung.com,
	crope@iki.fi, standby24x7@gmail.com, ricardo.ribalda@gmail.com,
	ao2@ao2.it, bparrot@ti.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 13, 2016 at 11:02 PM, Nicolas Dufresne
<nicolas.dufresne@collabora.com> wrote:
> Le mercredi 13 janvier 2016 à 20:03 +0800, Wu-Cheng Li a écrit :
>> Some drivers also need a control like
>> V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE to force an encoder frame
>> type. This patch adds a general V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
>>
>> This control only affects the next queued buffer. There's no need to
>> clear the value after requesting an I frame. But all controls are set
>> in v4l2_ctrl_handler_setup. So a default DISABLED value is required.
>> Basically this control is like V4L2_CTRL_TYPE_BUTTON with parameters.
>> How to prevent a control from being set in v4l2_ctrl_handler_setup so
>> DISABLED value is not needed? Does it make sense not to set a control
>> if it is EXECUTE_ON_WRITE?
>
> I don't like the way it's implemented. I don't know any decoder that
> have a frame type forcing feature other they I-Frame. It would be much
> more natural to use a toggle button control (and add more controls for
> other types when needed) then trying to merge hypothetical toggles into
> something that manually need to be set and disabled.
Using a button control sounds like a good idea. I'll discuss with other people
and reply tomorrow.
>
>>
>> Wu-Cheng Li (1):
>>   v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
>>
>>  Documentation/DocBook/media/v4l/controls.xml | 23
>> +++++++++++++++++++++++
>>  drivers/media/v4l2-core/v4l2-ctrls.c         | 13 +++++++++++++
>>  include/uapi/linux/v4l2-controls.h           |  5 +++++
>>  3 files changed, 41 insertions(+)
>>
