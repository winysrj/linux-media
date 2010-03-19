Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab0CST1Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 15:27:24 -0400
Message-ID: <4BA3D017.80504@redhat.com>
Date: Fri, 19 Mar 2010 16:27:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	v4l-dvb <linux-media@vger.kernel.org>
Subject: Re: RFC: Drop V4L1 support in V4L2 drivers
References: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl> <4BA375A7.3000400@redhat.com> <4BA3CC3B.1050705@redhat.com>
In-Reply-To: <4BA3CC3B.1050705@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:

>> 3) The removal of V4L1 means that the existing applications should not
>> try to include
>> videodev.h with newer kernels or their compilations will break (easy
>> to fix, but better
>> to remind application developers that may be reading this thread).
>> Also, the removal of
>> V4L1 compat means that all V4L1 only applications will stop working.
>> What's the current
>> status of webcam/TV/stream/radio/videotext/vbi applications? Just
>> yesterday, somebody
>> reported me a problem with radio crashing at the V4L1 compat layer. It
>> seemed that maybe
>> not all radio apps got converted. So, before dropping compat layer
>> support, we should
>> double check what apps will break.
>>
> 
> I think the best way forward here is making libv4l1 completely independ
> of the kernel
> v4l1 compat layer. This isn't to hard to do, I could even copy over the
> necessary bits
> to compile v4l1 apps from linux/videodev.h to libv4l1.h, then the kernel
> can completely
> drop v4l1 compat for v4l2 drivers, but this will need some time...

You should notice that it is not just video stream here: you need to consider
also radio, vbi/teletext and tuning. The easiest way seems to start migrating
the v4l1 compat to userspace.

On the other hand, what applications are we talking about? Maybe it is just easier
to write a document pointing to an alternative application for each case.

-- 

Cheers,
Mauro
