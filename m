Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3863 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575Ab3CSHIa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 03:08:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [REVIEWv2 PATCH 4/6] v4l2: add const to argument of write-only s_register ioctl.
Date: Tue, 19 Mar 2013 08:07:36 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1363615925-19507-1-git-send-email-hverkuil@xs4all.nl> <1363615925-19507-5-git-send-email-hverkuil@xs4all.nl> <3012858.ncv28K4OCe@avalon>
In-Reply-To: <3012858.ncv28K4OCe@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303190807.36752.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue March 19 2013 00:20:00 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Monday 18 March 2013 15:12:03 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > This ioctl is defined as IOW, so pass the argument as const.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> [snip]
> 
> > diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c
> > b/drivers/media/pci/ivtv/ivtv-ioctl.c index 080f179..15e08aa 100644
> > --- a/drivers/media/pci/ivtv/ivtv-ioctl.c
> > +++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
> > @@ -711,49 +711,50 @@ static int ivtv_g_chip_ident(struct file *file, void
> > *fh, struct v4l2_dbg_chip_i }
> > 
> >  #ifdef CONFIG_VIDEO_ADV_DEBUG
> > -static int ivtv_itvc(struct ivtv *itv, unsigned int cmd, void *arg)
> > +static volatile u8 __iomem *ivtv_itvc_start(struct ivtv *itv,
> > +		const struct v4l2_dbg_register *regs)
> 
> I haven't changed my mind since v1, I still don't think you need a volatile 
> here :-)

I agree with you, but changing this requires changing things not just in this
function but also in a header. Basically, it just adds noise to this patch.
This patch is about making s_register const and I don't want to mix it with
other changes unless absolutely necessary.

Regards,

	Hans
