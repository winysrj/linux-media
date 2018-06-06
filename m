Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40991 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932530AbeFFIqO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 04:46:14 -0400
Date: Wed, 6 Jun 2018 10:46:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tomasz Figa <tfiga@chromium.org>
Cc: mchehab+samsung@kernel.org, mchehab@s-opensource.com,
        Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180606084612.GB18743@amd>
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
        protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <CAAFQd5ACz1DNW07-vk6rCffC0aNcUG_9+YVNK9HmOTg0+-3yzg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Thanks for coming up with this proposal. Please see my comments below.
>=20
> > Ok, can I get any comments on this one?
> > v4l2_open_complex("/file/with/descriptor", 0) can be used to open
> > whole pipeline at once, and work if it as if it was one device.
>=20
> I'm not convinced if we should really be piggy backing on libv4l, but
> it's just a matter of where we put the code added by your patch, so
> let's put that aside.

There was some talk about this before, and libv4l2 is what we came
with. Only libv4l2 is in position to propagate controls to right
devices.

> Who would be calling this function?
>=20
> The scenario that I could think of is:
> - legacy app would call open(/dev/video?), which would be handled by
> libv4l open hook (v4l2_open()?),

I don't think that kind of legacy apps is in use any more. I'd prefer
not to deal with them.

> - v4l2_open() would check if given /dev/video? figures in its list of
> complex pipelines, for example by calling v4l2_open_complex() and
> seeing if it succeeds,

I'd rather not have v4l2_open_complex() called on devices. We could
test if argument is regular file and then call it... But again, that's
next step.

> - if it succeeds, the resulting fd would represent the complex
> pipeline, otherwise it would just open the requested node directly.

> I guess that could give some basic camera functionality on OMAP3-like har=
dware.

It definitely gives camera functionality on OMAP3. I'm using it to
take photos with Nokia N900.

> For most of the current generation of imaging subsystems (e.g. Intel
> IPU3, Rockchip RKISP1) it's not enough. The reason is that there is
> more to be handled by userspace than just setting controls:
>  - configuring pixel formats, resolutions, crops, etc. through the
> whole pipeline - I guess that could be preconfigured per use case
> inside the configuration file, though,

That may be future plan. Note that these can be preconfigured; unlike
controls propagation...

>  - forwarding buffers between capture and processing pipelines, i.e.
> DQBUF raw frame from CSI2 video node and QBUF to ISP video node,

My hardware does not need that, so I could not test it. I'll rely on
someone with required hardware to provide that.

(And you can take DQBUF and process it with software, at cost of
slightly higher CPU usage, right?)

>  - handling metadata CAPTURE and OUTPUT buffers controlling the 3A
> feedback loop - this might be optional if all we need is just ability
> to capture some frames, but required for getting good quality,
>  - actually mapping legacy controls into the above metadata,

I'm not sure what 3A is. If you mean hardware histograms and friends,
yes, it would be nice to support that, but, again, statistics can be
computed in software.

> I guess it's just a matter of adding further code to handle those,
> though. However, it would build up a separate legacy framework that
> locks us up into the legacy USB camera model, while we should rather
> be leaning towards a more flexible framework, such as Android Camera
> HALv3 or Pipewire. On top of such framework, we could just have a very
> thin layer to emulate the legacy, single video node, camera.

Yes, we'll need something more advanced.

But.. we also need something to run the devices today, so that kernel
drivers can be tested and do not bitrot. That's why I'm doing this
work.

And I believe we should work in steps before getting there... controls
propagation can not be done from external application, so I'm starting
with it.

> Some minor comments for the code follow.

Ok, let me send this, then go through the comments.

Best regards,
							Pavel


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlsXn1QACgkQMOfwapXb+vJ/vACeNCdTD+9Se+o8MnrzGz6dar4B
7d8An0mRQMrPZzHCq/ykDSjwuvLTqcoN
=ft9W
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
