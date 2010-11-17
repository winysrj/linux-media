Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39586 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934661Ab0KQPgX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 10:36:23 -0500
Received: by bwz15 with SMTP id 15so1717980bwz.19
        for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 07:36:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201011162242.02446.hverkuil@xs4all.nl>
References: <cover.1289740431.git.hverkuil@xs4all.nl>
	<201011162210.18000.hverkuil@xs4all.nl>
	<AANLkTikXkEZELQSEa6eQLobK7gpDe=_7+AawuxT3tjd5@mail.gmail.com>
	<201011162242.02446.hverkuil@xs4all.nl>
Date: Wed, 17 Nov 2010 10:36:21 -0500
Message-ID: <AANLkTimjPaizGp_MFs2F6BWHz2VUCG13NsjwLVsWr74p@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Nov 16, 2010 at 4:42 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tuesday, November 16, 2010 22:32:57 David Ellingsworth wrote:
>> Hans,
>>
>> I've had some patches pending for a while now that affect the dsbr100
>> driver. The patches can be seen here:
>> http://desource.dyndns.org/~atog/gitweb/?p=linux-media.git in the
>> dsbr100 branch. The first patch in the series fixes locking issues
>> throughout the driver and converts it to use the unlocked ioctl. The
>> series is a bit old, so it doesn't make use of the v4l2 core assisted
>> locking; but that is trivial to implement after this patch.
>
> Would it be a problem for you if for 2.6.37 I just replace .ioctl by
> .unlocked_ioctl? And do the full conversion for 2.6.38? That way the
> 2.6.37 patches remain small.
>

If you look at the first patch in that series, you'll see that the
conversion isn't that simple. There are a lot of places in that driver
that should have been protected by a lock that weren't. At the moment,
I think the BKL protects these areas from racing so just replacing the
.ioctl with the .unlocked_ioctl here isn't a good solution for this
driver. Applying the patch I've provided will however remove the BKL
and the resolve all the locking issues as well.

Regards,

David Ellingsworth
