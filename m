Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:22173 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbbLRLBg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 06:01:36 -0500
Subject: Re: Automatic device driver back-porting with media_build
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <5672A6F0.6070003@free.fr> <20151217105543.13599560@recife.lan>
 <5672BE15.9070006@free.fr> <20151217120830.0fc27f01@recife.lan>
 <5672C713.6090101@free.fr> <20151217125505.0abc4b40@recife.lan>
 <5672D5A6.8090505@free.fr> <20151217140943.7048811b@recife.lan>
 <5672E779.9080505@free.fr> <20151218083711.69d59233@recife.lan>
From: Mason <slash.tmp@free.fr>
Message-ID: <5673E788.5060002@free.fr>
Date: Fri, 18 Dec 2015 12:01:28 +0100
MIME-Version: 1.0
In-Reply-To: <20151218083711.69d59233@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/12/2015 11:37, Mauro Carvalho Chehab wrote:
> Em Thu, 17 Dec 2015 17:48:57 +0100
> Mason <slash.tmp@free.fr> escreveu:
> 
>> On 17/12/2015 17:09, Mauro Carvalho Chehab wrote:
>>> Em Thu, 17 Dec 2015 16:32:54 +0100
>>> Mason <slash.tmp@free.fr> escreveu:
>>>
>>>> I wanted to fix the NEED_WRITEL_RELAXED warning, but I don't know Perl.
>>>>
>>>> v4l/scripts/make_config_compat.pl
>>>>
>>>> check_files_for_func("writel_relaxed", "NEED_WRITEL_RELAXED", "include/asm-generic/io.h");
>>>> incorrectly outputs
>>>> #define NEED_WRITEL_RELAXED 1
>>>>
>>>>
>>>> In file included from <command-line>:0:0:
>>>> /tmp/sandbox/media_build/v4l/compat.h:1568:0: warning: "writel_relaxed" redefined
>>>>  #define writel_relaxed writel
>>>>  ^
>>>> In file included from include/linux/scatterlist.h:10:0,
>>>>                  from /tmp/sandbox/media_build/v4l/compat.h:1255,
>>>>                  from <command-line>:0:
>>>> /tmp/sandbox/custom-linux-3.4/arch/arm/include/asm/io.h:235:0: note: this is the location of the previous definition
>>>>  #define writel_relaxed(v,c) ((void)__raw_writel((__force u32) \
>>>>  ^
>>>>
>>>> Shouldn't the script examine arch/$ARCH/include/asm/io.h instead of
>>>> include/asm-generic/io.h ? (Or perhaps both?)
>>>>
>>>> Does make_config_compat.pl know about ARCH?
>>>
>>> No to both. When you do a "make init" on the Kernel repository, it
>>> will evaluate the ARCH vars.
>>>
>>> This is also needed for the media build to work, as it needs to
>>> check what CONFIG vars are enabled on the targeted Kernel.
>>
>> I downloaded the vanilla version of my custom kernel: linux-3.4.39.tar.xz
>>
>> Even then, NEED_WRITEL_RELAXED is incorrectly defined.
> 
> did you run a:
> 	make allmodconfig
> 	make init
> 
> for the vanilla version? Without that, the symlinks won't appear.

/tmp/sandbox/linux-3.4.39$ make allmodconfig
scripts/kconfig/conf --allmodconfig Kconfig
#
# configuration written to .config
#
/tmp/sandbox/linux-3.4.39$ make menuconfig
scripts/kconfig/mconf Kconfig
.config:25:warning: symbol value '' invalid for PHYS_OFFSET
#
# configuration written to .config
#


*** End of the configuration.
*** Execute 'make' to start the build or try 'make help'.

/tmp/sandbox/linux-3.4.39$ make init
scripts/kconfig/conf --silentoldconfig Kconfig
CHK include/linux/version.h
CHK include/generated/utsrelease.h
make[1]: `include/generated/mach-types.h' is up to date.
CC kernel/bounds.s
GEN include/generated/bounds.h
CC arch/arm/kernel/asm-offsets.s
GEN include/generated/asm-offsets.h
CALL scripts/checksyscalls.sh
CC scripts/mod/empty.o
MKELF scripts/mod/elfconfig.h
HOSTCC scripts/mod/file2alias.o
HOSTCC scripts/mod/modpost.o
HOSTCC scripts/mod/sumversion.o
HOSTLD scripts/mod/modpost
HOSTCC scripts/selinux/genheaders/genheaders
HOSTCC scripts/selinux/mdp/mdp
CC init/main.o
CHK include/generated/compile.h
UPD include/generated/compile.h
CC init/version.o
CC init/do_mounts.o
CC init/do_mounts_initrd.o
LD init/mounts.o
CC init/initramfs.o
CC init/calibrate.o
LD init/built-in.o

cd ../media_build/linux
make tar DIR=/tmp/sandbox/media_tree
make untar
cd ..
make release DIR=/tmp/sandbox/linux-3.4.39
make

make -C ../linux apply_patches
make[2]: Entering directory `/tmp/sandbox/media_build/linux'
Patches for 3.4.39. already applied.
make[2]: Leaving directory `/tmp/sandbox/media_build/linux'
make -C /tmp/sandbox/linux-3.4.39 SUBDIRS=/tmp/sandbox/media_build/v4l  modules
make[2]: Entering directory `/tmp/sandbox/linux-3.4.39'
  CC [M]  /tmp/sandbox/media_build/v4l/altera-lpt.o
In file included from <command-line>:0:0:
/tmp/sandbox/media_build/v4l/compat.h:1568:0: warning: "writel_relaxed" redefined
 #define writel_relaxed writel
 ^
In file included from include/linux/scatterlist.h:10:0,
                 from /tmp/sandbox/media_build/v4l/compat.h:1255,
                 from <command-line>:0:
/tmp/sandbox/linux-3.4.39/arch/arm/include/asm/io.h:235:0: note: this is the location of the previous definition
 #define writel_relaxed(v,c) ((void)__raw_writel((__force u32) \
 ^

$ grep -rn NEED_WRITEL_RELAXED
v4l/compat.h:1567:#ifdef NEED_WRITEL_RELAXED
v4l/scripts/make_config_compat.pl:667:	check_files_for_func("writel_relaxed", "NEED_WRITEL_RELAXED", "include/asm-generic/io.h");
v4l/config-compat.h:1888:#define NEED_WRITEL_RELAXED 1



