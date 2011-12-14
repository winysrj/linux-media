Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49903 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1LNP52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 10:57:28 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46])
	by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.71)
	(envelope-from <ming.lei@canonical.com>)
	id 1RarCx-00062r-5n
	for linux-media@vger.kernel.org; Wed, 14 Dec 2011 15:57:27 +0000
Received: by yhr47 with SMTP id 47so1431446yhr.19
        for <linux-media@vger.kernel.org>; Wed, 14 Dec 2011 07:57:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111214153407.GN1967@valkosipuli.localdomain>
References: <1322838172-11149-6-git-send-email-ming.lei@canonical.com>
	<20111214153407.GN1967@valkosipuli.localdomain>
Date: Wed, 14 Dec 2011 23:57:26 +0800
Message-ID: <CACVXFVNrEamdXq6qS98U-T6JiPMVNMHMW9j9prD1wz=SOfOyyA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face detection
From: Ming Lei <ming.lei@canonical.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, Dec 14, 2011 at 11:34 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:

>> +     case VIDIOC_G_FD_RESULT:
>> +     {
>> +             struct v4l2_fd_result *fr = arg;
>> +
>> +             if (!ops->vidioc_g_fd_result)
>> +                     break;
>> +
>> +             ret = ops->vidioc_g_fd_result(file, fh, fr);
>> +
>> +             dbgarg(cmd, "index=%d", fr->buf_index);
>> +             break;
>> +     }
>> +     case VIDIOC_G_FD_COUNT:
>> +     {
>> +             struct v4l2_fd_count *fc = arg;
>> +
>> +             if (!ops->vidioc_g_fd_count)
>> +                     break;
>> +
>> +             ret = ops->vidioc_g_fd_count(file, fh, fc);
>> +
>> +             dbgarg(cmd, "index=%d", fc->buf_index);
>> +             break;
>> +     }
>
> The patch description tells these ioctls may be called between... what? I'd

In fact, these ioctls should be called after return from poll.

> think such information could be better provided as events.

Yes, I still think so, but the length of returned data is variant, also
event has the 64 byte length's limitation.

> How is face detection enabled or disabled?

Currently, streaming on will trigger detection enabling, and streaming off
will trigger detection disabling.

>
> Could you detect other objects than faces?

The -v2 has been extended to detect objects, not limited to faces.

> Would events be large enough to deliver you the necessary data? We could

Looks like event(64 bytes) is not large enough to deliver the data.

> also consider delivering the information as a data structure on a separate
> plane.

Could you let me know how to do it?

>> +/**
>> + * struct v4l2_fd_result - VIDIOC_G_FD_RESULT argument
>> + * @buf_index:       entry, index of v4l2_buffer for face detection
>> + * @face_cnt:        return, how many faces detected from the @buf_index
>> + * @fd:              return, result of faces' detection
>> + */
>> +struct v4l2_fd_result {
>> +     __u32   buf_index;
>> +     __u32   face_cnt;
>> +     __u32   reserved[6];
>> +     struct v4l2_fd_detection *fd;
>
> Aligning structure sizes to a power of two is considered to be a good
> practice.

There are many changes on these structure in -v2.


thanks,
--
Ming Lei
