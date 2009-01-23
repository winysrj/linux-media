Return-path: <linux-media-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:36812 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbZAWI4j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 03:56:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: How can I fix errors and warnings in nvidia module for Tesla C1060
Date: Fri, 23 Jan 2009 09:55:53 +0100
Cc: fero@drama.obuda.kando.hu, linux-nvidia@lists.surfsouth.com,
	adaplas@gmail.com, npaci-rocks-discussion@sdsc.edu,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <3f9a31f40901222126t5baf80f8t12513dc9fd9b3f29@mail.gmail.com>
In-Reply-To: <3f9a31f40901222126t5baf80f8t12513dc9fd9b3f29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901230955.53828.rjw@sisk.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 23 January 2009, Jaswinder Singh Rajput wrote:
> Hello,
> 
> I am trying to install driver of nvidia Tesla C1060 on x86 based
> compute node of Rockcluster 5.1
> 
> But  I am following errors and warnings:
> 
>    make -f /usr/src/kernels/2.6.18-92.1.13.el5-i686/scripts/Makefile.build obj=
>    /tmp/selfgz3379/NVIDIA-Linux-x86-177.72-pkg1/usr/src/nv
>      cc -Wp,-MD,/tmp/selfgz3379/NVIDIA-Linux-x86-177.72-pkg1/usr/src/nv/.nv.o.d
>     -nostdinc -isystem /usr/lib/gcc/i386-redhat-linux/4.1.2/include -D__KERNEL_
>    _ -Iinclude -Iinclude2 -I/usr/src/kernels/2.6.18-92.1.13.el5-i686/include -i
>    nclude include/linux/autoconf.h   -I/tmp/selfgz3379/NVIDIA-Linux-x86-177.72-
>    pkg1/usr/src/nv -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict
>    -aliasing -fno-common -Wstrict-prototypes -Wundef -Werror-implicit-function-
>    declaration -Os -pipe -msoft-float -fno-builtin-sprintf -fno-builtin-log2 -f
>    no-builtin-puts -mpreferred-stack-boundary=2 -march=i686 -mtune=generic -mtu
>    ne=generic -mregparm=3 -ffreestanding -I/usr/src/kernels/2.6.18-92.1.13.el5-
>    i686/include/asm-i386/mach-generic -Iinclude/asm-i386/mach-generic -I/usr/sr
>    c/kernels/2.6.18-92.1.13.el5-i686/include/asm-i386/mach-default -Iinclude/as
>    m-i386/mach-default -fomit-frame-pointer -g -fno-stack-protector -Wdeclarati
>    on-after-statement -Wno-pointer-sign  -I/tmp/self
>    gz3379/NVIDIA-Linux-x86-177.72-pkg1/usr/src/nv -Wall -Wimplicit -Wreturn-typ
>    e -Wswitch -Wformat -Wchar-subscripts -Wparentheses -Wpointer-arith -Wno-mul
>    tichar -Werror -MD -Wsign-compare -Wno-cast-qual -Wno-error -D__KERNEL__ -DM
>    ODULE -DNVRM -DNV_VERSION_STRING=\"177.72\" -UDEBUG -U_DEBUG -DNDEBUG -DMODU
>    LE -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(nv)"  -D"KBUILD_MODNAM
>    E=KBUILD_STR(nvidia)" -c -o /tmp/selfgz3379/NVIDIA-Linux-x86-177.72-pkg1/usr
>    /src/nv/.tmp_nv.o /tmp/selfgz3379/NVIDIA-Linux-x86-177.72-pkg1/usr/src/nv/nv
>    .c
>    In file included from include/linux/list.h:8,
>                     from include/linux/lockdep.h:13,
>                     from include/linux/spinlock_types.h:18,
>                     from include/linux/spinlock.h:78,
>                     from include/linux/capability.h:45,
>                     from include/linux/sched.h:44,
>                     from include/linux/module.h:9,
>                     from /tmp/selfgz3379/NVIDIA-Linux-x86-177.72-pkg1/usr/src/n
>    v/nv-linux.h:59,
>                     from /tmp/selfgz3379/NVIDIA-Linux-x86-177.72-pkg1/usr/src/n
>    v/nv.c:14:
>    include/linux/prefetch.h: In function 'prefetch_range':
>    include/linux/prefetch.h:62: warning: pointer of type 'void *' used in arith
>    metic
>    In file included from include/linux/dmapool.h:14,
>                     from include/linux/pci.h:616,
>                     from /tmp/selfgz3379/NVIDIA-Linux-x86-177.72-pkg1/usr/src/n
>    v/nv-linux.h:86,
>                     from /tmp/selfgz3379/NVIDIA-Linux-x86-177.72-pkg1/usr/src/n
>    v/nv.c:14:
>    include/asm/io.h: In function 'check_signature':
>    include/asm/io.h:245: warning: wrong type argument to increment
> 
> ...
> 
> -> Kernel module compilation complete.
> ERROR: Unable to load the kernel module 'nvidia.ko'.  This happens most
>        frequently when this kernel module was built against the wrong or
>        improperly configured kernel sources, with a version of gcc that differs
>        from the one used to build the target kernel, or if a driver such as
>        rivafb/nvidiafb is present and prevents the NVIDIA kernel module from
>        obtaining ownership of the NVIDIA graphics device(s).
> 
>        Please see the log entries 'Kernel module load error' and 'Kernel
>        messages' at the end of the file '/var/log/nvidia-installer.log' for
>        more information.
> -> Kernel module load error: insmod: error inserting './usr/src/nv/nvidia.ko':
>    -1 No such device
> 
> I am attaching complete log file for your reference.
> 
> I cannot see any source code for these modules. How can I fix these
> error and warnings.

That's likely because the NVidia driver expects the arch asm headers to be in
include/linux .

Thanks,
Rafael
