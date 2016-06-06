Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34420 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbcFFWcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2016 18:32:31 -0400
Message-ID: <5755F9FB.9050309@gmail.com>
Date: Mon, 06 Jun 2016 23:32:27 +0100
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
To: kbuild test robot <fengguang.wu@intel.com>
CC: no To-header on input <kbuild-all@01.org>,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: undefined reference to `dma_common_mmap'
References: <200201100056.UF9oEzeg%fengguang.wu@intel.com> <20160606083705.GA2324@sudip-tp>
In-Reply-To: <20160606083705.GA2324@sudip-tp>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 06 June 2016 09:37 AM, Sudip Mukherjee wrote:
> On Thu, Jan 10, 2002 at 12:50:58AM +0800, kbuild test robot wrote:
>> Hi,
>>
>> It's probably a bug fix that unveils the link errors.
>>
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>> head:   af8c34ce6ae32addda3788d54a7e340cad22516b
>> commit: 420520766a796d36076111139ba1e4fb1aadeadd [media] media: Kconfig: add dependency of HAS_DMA
>> date:   in the future
>> config: m32r-allyesconfig (attached as .config)
>> compiler: m32r-linux-gcc (GCC) 4.9.0
>> reproduce:
>>          wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>>          chmod +x ~/bin/make.cross
>>          git checkout 420520766a796d36076111139ba1e4fb1aadeadd
>>          # save the attached .config to linux build tree
>>          make.cross ARCH=m32r
>
> Thanks, i will reproduce this tonight and see. But just fyi, i am no
> longer using my sudip@vectorindia.org because of a change in dayjob.
> I would have missed this mail unless the date of the mail was showing
> as Jan 10, 2002.

Before this patch m32r allyesconfig used to fail with the error:
../drivers/media/v4l2-core/videobuf2-dma-contig.c: In function 
'vb2_dc_get_userptr':
../drivers/media/v4l2-core/videobuf2-dma-contig.c:484:28: error: 
implicit declaration of function 'dma_get_cache_alignment' 
[-Werror=implicit-function-declaration]
   unsigned long dma_align = dma_get_cache_alignment();

and build never went past this point. This concerned patch fixed the 
error and brought out new errors which were never known before this patch.

Regards
Sudip
