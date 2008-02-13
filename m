Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1DDIe8D020074
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 08:18:40 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m1DDI8uR007470
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 08:18:09 -0500
Date: Wed, 13 Feb 2008 14:18:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: eric miao <eric.y.miao@gmail.com>
In-Reply-To: <f17812d70802122120r3f8f2c29qa70342d1bda75658@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802131346170.6252@axis700.grange>
References: <Pine.LNX.4.64.0802051830360.5882@axis700.grange>
	<20080211114129.GA10482@flint.arm.linux.org.uk>
	<Pine.LNX.4.64.0802111440230.4440@axis700.grange>
	<f17812d70802122120r3f8f2c29qa70342d1bda75658@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/6] V4L2 soc_camera driver for PXA27x processors
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

On Wed, 13 Feb 2008, eric miao wrote:

> Yes, the PXA3xx has dedicated DMA channels. Yet I still think carry the
> DRCMR register index into platform device's resource would be a better
> idea both for readability (so that no comment necessary for these magic
> numbers) and potential re-usability.

Do you mean just DRCMR's address as a memory-resource? But, as far as I 
understand, PXA3xx not only has a different register / different address, 
it has a completely different scheme for camera DMA-channel configuration, 
so, how is this going to be useful?

> The driver looks good overall and I'm sorry that I didn't have enough
> time to look into this recently. So here are some overall comments,
> I hope I can spend more time to do a line-by-line review later

I'll then wait for that one before submitting a new version, just 
addressing these your comments, ok?

> 1. due to expected difference between pxa27x and pxa3xx quick capture
> interface, I guess there will be dedicated code for pxa3xx, so naming
> of functions/variables to "pxa_*" will leave less choices for later
> processors, I suggest to use the prefix of "pxa27x_*", to indicate it
> is the first processor that this controller appears.

Well, even if we decide to also handle pxa3xx with this driver, having it 
called pxa27x_camera.c won't be too bad, I guess, so, right, let's rename 
it.

> 2. I really hope changes could be made in this patch to remove those
> QCI register definitions from pxa-regs.h to some where closer to this
> driver, maybe pxa27x_camera.h or directly embedded into the driver,
> and using ioremap() for the mmio access

You mean CICR[0-4] bitfield-definitions? Yes, sure, can get them out of 
pxa-regs.h.

> 3. by using only Y dma channel, the driver is dropping the capability
> of the hardware to convert interleaved YCbCr data to planar format,
> what is your plan for that capability?

This driver so far presents what I had to implement and what I could test. 
I didn't have any YCbCr cameras, so, as long as someone gets a task of 
supporting them and the necessary hardware, it'll have to be implemented 
too. I guess, what I could do now at most, is look in the datasheet and 
see if I can prepare the driver to facilitate those future extensions.

> 4. it looks like the sensor framework is currently unable to provide
> more information such as its connection type with the host (master or
> slave, parallel or serial), along with the frequency, sync polarity,
> otherwise, the fields in platform_data can be removed and setting of
> those CICRx registers can be fully inferred. Still, I think we might
> do better by naming the platform_data->platform_flags to some thing
> like
> 
> 	.ci_mode	= {MASTER, SLAVE}_{PARALLEL, SERIAL}
> 	.ci_width	= {8, 9, 10, 11, 12}
> 	.sync_polarity

Aren't all those parameters platform-specific and static? Would anyone 
ever want to switch between these modes at run-time? At least I don't 
think the v4l2 API supports any of those parameters ATM. As for naming, 
sure, we could think of better names. One comment so far - your .ci_width 
above seems to only allow one width at a time. Whereas a platform can 
support more than onw bus-width. Actually, this is one of parameters, 
switchable at run-time, but the platform _capabilities_ are fixed. For 
example in my case, the platform supported 8 and 10 bit modes, and a 
method to dynamically switch between those. So, my .flags look like

+       .flags  = PXA_CAMERA_MASTER | PXA_CAMERA_DATAWIDTH_8 | PXA_CAMERA_DATAWIDTH_10 |
+               PXA_CAMERA_PCLK_EN | PXA_CAMERA_MCLK_EN,

(see the [PATCH 6/6]). And the switching is transparent - it is activated 
upon setting of an 8- or 16-bit pixel format.

> 5. I saw many places emphasize on the assumption that there is only
> _one_ sensor attached, what if multiple sensors to be supported? I
> know several boards with such design.

Cool, I didn't know such existed, but I did implement the whole soc-camera 
API to allow multiple cameras and multiple camera busses. And I only 
restricted the pxa camera driver to 1 camera per bus, as I wasn't sure if 
anyone ever would come up with multi-camera designs with PXA270:-) Ok, it 
shouldn't be a big problem, I guess. There are not so many places in the 
driver, that assume that. But, to really implement support for such 
designs, again, one would need details of those implementations - is only 
one camera active at any given time? How do you switch between them? Do 
they use the same camera interface parameters (parallel / serial, master / 
slave, bus-width, clock configuration) or different, etc.

> 6. the naming of "pxa_is_xxx" reads like a boolean function to me
> at first sight, and it is actually not, maybe we can come up with
> a better name?

Maybe:-) As I first saw those functions, I also thought they were boolean, 
but in fact, "is" means "image sensor" and used to be the driver's name 
before I reworked it. You're right, they have to be changed now.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
