Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m92E6wOV025306
	for <video4linux-list@redhat.com>; Thu, 2 Oct 2008 10:06:58 -0400
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m92E6ddZ028900
	for <video4linux-list@redhat.com>; Thu, 2 Oct 2008 10:06:39 -0400
Received: from dlep95.itg.ti.com ([157.170.170.107])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id m92E6Xdc025700
	for <video4linux-list@redhat.com>; Thu, 2 Oct 2008 09:06:38 -0500
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep95.itg.ti.com (8.13.8/8.13.8) with ESMTP id m92E6XuP015701
	for <video4linux-list@redhat.com>; Thu, 2 Oct 2008 09:06:33 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Jadav, Brijesh R" <brijesh.j@ti.com>, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Date: Thu, 2 Oct 2008 09:06:45 -0500
Message-ID: <A69FA2915331DC488A831521EAE36FE4AF9AA07F@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE4AF7E5CAA@dlee06.ent.ti.com>
	<19F8576C6E063C45BE387C64729E739403DC087DE4@dbde02.ent.ti.com>,
	<A69FA2915331DC488A831521EAE36FE4AF92B104@dlee06.ent.ti.com>
	<19F8576C6E063C45BE387C64729E739403DC087DE6@dbde02.ent.ti.com>,
	<A69FA2915331DC488A831521EAE36FE4AF9A9E86@dlee06.ent.ti.com>
	<19F8576C6E063C45BE387C64729E739403DC087DF2@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739403DC087DF2@dbde02.ent.ti.com>
Content-Language: en-US
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
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

Brijesh,

Thanks. I have figured it out after posting the message and had sent anothe=
r to confirm if vidioc_default can be used for this. But the message never =
made it to the list for some reason. I will be using vidioc_default and add=
ing changes to v4l2-int-device as required.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
Phone : 301-515-3736
email: m-karicheri2@ti.com
________________________________
From: Jadav, Brijesh R
Sent: Wednesday, October 01, 2008 7:59 PM
To: Karicheri, Muralidharan; video4linux-list@redhat.com
Subject: RE: videobuf-dma-contig - buffer allocation at init time ?


Hi,

v4l2_ioctl_ops  has one private function pointer vidioc_default. this funct=
ion gets called if there is no matching ioctl so you can implement your pri=
vate ioctls in this function and set SoC specific parameters. Currently, as=
 far as i know, there is no interface available for proprietary ioctl in v4=
l2-int-device interface. You may have to add a new function interface in v4=
l2-int-device for setting specific parameters of slave device.



Thanks,

Brijesh Jadav


________________________________________
From: Karicheri, Muralidharan
Sent: Wednesday, October 01, 2008 4:06 PM
To: Jadav, Brijesh R; video4linux-list@redhat.com
Subject: RE: videobuf-dma-contig - buffer allocation at init time ?

Brijesh,

Do you know which V4L2 IOCTL is used to set/get SoC specific hardware
parameters as well decoder specific parameters? We have been using
proprietary IOCTLs for this purpose. Example, SoC has different modules
for image processing which requires configuration. Similarly sensors
have configurable parameters such as black compensation etc.

email: m-karicheri2@ti.com

>>>-----Original Message-----
>>>From: Jadav, Brijesh R
>>>Sent: Monday, September 29, 2008 7:54 PM
>>>To: Karicheri, Muralidharan; video4linux-list@redhat.com
>>>Subject: RE: videobuf-dma-contig - buffer allocation at init time ?
>>>
>>>Hi,
>>>
>>>Yes, OMAP display driver implements it in the same way as described but
>>>currently it does not use video-buf-contig layer and master-slave
>>>interface. OMAP capture driver uses video-buf-sg layer since it can use
>>>non-contiguous buffers and also it uses master-slave interface.
>>>
>>>Thanks,
>>>Brijesh Jadav
>>>
>>>________________________________________
>>>From: Karicheri, Muralidharan
>>>Sent: Monday, September 29, 2008 9:06 AM
>>>To: Jadav, Brijesh R; video4linux-list@redhat.com
>>>Subject: RE: videobuf-dma-contig - buffer allocation at init time ?
>>>
>>>Brijesh,
>>>
>>>Thanks for replying. Does OMAP implements it in the same way as
>>>you have described? (I am guessing you are working on OMAP drivers).
>>>I am using the master-slave interface from OMAP for interfacing the
>>>decoders to SoC controller V4L2 module.
>>>
>>>Regards.
>>>
>>>Murali Karicheri
>>>
>>>>>>-----Original Message-----
>>>>>>From: Jadav, Brijesh R
>>>>>>Sent: Sunday, September 28, 2008 1:34 PM
>>>>>>To: Karicheri, Muralidharan; video4linux-list@redhat.com
>>>>>>Subject: RE: videobuf-dma-contig - buffer allocation at init time ?
>>>>>>
>>>>>>Hi Murali,
>>>>>>
>>>>>>I was looking into the video-buf layer and looks like it is difficult
>>>to
>>>>>>pre-allocate the buffer at the init time and use them at the time of
>>>mmap
>>>>>>using video-buf-contig layer. The only way out is to implement mmap
>>>>>>function in the driver itself so that you can use your pre-allocated
>>>>>>buffers and map them. You can use the same implementation as that of
>>>>>>video-buf layer except that dma_alloc_coherent will not be called if
>>>it
>>>>>>is already allocated.
>>>>>>
>>>>>>Thanks,
>>>>>>Brijesh Jadav
>>>>>>________________________________________
>>>>>>From: video4linux-list-bounces@redhat.com [video4linux-list-
>>>>>>bounces@redhat.com] On Behalf Of Karicheri, Muralidharan
>>>>>>Sent: Monday, September 22, 2008 2:59 PM
>>>>>>To: video4linux-list@redhat.com
>>>>>>Subject: videobuf-dma-contig - buffer allocation at init time ?
>>>>>>
>>>>>>Hello,
>>>>>>
>>>>>>I am in the process of porting my V4L2 video driver to the latest
>>>kernel.
>>>>>>I would like to use the contiguous buffer allocation and would like t=
o
>>>>>>allocate frame buffers (contiguous) at driver initialization. The
>>>>>>contiguous buffer allocation module allocates buffer as part of
>>>>>>_videobuf_mmap_mapper() using dma_alloc_coherent() which gets called
>>>>>>during mmap() user calls. I have following questions about the design
>>>of
>>>>>>this module.
>>>>>>1) Why the allocation of buffer done as part of mmap() not at the ini=
t
>>>>>>time?  Usually video capture requires big frame buffers of 4M or so,
>>>if
>>>>>>HD capture is involved. So in our driver (based on 2.6.10) we allocat=
e
>>>>>>the buffer at driver initialization and had a hacked version of the
>>>>>>buffer allocation module which used this pre-allocated frame buffer
>>>>>>address ptrs during mmap. Allocating buffer of such big size during
>>>>>>kernel operation is likely to fail due to fragmentation of buffers.
>>>>>>2) Is there a way I can allocate the buffer using dma_alloc_coherent(=
)
>>>at
>>>>>>init time and still use the videobuf-dma-contig for mmap and buffer
>>>>>>management using the allocated buffers ?
>>>>>>3) Any other way to address the issue using the existing videobuf-dma=
-
>>>>>>contig module ?
>>>>>>
>>>>>>Thanks for your help.
>>>>>>
>>>>>>Murali
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
