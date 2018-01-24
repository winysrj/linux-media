Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:38182 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752450AbeAXIny (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 03:43:54 -0500
MIME-Version: 1.0
In-Reply-To: <20180124081316.r75cr7yrcg3xhpw3@mwanda>
References: <20180122103714.GA25044@mwanda> <5b3b7195-930c-58c3-d52f-b2738c3fde1e@kernel.org>
 <20180124081316.r75cr7yrcg3xhpw3@mwanda>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 24 Jan 2018 09:43:52 +0100
Message-ID: <CAK8P3a2Jms5tEaYi7=z2cg=AA__ftEott7_kRPtSE9YztAB3yQ@mail.gmail.com>
Subject: Re: [PATCH] [media] s3c-camif: array underflow in __camif_subdev_try_format()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sylwester Nawrocki <snawrocki@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "moderated list:ARM/SAMSUNG EXYNOS ARM ARCHITECTURES"
        <linux-samsung-soc@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 24, 2018 at 9:13 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Mon, Jan 22, 2018 at 09:50:04PM +0100, Sylwester Nawrocki wrote:
>> On 01/22/2018 11:37 AM, Dan Carpenter wrote:

> I happened to be looking at the same bugs but using Smatch.  Did you get
> these two bugs as well?
>
> drivers/scsi/sym53c8xx_2/sym_hipd.c:549 sym_getsync() error: iterator underflow 'div_10M' (-1)-255
> drivers/media/i2c/sr030pc30.c:522 try_fmt() error: iterator underflow 'sr030pc30_formats' (-1)-4

I don't recall seeing those two, here is a list of array-bounds
warnings I had in the past
months, mostly while building with gcc-7.2:

/git/arm-soc/arch/arm/mach-vexpress/spc.c:431:38: warning: array
subscript is below array bounds [-Warray-bounds]
/git/arm-soc/arch/x86/include/asm/string_32.h:70:16: error: array
subscript is above array bounds [-Werror=array-bounds]
/git/arm-soc/arch/x86/include/asm/uaccess_64.h:143:20: error: array
subscript is above array bounds [-Werror=array-bounds]
/git/arm-soc/drivers/cpufreq/arm_big_little.c:201:24: warning: array
subscript is above array bounds [-Warray-bounds]
/git/arm-soc/drivers/cpufreq/arm_big_little.c:325:16: warning: array
subscript is above array bounds [-Warray-bounds]
/git/arm-soc/drivers/cpufreq/arm_big_little.c:440:39: warning: array
subscript is above array bounds [-Warray-bounds]
/git/arm-soc/drivers/dma/sh/rcar-dmac.c:876:29: error: array subscript
is above array bounds [-Werror=array-bounds]
/git/arm-soc/drivers/isdn/hardware/eicon/message.c:11302:54: error:
array subscript is above array bounds [-Werror=array-bounds]
/git/arm-soc/drivers/net/ethernet/intel/igb/igb_ptp.c:367: error:
array subscript is below array bounds
/git/arm-soc/drivers/net/ethernet/intel/igb/igb_ptp.c:455: error:
array subscript is below array bounds
/git/arm-soc/drivers/scsi/qla2xxx/qla_gs.c:1398:7: error: array
subscript is above array bounds [-Werror=array-bounds]
/git/arm-soc/drivers/scsi/qla2xxx/qla_gs.c:2279:7: error: array
subscript is above array bounds [-Werror=array-bounds]
/git/arm-soc/drivers/scsi/sym53c416.c:565:58: error: array subscript
is above array bounds [-Werror=array-bounds]
/git/arm-soc/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c:492:14:
error: array subscript -1 is below array bounds of 'struct
ptlrpcd_ctl[]' [-Werror=array-bounds]
/git/arm-soc/fs/f2fs/segment.c:3044:5: error: array subscript is below
array bounds [-Werror=array-bounds]
/git/arm-soc/include/linux/compiler.h:253:20: error: array subscript
is above array bounds [-Werror=array-bounds]
/git/arm-soc/include/linux/dynamic_debug.h:86:20: warning: array
subscript is above array bounds [-Warray-bounds]
/git/arm-soc/include/sound/pcm.h:919:9: error: array subscript is
above array bounds [-Werror=array-bounds]
/git/arm-soc/kernel/bpf/verifier.c:4320:29: error: array subscript is
above array bounds [-Werror=array-bounds]
/git/arm-soc/kernel/rcu/tree.c:3332:13: warning: array subscript is
above array bounds [-Warray-bounds]
/git/arm-soc/net/ipv4/tcp_output.c:2129:40: error: array subscript is
below array bounds [-Werror=array-bounds]
/git/arm-soc/net/ipv4/tcp_output.c:2207:40: error: array subscript is
below array bounds [-Werror=array-bounds]
/git/arm-soc/net/rxrpc/ar-connection.c:589:16: warning: array
subscript is above array bounds [-Warray-bounds]
/git/arm-soc/sound/soc/sh/rcar/cmd.c:88:14: error: array subscript is
below array bounds [-Werror=array-bounds]
/git/arm-soc/sound/soc/sh/rcar/cmd.c:88: error: array subscript is
below array bounds

I've also opened two gcc bugs for warnings that appeared to be issued in error:

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83312
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81601

I haven't built with gcc-8 in a while, should try that again now that
PR83312 has been
marked 'fixed'.

       Arnd
