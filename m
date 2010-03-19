Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42483 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab0CSJD7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 05:03:59 -0400
Received: by bwz1 with SMTP id 1so2765365bwz.21
        for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 02:03:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>
References: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl>
	 <201003190904.53867.laurent.pinchart@ideasonboard.com>
	 <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>
Date: Fri, 19 Mar 2010 10:03:57 +0100
Message-ID: <d9def9db1003190203n40052476nc1f0d544d05ba4b6@mail.gmail.com>
Subject: Re: RFC: Drop V4L1 support in V4L2 drivers
From: Markus Rechberger <mrechberger@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	v4l-dvb <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 19, 2010 at 9:46 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> On Friday 19 March 2010 08:59:08 Hans Verkuil wrote:
>>> Hi all,
>>>
>>> V4L1 support has been marked as scheduled for removal for a long time.
>>> The
>>> deadline for that in the feature-removal-schedule.txt file was July
>>> 2009.
>>>
>>> I think it is time that we remove the V4L1 compatibility support from
>>> V4L2
>>> drivers for 2.6.35.
>>
>> Do you mean just removing V4L1-specific code from V4L2 drivers, or
>> removing
>> the V4L1 compatibility layer completely ?
>
> The compat layer as well. So the only V4L1 code left is that for V4L1-only
> drivers.
>

I'm against this we have customers using the compat layer.
Aside of that the compat layer doesn't hurt anyone, newer more serious
applications
are written with v4l2 only actually.

> This means that V4L2 drivers can only be used by V4L2-aware applications
> and can no longer be accessed by V4L1-only applications.
>
>>> It would help with the videobuf cleanup as well, but that's just a
>>> bonus.
>>
>> Do we still have V4L1-only drivers that use videobuf ?
>
> No V4L1-only drivers use videobuf, but videobuf has support for the V4L1
> compat support in V4L2 drivers (the cgmbuf ioctl). So when we remove the
> compat support, then that videobuf code can be removed as well.
>

that's just a bad implementation then and just should be fixed up the compat
layer can handle this quite elegant.

-Markus
