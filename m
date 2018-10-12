Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45454 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbeJLMxi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 08:53:38 -0400
From: <tbhardwa@codeaurora.org>
To: "'Zhang, Ning A'" <ning.a.zhang@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
References: <1539313441.21249.3.camel@intel.com> <1539318782.21249.7.camel@intel.com>
In-Reply-To: <1539318782.21249.7.camel@intel.com>
Subject: RE: question about V4L2_MEMORY_USERPTR on 64bit applications
Date: Fri, 12 Oct 2018 10:52:51 +0530
Message-ID: <000601d461eb$a1f7afc0$e5e70f40$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

64 bit kernel have 64 bit long(not 32 bit), which is not the case with =
userspace (in 64 bit userspace long is 32-bit). Probably thig got you =
confused.

-----Original Message-----
From: linux-media-owner@vger.kernel.org =
<linux-media-owner@vger.kernel.org> On Behalf Of Zhang, Ning A
Sent: Friday, October 12, 2018 10:03 AM
To: linux-kernel@vger.kernel.org; linux-media@vger.kernel.org
Subject: Re: question about V4L2_MEMORY_USERPTR on 64bit applications

sorry for wrong question, I really meet memory address truncated issue, =
when use V4L2 kernel APIs.

in a kernel thread created by kernel_thread() I vm_mmap a shmem_file to =
addr: 00007ffff7fa8000 and queue it to V4L2, after dequeue it, and I =
find the address is truncated to 00000000f7fa8000

I use __u64 {aka long long unsigned int} to save address, and I find =
userptr is unsigned long, wrongly think it as "data truncated"
and a lot of __u32 in this structure.

everything works fine, but I still don't understand why high 32bit be =
0..

BR.
Ning.


=E5=9C=A8 2018-10-12=E4=BA=94=E7=9A=84 11:04 +0800=EF=BC=8CZhang =
Ning=E5=86=99=E9=81=93=EF=BC=9A
> Hi,
>=20
> I have question about V4L2_MEMORY_USERPTR on 64bit applications.
>=20
> struct v4l2_buffer {
> 	__u32			index;
> 	__u32			type;
> 	__u32			bytesused;
> 	__u32			flags;
> 	__u32			field;
> 	struct timeval		timestamp;
> 	struct v4l2_timecode	timecode;
> 	__u32			sequence;
>=20
> 	/* memory location */
> 	__u32			memory;
> 	union {
> 		__u32           offset;
> 		unsigned long   userptr;   <<<--- this is a 32bit addr.
> 		struct v4l2_plane *planes;
> 		__s32		fd;
> 	} m;
> 	__u32			length;
> 	__u32			reserved2;
> 	__u32			reserved;
> };
>=20
> when use a 64bit application, memory from malloc is 64bit address.
> memory from GPU (eg, intel i915) are also 64bit address.
>=20
> when use these kind of memory as V4L2_MEMORY_USERPTR, address will be=20
> truncated into 32bit.
>=20
> this would be error, but actually not. I really don't understand.
>=20
> BR.
> Ning.
