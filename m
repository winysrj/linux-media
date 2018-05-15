Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34752 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750748AbeEOWDc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 18:03:32 -0400
Date: Tue, 15 May 2018 19:03:14 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180515190314.2909e3be@vento.lan>
In-Reply-To: <20180515200117.GA21673@amd>
References: <20170516124519.GA25650@amd>
        <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl>
        <20180316205512.GA6069@amd>
        <c2a7e1f3-589d-7186-2a85-545bfa1c4536@xs4all.nl>
        <20180319102354.GA12557@amd>
        <20180319074715.5b700405@vento.lan>
        <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
        <20180319120043.GA20451@amd>
        <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
        <20180319095544.7e235a3e@vento.lan>
        <20180515200117.GA21673@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 15 May 2018 22:01:17 +0200
Pavel Machek <pavel@ucw.cz> escreveu:

> Hi!
>=20
> > So, IMHO, entities should be described as:
> >=20
> > 	[entity entity1]
> > 		name =3D foo
> > 		function =3D bar =20
>=20
> I don't really think windows-style config file is suitable here, as we
> have more than two "nested blocks".
>=20
> What about something like this? Note that I'd only implement the
> controls mapping for now... but it should be extensible later to setup
> mappings for the application.
>=20
> Best regards,
> 								Pavel
>=20
>=20
> #modes: 2
> Driver name: OMAP 3 resizer

It probably makes sense to place the driver name before #modes.

=46rom what I understood, the "#foo: <number>" is a tag that makes the
parser to expect for <number> of "foo".

I would also add a first line at the beginning describing the
version of the format, just in case we add more stuff that
would require to change something at the format.

Except for that, it seems ok.

> Mode: 3000x1800
>  #devices: 2
>   0: et8ek8 sensor
>   1: OMAP3 resizer
>  #controls: 2
>   0x4321a034: 1
>   0x4113aab0: 1
>  #links: 1
>   link:
>    entity1: et8ek8 sensor:1
>    entity2: OMAP3 resizer:0
>    resolution1: 1024x768
>    resolution2: 1024x768
> Mode: 1024x768
>  #devices: 2
>   0: et8ek8 sensor
>   1: OMAP3 resizer
>  #controls: 2
>   0x4321a034: 1
>   0x4113aab0: 1
>  #links: 1
>   link:
>    entity1: et8ek8 sensor:1
>    entity2: OMAP3 resizer:0
>    resolution1: 1024x768
>    resolution2: 1024x768
>=20
>=20
>=20



Thanks,
Mauro
