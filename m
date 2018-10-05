Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36302 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728003AbeJESut (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 14:50:49 -0400
Date: Fri, 5 Oct 2018 08:52:14 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] V4L2_PIX_FMT_MJPEG vs V4L2_PIX_FMT_JPEG
Message-ID: <20181005085214.7f605ae1@coco.lan>
In-Reply-To: <d24d3977163f6c05cd65210b743f4e0dc321388d.camel@ndufresne.ca>
References: <03c10b29-6ead-1aa2-334a-c6357004a5ac@xs4all.nl>
        <d24d3977163f6c05cd65210b743f4e0dc321388d.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 01 Oct 2018 08:42:56 -0400
Nicolas Dufresne <nicolas@ndufresne.ca> escreveu:

> Hello Hans,
>=20
> Le lundi 01 octobre 2018 =C3=A0 10:43 +0200, Hans Verkuil a =C3=A9crit :
> > It turns out that we have both JPEG and Motion-JPEG pixel formats defin=
ed.
> >=20
> > Furthermore, some drivers support one, some the other and some both.
> >=20
> > These pixelformats both mean the same.
> >=20
> > I propose that we settle on JPEG (since it seems to be used most often)=
 and
> > add JPEG support to those drivers that currently only use MJPEG. =20
>=20
> Thanks for looking into this. As per GStreamer code, I see 3 alias for
> JPEG. V4L2_PIX_FMT_MJPEG/JPEG/PJPG. I don't know the context, this code
> was written before I knew GStreamer existed. It's possible there is a
> subtle difference, I have never looked at it, but clearly all our JPEG
> decoder handle these as being the same.
>=20
> https://cgit.freedesktop.org/gstreamer/gst-plugins-good/tree/sys/v4l2/gst=
v4l2object.c#n956

The code at libv4l handles both MJPEG and JPEG the same way. PJPG is
handled somewhat differently (although it uses the same code). There is a
code there that cleanups some Pixart-specific headers.

Thanks,
Mauro
