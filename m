Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:34455 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbbIWGxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2015 02:53:38 -0400
Subject: Re: [RFC PATCH v5 0/8] Refactoring Videobuf2 for common use
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
References: <1442928636-3589-1-git-send-email-jh1009.sung@samsung.com>
 <56016F17.2070007@xs4all.nl> <560233C8.6080806@samsung.com>
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56024C6A.90807@xs4all.nl>
Date: Wed, 23 Sep 2015 08:53:30 +0200
MIME-Version: 1.0
In-Reply-To: <560233C8.6080806@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The davinci issues are now resolved, but when compiling for i686 I still get
these:

/home/hans/work/build/media-git/drivers/media/pci/sta2x11/sta2x11_vip.c: In function 'buffer_prepare':
/home/hans/work/build/media-git/drivers/media/pci/sta2x11/sta2x11_vip.c:301:45: warning: passing argument 1 of 'to_vip_buffer' from incompatible pointer type [-Wincompatible-pointer-types]
  struct vip_buffer *vip_buf = to_vip_buffer(vb);
                                             ^
/home/hans/work/build/media-git/drivers/media/pci/sta2x11/sta2x11_vip.c:95:34: note: expected 'struct vb2_v4l2_buffer *' but argument is of type 'struct vb2_buffer *'
 static inline struct vip_buffer *to_vip_buffer(struct vb2_v4l2_buffer *vb2)
                                  ^
/home/hans/work/build/media-git/drivers/media/pci/sta2x11/sta2x11_vip.c: In function 'buffer_queue':
/home/hans/work/build/media-git/drivers/media/pci/sta2x11/sta2x11_vip.c:318:45: warning: passing argument 1 of 'to_vip_buffer' from incompatible pointer type [-Wincompatible-pointer-types]
  struct vip_buffer *vip_buf = to_vip_buffer(vb);
                                             ^
/home/hans/work/build/media-git/drivers/media/pci/sta2x11/sta2x11_vip.c:95:34: note: expected 'struct vb2_v4l2_buffer *' but argument is of type 'struct vb2_buffer *'
 static inline struct vip_buffer *to_vip_buffer(struct vb2_v4l2_buffer *vb2)
                                  ^
/home/hans/work/build/media-git/drivers/media/pci/sta2x11/sta2x11_vip.c: In function 'buffer_finish':
/home/hans/work/build/media-git/drivers/media/pci/sta2x11/sta2x11_vip.c:334:45: warning: passing argument 1 of 'to_vip_buffer' from incompatible pointer type [-Wincompatible-pointer-types]
  struct vip_buffer *vip_buf = to_vip_buffer(vb);
                                             ^
/home/hans/work/build/media-git/drivers/media/pci/sta2x11/sta2x11_vip.c:95:34: note: expected 'struct vb2_v4l2_buffer *' but argument is of type 'struct vb2_buffer *'
 static inline struct vip_buffer *to_vip_buffer(struct vb2_v4l2_buffer *vb2)
                                  ^

Regards,

	Hans

On 23-09-15 07:08, Junghak Sung wrote:
> Dear Hans,
> 
> I tried to make a patch to fix the compile errors below.
> If you can not wait for next round, you can resolve
> the compile errors below with attached patch file.
> But, I'm not sure that this patch can resolve really ALL
> compile problems.
> So, if you don't mind and if you can,
> please, send me your .config file that I can test compile
> by using same config file with yours.
> 
> Regards,
> Junghak
> 
> 
> On 09/23/2015 12:09 AM, Hans Verkuil wrote:
>> Mauro asked if I could make a pull request for patches 1-4, but while compiling
>> it I got these errors and warnings:
>>
>> In file included from /home/hans/work/build/media-git/include/linux/interrupt.h:5:0,
>>                   from /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c:18:
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c: In function 'to_vpif_buffer':
>> /home/hans/work/build/media-git/include/linux/kernel.h:811:48: warning: initialization from incompatible pointer type [-Wincompatible-pointer-types]
>>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>>                                                  ^
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c:58:9: note: in expansion of macro 'container_of'
>>    return container_of(vb, struct vpif_disp_buffer, vb);
>>           ^
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c: In function 'vpif_buffer_prepare':
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c:80:4: error: 'struct vb2_buffer' has no member named 'field'
>>    vb->field = common->fmt.fmt.pix.field;
>>      ^
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c: In function 'vpif_start_streaming':
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c:200:39: warning: passing argument 1 of 'vb2_dma_contig_plane_dma_addr' from incompatible pointer type [-Wincompatible-pointer-types]
>>    addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
>>                                         ^
>> In file included from /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.h:20:0,
>>                   from /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c:26:
>> /home/hans/work/build/media-git/include/media/videobuf2-dma-contig.h:20:1: note: expected 'struct vb2_buffer *' but argument is of type 'struct vb2_v4l2_buffer *'
>>   vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
>>   ^
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c: In function 'process_progressive_mode':
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c:311:39: warning: passing argument 1 of 'vb2_dma_contig_plane_dma_addr' from incompatible pointer type [-Wincompatible-pointer-types]
>>    addr = vb2_dma_contig_plane_dma_addr(&common->next_frm->vb, 0);
>>                                         ^
>> In file included from /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.h:20:0,
>>                   from /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c:26:
>> /home/hans/work/build/media-git/include/media/videobuf2-dma-contig.h:20:1: note: expected 'struct vb2_buffer *' but argument is of type 'struct vb2_v4l2_buffer *'
>>   vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
>>   ^
>> /home/hans/work/build/media-git/scripts/Makefile.build:264: recipe for target 'drivers/media/platform/davinci/vpif_display.o' failed
>>
>> In file included from /home/hans/work/build/media-git/drivers/media/pci/sta2x11/sta2x11_vip.c:29:0:
>> /home/hans/work/build/media-git/drivers/media/pci/sta2x11/sta2x11_vip.c: In function 'to_vip_buffer':
>> /home/hans/work/build/media-git/include/linux/kernel.h:811:48: warning: initialization from incompatible pointer type [-Wincompatible-pointer-types]
>>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>>                                                  ^
>> /home/hans/work/build/media-git/drivers/media/pci/sta2x11/sta2x11_vip.c:97:9: note: in expansion of macro 'container_of'
>>    return container_of(vb2, struct vip_buffer, vb);
>>           ^
>>
>> Please fix!
>>
>> Thanks,
>>
>> 	Hans
>>
>> On 22-09-15 15:30, Junghak Sung wrote:
>>> Hello everybody,
>>>
>>> This is the 5th round for refactoring Videobuf2(a.k.a VB2).
>>> The purpose of this patch series is to separate existing VB2 framework
>>> into core part and V4L2 specific part. So that not only V4L2 but also other
>>> frameworks can use them to manage buffer and utilize queue.
>>>
>>> Why do we try to make the VB2 framework to be common?
>>>
>>> As you may know, current DVB framework uses ringbuffer mechanism to demux
>>> MPEG-2 TS data and pass it to userspace. However, this mechanism requires
>>> extra memory copy because DVB framework provides only read() system call for
>>> application - read() system call copies the kernel data to user-space buffer.
>>> So if we can use VB2 framework which supports streaming I/O and buffer
>>> sharing mechanism, then we could enhance existing DVB framework by removing
>>> the extra memory copy - with VB2 framework, application can access the kernel
>>> data directly through mmap system call.
>>>
>>> We have a plan for this work as follows:
>>> 1. Separate existing VB2 framework into three parts - VB2 common, VB2-v4l2.
>>>     Of course, this change will not affect other v4l2-based
>>>     device drivers. This patch series corresponds to this step.
>>>
>>> 2. Add and implement new APIs for DVB streaming I/O.
>>>     We can remove unnecessary memory copy between kernel-space and user-space
>>>     by using these new APIs. However, we leaves legacy interfaces as-is
>>>     for backward compatibility.
>>>
>>> This patch series is the first step for it.
>>> The previous version of this patch series can be found at belows.
>>>
>>> [1] RFC PATCH v1 - http://www.spinics.net/lists/linux-media/msg90688.html
>>> [2] RFC PATCH v2 - http://www.spinics.net/lists/linux-media/msg92130.html
>>> [3] RFC PATCH v3 - http://www.spinics.net/lists/linux-media/msg92953.html
>>> [4] RFC PATCH v4 - http://www.spinics.net/lists/linux-media/msg93421.html
>>>
>>> Changes since v4
>>> 1. Rebase on 4.3-rc1
>>> Kernel 4.3-rc1 was released. So, this patch set is made based on
>>> that version.
>>>
>>> 2. Modify queue_setup() argument
>>> In previous patch set, struct v4l2_format, which is a parameter of
>>> queue_setup(), is abstracted by using void pointer. But, it is better way to
>>> pass the parameter with presise meaning than abstracting it.
>>> So, replace void * with struct vb2_format which is newly defined to contain
>>> the format information for common use.
>>>
>>> 3. Add a code to check if VB2_MAX_* match with VIDEO_MAX_*
>>> Add a check code to videobuf2-v4l2.c where the compiler compares VIDEO_MAX_FRAME
>>> and VB2_MAX_FRAME (and ditto for MAX_PLANES) and throws an #error if they
>>> do not match.
>>>
>>> 4. Change the commit order
>>> For easier review, the patch that just move things around without doing any
>>> functional change is moved to the last.
>>>
>>> All ideas above are from Hans and it seems to be better and right way.
>>>
>>>
>>> Changes since v3
>>>
>>> 1. Resolve build errors
>>> In previous patch set, the build errors prevented reviewers from applying
>>> the patch. So, in this patch, I tryed to fix the build errors but I hadn't
>>> the build test on all architectures except for x86 and ARM.
>>>
>>> 2. Modify descriptions for DocBook
>>> Descriptions not complying with the DocBook rule are modified,
>>> which was pointed out by Mauro.
>>>
>>> 3. Initialize reserved fields explicitly
>>> The reserved fields of v4l2_buffer are initialized by 0 explicitly
>>> when the vb2_buffer information is returned to userspace,
>>> which was pointed out by Hans.
>>>
>>> 4. Remove unnecessary type-cast
>>> According to Mauro's advice, the unnecessary type-cast are removed
>>> because it's better for the compiler - rather than human - to check those
>>> things.
>>>
>>> 5. Sperate the patch - not easy to review - into two patches
>>> In previous patch set, patch 5 was too difficult to review. So accoring to
>>> Hans' opinion, it separated the patch without any functional changes.
>>>
>>>
>>> Changes since v2
>>>
>>> 1. Remove v4l2 stuffs completely from vb2_buffer
>>> The v4l2 stuffs - v4l2_buf and v4l2_planes - are removed completely from
>>> struct vb2_buffer. New member variables - index, type, memory - are added
>>> to struct vb2_buffer, all of which can be used commonly. And bytesused,
>>> length, offset, userptr, fd, data_offset are added to struct vb2_plane
>>> for the same reason. So, we can manage video buffer by only using
>>> struct vb2_buffer.
>>> And, v4l2 stuffs - flags, field, timestamp, timecode, sequence - are defined
>>> as member variables of struct vb2_v4l2_buffer.
>>>
>>> 2. Create new header file for VB2 internal use
>>> videobuf2-internal.h is created, which is referred by videobuf2-core
>>> and videobuf2-v4l2. The header file contains dprintk() for debug,
>>> macro functions to invoke various callbacks, and vb2_core_* function prototypes
>>> referred by inside of videobuf2.
>>>
>>> 3. Remove buffer-specific callbacks as much as possible
>>> There were many callback functions to handle video buffer information
>>> in previous patch series. In this patch series, I try to remove these callbacks
>>> as much as possible without breaking the existing function flow.
>>> As a result, only four callbacks are remained - fill_user_buffer(),
>>> fill_vb2_buffer(), fill_vb2_timestamp() and is_last().
>>>
>>> All ideas above are from Hans and it seems to be better and right way.
>>>
>>>
>>> Changes since v1
>>>
>>> 1. Divide patch set into more pieces
>>> v1 was not reviewed normally because the 2/3 patch is failed to send to mailing
>>> list with size problem - over 300kb. So I have divided the patch set into five
>>> pieces and refined them neatly, which was pointed by Hans.
>>>
>>> 2. Add shell scripts for renaming patch
>>> In case of renaming patch, shell scripts are included inside the body of the
>>> patches by Mauro's advice. 1/5 and 5/5 patches include these scripts, which can
>>> be used by reviewers or maintainers to regenerate big patch file if something
>>> goes wrong during patch apply.
>>>
>>> 3. Remove dependency on v4l2 from videobuf2
>>> In previous patch set, videobuf2-core uses v4l2-specific stuff as it is.
>>> e.g. enum v4l2_buf_type and enum v4l2_memory. That prevented other frameworks
>>> from using videobuf2 independently and made them forced to include
>>> v4l2-specific stuff.
>>> In this version, these dependent stuffs are replaced with VB2 own stuffs.
>>> e.g. enum vb2_buf_type and enum vb2_memory. So, v4l2-specific header file isn't
>>> required to use videobuf2 in other modules. Please, note that videobuf2 stuffs
>>> will be translated to v4l2-specific stuffs in videobuf2-v4l2.c file for
>>> backward compatibility.
>>>
>>> 4. Unify duplicated definitions
>>> VB2_DEBUG() is newly defined in videobuf2-core header file in order to unify
>>> duplicated macro functions that invoke callback functions implemented in vb2
>>> backends - i.e., videobuf2-vmalloc and videobuf2-dma-sg - and queue relevant
>>> callbacks of device drivers.
>>> In previous patch set, these macro functions were defined
>>> in both videobuf2-core.c and videobuf2-v4l2.c.
>>>
>>>
>>> This patch series is based on media_tree.git [5]. I have applied this patches
>>> to my own git [6] for review, and tested this patch series on ubuntu
>>> PC(Intel i7-3770) for x86 system and odroid-xu3(exynos5422) for ARM.
>>>
>>> [5] media_tree.git - http://git.linuxtv.org/cgit.cgi/media_tree.git/
>>> [6] jsung/dvb-vb2.git - http://git.linuxtv.org/cgit.cgi/jsung/dvb-vb2.git/
>>>      (branch: vb2-refactoring)
>>>
>>> Any suggestions and comments are welcome.
>>>
>>> Regards,
>>> Junghak
>>>
>>> Junghak Sung (8):
>>>    media: videobuf2: Replace videobuf2-core with videobuf2-v4l2
>>>    media: videobuf2: Restructure vb2_buffer (1/3)
>>>    media: videobuf2: Restructure vb2_buffer (2/3)
>>>    media: videobuf2: Restructure vb2_buffer (3/3)
>>>    media: videobuf2: Change queue_setup argument
>>>    media: videobuf2: Replace v4l2-specific data with vb2 data.
>>>    media: videobuf2: Prepare to divide videobuf2
>>>    media: videobuf2: Move v4l2-specific stuff to videobuf2-v4l2
>>>
>>>   drivers/input/touchscreen/sur40.c                  |   28 +-
>>>   drivers/media/dvb-frontends/rtl2832_sdr.c          |   23 +-
>>>   drivers/media/pci/cobalt/cobalt-driver.h           |    6 +-
>>>   drivers/media/pci/cobalt/cobalt-irq.c              |    7 +-
>>>   drivers/media/pci/cobalt/cobalt-v4l2.c             |   26 +-
>>>   drivers/media/pci/cx23885/cx23885-417.c            |   13 +-
>>>   drivers/media/pci/cx23885/cx23885-core.c           |   24 +-
>>>   drivers/media/pci/cx23885/cx23885-dvb.c            |   11 +-
>>>   drivers/media/pci/cx23885/cx23885-vbi.c            |   18 +-
>>>   drivers/media/pci/cx23885/cx23885-video.c          |   29 +-
>>>   drivers/media/pci/cx23885/cx23885.h                |    2 +-
>>>   drivers/media/pci/cx25821/cx25821-video.c          |   32 +-
>>>   drivers/media/pci/cx25821/cx25821.h                |    3 +-
>>>   drivers/media/pci/cx88/cx88-blackbird.c            |   15 +-
>>>   drivers/media/pci/cx88/cx88-core.c                 |    8 +-
>>>   drivers/media/pci/cx88/cx88-dvb.c                  |   13 +-
>>>   drivers/media/pci/cx88/cx88-mpeg.c                 |   14 +-
>>>   drivers/media/pci/cx88/cx88-vbi.c                  |   19 +-
>>>   drivers/media/pci/cx88/cx88-video.c                |   21 +-
>>>   drivers/media/pci/cx88/cx88.h                      |    2 +-
>>>   drivers/media/pci/dt3155/dt3155.c                  |   23 +-
>>>   drivers/media/pci/dt3155/dt3155.h                  |    3 +-
>>>   drivers/media/pci/netup_unidvb/netup_unidvb_core.c |   21 +-
>>>   drivers/media/pci/saa7134/saa7134-core.c           |   14 +-
>>>   drivers/media/pci/saa7134/saa7134-ts.c             |   16 +-
>>>   drivers/media/pci/saa7134/saa7134-vbi.c            |   12 +-
>>>   drivers/media/pci/saa7134/saa7134-video.c          |   23 +-
>>>   drivers/media/pci/saa7134/saa7134.h                |    4 +-
>>>   drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   48 +-
>>>   drivers/media/pci/solo6x10/solo6x10-v4l2.c         |   26 +-
>>>   drivers/media/pci/solo6x10/solo6x10.h              |    4 +-
>>>   drivers/media/pci/sta2x11/sta2x11_vip.c            |   14 +-
>>>   drivers/media/pci/tw68/tw68-video.c                |   28 +-
>>>   drivers/media/pci/tw68/tw68.h                      |    3 +-
>>>   drivers/media/platform/am437x/am437x-vpfe.c        |   41 +-
>>>   drivers/media/platform/am437x/am437x-vpfe.h        |    3 +-
>>>   drivers/media/platform/blackfin/bfin_capture.c     |   34 +-
>>>   drivers/media/platform/coda/coda-bit.c             |  135 +-
>>>   drivers/media/platform/coda/coda-common.c          |   25 +-
>>>   drivers/media/platform/coda/coda-jpeg.c            |    6 +-
>>>   drivers/media/platform/coda/coda.h                 |    8 +-
>>>   drivers/media/platform/coda/trace.h                |   18 +-
>>>   drivers/media/platform/davinci/vpbe_display.c      |   37 +-
>>>   drivers/media/platform/davinci/vpif_capture.c      |   36 +-
>>>   drivers/media/platform/davinci/vpif_capture.h      |    2 +-
>>>   drivers/media/platform/davinci/vpif_display.c      |   28 +-
>>>   drivers/media/platform/davinci/vpif_display.h      |    2 +-
>>>   drivers/media/platform/exynos-gsc/gsc-core.h       |    4 +-
>>>   drivers/media/platform/exynos-gsc/gsc-m2m.c        |   25 +-
>>>   drivers/media/platform/exynos4-is/fimc-capture.c   |   36 +-
>>>   drivers/media/platform/exynos4-is/fimc-core.c      |    2 +-
>>>   drivers/media/platform/exynos4-is/fimc-core.h      |    4 +-
>>>   drivers/media/platform/exynos4-is/fimc-is.h        |    2 +-
>>>   drivers/media/platform/exynos4-is/fimc-isp-video.c |   27 +-
>>>   drivers/media/platform/exynos4-is/fimc-isp-video.h |    2 +-
>>>   drivers/media/platform/exynos4-is/fimc-isp.h       |    4 +-
>>>   drivers/media/platform/exynos4-is/fimc-lite.c      |   29 +-
>>>   drivers/media/platform/exynos4-is/fimc-lite.h      |    4 +-
>>>   drivers/media/platform/exynos4-is/fimc-m2m.c       |   23 +-
>>>   drivers/media/platform/m2m-deinterlace.c           |   25 +-
>>>   drivers/media/platform/marvell-ccic/mcam-core.c    |   49 +-
>>>   drivers/media/platform/marvell-ccic/mcam-core.h    |    2 +-
>>>   drivers/media/platform/mx2_emmaprp.c               |   17 +-
>>>   drivers/media/platform/omap3isp/ispvideo.c         |   27 +-
>>>   drivers/media/platform/omap3isp/ispvideo.h         |    4 +-
>>>   drivers/media/platform/rcar_jpu.c                  |   66 +-
>>>   drivers/media/platform/s3c-camif/camif-capture.c   |   29 +-
>>>   drivers/media/platform/s3c-camif/camif-core.c      |    2 +-
>>>   drivers/media/platform/s3c-camif/camif-core.h      |    4 +-
>>>   drivers/media/platform/s5p-g2d/g2d.c               |   24 +-
>>>   drivers/media/platform/s5p-jpeg/jpeg-core.c        |   34 +-
>>>   drivers/media/platform/s5p-mfc/s5p_mfc.c           |   80 +-
>>>   drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    4 +-
>>>   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   19 +-
>>>   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   62 +-
>>>   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |   46 +-
>>>   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |   33 +-
>>>   drivers/media/platform/s5p-tv/mixer.h              |    4 +-
>>>   drivers/media/platform/s5p-tv/mixer_grp_layer.c    |    2 +-
>>>   drivers/media/platform/s5p-tv/mixer_reg.c          |    2 +-
>>>   drivers/media/platform/s5p-tv/mixer_video.c        |   13 +-
>>>   drivers/media/platform/s5p-tv/mixer_vp_layer.c     |    5 +-
>>>   drivers/media/platform/sh_veu.c                    |   70 +-
>>>   drivers/media/platform/sh_vou.c                    |   37 +-
>>>   drivers/media/platform/soc_camera/atmel-isi.c      |   28 +-
>>>   drivers/media/platform/soc_camera/mx2_camera.c     |   23 +-
>>>   drivers/media/platform/soc_camera/mx3_camera.c     |   41 +-
>>>   drivers/media/platform/soc_camera/rcar_vin.c       |   59 +-
>>>   .../platform/soc_camera/sh_mobile_ceu_camera.c     |   71 +-
>>>   drivers/media/platform/soc_camera/soc_camera.c     |    2 +-
>>>   drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |   29 +-
>>>   drivers/media/platform/ti-vpe/vpe.c                |   44 +-
>>>   drivers/media/platform/vim2m.c                     |   58 +-
>>>   drivers/media/platform/vivid/vivid-core.h          |    4 +-
>>>   drivers/media/platform/vivid/vivid-kthread-cap.c   |   73 +-
>>>   drivers/media/platform/vivid/vivid-kthread-out.c   |   34 +-
>>>   drivers/media/platform/vivid/vivid-sdr-cap.c       |   51 +-
>>>   drivers/media/platform/vivid/vivid-vbi-cap.c       |   45 +-
>>>   drivers/media/platform/vivid/vivid-vbi-out.c       |   25 +-
>>>   drivers/media/platform/vivid/vivid-vid-cap.c       |   35 +-
>>>   drivers/media/platform/vivid/vivid-vid-out.c       |   36 +-
>>>   drivers/media/platform/vsp1/vsp1_rpf.c             |    4 +-
>>>   drivers/media/platform/vsp1/vsp1_video.c           |  135 +-
>>>   drivers/media/platform/vsp1/vsp1_video.h           |    8 +-
>>>   drivers/media/platform/vsp1/vsp1_wpf.c             |    4 +-
>>>   drivers/media/platform/xilinx/xilinx-dma.c         |   32 +-
>>>   drivers/media/platform/xilinx/xilinx-dma.h         |    2 +-
>>>   drivers/media/usb/airspy/airspy.c                  |   26 +-
>>>   drivers/media/usb/au0828/au0828-vbi.c              |   17 +-
>>>   drivers/media/usb/au0828/au0828-video.c            |   49 +-
>>>   drivers/media/usb/au0828/au0828.h                  |    3 +-
>>>   drivers/media/usb/em28xx/em28xx-vbi.c              |   16 +-
>>>   drivers/media/usb/em28xx/em28xx-video.c            |   38 +-
>>>   drivers/media/usb/em28xx/em28xx.h                  |    3 +-
>>>   drivers/media/usb/go7007/go7007-driver.c           |   29 +-
>>>   drivers/media/usb/go7007/go7007-priv.h             |    4 +-
>>>   drivers/media/usb/go7007/go7007-v4l2.c             |   22 +-
>>>   drivers/media/usb/hackrf/hackrf.c                  |   24 +-
>>>   drivers/media/usb/msi2500/msi2500.c                |   19 +-
>>>   drivers/media/usb/pwc/pwc-if.c                     |   35 +-
>>>   drivers/media/usb/pwc/pwc-uncompress.c             |    6 +-
>>>   drivers/media/usb/pwc/pwc.h                        |    4 +-
>>>   drivers/media/usb/s2255/s2255drv.c                 |   29 +-
>>>   drivers/media/usb/stk1160/stk1160-v4l.c            |   17 +-
>>>   drivers/media/usb/stk1160/stk1160-video.c          |   12 +-
>>>   drivers/media/usb/stk1160/stk1160.h                |    4 +-
>>>   drivers/media/usb/usbtv/usbtv-video.c              |   27 +-
>>>   drivers/media/usb/usbtv/usbtv.h                    |    3 +-
>>>   drivers/media/usb/uvc/uvc_queue.c                  |   32 +-
>>>   drivers/media/usb/uvc/uvc_video.c                  |   20 +-
>>>   drivers/media/usb/uvc/uvcvideo.h                   |    6 +-
>>>   drivers/media/v4l2-core/Makefile                   |    4 +-
>>>   drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +-
>>>   drivers/media/v4l2-core/v4l2-mem2mem.c             |   10 +-
>>>   drivers/media/v4l2-core/v4l2-trace.c               |   10 +-
>>>   drivers/media/v4l2-core/vb2-trace.c                |    9 +
>>>   drivers/media/v4l2-core/videobuf2-core.c           | 2040 +++-----------------
>>>   drivers/media/v4l2-core/videobuf2-dma-contig.c     |    2 +-
>>>   drivers/media/v4l2-core/videobuf2-dma-sg.c         |    2 +-
>>>   drivers/media/v4l2-core/videobuf2-internal.h       |  161 ++
>>>   drivers/media/v4l2-core/videobuf2-memops.c         |    2 +-
>>>   drivers/media/v4l2-core/videobuf2-v4l2.c           | 1709 ++++++++++++++++
>>>   drivers/media/v4l2-core/videobuf2-vmalloc.c        |    2 +-
>>>   drivers/staging/media/davinci_vpfe/vpfe_video.c    |   46 +-
>>>   drivers/staging/media/davinci_vpfe/vpfe_video.h    |    3 +-
>>>   drivers/staging/media/omap4iss/iss_video.c         |   25 +-
>>>   drivers/staging/media/omap4iss/iss_video.h         |    6 +-
>>>   drivers/usb/gadget/function/uvc_queue.c            |   28 +-
>>>   drivers/usb/gadget/function/uvc_queue.h            |    4 +-
>>>   include/media/davinci/vpbe_display.h               |    3 +-
>>>   include/media/soc_camera.h                         |    2 +-
>>>   include/media/v4l2-mem2mem.h                       |   11 +-
>>>   include/media/videobuf2-core.h                     |  247 ++-
>>>   include/media/videobuf2-dma-contig.h               |    2 +-
>>>   include/media/videobuf2-dma-sg.h                   |    2 +-
>>>   include/media/videobuf2-dvb.h                      |    8 +-
>>>   include/media/videobuf2-memops.h                   |    2 +-
>>>   include/media/videobuf2-v4l2.h                     |  149 ++
>>>   include/media/videobuf2-vmalloc.h                  |    2 +-
>>>   include/trace/events/v4l2.h                        |   62 +-
>>>   include/trace/events/vb2.h                         |   65 +
>>>   161 files changed, 4310 insertions(+), 3348 deletions(-)
>>>   create mode 100644 drivers/media/v4l2-core/vb2-trace.c
>>>   create mode 100644 drivers/media/v4l2-core/videobuf2-internal.h
>>>   create mode 100644 drivers/media/v4l2-core/videobuf2-v4l2.c
>>>   create mode 100644 include/media/videobuf2-v4l2.h
>>>   create mode 100644 include/trace/events/vb2.h
>>>
>>
