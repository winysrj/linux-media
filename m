Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:53329 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab2F1MRa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 08:17:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: [RFCv3 PATCH 26/33] videobuf2-core: add helper functions.
Date: Thu, 28 Jun 2012 14:17:28 +0200
Cc: linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	uclinux-dist-devel@blackfin.uclinux.org
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com> <a7faf8fbd12471e355c78859062184fea7beb6b2.1340865818.git.hans.verkuil@cisco.com> <CAHG8p1ADgmzMFZCwULrU__vCuuEGTwEXr+DTfDTcZYA_0iNgkw@mail.gmail.com>
In-Reply-To: <CAHG8p1ADgmzMFZCwULrU__vCuuEGTwEXr+DTfDTcZYA_0iNgkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206281417.28432.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 28 June 2012 11:27:26 Scott Jiang wrote:
> > +int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +       struct video_device *vdev = video_devdata(file);
> > +
> > +       return vb2_mmap(vdev->queue, vma);
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_fop_mmap);
> Missed one file ops.
> 
> #ifndef CONFIG_MMU
> unsigned long vb2_fop_get_unmapped_area(struct file *file,
> 
>  unsigned long addr,
> 
>  unsigned long len,
> 
>  unsigned long pgoff,
> 
>  unsigned long flags)
> {
>         struct video_device *vdev = video_devdata(file);
> 
>         return vb2_get_unmapped_area(vdev->queue,
>                                                              addr,
>                                                              len,
>                                                              pgoff,
>                                                              flags);
> }
> EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
> #endif

Thanks!

I wasn't aware there was a vb2_fop_get_unmapped_area(). :-)

Regards,

	Hans
