Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57248 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753459AbdIDL3y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 07:29:54 -0400
Date: Mon, 4 Sep 2017 08:29:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Soeren Moch <smoch@web.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Honza =?UTF-8?B?UGV0cm91?= =?UTF-8?B?xaE=?=
        <jpetrous@gmail.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Shuah Khan <shuah@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH 00/15] Improve DVB documentation and reduce its gap
Message-ID: <20170904081358.33730670@recife.lan>
In-Reply-To: <535588b7-a467-2267-00b5-0d0ef00d782c@web.de>
References: <cover.1504222628.git.mchehab@s-opensource.com>
 <CAJbz7-0QaB3Hpi23pZZ_DLFQyqQ7kynRiP6J0a8UUj9RzooLCA@mail.gmail.com>
 <20170901063202.2abf561e@vento.lan>
 <535588b7-a467-2267-00b5-0d0ef00d782c@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 4 Sep 2017 02:55:15 +0200
Soeren Moch <smoch@web.de> escreveu:

> Hi Mauro,
>=20
> On 01.09.2017 11:32, Mauro Carvalho Chehab wrote:
> > Em Fri, 1 Sep 2017 10:40:28 +0200
> > Honza Petrou=C5=A1 <jpetrous@gmail.com> escreveu:
> > =20
> >> 2017-09-01 1:46 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.=
com>: =20
> >>> The DVB documentation was negligected for a long time, with
> >>> resulted on several gaps between the API description and its
> >>> documentation.
> >>>
> >>> I'm doing a new reading at the documentation. As result of it,
> >>> this series:
> >>>
> >>> - improves the introductory chapter, making it more generic;
> >>> - Do some adjustments at the frontend API, using kernel-doc
> >>>   when possible.
> >>> - Remove unused APIs at DVB demux. I suspect that the drivers
> >>>   implementing such APIs were either never merged upstream,
> >>>   or the API itself  were never used or was deprecated a long
> >>>   time ago. In any case, it doesn't make any sense to carry
> >>>   on APIs that aren't properly documented, nor are used on the
> >>>   upstream Kernel.
> >>>
> >>> With this patch series, the gap between documentation and
> >>> code is solved for 3 DVB APIs:
> >>>
> >>>   - Frontend API;
> >>>   - Demux API;
> >>>   - Net API.
> >>>
> >>> There is still a gap at the CA API that I'll try to address when I
> >>> have some time[1].
> >>>
> >>> [1] There's a gap also on the legacy audio, video and OSD APIs,
> >>>     but, as those are used only by a single very old deprecated
> >>>     hardware (av7110), it is probably not worth the efforts.
> >>>   =20
> av7110 cards may be old, but there are still users of these cards.=20
> For instance I'm watching TV received and decoded with such card in this =
moment.
> So what do you mean with "deprecated hardware"?

Nobody is telling otherwise. What I mean by "deprecated" is that it is
not a product that you could got to a shop and buy a new one. Its=20
production stopped a long time ago.

> >> I agree that av7110 is very very old piece of hw (but it is already
> >> in my hall of fame because of its Skystar 1 incarnation as
> >> first implementation of DVB in Linux) and it is sad that we still
> >> don't have at least one driver for any SoC with embedded DVB
> >> devices. =20
> > Yeah, av7110 made history. Please notice that this series doesn't
> > remove any API that it is used by it. All it removes are the APIs
> > that there's no Kernel driver using.
> >
> > Carry on APIs without client is usually a very bad idea, as nobody
> > could be certain about how to use it. It is even worse when such
> > APIs are not properly documented (with is the case here).
> > =20
> >> I understand that the main issue is that no any DVB-enabled
> >> SoC vendor is interested in upstreaming theirs code, but I still hope
> >> it will change in near future(*) =20
> > We have one driver for a SoC DVB hardware at:
> > 	drivers/media/platform/sti/c8sectpfe/
> >
> > I guess it still doesn't cover the entire SoC, but this is a WiP. If I
> > remember well, at the midia part of the SoC, they started by submitting
> > the Remote Controller code.
> > =20
> >> Without having full-featured DVB device in vanilla, we surely don't
> >> get some parts of DVB API covered. I can imagine that  when
> >> somebody comes with such full-featured device he wants to reinvent
> >> just removed bits. =20
> > Re-adding the removed bits is easy. However, the API defined for
> > av7110 is old and it is showing its age: it assumes a limited number
> > of possible inputs/outputs. Modern SoC has a lot more ways link the
> > audio/video IP blocks than what the API provides. On a modern SoC,
> > not only DVB is supported, but also analog inputs (to support things
> > like composite input), cameras, HDMI inputs and even analog TV.
> > All of them interconnected to a media ISP. The current FF API can't
> > represent such hardware.
> >
> > The best API to represent those pipelines that exist on SoC for
> > multimedia is the media controller, where all IP blocks and their
> > links (whatever they are) can be represented, if needed.
> >
> > The audio and video DVB API is also too limited: it hasn't
> > evolved since when it was added. For audio, the ALSA API
> > allows a way more control of the hardware; for video, the
> > V4L2 API nowadays has all the bits to control video decoding
> > and encoding. Both APIs provide support for audio and video
> > inputs commonly found on those devices. =20
> The real advantage of the DVB audio/video/osd API is the possibility
> of frame synchronous audio/video/overlay output for high-quality
> audio/video playback, maybe with picture-in-picture functionality.
>=20
> Especially audio synchronization is not easy when the audio format
> changes from compressed audio (e.g. AC-3) to PCM (stereo), e.g. on
> HDMI output. While HDMI output hardware usually takes video frames and
> audio packets (and AVI info frames for audio/video format signalization)
> synchronously, V4L2 and ALSA rip these data blocks apart and push these
> through different pipelines with different buffering properties. This
> makes it very difficult for userspace applications. With the DVB API
> the hardware takes care of the synchronisation.

Since ever, V4L2 metadata carries both a timestamp and a frame number. On
ALSA, support for it is more complex, and was discussed for a while.
I'm not sure about the current status, but I guess timestamp suppot was
already added due to compressed audio requirements.

> > Also, nowadays, video decoding usually happens at the GPU on SoC. So,=20
> > in practice, a SoC FF would likely use the DRM subsystem to control the
> > video codecs. =20
> I think this is a common misunderstanding. Video is decoded on separate
> hardware blocks nowadays, not on a (3D-)GPU. GPU vendors like to hide this
> fact by declaring all blocks together as GPU, but in SoC architectures
> like e.g. imx, sunxi, or meson one can easily see separate 2D-GPU, 3D-GPU,
> video codec and image processing / video output blocks.
> On imx6q for instance we use etnaviv 2D- and 3D-GPU drivers, a coda
> video decoder driver, and ipu-v3 video output drivers. While etnaviv and
> ipu-v3 are gpu/drm drivers, the coda video decoder is a media/platform
> device and not integrated into the drm framework.

Yeah, the codecs are implemented by a separated IP block (usually a
media DSP), with may be firmware updated. They're usually separated from
2D or 3D IP blocks. Yet, from control/streaming PoV, they're usually
controlled via GL though the DRM subsystem. V4L2 also has support
for such codecs. There are even some solutions on embedded where the
2D/3D/codecs are on a separate chip from the SoC.

> > So, anyone wanting to upstream drivers for a modern FF hardware would n=
eed
> > to touch a lot inside the DVB API, for it to cover all the needs. A more
> > appropriate approach to support those devices would be, instead,=20
> > to use a set of APIs: DVB, V4L2, ALSA, RC, CEC, MC, DRM. =20
> You know I want to upstream a driver for (not so modern) FF hardware, with
> the DVB audio/video API and without touching anything inside this API (sm=
all
> additions to the osd API). I still hope this driver can be accepted.

That has nothing to do with this patch series. The goal here is just to
synchronize the documentation with the current DVB implementation upstream,
specially for the ioctls that all drivers implement.

> I fully understand the desire for new APIs to support modern hardware
> with additional needs. As kernel developer I also understand that it is
> easier to create new APIs instead of extending the exiting ones.
> As application programmer instead I would prefer to stick with existing
> APIs, at least to get some compatibility lib if older APIs are deprecated
> and replaced with newer ones.
>=20
> It is especially confusing for me to see a lot of new APIs with overlappi=
ng
> scope. The same functionality is handled by different APIs, why?

Historic reasons. The addition of audio/video at DVB is one such
example: by the time it was written, there were already ALSA (and OSS),
plus V4L2 (and V4L).

I don't know if you're aware, but, in the early days, it was possible to
control some DVB devices via V4L2. On that time, for some hardware,
there was two drivers for DVB: one inside video4linux and another one
inside dvb directories. Such support got removed, as it was an abberation.

> You mentioned above, video codecs should be handled by DRM, are V4L2
> decoder drivers also deprecated?

V4L2 mem2mem drivers provide a different feature than DRM. On DRM,
a video plane is set to receive, let's say, a MPEG4 stream to be
displayed, usually controlled by GL; on V4L2, the MPEG4 would be converted=
=20
to some other format and returned back to userspace (for example, to be
recorded).

Yeah, there are some overlay between them, but it is usually clear
when one should add support to DRM or V4L2.

> Video scaling is usually handled by the DRM output pipeline. This is
> efficient
> since the image is read only once. For instance on imx6 we have a V4L2
> mem2mem
> scaler instead.

It is as efficient to use DRM or V4L2, as both support DMABUF. So,
either way, is possible to do zero-copy data transfers.

> Video output (including overlays) seems to be handled by DRM nowadays, vi=
deo
> input by MC.

No, MC doesn't handle video buffers. It is meant to just set hardware
pipelines. Ok, in the case of a full featured DVB hardware, if you're
not interested on recording, it would be possible to use MC to setup a
pipeline that would set audio and video decoding pipelines without
the need of any data copies. Yet, you may still need to use other
APIs, in order to syncronize A/V with external things (like a teletext
overlay, or some popup menu).

> The whole media subsystem seems not to have any business with
> audio anymore. Is the whole V4L2 API superseded by something else?

It never had. V4L2 can control audio settings (like language selection
stero/mono switch, and even volume/balance), but it was never meant to
be an API for the digital audio output. Ok, on very ancient hardware, the
audio could be provided only via an analog output pin (or CD cable).

Still, on those cases, the audio is generally connected to the CD or
AUX input at the audio card, and userspace ends by controlling it via
ALSA.

> As you have worked a lot on documentation recently, can you point me to s=
ome
> documentation how the different APIs are supposed to work together? What =
API
> to use when?

Contributions for that are welcome.=20

We're still fighting to have the current DVB API documented. Before
those patches I'm working with, several parts of the DVB API documentation
are a piece of fiction, as it doesn't match what's implemented.

For example, the CA documentation used to say that the CA is=20
controlled via /dev/ost/ca. I was not here when DVB was added
usptream. Yet, I'd risk to say that, since when the DVB system was
merged upstream, the CA device was always /dev/adapter?/ca?.

Maybe somewhere between 1999-2001, when the subsystem were on
its early days and out of the Kernel tree, "/dev/ost/*" devnodes
were used for a while.

Thanks,
Mauro
