Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40522 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932254AbcLMOJh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 09:09:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [media] s5k6aa: set usleep_range greater 0
Date: Tue, 13 Dec 2016 16:10:09 +0200
Message-ID: <5277658.1FioEDcST1@avalon>
In-Reply-To: <ae02dfc1-39b9-f7f7-5168-d00e4ad75db7@samsung.com>
References: <CGME20161213015743epcas3p19867fa74e5ffe2974364d317d9b494f6@epcas3p1.samsung.com> <1481594282-12801-1-git-send-email-hofrat@osadl.org> <ae02dfc1-39b9-f7f7-5168-d00e4ad75db7@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tuesday 13 Dec 2016 13:38:52 Sylwester Nawrocki wrote:
> On 12/13/2016 02:58 AM, Nicholas Mc Guire wrote:
> > As this is not in atomic context and it does not seem like a critic=
al
> > timing setting a range of 1ms allows the timer subsystem to optimiz=
e
> > the hrtimer here.
> >=20
> > Fixes: commit bfa8dd3a0524 ("[media] v4l: Add v4l2 subdev driver fo=
r
> > S5K6AAFX sensor") Signed-off-by: Nicholas Mc Guire <hofrat@osadl.or=
g>
> > ---
>=20
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>=20
> I'm not sure the "Fixes" tag is needed here.
>=20
> > Patch is against 4.9.0 (localversion-next is next-20161212)
>=20
> Ideally patches for the media subsystem should be normally based on
> master branch of the media tree (git://linuxtv.org/media_tree.git).

As pointed out by Ian Arkver, the datasheet states the delay should be =
>50=B5s.=20
Would it make sense to reduce the sleep duration to (3000, 4000) for in=
stance=20
(or possibly even lower), instead of increasing it ?

--=20
Regards,

Laurent Pinchart

