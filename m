Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36198 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750725AbdLKTxi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 14:53:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 3/3 v7] uvcvideo: add a metadata device node
Date: Mon, 11 Dec 2017 21:53:39 +0200
Message-ID: <19653172.edRCCjirqM@avalon>
In-Reply-To: <alpine.DEB.2.20.1712061503060.26640@axis700.grange>
References: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de> <alpine.DEB.2.20.1712051454460.22421@axis700.grange> <alpine.DEB.2.20.1712061503060.26640@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday, 6 December 2017 17:08:14 EET Guennadi Liakhovetski wrote:
> Hi Laurent,
>=20
> While testing the new patch version, we did introduce a couple of
> differences:
>=20
> 1. We cannot (easily) reuse .vidioc_querycap() - the metadata node uses
> v4l2_fh_open() directly, so, it has a different struct file::private_data
> pointer.

OK, no problem, it's not a big deal.=B5

> 2. After your video device unification, the order has swapped: now
> /dev/video0 is a metadata node and /dev/video1 is a video node. Is that
> how you wanted to have this or you don't mind or shall I swap them back?
> For now I've swapped them back, I think that would be more appropriate.

I agree, that's better, thank you.

=2D-=20
Regards,

Laurent Pinchart
