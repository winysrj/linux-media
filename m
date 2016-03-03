Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:34770 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbcCCMYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 07:24:08 -0500
MIME-Version: 1.0
In-Reply-To: <1782092.xMPH0kgtGM@wuerfel>
References: <1456992221-26712-1-git-send-email-k.kozlowski@samsung.com>
	<1456992221-26712-16-git-send-email-k.kozlowski@samsung.com>
	<1782092.xMPH0kgtGM@wuerfel>
Date: Thu, 3 Mar 2016 21:24:06 +0900
Message-ID: <CAJKOXPfjKmZBBv4zNo+oBaoktZmSs3pUQ03H6g_BwYaWKEKtgA@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [RFC 15/15] mfd: syscon: Fix build of missing
 ioremap on UM
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: rtc-linux@googlegroups.com
Cc: linux-arm-kernel@lists.infradead.org, daniel.lezcano@linaro.org,
	tglx@linutronix.de, dan.j.williams@intel.com, vinod.koul@intel.com,
	jason@lakedaemon.net, marc.zyngier@arm.com,
	mchehab@osg.samsung.com, lee.jones@linaro.org,
	peppe.cavallaro@st.com, kishon@ti.com, linus.walleij@linaro.org,
	sre@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org,
	a.zummo@towertech.it, alexandre.belloni@free-electrons.com,
	andy.gross@linaro.org, david.brown@linaro.org,
	laurent.pinchart@ideasonboard.com, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-soc@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-usb@vger.kernel.org, Richard Weinberger <richard@nod.at>,
	Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-03-03 19:50 GMT+09:00 Arnd Bergmann <arnd@arndb.de>:
> On Thursday 03 March 2016 17:03:41 Krzysztof Kozlowski wrote:
>> Since commit c89c0114955a ("mfd: syscon: Set regmap max_register in
>> of_syscon_register") the syscon uses ioremap so it fails on COMPILE_TEST
>> without HAS_IOMEM:
>>
>> drivers/mfd/syscon.c: In function ‘of_syscon_register’:
>> drivers/mfd/syscon.c:67:9: error: implicit declaration of function ‘ioremap’ [-Werror=implicit-function-declaration]
>>   base = ioremap(res.start, resource_size(&res));
>>          ^
>> drivers/mfd/syscon.c:67:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
>>   base = ioremap(res.start, resource_size(&res));
>>        ^
>> drivers/mfd/syscon.c:109:2: error: implicit declaration of function ‘iounmap’ [-Werror=implicit-function-declaration]
>>   iounmap(base);
>>
>> When selecting MFD_SYSCON, depend on HAS_IOMEM to avoid unmet direct
>> dependencies.
>>
>> Reported-by: kbuild test robot <lkp@intel.com>
>> Fixes: c89c0114955a ("mfd: syscon: Set regmap max_register in of_syscon_register")
>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> ---
>
> Thanks for looking into this, the patches all look right to me, but
> I fear we are forever playing catch-up here, as the number of syscon users
> is only growing, and it's not obvious to the average driver developer
> why they have to select this symbol.

Actually I screwed something because entire MFD menuconfig (including
MFD_SYSCON) is already guarded by if HAS_IOMEM.

I was fixing the problem from the end (the build error) and then hit
these unmet direct dependencies (mentioned this in other mail).

I think this patch 15/15 is not needed.

>
> Interestingly, when I try to build an allmodconfig kernel for UML,
> it seems to reject any driver calling ioremap/iounmap but not
> the wrapper functions around that (of_iomap, devm_ioremap,
> devm_ioremap_resource, ...)

The declaration of devm-like functions is always there. However it
should fail during linking stage (see my other patches like for
thermal, nvram etc. this is still in progress because I did not manage
to build allyesconfig on UML yet).

> or the actual accessors that make no
> sense without ioremap (readl, writel, inb, outb, iowrite32, ...).
>
> I've played with this a bit, and arrived at the patch below, is this
> something we want as well?
>
>         Arnd
>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index aa21dc55eb15..2e5b1e525a1d 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -1034,6 +1034,7 @@ config MFD_SUN6I_PRCM
>>
>>  config MFD_SYSCON
>>       bool "System Controller Register R/W Based on Regmap"
>> +     depends on HAS_IOMEM
>>       select REGMAP_MMIO
>>       help
>>         Select this option to enable accessing system control registers
>>
>
>
>  arch/um/include/asm/io.h           |    1 +
>  drivers/char/Kconfig               |    3 +++
>  drivers/char/mem.c                 |   16 ++++++++++++++++
>  drivers/clocksource/Kconfig        |    3 +++
>  drivers/fmc/Kconfig                |    1 +
>  drivers/fpga/Kconfig               |    1 +
>  drivers/hwtracing/intel_th/Kconfig |    1 +
>  drivers/mfd/Kconfig                |    1 +
>  drivers/misc/altera-stapl/Kconfig  |    2 +-
>  drivers/mtd/chips/Kconfig          |    4 ++++
>  drivers/mtd/lpddr/Kconfig          |    1 +
>  drivers/mtd/maps/Kconfig           |    3 ++-
>  drivers/mtd/nand/Kconfig           |    2 +-
>  drivers/mtd/spi-nor/Kconfig        |    1 +
>  drivers/net/can/Kconfig            |    1 +
>  drivers/net/hamradio/Kconfig       |    9 ++++++---
>  drivers/nvmem/Kconfig              |    1 +
>  drivers/phy/Kconfig                |    9 +++++++--
>  drivers/power/reset/Kconfig        |    4 +++-
>  drivers/staging/comedi/Kconfig     |    6 +++++-
>  drivers/thermal/Kconfig            |   11 +++++++++--

For some of these I already started fixing:
https://lkml.org/lkml/2016/3/3/147
http://comments.gmane.org/gmane.linux.kernel/2167664


>  include/linux/irq.h                |    2 ++
>  include/linux/mtd/cfi.h            |    2 ++
>  include/linux/mtd/map.h            |    2 ++
>  kernel/resource.c                  |    2 ++
>  lib/Kconfig                        |    7 ++++++-
>  mm/bootmem.c                       |    4 ++--
>  27 files changed, 85 insertions(+), 15 deletions(-)
>
> diff --git a/arch/um/include/asm/io.h b/arch/um/include/asm/io.h
> new file mode 100644
> index 0000000..618ff13
> --- /dev/null
> +++ b/arch/um/include/asm/io.h
> @@ -0,0 +1 @@
> +/* no IOPORT or IOMEM suport */
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index a043107..f6dc17a 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -8,6 +8,7 @@ source "drivers/tty/Kconfig"
>
>  config DEVMEM
>         bool "/dev/mem virtual device support"
> +       depends on HAS_IOMEM
>         default y
>         help
>           Say Y here if you want to support the /dev/mem device.
> @@ -17,6 +18,7 @@ config DEVMEM
>
>  config DEVKMEM
>         bool "/dev/kmem virtual device support"
> +       depends on HAS_IOMEM
>         default y
>         help
>           Say Y here if you want to support the /dev/kmem device. The
> @@ -94,6 +96,7 @@ config BFIN_OTP_WRITE_ENABLE
>  config PRINTER
>         tristate "Parallel printer support"
>         depends on PARPORT
> +       depends on HAS_IOPORT
>         ---help---
>           If you intend to attach a printer to the parallel port of your Linux
>           box (as opposed to using a serial printer; if the connector at the
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 4f6f94c..eedd129 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -91,6 +91,7 @@ void __weak unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
>  }
>  #endif
>
> +#ifdef CONFIG_DEVMEM
>  /*
>   * This funcion reads the *physical* memory. The f_pos points directly to the
>   * memory location.
> @@ -219,6 +220,7 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
>         *ppos += written;
>         return written;
>  }
> +#endif
>
>  int __weak phys_mem_access_prot_allowed(struct file *file,
>         unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
> @@ -312,6 +314,7 @@ static inline int private_mapping_ok(struct vm_area_struct *vma)
>  }
>  #endif
>
> +#ifdef CONFIG_DEVMEM
>  static const struct vm_operations_struct mmap_mem_ops = {
>  #ifdef CONFIG_HAVE_IOREMAP_PROT
>         .access = generic_access_phys
> @@ -351,7 +354,9 @@ static int mmap_mem(struct file *file, struct vm_area_struct *vma)
>         }
>         return 0;
>  }
> +#endif
>
> +#ifdef CONFIG_DEVKMEM
>  static int mmap_kmem(struct file *file, struct vm_area_struct *vma)
>  {
>         unsigned long pfn;
> @@ -552,7 +557,9 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
>         *ppos = p;
>         return virtr + wrote ? : err;
>  }
> +#endif
>
> +#ifdef CONFIG_DEVPORT
>  static ssize_t read_port(struct file *file, char __user *buf,
>                          size_t count, loff_t *ppos)
>  {
> @@ -594,6 +601,7 @@ static ssize_t write_port(struct file *file, const char __user *buf,
>         *ppos = i;
>         return tmp-buf;
>  }
> +#endif
>
>  static ssize_t read_null(struct file *file, char __user *buf,
>                          size_t count, loff_t *ppos)
> @@ -710,10 +718,12 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
>         return ret;
>  }
>
> +#ifdef CONFIG_DEVPORT
>  static int open_port(struct inode *inode, struct file *filp)
>  {
>         return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
>  }
> +#endif
>
>  #define zero_lseek     null_lseek
>  #define full_lseek      null_lseek
> @@ -722,6 +732,7 @@ static int open_port(struct inode *inode, struct file *filp)
>  #define open_mem       open_port
>  #define open_kmem      open_mem
>
> +#ifdef CONFIG_DEVMEM
>  static const struct file_operations __maybe_unused mem_fops = {
>         .llseek         = memory_lseek,
>         .read           = read_mem,
> @@ -733,7 +744,9 @@ static const struct file_operations __maybe_unused mem_fops = {
>         .mmap_capabilities = memory_mmap_capabilities,
>  #endif
>  };
> +#endif
>
> +#ifdef CONFIG_DEVKMEM
>  static const struct file_operations __maybe_unused kmem_fops = {
>         .llseek         = memory_lseek,
>         .read           = read_kmem,
> @@ -745,6 +758,7 @@ static const struct file_operations __maybe_unused kmem_fops = {
>         .mmap_capabilities = memory_mmap_capabilities,
>  #endif
>  };
> +#endif
>
>  static const struct file_operations null_fops = {
>         .llseek         = null_lseek,
> @@ -755,12 +769,14 @@ static const struct file_operations null_fops = {
>         .splice_write   = splice_write_null,
>  };
>
> +#ifdef CONFIG_DEVPORT
>  static const struct file_operations __maybe_unused port_fops = {
>         .llseek         = memory_lseek,
>         .read           = read_port,
>         .write          = write_port,
>         .open           = open_port,
>  };
> +#endif
>
>  static const struct file_operations zero_fops = {
>         .llseek         = zero_lseek,
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index 33db740..6b58974 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -38,6 +38,7 @@ config DIGICOLOR_TIMER
>  config DW_APB_TIMER
>         bool "DW APB timer driver" if COMPILE_TEST
>         depends on GENERIC_CLOCKEVENTS
> +       depends on HAS_IOMEM
>         help
>           Enables the support for the dw_apb timer.
>
> @@ -64,6 +65,7 @@ config ARMADA_370_XP_TIMER
>  config MESON6_TIMER
>         bool "Meson6 timer driver" if COMPILE_TEST
>         depends on GENERIC_CLOCKEVENTS
> +       depends on HAS_IOMEM
>         select CLKSRC_MMIO
>         help
>           Enables the support for the Meson6 timer driver.
> @@ -114,6 +116,7 @@ config CADENCE_TTC_TIMER
>  config ASM9260_TIMER
>         bool "ASM9260 timer driver" if COMPILE_TEST
>         depends on GENERIC_CLOCKEVENTS
> +       depends on HAS_IOMEM
>         select CLKSRC_MMIO
>         select CLKSRC_OF
>         help
> diff --git a/drivers/fmc/Kconfig b/drivers/fmc/Kconfig
> index 3a75f42..adf1391 100644
> --- a/drivers/fmc/Kconfig
> +++ b/drivers/fmc/Kconfig
> @@ -4,6 +4,7 @@
>
>  menuconfig FMC
>         tristate "FMC support"
> +       depends on HAS_IOMEM
>         help
>
>           FMC (FPGA Mezzanine Carrier) is a mechanical and electrical
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index c9b9fdf..36c54af 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -21,6 +21,7 @@ config FPGA_MGR_SOCFPGA
>
>  config FPGA_MGR_ZYNQ_FPGA
>         tristate "Xilinx Zynq FPGA"
> +       depends on HAS_IOMEM
>         help
>           FPGA manager driver support for Xilinx Zynq FPGAs.
>
> diff --git a/drivers/hwtracing/intel_th/Kconfig b/drivers/hwtracing/intel_th/Kconfig
> index b7a9073..467dae9 100644
> --- a/drivers/hwtracing/intel_th/Kconfig
> +++ b/drivers/hwtracing/intel_th/Kconfig
> @@ -1,5 +1,6 @@
>  config INTEL_TH
>         tristate "Intel(R) Trace Hub controller"
> +       depends on HAS_IOMEM
>         help
>           Intel(R) Trace Hub (TH) is a set of hardware blocks (subdevices) that
>           produce, switch and output trace data from multiple hardware and
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 9ca66de..6ff6246 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -999,6 +999,7 @@ config MFD_SUN6I_PRCM
>
>  config MFD_SYSCON
>         bool "System Controller Register R/W Based on Regmap"
> +       depends on HAS_IOMEM

This shouldn't be needed. There is if HAS_IOMEM at beginning.

Best regards,
Krzysztof
