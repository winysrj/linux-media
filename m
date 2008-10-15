Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9FDWrGp009789
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 09:32:53 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9FDWh7C016159
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 09:32:44 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Jadav, Brijesh R" <brijesh.j@ti.com>, Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 15 Oct 2008 08:32:36 -0500
Message-ID: <A69FA2915331DC488A831521EAE36FE4AFB7CAD5@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE4AF7E5CAA@dlee06.ent.ti.com>
	<200810031635.40168.robk@starhub.net.sg>
	<19F8576C6E063C45BE387C64729E739403DC087DFD@dbde02.ent.ti.com>
	<aec7e5c30810140546g4fa97f6br2a6bd3b84e083329@mail.gmail.com>
	<19F8576C6E063C45BE387C64729E739403DC2A806B@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739403DC2A806B@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: RE: videobuf-dma-contig - buffer allocation at init time ?
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

Hi,

I think this will resolve our issue as well. I will use this for my port.


Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
Phone : 301-515-3736
email: m-karicheri2@ti.com

>>>-----Original Message-----
>>>From: Jadav, Brijesh R
>>>Sent: Wednesday, October 15, 2008 7:54 AM
>>>To: Magnus Damm
>>>Cc: video4linux-list@redhat.com; Karicheri, Muralidharan
>>>Subject: RE: videobuf-dma-contig - buffer allocation at init time ?
>>>
>>>Hi,
>>>
>>>Thank you very much for providing me the solution to this problem. This
>>>will solve our problem for which we struggled a lot.
>>>
>>>Brijesh Jadav
>>>
>>>-----Original Message-----
>>>From: Magnus Damm [mailto:magnus.damm@gmail.com]
>>>Sent: Tuesday, October 14, 2008 6:17 PM
>>>To: Jadav, Brijesh R
>>>Cc: Rob Kramer; video4linux-list@redhat.com; Karicheri, Muralidharan
>>>Subject: Re: videobuf-dma-contig - buffer allocation at init time ?
>>>
>>>Hi there,
>>>
>>>On Sat, Oct 4, 2008 at 2:41 AM, Jadav, Brijesh R <brijesh.j@ti.com>
>>>wrote:
>>>> Hi,
>>>>
>>>> Even dma_alloc_coherent fails after some time because of the memory
>>>fragmentation for the large buffer, which is required for the HD modes.
>>>This is typically in the Embedded devices because they have less memory.
>>>Is it possible to have a hook from the video-buf layer to the driver for
>>>allocating contiguous buffer so that allocation and de-allocation is
>>>managed in the driver completely?
>>>
>>>Yes, you are correct that fragmentation will be an issue. To avoid
>>>that you could allocate a static buffer at boot up and use that buffer
>>>with dma_declare_coherent_memory().
>>>
>>>Look at how platform_resource_setup_memory() is being used in the
>>>board specific code here:
>>>
>>>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-
>>>2.6.git;a=blob;f=arch/sh/boards/mach-
>>>migor/setup.c;h=714dce91cc9bbb30684764c33eef963c09844866;hb=HEAD
>>>
>>>This SuperH specific function is used at boot up time to allocate a
>>>chunk of physically contiguous memory for on-chip IP blocks:
>>>
>>>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-
>>>2.6.git;a=blob;f=arch/sh/mm/consistent.c;h=64b8f7f96f9aed038e87be11ee374d
>>>5b0797f239;hb=HEAD
>>>
>>>This memory chunk is passed to the V4L2 driver as a platform resource.
>>>The V4L2 driver performs a dma_declare_coherent_memory() call to make
>>>sure all future dma_alloc_coherent() calls will be allocated from this
>>>memory.
>>>
>>>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-
>>>2.6.git;a=blob;f=drivers/media/video/sh_mobile_ceu_camera.c;h=76838091dc6
>>>6ce05140b63912ec106422e2bc542;hb=HEAD
>>>
>>>Look at Documentation/DMA-API.txt for more information. Not sure if
>>>your architecture support this mechanism though.
>>>
>>>/ magnus


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
