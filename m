Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:38974 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934691AbbLQPdA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 10:33:00 -0500
Subject: Re: Automatic device driver back-porting with media_build
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <5672A6F0.6070003@free.fr> <20151217105543.13599560@recife.lan>
 <5672BE15.9070006@free.fr> <20151217120830.0fc27f01@recife.lan>
 <5672C713.6090101@free.fr> <20151217125505.0abc4b40@recife.lan>
From: Mason <slash.tmp@free.fr>
Message-ID: <5672D5A6.8090505@free.fr>
Date: Thu, 17 Dec 2015 16:32:54 +0100
MIME-Version: 1.0
In-Reply-To: <20151217125505.0abc4b40@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/12/2015 15:55, Mauro Carvalho Chehab wrote:

> Em Thu, 17 Dec 2015 15:30:43 +0100
> Mason <slash.tmp@free.fr> escreveu:
> 
>> On 17/12/2015 15:08, Mauro Carvalho Chehab wrote:
>>
>>> Then I guess you're not using vanilla 3.4 Kernel, but some heavily
>>> modified version. You're on your own here.
>>
>> #ifdef NEED_KVFREE
>> #include <linux/mm.h>
>> static inline void kvfree(const void *addr)
>> {
>> 	if (is_vmalloc_addr(addr))
>> 		vfree(addr);
>> 	else
>> 		kfree(addr);
>> }
>> #endif
>>
>> /tmp/sandbox/media_build/v4l/compat.h: In function 'kvfree':
>> /tmp/sandbox/media_build/v4l/compat.h:1631:3: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
>>    vfree(addr);
>>    ^
>>
>> vfree is declared in linux/vmalloc.h
>>
>> The fix is trivial:
>>
>> diff --git a/v4l/compat.h b/v4l/compat.h
>> index c225c07d6caa..7f3f1d5f9d11 100644
>> --- a/v4l/compat.h
>> +++ b/v4l/compat.h
>> @@ -1625,6 +1625,7 @@ static inline void eth_zero_addr(u8 *addr)
>>  
>>  #ifdef NEED_KVFREE
>>  #include <linux/mm.h>
>> +#include <linux/vmalloc.h>
>>  static inline void kvfree(const void *addr)
>>  {
>>         if (is_vmalloc_addr(addr))
>>
>>
> 
> Well, it doesn't hurt to add it to the media_build tree, since
> vmalloc.h exists at least since 2.6.11.
> 
> Added upstream.
> 
> Did the driver compile fine?

I wanted to fix the NEED_WRITEL_RELAXED warning, but I don't know Perl.

v4l/scripts/make_config_compat.pl

check_files_for_func("writel_relaxed", "NEED_WRITEL_RELAXED", "include/asm-generic/io.h");
incorrectly outputs
#define NEED_WRITEL_RELAXED 1


In file included from <command-line>:0:0:
/tmp/sandbox/media_build/v4l/compat.h:1568:0: warning: "writel_relaxed" redefined
 #define writel_relaxed writel
 ^
In file included from include/linux/scatterlist.h:10:0,
                 from /tmp/sandbox/media_build/v4l/compat.h:1255,
                 from <command-line>:0:
/tmp/sandbox/custom-linux-3.4/arch/arm/include/asm/io.h:235:0: note: this is the location of the previous definition
 #define writel_relaxed(v,c) ((void)__raw_writel((__force u32) \
 ^

Shouldn't the script examine arch/$ARCH/include/asm/io.h instead of
include/asm-generic/io.h ? (Or perhaps both?)

Does make_config_compat.pl know about ARCH?

The following patch makes "#define NEED_WRITEL_RELAXED 1" go away,
but I'm looking for a general solution.


The next error is:

  CC [M]  /tmp/sandbox/media_build/v4l/dvb_net.o
/tmp/sandbox/media_build/v4l/dvb_net.c: In function 'dvb_net_add_if':
/tmp/sandbox/media_build/v4l/dvb_net.c:1244:38: error: macro "alloc_netdev" passed 4 arguments, but takes just 3
       NET_NAME_UNKNOWN, dvb_net_setup);
                                      ^
/tmp/sandbox/media_build/v4l/dvb_net.c:1243:8: error: 'alloc_netdev' undeclared (first use in this function)
  net = alloc_netdev(sizeof(struct dvb_net_priv), "dvb",
        ^
/tmp/sandbox/media_build/v4l/dvb_net.c:1243:8: note: each undeclared identifier is reported only once for each function it appears in
/tmp/sandbox/media_build/v4l/dvb_net.c: At top level:
/tmp/sandbox/media_build/v4l/dvb_net.c:1205:13: warning: 'dvb_net_setup' defined but not used [-Wunused-function]
 static void dvb_net_setup(struct net_device *dev)

Will look into it.


Regards.

diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index 641f55e9c137..30a004525c08 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -664,7 +664,7 @@ sub check_other_dependencies()
        check_files_for_func("DMA_ATTR_SKIP_CPU_SYNC", "NEED_DMA_ATTR_SKIP_CPU_SYNC", "include/linux/dma-attrs.h");
        check_files_for_func("sign_extend32", "NEED_SIGN_EXTEND32", "include/linux/bitops.h");
        check_files_for_func("netdev_dbg", "NEED_NETDEV_DBG", "include/linux/netdevice.h");
-       check_files_for_func("writel_relaxed", "NEED_WRITEL_RELAXED", "include/asm-generic/io.h");
+       check_files_for_func("writel_relaxed", "NEED_WRITEL_RELAXED", "arch/arm/include/asm/io.h");
        check_files_for_func("get_user_pages_unlocked", "NEED_GET_USER_PAGES_UNLOCKED", "include/linux/mm.h");
        check_files_for_func("pr_warn_once", "NEED_PR_WARN_ONCE", "include/linux/printk.h");
        check_files_for_func("DIV_ROUND_CLOSEST_ULL", "NEED_DIV_ROUND_CLOSEST_ULL", "include/linux/kernel.h");


