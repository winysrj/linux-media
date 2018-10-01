Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52788 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbeJAXsX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 19:48:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] V4L2_PIX_FMT_MJPEG vs V4L2_PIX_FMT_JPEG
Date: Mon, 01 Oct 2018 20:09:53 +0300
Message-ID: <2837034.jU5LiXlfQ2@avalon>
In-Reply-To: <0ea4fe85-508a-8a9d-0abe-7ae06b0146d3@xs4all.nl>
References: <03c10b29-6ead-1aa2-334a-c6357004a5ac@xs4all.nl> <29bc7b9ffd2ca761cc6df88ff113bb6bcc844e1d.camel@collabora.com> <0ea4fe85-508a-8a9d-0abe-7ae06b0146d3@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday, 1 October 2018 19:28:58 EEST Hans Verkuil wrote:
> On 10/01/2018 06:12 PM, Ezequiel Garcia wrote:
> > On Mon, 2018-10-01 at 08:42 -0400, Nicolas Dufresne wrote:
> >> Le lundi 01 octobre 2018 =E0 10:43 +0200, Hans Verkuil a =E9crit :
> >>> It turns out that we have both JPEG and Motion-JPEG pixel formats
> >>> defined.
> >>>=20
> >>> Furthermore, some drivers support one, some the other and some both.
> >>>=20
> >>> These pixelformats both mean the same.
> >>>=20
> >>> I propose that we settle on JPEG (since it seems to be used most ofte=
n)
> >>> and add JPEG support to those drivers that currently only use MJPEG.
> >>=20
> >> Thanks for looking into this. As per GStreamer code, I see 3 alias for
> >> JPEG. V4L2_PIX_FMT_MJPEG/JPEG/PJPG. I don't know the context, this code
> >> was written before I knew GStreamer existed. It's possible there is a
> >> subtle difference, I have never looked at it, but clearly all our JPEG
> >> decoder handle these as being the same.
> >>=20
> >> https://cgit.freedesktop.org/gstreamer/gst-plugins-good/tree/sys/v4l2/=
gst
> >> v4l2object.c#n956
> >=20
> > To add more data points on the gstreamer side, there's really no
> > difference between gstreamer's types image/jpeg and video/x-jpeg.
> >=20
> > Notably, jpegdec element just stuffs a huffman table if one is missing,
> > for any jpeg:
> >=20
> > https://cgit.freedesktop.org/gstreamer/gst-plugins-good/tree/ext/jpeg/g=
stj
> > pegdec.c#n584
>=20
> lib/libv4lconvert/libv4lconvert.c also treats JPEG and MJPEG the same.
>=20
> It looks like JPEG and MJPEG are randomly used and I don't think you can
> assume that one will have a huffman table and not the other.

That at least should be fixed. If we decide that whether the frames will=20
contain a Huffman table or not is useful information for userspace, then we=
=20
should convey it, either through the current mechanism (JPEG vs. MJPEG) or=
=20
through a different mechanism. Otherwise, we can merge JPEG and MJPEG (as l=
ong=20
as it doesn't break userspace).

=2D-=20
Regards,

Laurent Pinchart
