Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:28892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab0JODkB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 23:40:01 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9F3e0eU029909
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Oct 2010 23:40:01 -0400
Message-ID: <4CB7CD0D.60605@redhat.com>
Date: Fri, 15 Oct 2010 00:39:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL REQUEST] IR patches for 2.6.37-rc1
References: <20101008214407.GI5165@redhat.com> <AANLkTimezuonksK=wW1PAkW40oo-KPRMrVdoNxymK69f@mail.gmail.com> <20101012135028.GF4057@redhat.com>
In-Reply-To: <20101012135028.GF4057@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-10-2010 10:50, Jarod Wilson escreveu:
> On Sat, Oct 09, 2010 at 02:23:15PM -0400, Jarod Wilson wrote:
>> On Fri, Oct 8, 2010 at 5:44 PM, Jarod Wilson <jarod@redhat.com> wrote:
>>> Hey Mauro,
>>>
>>> I've queued up some lirc fixes and a couple of patches that add a new
>>> ir-core driver for the Nuvoton w836x7hg Super I/O integrated CIR
>>> functionality. All but the Kconfig re-sorting patch have been posted to
>>> linux-media for review, but I'm hoping they can all get merged in time for
>>> the 2.6.37-rc1 window, and any additional review feedback can be taken
>>> care of with follow-up patches.
>>>
>>> The following changes since commit b9a1211dff08aa73fc26db66980ec0710a6c7134:
>>>
>>>  V4L/DVB: Staging: cx25821: fix braces and space coding style issues (2010-10-07 15:37:27 -0300)
>>
>> Minor update to the pull req to fully wire up compat ioctls and fixup
>> some error messages in lirc_dev:
>>
>> The following changes since commit 81d64d12e11a3cca995e6c752e4bd2898959ed0a:
>>
>>   V4L/DVB: cx231xx: remove some unused functions (2010-10-07 21:05:52 -0300)
>>
>> are available in the git repository at:
>>   git://git.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-lirc.git staging
> 
> Just tacked on two minor streamzap patches, including the one from Dan
> Carpenter that fixes an overflow with timeout values. The other streamzap
> patch just makes Dan's patch not create a line > 80 chars, more or less
> (renames STREAMZAP_FOO defines to SZ_FOO).
> 
> Dan Carpenter (1):
>       [patch -next] V4L/DVB: IR/streamzap: fix usec to nsec conversion
> 
> Jarod Wilson (8):
>       IR: add driver for Nuvoton w836x7hg integrated CIR

There's a number of checkpatch issues on this patch. Please send me later a patch 
addressing them. The 80-cols warnings seem bogus to me.
You should notice that a few printk's have the \n missing. Not sure if you forgot, or
if you should be using KERN_CONT for some printk's.

WARNING: printk() should include KERN_ facility level
#229: FILE: drivers/media/IR/nuvoton-cir.c:135:
+	printk("%s: Dump CIR logical device registers:\n", NVT_DRIVER_NAME);

WARNING: printk() should include KERN_ facility level
#230: FILE: drivers/media/IR/nuvoton-cir.c:136:
+	printk(" * CR CIR ACTIVE :   0x%x\n",

WARNING: printk() should include KERN_ facility level
#232: FILE: drivers/media/IR/nuvoton-cir.c:138:
+	printk(" * CR CIR BASE ADDR: 0x%x\n",

WARNING: printk() should include KERN_ facility level
#235: FILE: drivers/media/IR/nuvoton-cir.c:141:
+	printk(" * CR CIR IRQ NUM:   0x%x\n",

WARNING: printk() should include KERN_ facility level
#240: FILE: drivers/media/IR/nuvoton-cir.c:146:
+	printk("%s: Dump CIR registers:\n", NVT_DRIVER_NAME);

WARNING: printk() should include KERN_ facility level
#241: FILE: drivers/media/IR/nuvoton-cir.c:147:
+	printk(" * IRCON:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRCON));

WARNING: printk() should include KERN_ facility level
#242: FILE: drivers/media/IR/nuvoton-cir.c:148:
+	printk(" * IRSTS:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRSTS));

WARNING: printk() should include KERN_ facility level
#243: FILE: drivers/media/IR/nuvoton-cir.c:149:
+	printk(" * IREN:      0x%x\n", nvt_cir_reg_read(nvt, CIR_IREN));

WARNING: printk() should include KERN_ facility level
#244: FILE: drivers/media/IR/nuvoton-cir.c:150:
+	printk(" * RXFCONT:   0x%x\n", nvt_cir_reg_read(nvt, CIR_RXFCONT));

WARNING: printk() should include KERN_ facility level
#245: FILE: drivers/media/IR/nuvoton-cir.c:151:
+	printk(" * CP:        0x%x\n", nvt_cir_reg_read(nvt, CIR_CP));

WARNING: printk() should include KERN_ facility level
#246: FILE: drivers/media/IR/nuvoton-cir.c:152:
+	printk(" * CC:        0x%x\n", nvt_cir_reg_read(nvt, CIR_CC));

WARNING: printk() should include KERN_ facility level
#247: FILE: drivers/media/IR/nuvoton-cir.c:153:
+	printk(" * SLCH:      0x%x\n", nvt_cir_reg_read(nvt, CIR_SLCH));

WARNING: printk() should include KERN_ facility level
#248: FILE: drivers/media/IR/nuvoton-cir.c:154:
+	printk(" * SLCL:      0x%x\n", nvt_cir_reg_read(nvt, CIR_SLCL));

WARNING: printk() should include KERN_ facility level
#249: FILE: drivers/media/IR/nuvoton-cir.c:155:
+	printk(" * FIFOCON:   0x%x\n", nvt_cir_reg_read(nvt, CIR_FIFOCON));

WARNING: printk() should include KERN_ facility level
#250: FILE: drivers/media/IR/nuvoton-cir.c:156:
+	printk(" * IRFIFOSTS: 0x%x\n", nvt_cir_reg_read(nvt, CIR_IRFIFOSTS));

WARNING: printk() should include KERN_ facility level
#251: FILE: drivers/media/IR/nuvoton-cir.c:157:
+	printk(" * SRXFIFO:   0x%x\n", nvt_cir_reg_read(nvt, CIR_SRXFIFO));

WARNING: printk() should include KERN_ facility level
#252: FILE: drivers/media/IR/nuvoton-cir.c:158:
+	printk(" * TXFCONT:   0x%x\n", nvt_cir_reg_read(nvt, CIR_TXFCONT));

WARNING: printk() should include KERN_ facility level
#253: FILE: drivers/media/IR/nuvoton-cir.c:159:
+	printk(" * STXFIFO:   0x%x\n", nvt_cir_reg_read(nvt, CIR_STXFIFO));

WARNING: printk() should include KERN_ facility level
#254: FILE: drivers/media/IR/nuvoton-cir.c:160:
+	printk(" * FCCH:      0x%x\n", nvt_cir_reg_read(nvt, CIR_FCCH));

WARNING: printk() should include KERN_ facility level
#255: FILE: drivers/media/IR/nuvoton-cir.c:161:
+	printk(" * FCCL:      0x%x\n", nvt_cir_reg_read(nvt, CIR_FCCL));

WARNING: printk() should include KERN_ facility level
#256: FILE: drivers/media/IR/nuvoton-cir.c:162:
+	printk(" * IRFSM:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRFSM));

WARNING: printk() should include KERN_ facility level
#267: FILE: drivers/media/IR/nuvoton-cir.c:173:
+	printk("%s: Dump CIR WAKE logical device registers:\n",

WARNING: printk() should include KERN_ facility level
#269: FILE: drivers/media/IR/nuvoton-cir.c:175:
+	printk(" * CR CIR WAKE ACTIVE :   0x%x\n",

WARNING: printk() should include KERN_ facility level
#271: FILE: drivers/media/IR/nuvoton-cir.c:177:
+	printk(" * CR CIR WAKE BASE ADDR: 0x%x\n",

ERROR: code indent should use tabs where possible
#273: FILE: drivers/media/IR/nuvoton-cir.c:179:
+^I        nvt_cr_read(nvt, CR_CIR_BASE_ADDR_LO));$

WARNING: printk() should include KERN_ facility level
#274: FILE: drivers/media/IR/nuvoton-cir.c:180:
+	printk(" * CR CIR WAKE IRQ NUM:   0x%x\n",

WARNING: printk() should include KERN_ facility level
#279: FILE: drivers/media/IR/nuvoton-cir.c:185:
+	printk("%s: Dump CIR WAKE registers\n", NVT_DRIVER_NAME);

WARNING: printk() should include KERN_ facility level
#280: FILE: drivers/media/IR/nuvoton-cir.c:186:
+	printk(" * IRCON:          0x%x\n",

WARNING: printk() should include KERN_ facility level
#282: FILE: drivers/media/IR/nuvoton-cir.c:188:
+	printk(" * IRSTS:          0x%x\n",

WARNING: printk() should include KERN_ facility level
#284: FILE: drivers/media/IR/nuvoton-cir.c:190:
+	printk(" * IREN:           0x%x\n",

WARNING: printk() should include KERN_ facility level
#286: FILE: drivers/media/IR/nuvoton-cir.c:192:
+	printk(" * FIFO CMP DEEP:  0x%x\n",

WARNING: printk() should include KERN_ facility level
#288: FILE: drivers/media/IR/nuvoton-cir.c:194:
+	printk(" * FIFO CMP TOL:   0x%x\n",

WARNING: printk() should include KERN_ facility level
#290: FILE: drivers/media/IR/nuvoton-cir.c:196:
+	printk(" * FIFO COUNT:     0x%x\n",

WARNING: printk() should include KERN_ facility level
#292: FILE: drivers/media/IR/nuvoton-cir.c:198:
+	printk(" * SLCH:           0x%x\n",

WARNING: printk() should include KERN_ facility level
#294: FILE: drivers/media/IR/nuvoton-cir.c:200:
+	printk(" * SLCL:           0x%x\n",

WARNING: printk() should include KERN_ facility level
#296: FILE: drivers/media/IR/nuvoton-cir.c:202:
+	printk(" * FIFOCON:        0x%x\n",

WARNING: printk() should include KERN_ facility level
#298: FILE: drivers/media/IR/nuvoton-cir.c:204:
+	printk(" * SRXFSTS:        0x%x\n",

WARNING: printk() should include KERN_ facility level
#300: FILE: drivers/media/IR/nuvoton-cir.c:206:
+	printk(" * SAMPLE RX FIFO: 0x%x\n",

WARNING: printk() should include KERN_ facility level
#302: FILE: drivers/media/IR/nuvoton-cir.c:208:
+	printk(" * WR FIFO DATA:   0x%x\n",

WARNING: printk() should include KERN_ facility level
#304: FILE: drivers/media/IR/nuvoton-cir.c:210:
+	printk(" * RD FIFO ONLY:   0x%x\n",

WARNING: printk() should include KERN_ facility level
#306: FILE: drivers/media/IR/nuvoton-cir.c:212:
+	printk(" * RD FIFO ONLY IDX: 0x%x\n",

WARNING: printk() should include KERN_ facility level
#308: FILE: drivers/media/IR/nuvoton-cir.c:214:
+	printk(" * FIFO IGNORE:    0x%x\n",

WARNING: printk() should include KERN_ facility level
#310: FILE: drivers/media/IR/nuvoton-cir.c:216:
+	printk(" * IRFSM:          0x%x\n",

WARNING: printk() should include KERN_ facility level
#314: FILE: drivers/media/IR/nuvoton-cir.c:220:
+	printk("%s: Dump CIR WAKE FIFO (len %d)\n", NVT_DRIVER_NAME, fifo_len);

WARNING: printk() should include KERN_ facility level
#315: FILE: drivers/media/IR/nuvoton-cir.c:221:
+	printk("* Contents = ");

WARNING: line over 80 characters
#450: FILE: drivers/media/IR/nuvoton-cir.c:356:
+	nvt_cir_reg_write(nvt, CIR_IRCON_TXEN | CIR_IRCON_RXEN | CIR_IRCON_RXINV |

WARNING: line over 80 characters
#460: FILE: drivers/media/IR/nuvoton-cir.c:366:
+	/* and finally, enable RX Trigger Level Read and Packet End interrupts */

WARNING: line over 80 characters
#513: FILE: drivers/media/IR/nuvoton-cir.c:419:
+			       CIR_WAKE_IRCON_SAMPLE_PERIOD_SEL, CIR_WAKE_IRCON);

WARNING: printk() should include KERN_ facility level
#648: FILE: drivers/media/IR/nuvoton-cir.c:554:
+	printk("%s (len %d): ", __func__, nvt->pkts);

WARNING: Use #include <linux/ioctl.h> instead of <asm/ioctl.h>
#1345: FILE: drivers/media/IR/nuvoton-cir.h:29:
+#include <asm/ioctl.h>

total: 1 errors, 49 warnings, 1649 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.



>       nuvoton-cir: add proper rx fifo overrun handling
>       IR/Kconfig: sort hardware entries alphabetically
>       IR/lirc: further ioctl portability fixups
>       staging/lirc: ioctl portability fixups
>       lirc: wire up .compat_ioctl to main ioctl handler
>       lirc_dev: fixup error messages w/missing newlines
>       IR/streamzap: shorten up some define names for readability
> 
> 

