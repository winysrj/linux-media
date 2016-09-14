Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49501 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753427AbcINT7v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 15:59:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: Re: [PATCH 11/13] v4l: vsp1: Determine partition requirements for scaled images
Date: Wed, 14 Sep 2016 23:00:33 +0300
Message-ID: <1554377.UPrL1uhbCT@avalon>
In-Reply-To: <20160914192733.GL739@bigcity.dyn.berto.se>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1473808626-19488-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20160914192733.GL739@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Wednesday 14 Sep 2016 21:27:33 Niklas S=F6derlund wrote:
> On 2016-09-14 02:17:04 +0300, Laurent Pinchart wrote:
> > From: Kieran Bingham <kieran+renesas@bingham.xyz>
> >=20
> > The partition algorithm needs to determine the capabilities of each=

> > entity in the pipeline to identify the correct maximum partition wi=
dth.
> >=20
> > Extend the vsp1 entity operations to provide a max_width operation =
and
> > use this call to calculate the number of partitions that will be
> > processed by the algorithm.
> >=20
> > Gen 2 hardware does not require multiple partitioning, and as such
> > will always return a single partition.
> >=20
> > Signed-off-by: Kieran Bingham <kieran+renesas@bingham.xyz>
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
>=20
> I can't find the information about the partition limitations for SRU =
or
> UDS in any of the documents I have.

That's because it's not documented in the datasheet :-(

> But for the parts not relating to the logic of figuring out the hscal=
e from
> the input/output formats width:
>=20
> Reviewed-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.s=
e>

Thanks.

--=20
Regards,

Laurent Pinchart

