Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:56558 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751352AbcJKTBb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 15:01:31 -0400
From: Eric Anholt <eric@anholt.net>
To: Brian Starkey <brian.starkey@arm.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        liviu.dudau@arm.com, robdclark@gmail.com, hverkuil@xs4all.nl,
        ville.syrjala@linux.intel.com, daniel@ffwll.ch
Subject: Re: [RFC PATCH 00/11] Introduce writeback connectors
In-Reply-To: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
Date: Tue, 11 Oct 2016 12:01:14 -0700
Message-ID: <87d1j6emmd.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Brian Starkey <brian.starkey@arm.com> writes:

> Hi,
>
> This RFC series introduces a new connector type:
>  DRM_MODE_CONNECTOR_WRITEBACK
> It is a follow-on from a previous discussion: [1]
>
> Writeback connectors are used to expose the memory writeback engines
> found in some display controllers, which can write a CRTC's
> composition result to a memory buffer.
> This is useful e.g. for testing, screen-recording, screenshots,
> wireless display, display cloning, memory-to-memory composition.
>
> Patches 1-7 include the core framework changes required, and patches
> 8-11 implement a writeback connector for the Mali-DP writeback engine.
> The Mali-DP patches depend on this other series: [2].
>
> The connector is given the FB_ID property for the output framebuffer,
> and two new read-only properties: PIXEL_FORMATS and
> PIXEL_FORMATS_SIZE, which expose the supported framebuffer pixel
> formats of the engine.
>
> The EDID property is not exposed for writeback connectors.
>
> Writeback connector usage:
> --------------------------
> Due to connector routing changes being treated as "full modeset"
> operations, any client which wishes to use a writeback connector
> should include the connector in every modeset. The writeback will not
> actually become active until a framebuffer is attached.
>
> The writeback itself is enabled by attaching a framebuffer to the
> FB_ID property of the connector. The driver must then ensure that the
> CRTC content of that atomic commit is written into the framebuffer.
>
> The writeback works in a one-shot mode with each atomic commit. This
> prevents the same content from being written multiple times.
> In some cases (front-buffer rendering) there might be a desire for
> continuous operation - I think a property could be added later for
> this kind of control.
>
> Writeback can be disabled by setting FB_ID to zero.

I think this sounds great, and the interface is just right IMO.

I don't really see a use for continuous mode -- a sequence of one-shots
makes a lot more sense because then you can know what data has changed,
which anyone trying to use the writeback buffer would need to know.

> Known issues:
> -------------
>  * I'm not sure what "DPMS" should mean for writeback connectors.
>    It could be used to disable writeback (even when a framebuffer is
>    attached), or it could be hidden entirely (which would break the
>    legacy DPMS call for writeback connectors).
>  * With Daniel's recent re-iteration of the userspace API rules, I
>    fully expect to provide some userspace code to support this. The
>    question is what, and where? We want to use writeback for testing,
>    so perhaps some tests in igt is suitable.
>  * Documentation. Probably some portion of this cover letter needs to
>    make it into Documentation/
>  * Synchronisation. Our hardware will finish the writeback by the next
>    vsync. I've not implemented fence support here, but it would be an
>    obvious addition.

My hardware won't necessarily finish by the next vsync -- it trickles
out at whatever rate it can find memory bandwidth to get the job done,
and fires an interrupt when it's finished.

So I would like some definition for how syncing works.  One answer would
be that these flips don't trigger their pageflip events until the
writeback is done (so I need to collect both the vsync irq and the
writeback irq before sending).  Another would be that manage an
independent fence for the writeback fb, so that you still immediately
know when framebuffers from the previous scanout-only frame are idle.

Also, tests for this in igt, please.  Writeback in igt will give us so
much more ability to cover KMS functionality on non-Intel hardware.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJX/Tb6AAoJELXWKTbR/J7oP3MP/17/Lu/wCv23lpIsZv8YdQo+
RDNYcEFfmuwdI61WwbsDzYY4QdOiGSIeSxIQxb7U0GyRONK5OZbAKRgW4+PzRLWd
1ABJA0579lAuvImRAjNbLNOd5XauQMN3O/lFjc01D4MTItpbGfCHJ1tu23QgU6Zh
D6tHLjnZrtiFVg4WEdPG56Or5de3dCqxqxs4AxIv1bWTVdF4/HEr6ot2U1e3C7kN
yuXTr/CMRaxizoEW3aooRg2MbM44/1GYHBmvJ0NokH5qZOnawOnVE/QDiPJLM7Qt
VdMTcDCa62cTeXmMauwbW4SfPDBmB2J24ObV5U5J7TX1rAMl7Kj82at5cIaKkSvn
e0RUG9sQzw9W+7RV42wtd6HNMHX4OQ0gsXp736ZiSFtXro+s2cE3McjJYDE1n4nA
cdoFlMX7CwIiC/lVGqxRUYoSrNQslwowuvD6afclzu8c+uEeyoznEXXGqB/UvMoS
GPs8piifP0vilfhYud4Aak5sc9kBQhgvjDE1W8G9AlUcjNKap2dclAE1E4XYSlXI
gGTLi5ZG/VwviwD57ODhhXk+Tr1//f+I4sWY1pZ1G2J+9M/Z136A4FfaWHlR5xce
06omSoUvf+/xgcb1GJsmiui8F57cbdVegfXPoKv2hFHA1vIwQYVjanNPgiZkUpWN
sL+kRY45RKkYCKWuTo6D
=8KAN
-----END PGP SIGNATURE-----
--=-=-=--
