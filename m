Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:33493 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbcFUHLo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 03:11:44 -0400
Message-ID: <5768E84E.9040400@gmail.com>
Date: Tue, 21 Jun 2016 08:10:06 +0100
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
To: kbuild test robot <fengguang.wu@intel.com>
CC: kbuild-all@01.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: ERROR: "bad_dma_ops" [sound/core/snd-pcm.ko] undefined!
References: <201606191246.rRvhiD2z%fengguang.wu@intel.com>
In-Reply-To: <201606191246.rRvhiD2z%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 19 June 2016 05:15 AM, kbuild test robot wrote:
> Hi,
>
> FYI, the error/warning still remains.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   c141afd1a28793c08c88325aa64b773be6f79ccf
> commit: 420520766a796d36076111139ba1e4fb1aadeadd [media] media: Kconfig: add dependency of HAS_DMA
> date:   5 months ago
> config: m32r-allmodconfig (attached as .config)
> compiler: m32r-linux-gcc (GCC) 4.9.0

You are using 4.9.0 ? If you want you can get 5.3.0 from: 
http://chat.vectorindia.net/crosstool/x86_64/5.3.0/m32r-linux.tar.xz


> reproduce:
>          wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          git checkout 420520766a796d36076111139ba1e4fb1aadeadd
>          # save the attached .config to linux build tree
>          make.cross ARCH=m32r
>
> All errors (new ones prefixed by >>):

These are not new errors, old errors which now appears because the 
previous error was solved.

>
>     ERROR: "bad_dma_ops" [sound/soc/qcom/snd-soc-lpass-platform.ko] undefined!
>     ERROR: "dma_common_mmap" [sound/soc/qcom/snd-soc-lpass-platform.ko] undefined!
>     ERROR: "bad_dma_ops" [sound/soc/kirkwood/snd-soc-kirkwood.ko] undefined!
>     ERROR: "bad_dma_ops" [sound/soc/fsl/snd-soc-fsl-asrc.ko] undefined!
>     ERROR: "bad_dma_ops" [sound/soc/atmel/snd-soc-atmel-pcm-pdc.ko] undefined!
>>> ERROR: "bad_dma_ops" [sound/core/snd-pcm.ko] undefined!
>>> ERROR: "dma_common_mmap" [sound/core/snd-pcm.ko] undefined!

These are still there and I need to do something about them.

>>> ERROR: "__ucmpdi2" [lib/842/842_decompress.ko] undefined!
>>> ERROR: "__ucmpdi2" [fs/btrfs/btrfs.ko] undefined!

Patch for these is submitted and should be in Andrew's tree now. But i 
dont see them in linux-next. I think I will ping Andrew asking him.

>     ERROR: "bad_dma_ops" [drivers/usb/host/xhci-plat-hcd.ko] undefined!
<snip>
>     ERROR: "dma_pool_create" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>     ERROR: "smp_flush_cache_all" [drivers/misc/lkdtm.ko] undefined!
>>> ERROR: "__ucmpdi2" [drivers/media/i2c/adv7842.ko] undefined!
>>> ERROR: "__ucmpdi2" [drivers/md/bcache/bcache.ko] undefined!
>>> ERROR: "__ucmpdi2" [drivers/iio/imu/inv_mpu6050/inv-mpu6050.ko] undefined!

same reply as above.

>     ERROR: "bad_dma_ops" [drivers/hwtracing/intel_th/intel_th_msu.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/hwtracing/intel_th/intel_th.ko] undefined!
>>> ERROR: "bad_dma_ops" [drivers/fpga/zynq-fpga.ko] undefined!

iirc, it is fixed now.

regards
sudip
