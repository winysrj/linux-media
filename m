Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35032 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1KXR7H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 12:59:07 -0500
Received: by wwp14 with SMTP id 14so2137587wwp.1
        for <linux-media@vger.kernel.org>; Thu, 24 Nov 2011 09:59:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ECE80BE.4090109@redhat.com>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
	<dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com>
	<4ECE79F5.9000402@linuxtv.org>
	<4ECE80BE.4090109@redhat.com>
Date: Thu, 24 Nov 2011 23:29:05 +0530
Message-ID: <CAHFNz9LWjUF-ddKefK29w29NwNhZDAv3kxibbJ-TRknD5GJTGA@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 24, 2011 at 11:07 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 24-11-2011 15:08, Andreas Oberritter escreveu:
>> Don't break existing Userspace APIs for no reason! It's OK to add the
>> new API, but - pretty please - don't just blindly remove audio.h and
>> video.h. They are in use since many years by av7110, out-of-tree drivers
>> *and more importantly* by applications. Yes, I know, you'd like to see
>> those out-of-tree drivers merged, but it isn't possible for many
>> reasons. And even if they were merged, you'd say "Port them and your
>> apps to V4L". No! That's not an option.
>
> Hi Andreas,
>
> Userspace applications that support av7110 can include the new linux/av7110.h
> header. Other applications that support out-of-tree drivers can just have
> their own copy of audio.h, osd.h and video.h. So, it won't break or prevent
> existing applications to keep working.
>
> The thing is that the media API presents two interfaces to control mpeg decoders.
> This is confusing, and, while one of them has active upstream developers working
> on it, adding new drivers and new features on it, the other API is not being
> updated accordingly, and no new upstream drivers use it.
>
> Worse than that, several ioctl's are there, with not a single in-kernel implementation,
> nor any documentation about how they are supposed to work.
>
> We noticed in Prague that new DVB developers got confused about what should be the
> proper implementation for new drivers, so marking it as deprecated is important,
> otherwise, we'll end by having different approaches for the same thing.
>
> Just to give you one example, newer DTV standards like ISDB-T and DVB-T2 now uses
> H.264 video streams. Support for H.264 were added recently at V4L2 API, but the
> dvb video API doesn't support it.


That's not true at all. I am testing DVB-S2/H.264 with the current DVB API.
