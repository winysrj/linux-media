Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46346
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751694AbdIAJcN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 05:32:13 -0400
Date: Fri, 1 Sep 2017 06:32:02 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Honza =?UTF-8?B?UGV0cm91xaE=?= <jpetrous@gmail.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Shuah Khan <shuah@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH 00/15] Improve DVB documentation and reduce its gap
Message-ID: <20170901063202.2abf561e@vento.lan>
In-Reply-To: <CAJbz7-0QaB3Hpi23pZZ_DLFQyqQ7kynRiP6J0a8UUj9RzooLCA@mail.gmail.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
        <CAJbz7-0QaB3Hpi23pZZ_DLFQyqQ7kynRiP6J0a8UUj9RzooLCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 1 Sep 2017 10:40:28 +0200
Honza Petrouš <jpetrous@gmail.com> escreveu:

> 2017-09-01 1:46 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> > The DVB documentation was negligected for a long time, with
> > resulted on several gaps between the API description and its
> > documentation.
> >
> > I'm doing a new reading at the documentation. As result of it,
> > this series:
> >
> > - improves the introductory chapter, making it more generic;
> > - Do some adjustments at the frontend API, using kernel-doc
> >   when possible.
> > - Remove unused APIs at DVB demux. I suspect that the drivers
> >   implementing such APIs were either never merged upstream,
> >   or the API itself  were never used or was deprecated a long
> >   time ago. In any case, it doesn't make any sense to carry
> >   on APIs that aren't properly documented, nor are used on the
> >   upstream Kernel.
> >
> > With this patch series, the gap between documentation and
> > code is solved for 3 DVB APIs:
> >
> >   - Frontend API;
> >   - Demux API;
> >   - Net API.
> >
> > There is still a gap at the CA API that I'll try to address when I
> > have some time[1].
> >
> > [1] There's a gap also on the legacy audio, video and OSD APIs,
> >     but, as those are used only by a single very old deprecated
> >     hardware (av7110), it is probably not worth the efforts.
> >  
> 
> I agree that av7110 is very very old piece of hw (but it is already
> in my hall of fame because of its Skystar 1 incarnation as
> first implementation of DVB in Linux) and it is sad that we still
> don't have at least one driver for any SoC with embedded DVB
> devices.

Yeah, av7110 made history. Please notice that this series doesn't
remove any API that it is used by it. All it removes are the APIs
that there's no Kernel driver using.

Carry on APIs without client is usually a very bad idea, as nobody
could be certain about how to use it. It is even worse when such
APIs are not properly documented (with is the case here).

> I understand that the main issue is that no any DVB-enabled
> SoC vendor is interested in upstreaming theirs code, but I still hope
> it will change in near future(*)

We have one driver for a SoC DVB hardware at:
	drivers/media/platform/sti/c8sectpfe/

I guess it still doesn't cover the entire SoC, but this is a WiP. If I
remember well, at the midia part of the SoC, they started by submitting
the Remote Controller code.

> Without having full-featured DVB device in vanilla, we surely don't
> get some parts of DVB API covered. I can imagine that  when
> somebody comes with such full-featured device he wants to reinvent
> just removed bits.

Re-adding the removed bits is easy. However, the API defined for
av7110 is old and it is showing its age: it assumes a limited number
of possible inputs/outputs. Modern SoC has a lot more ways link the
audio/video IP blocks than what the API provides. On a modern SoC,
not only DVB is supported, but also analog inputs (to support things
like composite input), cameras, HDMI inputs and even analog TV.
All of them interconnected to a media ISP. The current FF API can't
represent such hardware.

The best API to represent those pipelines that exist on SoC for
multimedia is the media controller, where all IP blocks and their
links (whatever they are) can be represented, if needed.

The audio and video DVB API is also too limited: it hasn't
evolved since when it was added. For audio, the ALSA API
allows a way more control of the hardware; for video, the
V4L2 API nowadays has all the bits to control video decoding
and encoding. Both APIs provide support for audio and video
inputs commonly found on those devices.

Also, nowadays, video decoding usually happens at the GPU on SoC. So, 
in practice, a SoC FF would likely use the DRM subsystem to control the
video codecs.

So, anyone wanting to upstream drivers for a modern FF hardware would need
to touch a lot inside the DVB API, for it to cover all the needs. A more
appropriate approach to support those devices would be, instead, 
to use a set of APIs: DVB, V4L2, ALSA, RC, CEC, MC, DRM.

> 
> It's my 5 cents
> /Honza
> 
> (*) My favourite is HiSilicon with very nice Hi3798 4K chip
> with announced support from Linaro and already available
> devboard for reasonable price.
> 
> PS: I'm in no any way connected with HiSilicon nor
> any other DVB-enabled SoC vendor.

Thanks,
Mauro
