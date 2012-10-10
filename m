Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60568 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2JJLL5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 07:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <20121010075418.6a18a867@redhat.com>
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
	<20121010075418.6a18a867@redhat.com>
Date: Wed, 10 Oct 2012 20:11:55 +0900
Message-ID: <CAH9JG2VBQSmiBYgVTaFYbgeaE35WMB-J4exT3Uqd9+fnsM0d-A@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCHv9 00/25] Integration of videobuf2 with DMABUF
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	arm-linux <linux-arm-kernel@lists.infradead.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	k.debski@samsung.com, s.nawrocki@samsung.com, pawel@osciak.com,
	sumit.semwal@ti.com, robdclark@gmail.com,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Arnd Bergmann <arnd@arndb.de>,
	laurent.pinchart@ideasonboard.com, airlied@redhat.com,
	remi@remlab.net, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/10/12, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Hi,
>
> Em Tue, 02 Oct 2012 16:27:11 +0200
> Tomasz Stanislawski <t.stanislaws@samsung.com> escreveu:
>
>> Hello everyone,
>> This patchset adds support for DMABUF [2] importing and exporting to V4L2
>> stack.
>>
>> v9:
>> - rebase on 3.6
>> - change type for fs to __s32
>> - add support for vb2_ioctl_expbuf
>> - remove patch 'v4l: vb2: add support for DMA_ATTR_NO_KERNEL_MAPPING',
>>   it will be posted as a separate patch
>> - fix typos and style in Documentation (from Hans Verkuil)
>> - only vb2-core and vb2-dma-contig selects DMA_SHARED_BUFFER in Kconfig
>> - use data_offset and length while queueing DMABUF
>> - return the most recently used fd at VIDIOC_DQBUF
>> - use (buffer-type, index, plane) tuple instead of mem_offset
>>   to identify a for exporting (from Hans Verkuil)
>> - support for DMABUF mmap in vb2-dma-contig (from Laurent Pinchart)
>> - add testing alignment of vaddr and size while verifying userptr
>>   against DMA capabilities (from Laurent Pinchart)
>> - substitute VM_DONTDUMP with VM_RESERVED
>> - simplify error handling in vb2_dc_get_dmabuf (from Laurent Pinchart)
>
> For now, NACK. See below.

Sad news!
It's failed to merge by very poor samsung board support at mainline.

CC arm & samsung mailing list.

Thank you,
Kyungmin Park
>
> I spent 4 days trying to setup an environment that would allow testing
> DMABUF with video4linux without success (long story, see below). Also,
> Laurent tried the same without any luck, and it seems that it even
> corrupted his test machine.
>
> Basically Samsung generously donated me two boards that it could be
> used on this test (Origen and SMDK310). None of them actually worked
> with the upstream kernel: patches are needed to avoid OOPSes on
> Origen; both Origen/SMDK310 defconfigs are completely broken, and drivers
> don't even boot if someone tries to use the Kernel's defconfigs.
>
> Even after spending _days_ trying to figure out the needed .config options
> (as the config files are not easily available), both boards have... issues:
>
> 	- lack of any display output driver at SMDK310;
>
> 	- lack of any network driver at Origen: it seems that none of
> the available network options on Origen was upstreamed: no Bluetooth, no
> OTG,
> no Wifi.
>
> The only test I was able to do (yesterday, late night), the DMABUF caused
> an OOPS at the Origen board. So, for sure it is not ready for upstream.
>
> It is now, too late for 3.7. I might consider it to 3.8, if something
> can be done to fix the existing issues, and setup a proper setup, using
> the upstream Kernel.
>
> Regards,
> Mauro
>
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
>
