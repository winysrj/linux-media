Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1623 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbZG3Gbz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 02:31:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: How to save number of times using memcpy?
Date: Thu, 30 Jul 2009 08:31:32 +0200
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	v4l2_linux <linux-media@vger.kernel.org>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?utf-8?q?=C3=AB=C2=B0=E2=80=A2=C3=AA=C2=B2=C2=BD=C3=AB=C2=AF=C2=BC?=
	<kyungmin.park@samsung.com>,
	"jm105.lee@samsung.com" <jm105.lee@samsung.com>,
	=?utf-8?q?=C3=AC=EF=BF=BD=C2=B4=C3=AC=E2=80=9E=C2=B8=C3=AB=C2=AC=C2=B8?=
	<semun.lee@samsung.com>,
	=?utf-8?q?=C3=AB=C5=92=E2=82=AC=C3=AC=EF=BF=BD=C2=B8=C3=AA=C2=B8=C2=B0?=
	<inki.dae@samsung.com>,
	=?utf-8?q?=C3=AA=C2=B9=E2=82=AC=C3=AD=CB=9C=E2=80=A2=C3=AC=C2=A4?=
	 =?utf-8?q?=E2=82=AC?= <riverful.kim@samsung.com>
References: <10799.62.70.2.252.1248852719.squirrel@webmail.xs4all.nl> <200907292352.00179.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE401450FAFD0@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401450FAFD0@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907300831.39579.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 30 July 2009 00:05:49 Karicheri, Muralidharan wrote:
> Hans,
>
> I am bit confused about your usage of "davinci". Are you referring to
> vpfe capture driver and dm6467 display driver vs OMAP ?

Yes, the dm6467 display driver (drivers/media/video/davinci/vpif_display.c).

That driver allocates buffers in the vpif_probe() function, and only if the 
caller wants more buffers in REQBUFS will the driver attempt to allocate 
additional buffers. Just look at the source.

> I know at least 
> in these drivers it doesn‚Äôt allocate buffer at init time, but only on
> REQBUF. I need to add this support (buffer allocation at init time) in
> the driver. One way to allocate buffer in driver at init time is to use
> dma_declare_coherent_memory() and pass physical memory address (outside
> the kernel memory space) to this API. I am not aware of any other way of
> doing this. Please let me know If there are alternate ways of doing this.
>
> Also which OMAP file I can refer to understand the implementation you are
> referring to?

See the path to the vpif_display.c source above (from our v4l-dvb 
repository). That implementation will work fine as long as the driver is 
compiled into the kernel and not as a module.

There is one disadvantage, though: the memory allocated is rounded up by the 
kernel to the next power of two. Depending on the precise number and size 
of the buffers this might lead to wasted memory.

Regards,

	Hans

>
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> email: m-karicheri2@ti.com
>
> >-----Original Message-----
> >From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> >owner@vger.kernel.org] On Behalf Of Hans Verkuil
> >Sent: Wednesday, July 29, 2009 5:52 PM
> >To: Karicheri, Muralidharan
> >Cc: Laurent Pinchart; Mauro Carvalho Chehab; Dongsoo, Nathaniel Kim;
> >v4l2_linux; Dongsoo Kim; √´¬∞‚Ä¢√™¬≤¬Ω√´¬Ø¬º; jm105.lee@samsung.com; √¨ÔøΩ¬¥√¨‚Äû¬∏√´¬¨¬∏;
> >√´≈í‚Ç¨√¨ÔøΩ¬∏√™¬∏¬∞; √™¬π‚Ç¨√≠Àú‚Ä¢√¨¬§‚Ç¨
> >Subject: Re: How to save number of times using memcpy?
> >
> >On Wednesday 29 July 2009 21:06:17 Karicheri, Muralidharan wrote:
> >> Hans,
> >>
> >> >True. However, my experience is that this approach isn't needed in
> >> > most cases as long as the v4l driver is compiled into the kernel. In
> >> > that case it is called early enough in the boot sequence that there
> >> > is still enough unfragmented memory available. This should
> >> > definitely be the default case for drivers merged into v4l-dvb.
> >>
> >> In my understanding, the buffer is allocated in the video buffer layer
> >> when driver makes the videobuf_reqbufs() call.
> >
> >That depends completely on the driver implementation. In the case of the
> >davinci driver it will allocate memory for X buffers when the driver is
> >first initialized and it will use those when the application calls
> > reqbufs. If the app wants more than X buffers the driver will attempt
> > to dynamically allocate additional buffers, but those are usually hard
> > to obtain.
> >
> >In my experience there is no problem for the driver to allocate the
> >required
> >memory if it is done during driver initialization and if the driver is
> >compiled into the kernel.
> >
> >> Since this happens after
> >> the kernel is up, this is indeed a serious issue when we require HD
> >> resolution buffers. When I have tested vpfe capture from MT9T031 with
> >> 2048x1536 resolution buffer, the video buffer layer gives an oops due
> >> to failure to allocate buffer( I think video buffer layer is not
> >> handling error case when there are not enough buffers to allocate).
> >> Since buffer allocation happens very late (not at initialization), it
> >> is unlikely to succeed due to fragmentation issue.
> >
> >That is really a driver problem: omap should use the same allocation
> > scheme as davinci does. That works pretty reliably. Of course, if
> > someone tries to squeeze the last drop out of their system, then they
> > still may have to use nasty tricks to get it to work (like using the
> > mem= kernel option). But such tricks are a last resort in my opinion.
> >
> >> So I have added support for USERPTR
> >> IO in vpfe capture to handle high resolution capture. This requires a
> >> kernel module to allocate contiguous buffer and the same is returned
> >> to application using an IOCTL. The physical/logical address can then
> >> be given to driver through USERPTR IO.
> >
> >What exactly is the point of doing this? I gather it is used to pass the
> >same physical memory from e.g. a capture device to e.g. a resizer
> > device, right? Otherwise I see no benefit to doing this as opposed to
> > regular mmap I/O.
> >
> >Regards,
> >
> >	Hans
> >
> >> Another way this can be done, when using mmap IO, is to allocate
> >> device memory (I have not tried it myself, but this seems to work in
> >> SOC Camera drivers) using dma_declare_coherent_memory() (Thanks to
> >> Guennadi Liakhovetski for the suggestion). This function takes
> >> physical memory address outside the kernel memory space. Then when
> >> dma_alloc_coherent() is called by video buffer layer, the buffer is
> >> allocated from the above pre-allocated device memory and will succeed
> >> always. But for this, the target architecture require support for
> >> consistent memory allocation.
> >>
> >> Murali
> >>
> >> >Regards,
> >> >
> >> >        Hans
> >> >
> >> >--
> >> >Hans Verkuil - video4linux developer - sponsored by TANDBERG
> >> >
> >> >--
> >> >To unsubscribe from this list: send the line "unsubscribe
> >> > linux-media" in the body of a message to majordomo@vger.kernel.org
> >> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media"
> >> in the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >--
> >Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media"
> > in the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛gù
>âØ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑hÌØø
Ìª≠Øø
>Ì∫öàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
