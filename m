Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:36643 "EHLO
	mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbcFQPoh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 11:44:37 -0400
Received: by mail-yw0-f178.google.com with SMTP id v78so11004514ywa.3
        for <linux-media@vger.kernel.org>; Fri, 17 Jun 2016 08:44:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160617163109.68945359@eldfell>
References: <512b52ab.02de420a.7040.7417SMTPIN_ADDED_BROKEN@mx.google.com>
 <CAF6AEGtG5h3z6b=+T1pSBpxSDS6r9Jz7UnaoGN4tVgU7RUZg6Q@mail.gmail.com>
 <20160617105950.1a909309@eldfell> <CAF6AEGtT8WXF=z883iB+9dS6rbS3RV3kJ=d-X+Eenv5MAcZ5Lg@mail.gmail.com>
 <20160617163109.68945359@eldfell>
From: Rob Clark <robdclark@gmail.com>
Date: Fri, 17 Jun 2016 11:44:34 -0400
Message-ID: <CAF6AEGvAe8Q20B4rMcrrR+5Cqybdi=kwyBCR0187b9uc5X1mSQ@mail.gmail.com>
Subject: Re: [Mesa-dev] [RFC] New dma_buf -> EGLImage EGL extension - Final
 spec published!
To: Pekka Paalanen <ppaalanen@gmail.com>
Cc: Tom Cooksey <tom.cooksey@arm.com>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"mesa-dev@lists.freedesktop.org" <mesa-dev@lists.freedesktop.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Daniel Stone <daniel@fooishbar.org>,
	Emil Velikov <emil.velikov@collabora.co.uk>,
	=?UTF-8?Q?Louis=2DFrancis_Ratt=C3=A9=2DBoulianne?=
	<louis-francis.ratte-boulianne@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 17, 2016 at 9:31 AM, Pekka Paalanen <ppaalanen@gmail.com> wrote:
> On Fri, 17 Jun 2016 08:26:04 -0400
> Rob Clark <robdclark@gmail.com> wrote:
>
>> On Fri, Jun 17, 2016 at 3:59 AM, Pekka Paalanen <ppaalanen@gmail.com> wrote:
>> > On Thu, 16 Jun 2016 10:40:51 -0400
>> > Rob Clark <robdclark@gmail.com> wrote:
>> >
>> >> So, if we wanted to extend this to support the fourcc-modifiers that
>> >> we have on the kernel side for compressed/tiled/etc formats, what
>> >> would be the right approach?
>> >>
>> >> A new version of the existing extension or a new
>> >> EGL_EXT_image_dma_buf_import2 extension, or ??
>> >
>> > Hi Rob,
>> >
>> > there are actually several things it might be nice to add:
>> >
>> > - a fourth plane, to match what DRM AddFB2 supports
>> >
>> > - the 64-bit fb modifiers
>> >
>> > - queries for which pixel formats are supported by EGL, so a display
>> >   server can tell the applications that before the application goes and
>> >   tries with a random bunch of them, shooting in the dark
>> >
>> > - queries for which modifiers are supported for each pixel format, ditto
>> >
>> > I discussed these with Emil in the past, and it seems an appropriate
>> > approach might be the following.
>> >
>> > Adding the 4th plane can be done as revising the existing
>> > EGL_EXT_image_dma_buf_import extension. The plane count is tied to
>> > pixel formats (and modifiers?), so the user does not need to know
>> > specifically whether the EGL implementation could handle a 4th plane or
>> > not. It is implied by the pixel format.
>> >
>> > Adding the fb modifiers needs to be a new extension, so that users can
>> > tell if they are supported or not. This is to avoid the following false
>> > failure: if user assumes modifiers are always supported, it will (may?)
>> > provide zero modifiers explicitly. If EGL implementation does not
>> > handle modifiers this would be rejected as unrecognized attributes,
>> > while if the zero modifiers were not given explicitly, everything would
>> > just work.
>>
>> hmm, if we design it as "not passing modifier" == "zero modifier", and
>> "never explicitly pass a zero modifier" then modifiers could be added
>> without a new extension.  Although I agree that queries would need a
>> new extension.. so perhaps not worth being clever.
>
> Indeed.
>
>> > The queries obviously(?) need a new extension. It might make sense
>> > to bundle both modifier support and the queries in the same new
>> > extension.
>> >
>> > We have some rough old WIP code at
>> > https://git.collabora.com/cgit/user/lfrb/mesa.git/log/?h=T1410-modifiers
>> > https://git.collabora.com/cgit/user/lfrb/egl-specs.git/log/?h=T1410
>> >
>> >
>> >> On Mon, Feb 25, 2013 at 6:54 AM, Tom Cooksey <tom.cooksey@arm.com> wrote:
>> >> > Hi All,
>> >> >
>> >> > The final spec has had enum values assigned and been published on Khronos:
>> >> >
>> >> > http://www.khronos.org/registry/egl/extensions/EXT/EGL_EXT_image_dma_buf_import.txt
>> >> >
>> >> > Thanks to all who've provided input.
>> >
>> > May I also pull your attention to a detail with the existing spec and
>> > Mesa behaviour I am asking about in
>> > https://lists.freedesktop.org/archives/mesa-dev/2016-June/120249.html
>> > "What is EGL_EXT_image_dma_buf_import image orientation as a GL texture?"
>> > Doing a dmabuf import seems to imply an y-flip AFAICT.
>>
>> I would have expected that *any* egl external image (dma-buf or
>> otherwise) should have native orientation rather than gl orientation.
>> It's somewhat useless otherwise.
>
> In that case importing dmabuf works differently than importing a
> wl_buffer (wl_drm), because for the latter, the y-invert flag is
> returned such that the orientation will match GL. And the direct
> scanout path goes through GBM since you have to import a wl_buffer, and
> I haven't looked what GBM does wrt. y-flip if anything.
>
>> I didn't read it carefully yet (would need caffeine first ;-)) but
>> EGL_KHR_image_base does say "This extension defines a new EGL resource
>> type that is suitable for sharing 2D arrays of image data between
>> client APIs" which to me implies native orientation.  So that just
>> sounds like a mesa bug somehow?
>
> That specific sentence implies nothing about orientation to me.
> Furthermore, the paragraph continues:
>
>         "Although the intended purpose is sharing 2D image data, the
>         underlying interface makes no assumptions about the format or
>         purpose of the resource being shared, leaving those decisions
>         to the application and associated client APIs."
>
> Might "format" include orientation?
>
> How does "native orientation" connect with "GL texture coordinates"?
> The latter have explicitly defined orientation and origin. For use in
> GL, the right way up image is having the origin in the bottom-left
> corner. An image right way up is an image right way up, regardless
> which corner is the origin. The problem comes when you start using
> coordinates.
>
>> Do you just get that w/ i965?  I know some linaro folks have been
>> using this extension to import buffers from video decoder with
>> freedreno/gallium and no one mentioned the video being upside down.
>
> Intel, yes, but since this happens *only* for the GL import path and
> direct scanout is fine without y-flipping, I bet people just flipped y
> and did not think twice, if there even was a problem. I just have a
> habit of asking "why". ;-)

well, if possible, try with one of the gallium drivers?

I'm honestly not 100% sure what it is supposed to be according to the
spec, but I do know some of the linaro folks were doing v4l2dec ->
glimagesink with dmabuf with both mali (I think some ST platform?) and
freedreno (snapdragon db410c), and no one complained to me that the
video was upside down for one or the other.  So I guess at least
gallium and mali are doing the same thing.  No idea if that is the
same thing that i965 does.

BR,
-R

> After all, using GL with windows and FBOs and stuff you very often find
> yourself upside down, and I suspect people have got the habit of just
> flipping it if it does not look right the first time. See e.g. the
> row-order of data going into glTexImage2D...
>
> If the answer is "oops, well, dmabuf import is semantically y-flipping
> when it should not, but we cannot fix it because that would break
> everyone", I would be happy with that. I just want confirmation before
> flipping the flip flag. :-)
>
>
> Thanks,
> pq
