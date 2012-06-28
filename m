Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50182 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab2F1J11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 05:27:27 -0400
Received: by yenl2 with SMTP id l2so1645503yen.19
        for <linux-media@vger.kernel.org>; Thu, 28 Jun 2012 02:27:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a7faf8fbd12471e355c78859062184fea7beb6b2.1340865818.git.hans.verkuil@cisco.com>
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
	<1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
	<a7faf8fbd12471e355c78859062184fea7beb6b2.1340865818.git.hans.verkuil@cisco.com>
Date: Thu, 28 Jun 2012 17:27:26 +0800
Message-ID: <CAHG8p1ADgmzMFZCwULrU__vCuuEGTwEXr+DTfDTcZYA_0iNgkw@mail.gmail.com>
Subject: Re: [RFCv3 PATCH 26/33] videobuf2-core: add helper functions.
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> +int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +
> +       return vb2_mmap(vdev->queue, vma);
> +}
> +EXPORT_SYMBOL_GPL(vb2_fop_mmap);
Missed one file ops.

#ifndef CONFIG_MMU
unsigned long vb2_fop_get_unmapped_area(struct file *file,

 unsigned long addr,

 unsigned long len,

 unsigned long pgoff,

 unsigned long flags)
{
        struct video_device *vdev = video_devdata(file);

        return vb2_get_unmapped_area(vdev->queue,
                                                             addr,
                                                             len,
                                                             pgoff,
                                                             flags);
}
EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
#endif

Scott
