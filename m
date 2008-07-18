Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IHj5PX009367
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 13:45:05 -0400
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6IHinVD010573
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 13:44:49 -0400
From: "Jalori, Mohit" <mjalori@ti.com>
To: John <john.maximus@gmail.com>
Date: Fri, 18 Jul 2008 12:44:16 -0500
Message-ID: <8AA5EFF14ED6C44DB31DA963D1E78F0DAFAB1E5A@dlee02.ent.ti.com>
References: <d695c0780807120311y55c3ef15q6528a6144aeb8c12@mail.gmail.com>
	<8AA5EFF14ED6C44DB31DA963D1E78F0DAF97A08F@dlee02.ent.ti.com>
	<3634de740807160906k133ded89yd91b33b00162fc68@mail.gmail.com>
In-Reply-To: <3634de740807160906k133ded89yd91b33b00162fc68@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: RE: omap3 camera driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>



> -----Original Message-----
> From: John [mailto:john.maximus@gmail.com]
> Sent: Wednesday, July 16, 2008 11:06 AM
> To: Jalori, Mohit
> Cc: video4linux-list@redhat.com
> Subject: Re: omap3 camera driver
>
> Hi Mohit,
> This patch is fails to apply against the labrador kernel 2.6.22.
>
> Kindly provide details of the kernel against which this patch is
> generated and tested.


The patch was generated against 2.6.26-rc6 version of the kernel. We will be posting sensor driver and lens driver that works with this camera driver next week.

>
> Regards,
>
> John
>
>
>
> On Sat, Jul 12, 2008 at 8:40 PM, Jalori, Mohit <mjalori@ti.com> wrote:
> > Yes it was failing for this for us as well.
> >
> > I kept the same formatting since other formats were defined that
> way.
> > Should I modify all formats with the space in between or keep it
> this way?
> >
> >
> >
> >> -----Original Message-----
> >> From: John Smith [mailto:john.v4l2@gmail.com]
> >> Sent: Saturday, July 12, 2008 5:12 AM
> >> To: video4linux-list@redhat.com; Jalori, Mohit
> >> Subject: omap3 camera driver
> >>
> >> Hi Mohit,
> >> I was just looking to your patch and the first observation I could
> get
> >> immediately is, checkpatch.pl script is failing on some of patches.
> I
> >> am not sure, was that missed or intentional? Below is checkpatch
> >> output for the one which I have tired -
> >>
> >>
> >>
> >> ./scripts/checkpatch.pl
> >> scripts/camera_patches/004_v4l2_sgrbg10_format.patch
> >> need space after that ',' (ctx:VxV)
> >> #19: FILE: include/linux/videodev2.h:312:
> >> +#define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B','A','1','0') /* 10bit
> >> raw bayer  */
> >>                                              ^
> >>
> >> need space after that ',' (ctx:VxV)
> >> #19: FILE: include/linux/videodev2.h:312:
> >> +#define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B','A','1','0') /* 10bit
> >> raw bayer  */
> >>                                                  ^
> >>
> >> need space after that ',' (ctx:VxV)
> >> #19: FILE: include/linux/videodev2.h:312:
> >> +#define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B','A','1','0') /* 10bit
> >> raw bayer  */
> >>                                                      ^
> >>
> >> Your patch has style problems, please review.  If any of these
> errors
> >> are false positives report them to the maintainer, see
> >> CHECKPATCH in MAINTAINERS.
> >>
> >> #------------------------------------------------------------------
> ---
> >> -------------
> >>
> >> ./scripts/checkpatch.pl
> >> scripts/camera_patches/007_v4l2_sgrbg10dpcm8_format.patch
> >> line over 80 characters
> >> #20: FILE: include/linux/videodev2.h:313:
> >> +#define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B','D','1','0') /*
> >> 10bit raw bayer DPCM compressed to 8 bits */
> >>
> >> need space after that ',' (ctx:VxV)
> >> #20: FILE: include/linux/videodev2.h:313:
> >> +#define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B','D','1','0') /*
> >> 10bit raw bayer DPCM compressed to 8 bits */
> >>                                                   ^
> >>
> >> need space after that ',' (ctx:VxV)
> >> #20: FILE: include/linux/videodev2.h:313:
> >> +#define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B','D','1','0') /*
> >> 10bit raw bayer DPCM compressed to 8 bits */
> >>                                                       ^
> >>
> >> need space after that ',' (ctx:VxV)
> >> #20: FILE: include/linux/videodev2.h:313:
> >> +#define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B','D','1','0') /*
> >> 10bit raw bayer DPCM compressed to 8 bits */
> >>                                                           ^
> >>
> >> Your patch has style problems, please review.  If any of these
> errors
> >> are false positives report them to the maintainer, see
> >> CHECKPATCH in MAINTAINERS.
> >>
> >>
> >> #------------------------------------------------------------------
> ---
> >> -------------
> >>
> >> ./scripts/checkpatch.pl
> >>
> scripts/camera_patches/010_omap_34xx_camera_driver_isp_basic_blocks.pa
> >> tch
> >> struct mutex definition without comment
> >> #1762: FILE: drivers/media/video/omap34xxcam.h:97:
> >> +       struct mutex mutex;
> >>
> >> struct mutex definition without comment
> >> #1816: FILE: drivers/media/video/omap34xxcam.h:151:
> >> +       struct mutex mutex;
> >>
> >> spinlock_t definition without comment
> >> #1846: FILE: drivers/media/video/omap34xxcam.h:181:
> >> +       spinlock_t vbq_lock;
> >>
> >> Use #include <linux/irq.h> instead of <asm/irq.h>
> >> #1901: FILE: drivers/media/video/isp/isp.c:33:
> >> +#include <asm/irq.h>
> >>
> >> spinlock_t definition without comment
> >> #1979: FILE: drivers/media/video/isp/isp.c:111:
> >> +       spinlock_t lock;
> >>
> >> spinlock_t definition without comment
> >> #1980: FILE: drivers/media/video/isp/isp.c:112:
> >> +       spinlock_t isp_temp_buf_lock;
> >>
> >> struct mutex definition without comment
> >> #1981: FILE: drivers/media/video/isp/isp.c:113:
> >> +       struct mutex isp_mutex;
> >>
> >> need consistent spacing around '/' (ctx:WxV)
> >> #3760: FILE: drivers/media/video/isp/isp.h:87:
> >> +#define NUM_ISP_CAPTURE_FORMATS        (sizeof(isp_formats) /\
> >>                                                              ^
> >>
> >> do not add new typedefs
> >> #3763: FILE: drivers/media/video/isp/isp.h:90:
> >> +typedef int (*isp_vbq_callback_ptr) (struct videobuf_buffer *vb);
> >>
> >> do not add new typedefs
> >> #3764: FILE: drivers/media/video/isp/isp.h:91:
> >> +typedef void (*isp_callback_t) (unsigned long status,
> >>
> >> spinlock_t definition without comment
> >> #3836: FILE: drivers/media/video/isp/isp.h:163:
> >> +       spinlock_t lock;
> >>
> >> struct mutex definition without comment
> >> #4085: FILE: drivers/media/video/isp/ispccdc.c:83:
> >> +       struct mutex mutexlock;
> >>
> >> Use #include <linux/irq.h> instead of <asm/irq.h>
> >> #5544: FILE: drivers/media/video/isp/ispmmu.c:38:
> >> +#include <asm/irq.h>
> >>
> >> #if 0 -- if this code redundant remove it
> >> #6397: FILE: drivers/media/video/isp/ispreg.h:26:
> >> +#if 0
> >>
> >> Your patch has style problems, please review.  If any of these
> errors
> >> are false positives report them to the maintainer, see
> >> CHECKPATCH in MAINTAINERS.
> >>
> >> #------------------------------------------------------------------
> ---
> >> ----------------------
> >>
> >>
> >> I would like to understand the design actually, will take some
> time.
> >>
> >> Thanks,
> >> John
> >
> > --
> > video4linux-list mailing list
> > Unsubscribe mailto:video4linux-list-
> request@redhat.com?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
> >

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
