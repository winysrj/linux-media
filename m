Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1526 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2FRLo4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 07:44:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv1 PATCH 27/32] vivi: embed struct video_device instead of allocating it.
Date: Mon, 18 Jun 2012 13:44:44 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <9b33e257c9f308801652f90514a330388d214c34.1339321562.git.hans.verkuil@cisco.com> <1562498.nha7JZTATH@avalon>
In-Reply-To: <1562498.nha7JZTATH@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206181344.44483.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 18 2012 12:13:38 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Sunday 10 June 2012 12:25:49 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/video/vivi.c |   25 +++++++------------------
> >  1 file changed, 7 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> > index 8dd5ae6..1e4da5e 100644
> > --- a/drivers/media/video/vivi.c
> > +++ b/drivers/media/video/vivi.c
> 
> [snip]
> 
> > @@ -1080,7 +1078,6 @@ static int vidioc_enum_input(struct file *file, void
> > *priv, return -EINVAL;
> > 
> >  	inp->type = V4L2_INPUT_TYPE_CAMERA;
> > -	inp->std = V4L2_STD_525_60;
> 
> Doesn't this belong to the previous patch ?

Indeed.

	Hans
