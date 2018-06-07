Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49566 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753304AbeFGHZi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 03:25:38 -0400
Date: Thu, 7 Jun 2018 09:25:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tomasz Figa <tfiga@chromium.org>
Cc: mchehab+samsung@kernel.org, mchehab@s-opensource.com,
        Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180607072536.GA12569@amd>
References: <20180319102354.GA12557@amd>
 <20180319074715.5b700405@vento.lan>
 <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
 <20180319120043.GA20451@amd>
 <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
 <20180319095544.7e235a3e@vento.lan>
 <20180515200117.GA21673@amd>
 <20180515190314.2909e3be@vento.lan>
 <20180602210145.GB20439@amd>
 <CAAFQd5ACz1DNW07-vk6rCffC0aNcUG_9+YVNK9HmOTg0+-3yzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <CAAFQd5ACz1DNW07-vk6rCffC0aNcUG_9+YVNK9HmOTg0+-3yzg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I guess that could give some basic camera functionality on OMAP3-like har=
dware.

Yeah, and that is the goal.

> For most of the current generation of imaging subsystems (e.g. Intel
> IPU3, Rockchip RKISP1) it's not enough. The reason is that there is
> more to be handled by userspace than just setting controls:
>  - configuring pixel formats, resolutions, crops, etc. through the
> whole pipeline - I guess that could be preconfigured per use case
> inside the configuration file, though,
>  - forwarding buffers between capture and processing pipelines, i.e.
> DQBUF raw frame from CSI2 video node and QBUF to ISP video node,
>  - handling metadata CAPTURE and OUTPUT buffers controlling the 3A
> feedback loop - this might be optional if all we need is just ability
> to capture some frames, but required for getting good quality,
>  - actually mapping legacy controls into the above metadata,

I just wanted to add few things:

It seems IPU3 and RKISP1 is really similar to what I have on
N900. Forwarding frames between parts of processing pipeline is not
neccessary, but the other parts are there.

There are also two points where you can gather the image data, either
(almost) raw GRBG10 data from the sensor, or scaled YUV data ready for
display. [And how to display that data without CPU involvement is
another, rather big, topic.]

Anyway, legacy applications expect simple webcams with bad pictures,
low resolution, and no AF support. And we should be able to provide
them with just that.

Best regards,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlsY3fAACgkQMOfwapXb+vI+3wCfaJuFZW1w9MomzGPLPcFeZTYD
6KIAoLl6DUqD+m9N51w932mPBSbBJVkT
=f3p9
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
