Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43967 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1LUTcm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 14:32:42 -0500
Received: by eaad14 with SMTP id d14so1426876eaa.19
        for <linux-media@vger.kernel.org>; Wed, 21 Dec 2011 11:32:41 -0800 (PST)
Message-ID: <4EF23455.10002@gmail.com>
Date: Wed, 21 Dec 2011 20:32:37 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face
 detection
References: <1322838172-11149-6-git-send-email-ming.lei@canonical.com>	<20111214153407.GN1967@valkosipuli.localdomain> <CACVXFVNrEamdXq6qS98U-T6JiPMVNMHMW9j9prD1wz=SOfOyyA@mail.gmail.com>
In-Reply-To: <CACVXFVNrEamdXq6qS98U-T6JiPMVNMHMW9j9prD1wz=SOfOyyA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ming,

On 12/14/2011 04:57 PM, Ming Lei wrote:
> Hi,
> 
> On Wed, Dec 14, 2011 at 11:34 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> 
>>> +     case VIDIOC_G_FD_RESULT:
>>> +     {
>>> +             struct v4l2_fd_result *fr = arg;
>>> +
>>> +             if (!ops->vidioc_g_fd_result)
>>> +                     break;
>>> +
>>> +             ret = ops->vidioc_g_fd_result(file, fh, fr);
>>> +
>>> +             dbgarg(cmd, "index=%d", fr->buf_index);
>>> +             break;
>>> +     }
>>> +     case VIDIOC_G_FD_COUNT:
>>> +     {
>>> +             struct v4l2_fd_count *fc = arg;
>>> +
>>> +             if (!ops->vidioc_g_fd_count)
>>> +                     break;
>>> +
>>> +             ret = ops->vidioc_g_fd_count(file, fh, fc);
>>> +
>>> +             dbgarg(cmd, "index=%d", fc->buf_index);
>>> +             break;
>>> +     }
>>
>> The patch description tells these ioctls may be called between... what? I'd
> 
> In fact, these ioctls should be called after return from poll.
> 
>> think such information could be better provided as events.
> 
> Yes, I still think so, but the length of returned data is variant, also
> event has the 64 byte length's limitation.

Right, I'm afraid it's not even enough for single object description.

I have been thinking about adding variable payload support to v4l2 event API.

>> How is face detection enabled or disabled?
> 
> Currently, streaming on will trigger detection enabling, and streaming off
> will trigger detection disabling.

We would need to develop a boolean control for this I think, this seems one of
the basic features for the configuration interface.

>> Could you detect other objects than faces?
> 
> The -v2 has been extended to detect objects, not limited to faces.
> 
>> Would events be large enough to deliver you the necessary data? We could
> 
> Looks like event(64 bytes) is not large enough to deliver the data.
> 
>> also consider delivering the information as a data structure on a separate
>> plane.
> 
> Could you let me know how to do it?

You would have to use multi-planar interface for that, which would introduce
additional complexity at user interface. Moreover variable plane count is not
supported in vb2. Relatively significant effort is required to add this IMHO.

-- 

Regards,
Sylwester
