Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42567 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753083AbdKPA1p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 19:27:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] v4l: rcar-vin: Implement V4L2 video node release handler
Date: Thu, 16 Nov 2017 02:27:53 +0200
Message-ID: <2234965.HDk880jUUl@avalon>
In-Reply-To: <20171115233433.GL12677@bigcity.dyn.berto.se>
References: <20171115224907.392-1-laurent.pinchart+renesas@ideasonboard.com> <20171115233433.GL12677@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Thursday, 16 November 2017 01:34:33 EET Niklas S=F6derlund wrote:
> On 2017-11-16 00:49:07 +0200, Laurent Pinchart wrote:
> > The rvin_dev data structure contains driver private data for an instance
> > of the VIN. It is allocated dynamically at probe time, and must be freed
> > once all users are gone.
> >=20
> > The structure is currently allocated with devm_kzalloc(), which results
> > in memory being freed when the device is unbound. If a userspace
> > application is currently performing an ioctl call, or just keeps the
> > device node open and closes it later, this will lead to accessing freed
> > memory.
> >=20
> > Fix the problem by implementing a V4L2 release handler for the video
> > node associated with the VIN instance (called when the last user of the
> > video node releases it), and freeing memory explicitly from the release
> > handler.
> >=20
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
>=20
> Acked-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
>=20
> This patch is based on-top of the VIN Gen3 enablement series not yet
> upstream. This is OK for me, just wanted to check that this was the
> intention as to minimize conflicts between the two.

Yes, that's my intention. The patch should be included, or possibly squashe=
d=20
in, your development branch.

=2D-=20
Regards,

Laurent Pinchart
