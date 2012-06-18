Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4638 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2FRLlQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 07:41:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv1 PATCH 28/32] vivi: use vb2 helper functions.
Date: Mon, 18 Jun 2012 13:40:59 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <47a839710682872826a3da4ef631fccded2ed299.1339321562.git.hans.verkuil@cisco.com> <27919488.Es5OfZrXDC@avalon>
In-Reply-To: <27919488.Es5OfZrXDC@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206181340.59382.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 18 2012 12:08:10 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Sunday 10 June 2012 12:25:50 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/video/vivi.c |  160 ++++++-----------------------------------
> >  1 file changed, 21 insertions(+), 139 deletions(-)
> > 
> > diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> > index 1e4da5e..1e8c4f3 100644
> > --- a/drivers/media/video/vivi.c
> > +++ b/drivers/media/video/vivi.c
> > @@ -767,7 +767,13 @@ static int queue_setup(struct vb2_queue *vq, const
> > struct v4l2_format *fmt, struct vivi_dev *dev = vb2_get_drv_priv(vq);
> >  	unsigned long size;
> > 
> > -	size = dev->width * dev->height * dev->pixelsize;
> > +	if (fmt)
> > +		size = fmt->fmt.pix.sizeimage;
> > +	else
> > +		size = dev->width * dev->height * dev->pixelsize;
> > +
> > +	if (size == 0)
> > +		return -EINVAL;
> 
> If I'm not mistaken, this is a bug fix to properly support CREATE_BUF, right ? 
> If so it should be split to its own patch.

OK.

	Hans
