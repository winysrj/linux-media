Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44659 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab0IJIfb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 04:35:31 -0400
Subject: Re: [PATCH 0/8 V5] Many fixes for in-kernel decoding and for the
 ENE driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	lirc-list@lists.sourceforge.net,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
In-Reply-To: <20100910020129.GA26845@redhat.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
	 <4C8805FA.3060102@infradead.org> <20100908224227.GL22323@redhat.com>
	 <AANLkTikBVSYpD_+qomCad-OvXg6CRam4b01wSBV-pNw8@mail.gmail.com>
	 <20100910020129.GA26845@redhat.com>
Content-Type: multipart/mixed; boundary="=-8igC4frwwd0X3K58TXTP"
Date: Fri, 10 Sep 2010 11:35:23 +0300
Message-ID: <1284107723.3498.21.camel@maxim-laptop>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>


--=-8igC4frwwd0X3K58TXTP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2010-09-09 at 22:01 -0400, Jarod Wilson wrote: 
> On Thu, Sep 09, 2010 at 12:34:27AM -0400, Jarod Wilson wrote:
> ...
> > >> For now, I've applied patches 3, 4 and 5, as it is nice to have Jarod's review also.
> > >
> > > I've finally got them all applied atop current media_tree staging/v2.6.37,
> > > though none of the streamzap bits in patch 7 are applicable any longer.
> > > Will try to get through looking and commenting (and testing) of the rest
> > > of them tonight.
> > 
> > Also had to make a minor addition to the rc5-sz decoder (same change
> > as in the other decoders). Almost have all the requisite test kernels
> > for David's, Maxim's and Dmitry's patchsets built and installed, wish
> > my laptop was faster... Probably would have been faster to use a lab
> > box and copy data over. Oh well. So functional testing to hopefully
> > commence tomorrow morning.
> 
> Wuff. None of the three builds is at all stable on my laptop, but I can't
> actually point the finger at any of the three patchsets, since I'm getting
> spontaneous lockups doing nothing at all before even plugging in a
> receiver. I did however get occasional periods of a non-panicking (not
> starting X seems to help a lot). Initial results:
> 

Btw, my printk blackbox patch could help you a lot.
I can't count how many times it helped me.
I just enable softlockup, hardlockup, and nmi watchdog, and let system
panic on oopses, and reboot. Or if you have hardware reboot button, you
can just use it. The point is that most BIOSES don't clear the ram, and
I take advantage of that.

Recently in an attempt to make it reserve only small portion of memory
(before I would use mem=) I also made this work out of box.

After a reboot, to get crash dmesg, just do
sudo cat /sys/kernel/debug/printk/crash_dmesg | strings

Note that kernel contains now a ramoops module that does similar things.
It doesn't reserve the memory automatically, and (this is the reason I
still don't use it) is only called by kernel to save oopses/panicks.
It should be enough though too, but my patch actually places the printk
buffer itself in the fixed area in the ram.


Best regards,
Maxim Levitsky

--=-8igC4frwwd0X3K58TXTP
Content-Disposition: attachment; filename="printk_blackbox.diff"
Content-Type: text/x-patch; name="printk_blackbox.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

commit 8f1c423046c22dad6aaeca04bfcb0ab301843c36
Author: Maxim Levitsky <maximlevitsky@gmail.com>
Date:   Sat Jul 31 13:43:03 2010 +0300

    printk: Allow to fix the physical address of printk buffer
    
        Allows to put printk buffer at fixed location of ram (default 128M).
    
        If debugfs is enabled, log of last boot is copied into
        system ram, and can be accessed via debugfs, for example
        cat /sys/kernel/debug/printk/crash_dmesg
    
        Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index ef292c7..a6eaf40 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -46,6 +46,7 @@ extern unsigned long saved_video_mode;
 extern void reserve_standard_io_resources(void);
 extern void i386_reserve_resources(void);
 extern void setup_default_timer_irq(void);
+extern void early_reserve_printk_buffer(void);
 
 #ifdef CONFIG_X86_MRST
 extern void x86_mrst_early_setup(void);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c3a4fbb..6fbf2a0 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -843,6 +843,7 @@ void __init setup_arch(char **cmdline_p)
 
 	/* after early param, so could get panic from serial */
 	reserve_early_setup_data();
+	early_reserve_printk_buffer();
 
 	if (acpi_mps_check()) {
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 3ba6e06..8854a91 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -106,7 +106,6 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 
 		if (is_ram && pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
 			return NULL;
-		WARN_ON_ONCE(is_ram);
 	}
 
 	/*
diff --git a/kernel/printk.c b/kernel/printk.c
index 8fe465a..a6fff63 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -41,6 +41,7 @@
 #include <linux/notifier.h>
 
 #include <asm/uaccess.h>
+#include <linux/debugfs.h>
 
 /*
  * for_each_console() allows you to iterate on each console
@@ -167,6 +168,7 @@ void log_buf_kexec_setup(void)
 }
 #endif
 
+#ifndef CONFIG_HWMEM_PRINTK
 static int __init log_buf_len_setup(char *str)
 {
 	unsigned size = memparse(str, &str);
@@ -207,6 +209,93 @@ out:
 }
 
 __setup("log_buf_len=", log_buf_len_setup);
+#endif
+
+#ifdef CONFIG_HWMEM_PRINTK
+
+char *old_log_buf;
+struct debugfs_blob_wrapper crash_dmesg_wrapper;
+static unsigned int printk_phys_address = CONFIG_HWMEM_PRINTK_DEFAULT_ADDRESS;
+
+
+static int __init printk_address_setup(char *p)
+{
+	char *tmp;
+
+	if (!strncmp(p, "off", 3))
+		printk_phys_address = 0;
+	else
+		printk_phys_address = memparse(p, &tmp);
+	return 0;
+}
+early_param("printk_address", printk_address_setup);
+
+
+void early_reserve_printk_buffer(void)
+{
+	if (printk_phys_address)
+		reserve_early(printk_phys_address,
+			printk_phys_address + __LOG_BUF_LEN, "printk buffer");
+}
+
+static int printk_move_to_fixed_address(void)
+{
+
+	char *mem_address;
+	unsigned long flags;
+	struct dentry *dbgfs_dir;
+
+	if (!printk_phys_address)
+		return 0;
+
+	mem_address = ioremap(printk_phys_address,  __LOG_BUF_LEN);
+
+	if (!mem_address) {
+		printk(KERN_ALERT "Can't map hardware kernel log memory."
+			"printk buffer disabled\n");
+		return  0;
+	}
+
+	printk(KERN_INFO "Logging kernel messages into HW memory at 0x%08x\n",
+			printk_phys_address);
+
+	/* allocate saved log buffer, and save the log memory that we
+	  will otherwise overwrite */
+	old_log_buf = kmalloc(__LOG_BUF_LEN, GFP_KERNEL);
+	if (old_log_buf)
+		memcpy(old_log_buf, mem_address, __LOG_BUF_LEN);
+
+
+	/* copy current log to the new memory */
+	memcpy(mem_address, log_buf, __LOG_BUF_LEN);
+
+	/* save the log memory, and publish it */
+	if (old_log_buf) {
+
+		crash_dmesg_wrapper.data = old_log_buf;
+		crash_dmesg_wrapper.size = __LOG_BUF_LEN;
+
+		dbgfs_dir = debugfs_create_dir("printk", NULL);
+
+		if (dbgfs_dir > 0)
+			debugfs_create_blob("crash_dmesg", S_IRUSR, dbgfs_dir,
+				&crash_dmesg_wrapper);
+	}
+
+
+
+	/* switch to the full log memory now */
+	spin_lock_irqsave(&logbuf_lock, flags);
+	log_buf = mem_address;
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	return 1;
+}
+postcore_initcall(printk_move_to_fixed_address);
+
+#else
+void early_reserve_printk_buffer(void) {}
+#endif
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1b4afd2..1f12584 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -788,6 +788,35 @@ config BOOT_PRINTK_DELAY
 	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
 	  what it believes to be lockup conditions.
 
+config HWMEM_PRINTK
+	bool "Log printk message buffer into fixed physical address (DANGEROUS)"
+	depends on DEBUG_KERNEL && PRINTK
+	help
+	  This option allows to place kernel log buffer into pre-defined
+	  area, somewhere in memory space.
+
+	  This creates some sort of black box recorder and can be very useful
+	  to debug several problems, especially 'panics' that happen while you
+	  use the X window system.
+
+
+	  If you also select debugfs support, you can easily look at
+	  kernel log of failed boot at:
+	  /sys/kernel/debug/printk/crash_dmesg
+
+	  (Assuming you mounted debugfs on /sys/kernel/debug)
+
+	  Misuse of this option can be DANGEROUS, as it makes kernel write at
+	  arbitary (selected by you) hardware memory range.
+
+	  It is only intended for debbuging, so say 'no' if not sure
+
+config HWMEM_PRINTK_DEFAULT_ADDRESS
+	hex
+	depends on HWMEM_PRINTK
+	prompt "Default address at which store the printk buffer (default 60M)"
+	default "0x3C00000"
+
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL

--=-8igC4frwwd0X3K58TXTP--

