Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:53973 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728811AbeHOPnr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 11:43:47 -0400
Received: by mail-qk0-f182.google.com with SMTP id v17-v6so620247qkb.11
        for <linux-media@vger.kernel.org>; Wed, 15 Aug 2018 05:51:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ee7e5b404c895d01682700d815a6cec89c2221a1.camel@bootlin.com>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
 <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
 <5f1a88aa-9ad9-9669-b8b9-78c921282279@xs4all.nl> <ee7e5b404c895d01682700d815a6cec89c2221a1.camel@bootlin.com>
From: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Date: Wed, 15 Aug 2018 14:51:39 +0200
Message-ID: <CAHStOZ5aU5N5UssqqSTU8YRN7nmGCX7H0eGO0GeB=AN0YK53dQ@mail.gmail.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-08-06 11:13 GMT+02:00 Paul Kocialkowski <paul.kocialkowski@bootlin.com>:
> Hi,
>
> On Mon, 2018-08-06 at 10:32 +0200, Hans Verkuil wrote:
>> On 08/06/2018 10:16 AM, Paul Kocialkowski wrote:
>> > On Sat, 2018-08-04 at 15:50 +0200, Hans Verkuil wrote:
>> > > Regarding point 3: I think this should be documented next to the pixel format. I.e.
>> > > the MPEG-2 Slice format used by the stateless cedrus codec requires the request API
>> > > and that two MPEG-2 controls (slice params and quantization matrices) must be present
>> > > in each request.
>> > >
>> > > I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_IN_REQ) is needed here.
>> > > It's really implied by the fact that you use a stateless codec. It doesn't help
>> > > generic applications like v4l2-ctl or qv4l2 either since in order to support
>> > > stateless codecs they will have to know about the details of these controls anyway.
>> > >
>> > > So I am inclined to say that it is not necessary to expose this information in
>> > > the API, but it has to be documented together with the pixel format documentation.
>> >
>> > I think this is affected by considerations about codec profile/level
>> > support. More specifically, some controls will only be required for
>> > supporting advanced codec profiles/levels, so they can only be
>> > explicitly marked with appropriate flags by the driver when the target
>> > profile/level is known. And I don't think it would be sane for userspace
>> > to explicitly set what profile/level it's aiming at. As a result, I
>> > don't think we can explicitly mark controls as required or optional.
>> >
>> > I also like the idea that it should instead be implicit and that the
>> > documentation should detail which specific stateless metadata controls
>> > are required for a given profile/level.
>> >
>> > As for controls validation, the approach followed in the Cedrus driver
>> > is to check that the most basic controls are filled and allow having
>> > missing controls for those that match advanced profiles.
>> >
>> > Since this approach feels somewhat generic enough to be applied to all
>> > stateless VPU drivers, maybe this should be made a helper in the
>> > framework?
>>
>> Sounds reasonable. Not sure if it will be in the first version, but it is
>> easy to add later.
>
> Definitely, I don't think this is such a high priority for now either.
>
>> > In addition, I see a need for exposing the maximum profile/level that
>> > the driver supports for decoding. I would suggest reusing the already-
>> > existing dedicated controls used for encoding for this purpose. For
>> > decoders, they would be used to expose the (read-only) maximum
>> > profile/level that is supported by the hardware and keep using them as a
>> > settable value in a range (matching the level of support) for encoders.
>> >
>> > This is necessary for userspace to determine whether a given video can
>> > be decoded in hardware or not. Instead of half-way decoding the video
>> > (ending up in funky results), this would easily allow skipping hardware
>> > decoding and e.g. falling back on software decoding.
>>
>> I think it might be better to expose this through new read-only bitmask
>> controls: i.e. a bitmask containing the supported profiles and levels.
>
> It seems that this is more or less what the coda driver is doing for
> decoding actually, although it uses a menu control between min/max
> supported profile/levels, with a mask to "blacklist" the unsupported
> values. Then, the V4L2_CTRL_FLAG_READ_ONLY flag is set to keep the
> control read-only.
>
>> Reusing the existing controls for a decoder is odd since there is not
>> really a concept of a 'current' value since you just want to report what
>> is supported. And I am not sure if all decoders can report the profile
>> or level that they detect.
>
> Is that really a problem when the READ_ONLY flag is set? I thought it
> was designed to fit this specific case, when the driver reports a value
> that userspace cannot affect.
>
> Otherwise, I agree that having a bitmask type would be a better fit, but
> I think it would be beneficial to keep the already-defined control and
> associated values, which implies using the menu control type for both
> encoders and decoders.
>
> If this is not an option, I would be in favour of adding per-codec read-
> only bitmask controls (e.g. for H264 something like
> V4L2_CID_MPEG_VIDEO_H264_PROFILE_SUPPORT) that expose the already-
> existing profile/level definitions as bit identifiers (a bit like coda
> is using them to craft a mask for the menu items to blacklist) for
> decoding only.
>
> What do you think?

Hi Paul, I think we need to go deeper than just exposing the supported
profiles/levels and also include a way to query the CAPTURE pixel
formats that are supported for each profile.

Maybe HEVC Main produces yuv420p but HEVC Main10 gives you
yuv420p10le. Maybe H.264 HiP produces NV12 but H.264 Hi422P produces
YUYV while also supporting down-sampling to NV12.

I don't know the specifics of each platform and the only example I can
think of is the Amlogic HEVC decoder that can produce NV12 for Main,
but only outputs a compressed proprietary format for Main10.

I unfortunately don't have an idea about how to implement that, but
I'll think about it.

Maxime

> Cheers,
>
> Paul
>
> --
> Paul Kocialkowski, Bootlin (formerly Free Electrons)
> Embedded Linux and kernel engineering
> https://bootlin.com
