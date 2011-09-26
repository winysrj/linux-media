Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2439 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1IZOZN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 10:25:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
Date: Mon, 26 Sep 2011 16:25:03 +0200
Cc: Scott Jiang <scott.jiang.linux@gmail.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com> <CAHG8p1C5F_HKX_GPHv_RdCRRNw9s3+ybK4giCjUXxgSUAUDRVw@mail.gmail.com> <4E70BA97.1090904@samsung.com>
In-Reply-To: <4E70BA97.1090904@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109261625.03748.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, September 14, 2011 16:30:47 Sylwester Nawrocki wrote:
> On 09/14/2011 09:10 AM, Scott Jiang wrote:
> >>> +static int bcap_qbuf(struct file *file, void *priv,
> >>> +                     struct v4l2_buffer *buf)
> >>> +{
> >>> +     struct bcap_device *bcap_dev = video_drvdata(file);
> >>> +     struct v4l2_fh *fh = file->private_data;
> >>> +     struct bcap_fh *bcap_fh = container_of(fh, struct bcap_fh, fh);
> >>> +
> >>> +     if (!bcap_fh->io_allowed)
> >>> +             return -EACCES;
> >>
> >> I suppose -EBUSY would be more appropriate here.
> >>
> > no, io_allowed is to control which file instance has the right to do I/O.
> 
> Looks like you are doing here what the v4l2 priority mechanism is meant for.
> Have you considered the access priority (VIDIOC_G_PRIORITY/VIDIOC_S_PRIORITY
> and friends)? Does it have any shortcomings?

Sylwester, the priority handling doesn't take care of this particular case.

When it comes to streaming you need to administrate which filehandle started
the streaming and block any other filehandle from interfering with that.

This check should really be done in vb2.

Regards,

	Hans
