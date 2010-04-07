Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:60844 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab0DGKBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Apr 2010 06:01:12 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Muralidharan Karicheri <mkaricheri@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"tony@atomide.com" <tony@atomide.com>
Date: Wed, 7 Apr 2010 15:30:34 +0530
Subject: RE: [PATCH 1/2] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver
 on 	top of DSS2
Message-ID: <19F8576C6E063C45BE387C64729E7394044DF7F9CC@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
	 <1270115880-21404-2-git-send-email-hvaibhav@ti.com>
 <z2j55a3e0ce1004021303rdf3092f7r87b119cd97687f9b@mail.gmail.com>
 <19F8576C6E063C45BE387C64729E7394044DF7F789@dbde02.ent.ti.com>
 <A69FA2915331DC488A831521EAE36FE4016A92D8CF@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4016A92D8CF@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Karicheri, Muralidharan
> Sent: Tuesday, April 06, 2010 11:56 PM
> To: Hiremath, Vaibhav; Muralidharan Karicheri
> Cc: linux-media@vger.kernel.org; mchehab@redhat.com; linux-
> omap@vger.kernel.org; tony@atomide.com
> Subject: RE: [PATCH 1/2] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver
> on top of DSS2
> 
> 
> Vaibhav,
> 
> >>
> >[Hiremath, Vaibhav] Thanks Murali, I really appreciate your comments here.
> >Please find response below -
> 
> You had responded only to some comments. Can I assume that you are taking
> care of the other comments as well? 
[Hiremath, Vaibhav] Yesterday I was replying from home so replied on only important comments. Today I went through all of the comments, most of them are valid comments and I accept most of them except 2 -

> +static u32 omap_vout_uservirt_to_phys(u32 virtp)
> +{
> +       unsigned long physp = 0;
> +       struct vm_area_struct *vma;
> +       struct mm_struct *mm = current->mm;
> +
> +       vma = find_vma(mm, virtp);
> +       /* For kernel direct-mapped memory, take the easy way */
> +       if (virtp >= PAGE_OFFSET) {
> +               physp = virt_to_phys((void *) virtp);
> +       } else if (vma && (vma->vm_flags & VM_IO)
> +                       && vma->vm_pgoff) {
> +               /* this will catch, kernel-allocated,
> +                  mmaped-to-usermode addresses */
> +               physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_start);
> +       } else {
> +               /* otherwise, use get_user_pages() for general userland pages */
> +               int res, nr_pages = 1;
> +               struct page *pages;
> +               down_read(&current->mm->mmap_sem);
> +
> +               res = get_user_pages(current, current->mm, virtp, nr_pages,
> +                               1, 0, &pages, NULL);
> +               up_read(&current->mm->mmap_sem);
> +
> +               if (res == nr_pages) {
> +                       physp =  __pa(page_address(&pages[0]) +
> +                                       (virtp & ~PAGE_MASK));
> +               } else {
> +                       printk(KERN_WARNING VOUT_NAME
> +                                       "get_user_pages failed\n");
> +                       return 0;
> +               }
> +       }
> +
> +       return physp;
> +}

[Murali] Shouldn't we remove omap_vout_uservirt_to_phys() and use videobuf_iolock() instead as we have done in vpfe_capture.c?

As mentioned before, in my opinion we can address this in sub-sequent patch series, and should not block this patch in getting to main-line.

> +/*
> + * Convert V4L2 pixel format to DSS pixel format
> + */
> +static enum omap_color_mode video_mode_to_dss_mode(struct omap_vout_device
> +                       *vout)
> +{
> +       struct omap_overlay *ovl;
> +       struct omapvideo_info *ovid;
> +       struct v4l2_pix_format *pix = &vout->pix;
> +
> +       ovid = &vout->vid_info;
> +       ovl = ovid->overlays[0];
> +
> +       switch (pix->pixelformat) {
> +       case 0:
> +               break;
> +       case V4L2_PIX_FMT_YUYV:
> +               return OMAP_DSS_COLOR_YUV2;
> +
> +       case V4L2_PIX_FMT_UYVY:
> +               return OMAP_DSS_COLOR_UYVY;
> +
> +       case V4L2_PIX_FMT_RGB565:
> +               return OMAP_DSS_COLOR_RGB16;
> +
> +       case V4L2_PIX_FMT_RGB24:
> +               return OMAP_DSS_COLOR_RGB24P;
> +
> +       case V4L2_PIX_FMT_RGB32:
> +               return (ovl->id == OMAP_DSS_VIDEO1) ?
> +                       OMAP_DSS_COLOR_RGB24U : OMAP_DSS_COLOR_ARGB32;
> +       case V4L2_PIX_FMT_BGR32:
> +               return OMAP_DSS_COLOR_RGBX32;
> +
> +       default:
> +               return -EINVAL;
> +       }
> +       return -EINVAL;

[Murali] Also return type is enum and you are returning a negative number here ???

I think yes it is acceptable, since ultimately enum is of type integer constant. You can return the value which fits into this size.


> I have also asked Hans to provide
> his comments since this is a new driver that he might have to approve. Did
> he review the code in the past?
> 
[Hiremath, Vaibhav] Yes he reviewed it some time back; anyway he has already provided few more comments now which I have already fixed. The patch is following this reply.

Thanks,
Vaibhav

> -Murali
> >
<snip>

