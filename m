Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:55657 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab1AGDTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 22:19:51 -0500
Date: Fri, 07 Jan 2011 12:19:45 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: RE: Memory sharing issue by application on V4L2 based device driver
 with system mmu.
In-reply-to: <AANLkTinsduJkynwwEeM5K9f3D7C6jtBgkAyZ0-_0z2X-@mail.gmail.com>
To: 'InKi Dae' <daeinki@gmail.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	kyungmin.park@samsung.com
Message-id: <003201cbae19$bda3dfc0$38eb9f40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: ko
Content-transfer-encoding: 8BIT
References: <4D25BC22.6080803@samsung.com>
 <AANLkTi=P8qY22saY9a_-rze1wsr-DLMgc6Lfa6qnfM7u@mail.gmail.com>
 <002201cbadfd$6d59e490$480dadb0$%han@samsung.com>
 <AANLkTinsduJkynwwEeM5K9f3D7C6jtBgkAyZ0-_0z2X-@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hello,

That's not a translation issue. What I mention is the size of allocation.
The malloc uses 4KB page allocation and SYS.MMU can handle it.
But 64KB or 1MB physically contiguous memory is better than 4KB page in the
point of performance.

Best regards,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of InKi Dae
> Sent: Friday, January 07, 2011 11:17 AM
> To: Jonghun Han
> Cc: linux-media@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
linux-fbdev;
> kyungmin.park@samsung.com
> Subject: Re: Memory sharing issue by application on V4L2 based device
driver
> with system mmu.
> 
> thank you for your comments.
> 
> your second comment has no any problem as I said before, user virtual
addess
> could be translated in page unit. but the problem, as you said, is that
when cpu
> access to the memory in user mode, the memory allocated by malloc, page
fault
> occurs so we can't find pfn to user virtual address. I missed that. but I
think we
> could resolve this one.
> 
> as before, user application allocates memory through malloc function and
then
> send it to device driver(using userptr feature). if the pfn is null when
device driver
> translated user virtual address in page unit then it allocates phsical
memory in
> page unit using some interface such as alloc_page() and then mapping
them. when
> pfn is null, to check it and allocate physical memory in page unit could
be
> processed by videobuf2.
> 
> of course, videobuf2 has no any duty considered for system mmu. so
> videobuf2 just provides callback for 3rd party and any platform with
system mmu
> such as Samsung SoC C210 implements the function(allocating physical
memory
> and mapping it) and registers it to callback of videobuf2. by doing so, I
think your
> first comment could be cleared.
> 
> please, feel free to give me your opinion and pointing out.
> 
> thank you.
> 
> 2011년 1월 7일 오전 8:57, Jonghun Han <jonghun.han@samsung.com>님의 말:
> >
> > Hello,
> >
> > There are two reasons why malloc isn't suitable for it.
> >
> > The first is that malloc doesn't allocate memory when malloc is called.
> > So driver or vb2 cannot find PFN for it in the VIDIOC_QBUF.
> >
> > The second is that malloc uses 4KB page allocation.
> > SYS.MMU(IO-MMU) can handle scattered memory. But it has a penalty when
> > TLB miss is occurred.
> > So as possible as physically contiguous pages are needed for
> > performance enhancement.
> >
> > So new allocator which can clear two main issues is needed.
> >
> > Best regards,
> >
> >> -----Original Message-----
> >> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> >> owner@vger.kernel.org] On Behalf Of InKi Dae
> >> Sent: Thursday, January 06, 2011 10:25 PM
> >> To: linux-media@vger.kernel.org
> >> Subject: Memory sharing issue by application on V4L2 based device
> >> driver
> > with
> >> system mmu.
> >>
> >> Hello, all.
> >>
> >> I'd like to discuss memory sharing issue by application on v4l2 based
> > device driver
> >> with system mmu and get some advices about that.
> >>
> >> Now I am working on Samsung SoC C210 platform and this platform has
> >> some multimedia devices with system mmu such as fimc, and mfc also we
> >> have implemented device drivers for them. those drivers are based on
> >> V4L2
> > framework
> >> with videobuf2. for system mmu of each device, we used VCM(Virtual
> > Contiguous
> >> Memory) framework.
> >>
> >> Simply, VCM framework provides  physical memory, device virtual
> >> memory allocation and memory mapping between them. when device driver
> >> is
> > initialized or
> >> operated by user application, each driver allocates physical memory
> >> and
> > device
> >> virtual memory and then mapping using VCM interface.
> >>
> >> refer to below link for more detail.
> >> http://www.spinics.net/lists/linux-media/msg26548.html
> >>
> >> Physical memory access process is as the following.
> >>            DVA                          PA
> >> device --------------> system mmu ------------------> physical memory
> >>
> >> DVA : device virtual address.
> >> PA : physical address.
> >>
> >> like this, device virtual address should be set to buffer(source or
> >> destination) register of multimedia device.
> >>
> >> the problem is that application want to share own memory with any
> >> device
> > driver to
> >> avoid memory copy. in other words, user-allocated memory could be
> >> source
> > or
> >> destination memory of multimedia device driver.
> >>
> >>
> >> let's see the diagram below.
> >>
> >>                user application
> >>
> >>                      |
> >>                      |
> >>                      |
> >>                      |
> >>                      |  1. UVA(allocated by malloc)
> >>                      |
> >>                      |
> >>                    ＼|/                   2. UVA(in page unit)
> >>
> >>        -----> multimedia device driver -------------------> videobuf2
> >>        |
> >>        |        |     ^                                         |
> >>        |        |     |                                         |
> >>        |        |     -------------------------------------------
> >>        |        |                    3. PA(in page unit)
> >>        |        |
> >>        |        | 4. PA(in page unit)
> >> 6. DVA  |        |
> >>        |        |
> >>        |        |
> >>        |      ＼|/
> >>        |
> >>        |       Virtual Contiguous Memory ---------
> >>        |                                         |
> >>        |           |     ^                       |
> >>        |           |     |                       | 5. map PA to DVA
> >>        |           |     |                       |
> >>        |           |     |                       |
> >>        -------------     -------------------------
> >>
> >> PA : physical address.
> >> UVA : user virtual address.
> >> DVA : device virtual address.
> >>
> >> 1. user application allocates user space memory through malloc
> >> function
> > and
> >> sending it to multimedia device driver based on v4l2 framework
> >> through
> > userptr
> >> feature.
> >>
> >> 2, 3. multimedia device driver gets translated physical address from
> >> videobuf2 framework in page unit.
> >>
> >> 4, 5. multimedia device driver gets allocated device virtual address
> >> and
> > mapping it
> >> to physical address and then mapping them through VCM interface.
> >>
> >> 6. multimedia device driver sets device virtual address from VCM to
> > buffer register.
> >>
> >> the diagram above is fully theoretical so I wonder that this way is
> > reasonable and
> >> has some problems also what should be considered.
> >>
> >> thank you for your interesting.
> >>
> >> _______________________________________________
> >> linux-arm-kernel mailing list
> >> linux-arm-kernel@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >> linux-media" in
> > the body
> >> of a message to majordomo@vger.kernel.org More majordomo info at
> >> http://vger.kernel.org/majordomo-info.html
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

