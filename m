Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52620
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759384AbcISLWi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 07:22:38 -0400
Date: Mon, 19 Sep 2016 08:22:26 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, gjasny@googlemail.com
Subject: Re: [v4l-utils PATCH 1/1] Fix static linking of v4l2-compliance and
 v4l2-ctl
Message-ID: <20160919082226.43cd1bc9@vento.lan>
In-Reply-To: <1474282225-31559-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474282225-31559-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 19 Sep 2016 13:50:25 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> v4l2-compliance and v4l2-ctl depend on librt and libpthread. The symbols
> are found by the linker only if these libraries are specified after the
> objects that depend on them.
> 
> As LDFLAGS variable end up expanded on libtool command line before LDADD,
> move the libraries to LDADD after local objects. -lpthread is added as on
> some systems librt depends on libpthread. This is the case on Ubuntu 16.04
> for instance.
> 
> After this patch, creating a static build using the command
> 
> LDFLAGS="--static -static" ./configure --disable-shared --enable-static

It sounds weird to use LDFLAGS="--static -static" here, as the
configure options are already asking for static.

IMHO, the right way would be to change configure.ac to add those LDFLAGS
when --disable-shared is used.

Regards,
Mauro

> 
> works again.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi,
> 
> This patch fixes the static build; the error is:
> 
>   CXXLD    v4l2-compliance
> ../../lib/libv4l2/.libs/libv4l2.a(libv4l2_la-v4l2-plugin.o): In function `v4l2_plugin_init':
> /home/sailus/a/v4l-utils/lib/libv4l2/v4l2-plugin.c:75: warning: Using 'dlopen' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /home/sailus/a/v4l-utils/lib/libv4lconvert/.libs/libv4lconvert.a(libv4lconvert_la-libv4lcontrol.o): In function `v4lcontrol_create':
> /home/sailus/a/v4l-utils/lib/libv4lconvert/control/libv4lcontrol.c:693: warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/librt.a(shm_open.o): In function `shm_open':
> (.text+0x1f): undefined reference to `__shm_directory'
> collect2: error: ld returned 1 exit status
> distcc[21660] ERROR: compile (null) on localhost failed
> Makefile:559: recipe for target 'v4l2-compliance' failed
> 
> Kind regards,
> Sakari
> 
>  utils/v4l2-compliance/Makefile.am | 4 ++--
>  utils/v4l2-ctl/Makefile.am        | 3 +--
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/utils/v4l2-compliance/Makefile.am b/utils/v4l2-compliance/Makefile.am
> index a895e8e..c2b5919 100644
> --- a/utils/v4l2-compliance/Makefile.am
> +++ b/utils/v4l2-compliance/Makefile.am
> @@ -5,12 +5,12 @@ DEFS :=
>  v4l2_compliance_SOURCES = v4l2-compliance.cpp v4l2-test-debug.cpp v4l2-test-input-output.cpp \
>  	v4l2-test-controls.cpp v4l2-test-io-config.cpp v4l2-test-formats.cpp v4l2-test-buffers.cpp \
>  	v4l2-test-codecs.cpp v4l2-test-colors.cpp v4l2-compliance.h
> -v4l2_compliance_LDFLAGS = -lrt
>  v4l2_compliance_CPPFLAGS = -I../common
>  
>  if WITH_V4L2_COMPLIANCE_LIBV4L
> -v4l2_compliance_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la
> +v4l2_compliance_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la -lrt -lpthread
>  else
> +v4l2_compliance_LDADD = -lrt -lpthread
>  DEFS += -DNO_LIBV4L2
>  endif
>  
> diff --git a/utils/v4l2-ctl/Makefile.am b/utils/v4l2-ctl/Makefile.am
> index 56943cd..2a05644 100644
> --- a/utils/v4l2-ctl/Makefile.am
> +++ b/utils/v4l2-ctl/Makefile.am
> @@ -7,11 +7,10 @@ v4l2_ctl_SOURCES = v4l2-ctl.cpp v4l2-ctl.h v4l2-ctl-common.cpp v4l2-ctl-tuner.cp
>  	v4l2-ctl-overlay.cpp v4l2-ctl-vbi.cpp v4l2-ctl-selection.cpp v4l2-ctl-misc.cpp \
>  	v4l2-ctl-streaming.cpp v4l2-ctl-sdr.cpp v4l2-ctl-edid.cpp v4l2-ctl-modes.cpp \
>  	v4l2-tpg-colors.c v4l2-tpg-core.c v4l-stream.c
> -v4l2_ctl_LDFLAGS = -lrt
>  v4l2_ctl_CPPFLAGS = -I../common
>  
>  if WITH_V4L2_CTL_LIBV4L
> -v4l2_ctl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la
> +v4l2_ctl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la -lrt -lpthread
>  else
>  DEFS += -DNO_LIBV4L2
>  endif



Thanks,
Mauro
