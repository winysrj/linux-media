Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:64268 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753108AbdIDA40 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 20:56:26 -0400
Subject: Re: [PATCH 00/15] Improve DVB documentation and reduce its gap
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: =?UTF-8?Q?Honza_Petrou=c5=a1?= <jpetrous@gmail.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Shuah Khan <shuah@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Colin Ian King <colin.king@canonical.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
 <CAJbz7-0QaB3Hpi23pZZ_DLFQyqQ7kynRiP6J0a8UUj9RzooLCA@mail.gmail.com>
 <20170901063202.2abf561e@vento.lan>
From: Soeren Moch <smoch@web.de>
Message-ID: <535588b7-a467-2267-00b5-0d0ef00d782c@web.de>
Date: Mon, 4 Sep 2017 02:55:15 +0200
MIME-Version: 1.0
In-Reply-To: <20170901063202.2abf561e@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 01.09.2017 11:32, Mauro Carvalho Chehab wrote:
> Em Fri, 1 Sep 2017 10:40:28 +0200
> Honza Petrouš <jpetrous@gmail.com> escreveu:
>
>> 2017-09-01 1:46 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>:
>>> The DVB documentation was negligected for a long time, with
>>> resulted on several gaps between the API description and its
>>> documentation.
>>>
>>> I'm doing a new reading at the documentation. As result of it,
>>> this series:
>>>
>>> - improves the introductory chapter, making it more generic;
>>> - Do some adjustments at the frontend API, using kernel-doc
>>>   when possible.
>>> - Remove unused APIs at DVB demux. I suspect that the drivers
>>>   implementing such APIs were either never merged upstream,
>>>   or the API itself  were never used or was deprecated a long
>>>   time ago. In any case, it doesn't make any sense to carry
>>>   on APIs that aren't properly documented, nor are used on the
>>>   upstream Kernel.
>>>
>>> With this patch series, the gap between documentation and
>>> code is solved for 3 DVB APIs:
>>>
>>>   - Frontend API;
>>>   - Demux API;
>>>   - Net API.
>>>
>>> There is still a gap at the CA API that I'll try to address when I
>>> have some time[1].
>>>
>>> [1] There's a gap also on the legacy audio, video and OSD APIs,
>>>     but, as those are used only by a single very old deprecated
>>>     hardware (av7110), it is probably not worth the efforts.
>>>  
av7110 cards may be old, but there are still users of these cards. For
instance I'm watching TV received and decoded with such card in this moment.
So what do you mean with "deprecated hardware"?
>> I agree that av7110 is very very old piece of hw (but it is already
>> in my hall of fame because of its Skystar 1 incarnation as
>> first implementation of DVB in Linux) and it is sad that we still
>> don't have at least one driver for any SoC with embedded DVB
>> devices.
> Yeah, av7110 made history. Please notice that this series doesn't
> remove any API that it is used by it. All it removes are the APIs
> that there's no Kernel driver using.
>
> Carry on APIs without client is usually a very bad idea, as nobody
> could be certain about how to use it. It is even worse when such
> APIs are not properly documented (with is the case here).
>
>> I understand that the main issue is that no any DVB-enabled
>> SoC vendor is interested in upstreaming theirs code, but I still hope
>> it will change in near future(*)
> We have one driver for a SoC DVB hardware at:
> 	drivers/media/platform/sti/c8sectpfe/
>
> I guess it still doesn't cover the entire SoC, but this is a WiP. If I
> remember well, at the midia part of the SoC, they started by submitting
> the Remote Controller code.
>
>> Without having full-featured DVB device in vanilla, we surely don't
>> get some parts of DVB API covered. I can imagine that  when
>> somebody comes with such full-featured device he wants to reinvent
>> just removed bits.
> Re-adding the removed bits is easy. However, the API defined for
> av7110 is old and it is showing its age: it assumes a limited number
> of possible inputs/outputs. Modern SoC has a lot more ways link the
> audio/video IP blocks than what the API provides. On a modern SoC,
> not only DVB is supported, but also analog inputs (to support things
> like composite input), cameras, HDMI inputs and even analog TV.
> All of them interconnected to a media ISP. The current FF API can't
> represent such hardware.
>
> The best API to represent those pipelines that exist on SoC for
> multimedia is the media controller, where all IP blocks and their
> links (whatever they are) can be represented, if needed.
>
> The audio and video DVB API is also too limited: it hasn't
> evolved since when it was added. For audio, the ALSA API
> allows a way more control of the hardware; for video, the
> V4L2 API nowadays has all the bits to control video decoding
> and encoding. Both APIs provide support for audio and video
> inputs commonly found on those devices.
The real advantage of the DVB audio/video/osd API is the possibility
of frame synchronous audio/video/overlay output for high-quality
audio/video playback, maybe with picture-in-picture functionality.

Especially audio synchronization is not easy when the audio format
changes from compressed audio (e.g. AC-3) to PCM (stereo), e.g. on
HDMI output. While HDMI output hardware usually takes video frames and
audio packets (and AVI info frames for audio/video format signalization)
synchronously, V4L2 and ALSA rip these data blocks apart and push these
through different pipelines with different buffering properties. This
makes it very difficult for userspace applications. With the DVB API
the hardware takes care of the synchronisation.
> Also, nowadays, video decoding usually happens at the GPU on SoC. So, 
> in practice, a SoC FF would likely use the DRM subsystem to control the
> video codecs.
I think this is a common misunderstanding. Video is decoded on separate
hardware blocks nowadays, not on a (3D-)GPU. GPU vendors like to hide this
fact by declaring all blocks together as GPU, but in SoC architectures
like e.g. imx, sunxi, or meson one can easily see separate 2D-GPU, 3D-GPU,
video codec and image processing / video output blocks.
On imx6q for instance we use etnaviv 2D- and 3D-GPU drivers, a coda
video decoder driver, and ipu-v3 video output drivers. While etnaviv and
ipu-v3 are gpu/drm drivers, the coda video decoder is a media/platform
device and not integrated into the drm framework.
> So, anyone wanting to upstream drivers for a modern FF hardware would need
> to touch a lot inside the DVB API, for it to cover all the needs. A more
> appropriate approach to support those devices would be, instead, 
> to use a set of APIs: DVB, V4L2, ALSA, RC, CEC, MC, DRM.
You know I want to upstream a driver for (not so modern) FF hardware, with
the DVB audio/video API and without touching anything inside this API (small
additions to the osd API). I still hope this driver can be accepted.

I fully understand the desire for new APIs to support modern hardware
with additional needs. As kernel developer I also understand that it is
easier to create new APIs instead of extending the exiting ones.
As application programmer instead I would prefer to stick with existing
APIs, at least to get some compatibility lib if older APIs are deprecated
and replaced with newer ones.

It is especially confusing for me to see a lot of new APIs with overlapping
scope. The same functionality is handled by different APIs, why?
You mentioned above, video codecs should be handled by DRM, are V4L2
decoder drivers also deprecated?
Video scaling is usually handled by the DRM output pipeline. This is
efficient
since the image is read only once. For instance on imx6 we have a V4L2
mem2mem
scaler instead.
Video output (including overlays) seems to be handled by DRM nowadays, video
input by MC. The whole media subsystem seems not to have any business with
audio anymore. Is the whole V4L2 API superseded by something else?

As you have worked a lot on documentation recently, can you point me to some
documentation how the different APIs are supposed to work together? What API
to use when?

Thanks,
Soeren
>
>> It's my 5 cents
>> /Honza
>>
>> (*) My favourite is HiSilicon with very nice Hi3798 4K chip
>> with announced support from Linaro and already available
>> devboard for reasonable price.
>>
>> PS: I'm in no any way connected with HiSilicon nor
>> any other DVB-enabled SoC vendor.
> Thanks,
> Mauro
