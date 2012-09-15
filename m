Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64229 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2IOUQ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 16:16:28 -0400
Received: by bkwj10 with SMTP id j10so1830393bkw.19
        for <linux-media@vger.kernel.org>; Sat, 15 Sep 2012 13:16:27 -0700 (PDT)
Message-ID: <5054E218.4010807@gmail.com>
Date: Sat, 15 Sep 2012 22:16:24 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	=?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 API PATCH 15/31] v4l2-core: Add new V4L2_CAP_MONOTONIC_TS
 capability.
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <201209151205.20981.hverkuil@xs4all.nl> <50545A86.3050904@iki.fi> <201209151435.41800.hverkuil@xs4all.nl>
In-Reply-To: <201209151435.41800.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/15/2012 02:35 PM, Hans Verkuil wrote:
>>>> If we switch all existing drivers to monotonic timestamps in kernel release
>>>> 3.x, v4l2-compliance can just use the version it gets from VIDIOC_QUERYCAP and
>>>> enforce monotonic timestamps verification if the version is>= 3.x. This isn't
>>>> more difficult for apps to check than a dedicated flag (although it's less
>>>> explicit).
>>>
>>> I think that checking for the driver (kernel) version is a very poor substitute
>>> for testing against a proper flag.
>>
>> That flag should be the default in this case. The flag should be set by
>> the framework instead giving every driver the job of setting it.
>>
>>> One alternative might be to use a v4l2_buffer flag instead. That does have the
>>> advantage that in the future we can add additional flags should we need to
>>> support different clocks. Should we ever add support to switch clocks dynamically,
>>> then a buffer flag is more suitable than a driver capability. In that scenario
>>> it does make real sense to have a flag (or really mask).
>>>
>>> Say something like this:
>>>
>>> /* Clock Mask */
>>> V4L2_BUF_FLAG_CLOCK_MASK	0xf000
>>> /* Possible Clocks */
>>> V4L2_BUF_FLAG_CLOCK_SYSTEM	0x0000
> 
> I realized that this should be called:
> 
> V4L2_BUF_FLAG_CLOCK_UNKNOWN	0x0000
> 
> With a comment saying that is clock is either the system clock or a monotonic
> clock. That reflects the current situation correctly.
> 
>>> V4L2_BUF_FLAG_CLOCK_MONOTONIC	0x1000

There is already lots of overhead related to the buffers management, could 
we perhaps have the most common option defined in a way that drivers don't 
need to update each buffer's flags before dequeuing, only to indicate the
timestamp type (other than flags being modified in videobuf) ?

This buffer flags idea sounds to me worse than the capability flag. After 
all the drivers should use monotonic clock timestamps, shouldn't they ?

Have anyone has ever come with a use case for switching timestamps clock 
type, can anyone give an example of it ? How likely is we will ever need 
that ? 

:)

--

Regards,
Sylwester
