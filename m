Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaLOP6d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 10:58:33 -0500
Message-ID: <548F051E.805@redhat.com>
Date: Mon, 15 Dec 2014 16:58:22 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: LibV4L2 and CREATE_BUFS issues
References: <5488748B.7060703@collabora.com> <548C17C9.2060809@redhat.com> <548C6607.10700@collabora.com> <548D5D26.5080504@redhat.com> <548D9D93.1080301@collabora.com>
In-Reply-To: <548D9D93.1080301@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 14-12-14 15:24, Nicolas Dufresne wrote:
>
> Le 2014-12-14 04:49, Hans de Goede a écrit :
>> Ah yes I see, so I assume that if libv4l where to return a failure for
>> CREATE_BUFS when conversion is used, that gstreamer will then fallback to
>> a regular REQUEST_BUFS call ?
>>
>> Then that indeed seems the best solution, can you submit patch for this ?
>
> Exactly, that should work. My concern with application side workaround would that the day someone implements CREATE_BUF support in v4l2 this application won't benefit without patching. I'll see if I can find time, disabling it seems faster then implementing support for it, specially that current experiment show that the jpeg code is really fragile. Current state is that libv4l2 is causing a buffer overflow, so it is harmful library in that sense.

Hmm, is that jpeg overflow still there with my recent (aprok 2-3 weeks ago) fix
for this?

> This raise a concern, it would mean that USERPTR, DMABUF, CREATE_BUFS will now be lost (in most cases) when enabling libv4l2.

Yes, which is not good.

> This is getting a bit annoying. Specially that we are pushing forward having m2m decoders to only be usable through libv4l2 (HW specific parsers). Is there a long term plan or are we simply pushing the dust toward libv4l2 ?

I think that trying to bold support for all of this into libv4l2 is not necessarily
a good idea. Then again if we're going to use libv4l2 plugins to do things like
media-controller pipeline setups for apps which are not media-controller aware,
maybe it is ...

libv4l2 was mostly created to get the then current generation of v4l2 apps to work
with webcams which have funky formats without pushing fmt conversion into the kernel
as several out of tree drivers were doing.

It may be better to come up with a better API for libv4lconvert, and let apps which
want to do advanced stuff deal with conversion themselves, while keeping all the
conversion code in a central place, but that does leave the media-controller issue.

Note that I've aprox. 0 time to work on libv4l now a days ...

What we really need is an active libv4l maintainer. Do not get me wrong, Gregor
has been doing a great job at maintaining it, but if we want to do some architectural
rework (or just a complete rewrite) I think we need someone who knows the v4l2 API,
media-controller, etc. a lot better.

Regards,

Hans
