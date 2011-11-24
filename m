Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:44954 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab1KXSBV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 13:01:21 -0500
Message-ID: <4ECE866D.5040608@linuxtv.org>
Date: Thu, 24 Nov 2011 19:01:17 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com> <4ECE79F5.9000402@linuxtv.org> <4ECE80BE.4090109@redhat.com>
In-Reply-To: <4ECE80BE.4090109@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24.11.2011 18:37, Mauro Carvalho Chehab wrote:
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

As already replied to Hans, breaking compilation on purpose is bad.

> The thing is that the media API presents two interfaces to control mpeg decoders.
> This is confusing, and, while one of them has active upstream developers working
> on it, adding new drivers and new features on it, the other API is not being
> updated accordingly, and no new upstream drivers use it.

There is no "media API". There's a V4L API and a DVB API. There are
active downstream developers adding new drivers and features to it.

> Worse than that, several ioctl's are there, with not a single in-kernel implementation, 
> nor any documentation about how they are supposed to work.

I think I know how most of them are supposed to work. If you have
questions, just ask.

Yes, there are many ioctls which have never been used (mostly for DVD
playback, IIRC). You can mark them as deprecated.

> We noticed in Prague that new DVB developers got confused about what should be the
> proper implementation for new drivers, so marking it as deprecated is important,
> otherwise, we'll end by having different approaches for the same thing.

There's a huge difference between marking something as deprecated and
deleting userspace header files (and compat-ioctl for that matter).

Adding a comment on top of audio.h and video.h will be good enough for
new DVB developers.

> Just to give you one example, newer DTV standards like ISDB-T and DVB-T2 now uses
> H.264 video streams. Support for H.264 were added recently at V4L2 API, but the
> dvb video API doesn't support it.

My attempts to add the necessary #defines for new video standards were
blocked because there was no in-kernel driver available. You can't use
that as an argument against it now. If you like, I can submit patches to
address this.

Regards,
Andreas
