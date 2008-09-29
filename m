Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8TNsAbd025386
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 19:54:10 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8TNrxFn028945
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 19:54:00 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id m8TNrruT009653
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 18:53:58 -0500
Received: from dbde71.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id m8TNrplx016261
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 05:23:52 +0530 (IST)
From: "Jadav, Brijesh R" <brijesh.j@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Tue, 30 Sep 2008 05:23:50 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403DC087DE6@dbde02.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE4AF7E5CAA@dlee06.ent.ti.com>
	<19F8576C6E063C45BE387C64729E739403DC087DE4@dbde02.ent.ti.com>,
	<A69FA2915331DC488A831521EAE36FE4AF92B104@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4AF92B104@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: 
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

Yes, OMAP display driver implements it in the same way as described but currently it does not use video-buf-contig layer and master-slave interface. OMAP capture driver uses video-buf-sg layer since it can use non-contiguous buffers and also it uses master-slave interface.

Thanks,
Brijesh Jadav

________________________________________
From: Karicheri, Muralidharan
Sent: Monday, September 29, 2008 9:06 AM
To: Jadav, Brijesh R; video4linux-list@redhat.com
Subject: RE: videobuf-dma-contig - buffer allocation at init time ?

Brijesh,

Thanks for replying. Does OMAP implements it in the same way as
you have described? (I am guessing you are working on OMAP drivers).
I am using the master-slave interface from OMAP for interfacing the
decoders to SoC controller V4L2 module.

Regards.

Murali Karicheri

>>>-----Original Message-----
>>>From: Jadav, Brijesh R
>>>Sent: Sunday, September 28, 2008 1:34 PM
>>>To: Karicheri, Muralidharan; video4linux-list@redhat.com
>>>Subject: RE: videobuf-dma-contig - buffer allocation at init time ?
>>>
>>>Hi Murali,
>>>
>>>I was looking into the video-buf layer and looks like it is difficult to
>>>pre-allocate the buffer at the init time and use them at the time of mmap
>>>using video-buf-contig layer. The only way out is to implement mmap
>>>function in the driver itself so that you can use your pre-allocated
>>>buffers and map them. You can use the same implementation as that of
>>>video-buf layer except that dma_alloc_coherent will not be called if it
>>>is already allocated.
>>>
>>>Thanks,
>>>Brijesh Jadav
>>>________________________________________
>>>From: video4linux-list-bounces@redhat.com [video4linux-list-
>>>bounces@redhat.com] On Behalf Of Karicheri, Muralidharan
>>>Sent: Monday, September 22, 2008 2:59 PM
>>>To: video4linux-list@redhat.com
>>>Subject: videobuf-dma-contig - buffer allocation at init time ?
>>>
>>>Hello,
>>>
>>>I am in the process of porting my V4L2 video driver to the latest kernel.
>>>I would like to use the contiguous buffer allocation and would like to
>>>allocate frame buffers (contiguous) at driver initialization. The
>>>contiguous buffer allocation module allocates buffer as part of
>>>_videobuf_mmap_mapper() using dma_alloc_coherent() which gets called
>>>during mmap() user calls. I have following questions about the design of
>>>this module.
>>>1) Why the allocation of buffer done as part of mmap() not at the init
>>>time?  Usually video capture requires big frame buffers of 4M or so, if
>>>HD capture is involved. So in our driver (based on 2.6.10) we allocate
>>>the buffer at driver initialization and had a hacked version of the
>>>buffer allocation module which used this pre-allocated frame buffer
>>>address ptrs during mmap. Allocating buffer of such big size during
>>>kernel operation is likely to fail due to fragmentation of buffers.
>>>2) Is there a way I can allocate the buffer using dma_alloc_coherent() at
>>>init time and still use the videobuf-dma-contig for mmap and buffer
>>>management using the allocated buffers ?
>>>3) Any other way to address the issue using the existing videobuf-dma-
>>>contig module ?
>>>
>>>Thanks for your help.
>>>
>>>Murali

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
