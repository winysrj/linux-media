Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpd3.aruba.it ([62.149.128.208]:57849 "HELO smtp6.aruba.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753411AbZJAR3m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Oct 2009 13:29:42 -0400
Subject: Osprey 230
From: Mauro Cominale <m.cominale@cnsat.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4015536FCAE@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE4015536FCAE@dlee06.ent.ti.com>
Content-Type: text/plain
Date: Thu, 01 Oct 2009 19:29:40 +0200
Message-Id: <1254418180.4397.14.camel@mauro-XPS>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm testing an Osprey 230 but I have problems with Audio acquisition. 

with the standard  bttv driver the audio is flickering and seems at
wrong sample rate (the voice of mickey mouse...) , after the compile v4l
the sound is totally mute.

I tried to compile the source from
http://linuxtv.org/hg/~mchehab/osprey

and from  http://linuxtv.org/hg/~tap/osprey

but I have some problems:

from ~tap repo I have this errors:

lidia@lidia-test:~/osprey$ make
make -C /home/lidia/osprey/v4l 
make[1]: Entering directory `/home/lidia/osprey/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.27-7-generic/build
make -C /lib/modules/2.6.27-7-generic/build
SUBDIRS=/home/lidia/osprey/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.27-7-generic'
  CC [M]  /home/lidia/osprey/v4l/bttv-driver.o
In file included from /home/lidia/osprey/v4l/bttv-driver.c:40:
/home/lidia/osprey/v4l/bttvp.h:94:1: warning: "clamp" redefined
In file included from include/asm/system.h:10,
                 from include/asm/processor.h:17,
                 from include/linux/prefetch.h:14,
                 from include/linux/list.h:6,
                 from include/linux/module.h:9,
                 from /home/lidia/osprey/v4l/bttv-driver.c:32:
include/linux/kernel.h:376:1: warning: this is the location of the
previous definition
/home/lidia/osprey/v4l/bttv-driver.c: In function 'show_card':
/home/lidia/osprey/v4l/bttv-driver.c:177: error: incompatible type for
argument 1 of 'dev_get_drvdata'
/home/lidia/osprey/v4l/bttv-driver.c: In function 'bttv_switch_overlay':
/home/lidia/osprey/v4l/bttv-driver.c:1777: error: 'STATE_DONE'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c:1777: error: (Each undeclared
identifier is reported only once
/home/lidia/osprey/v4l/bttv-driver.c:1777: error: for each function it
appears in.)
/home/lidia/osprey/v4l/bttv-driver.c: In function 'bttv_prepare_buffer':
/home/lidia/osprey/v4l/bttv-driver.c:1888: error: 'STATE_NEEDS_INIT'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c:1898: error: 'STATE_PREPARED'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c: In function 'buffer_queue':
/home/lidia/osprey/v4l/bttv-driver.c:1937: error: 'STATE_QUEUED'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c: In function 'bttv_common_ioctls':
/home/lidia/osprey/v4l/bttv-driver.c:2115: error: implicit declaration
of function 'v4l2_video_std_construct'
/home/lidia/osprey/v4l/bttv-driver.c: In function 'setup_window':
/home/lidia/osprey/v4l/bttv-driver.c:2610: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:2627: error: implicit declaration
of function 'videobuf_pci_alloc'
/home/lidia/osprey/v4l/bttv-driver.c:2627: warning: assignment makes
pointer from integer without a cast
/home/lidia/osprey/v4l/bttv-driver.c:2632: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c: In function 'bttv_s_fmt':
/home/lidia/osprey/v4l/bttv-driver.c:2813: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:2822: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c: In function 'bttv_do_ioctl':
/home/lidia/osprey/v4l/bttv-driver.c:2851: error: implicit declaration
of function 'v4l_print_ioctl'
/home/lidia/osprey/v4l/bttv-driver.c:2924: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:2951: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3025: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3063: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3086: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3089: warning: assignment makes
pointer from integer without a cast
/home/lidia/osprey/v4l/bttv-driver.c:3098: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3107: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3119: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3137: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3144: error: 'STATE_QUEUED'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c:3145: error: 'STATE_ACTIVE'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c:3162: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3173: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3182: error: 'STATE_ERROR'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c:3185: error: 'STATE_DONE'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c:3196: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3210: error: implicit declaration
of function 'v4l_compat_translate_ioctl'
/home/lidia/osprey/v4l/bttv-driver.c:3359: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3385: warning: assignment makes
pointer from integer without a cast
/home/lidia/osprey/v4l/bttv-driver.c:3391: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3600: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3618: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3644: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c: In function 'bttv_ioctl':
/home/lidia/osprey/v4l/bttv-driver.c:3680: error: implicit declaration
of function 'video_usercopy'
/home/lidia/osprey/v4l/bttv-driver.c: In function 'bttv_read':
/home/lidia/osprey/v4l/bttv-driver.c:3693: error: 'v4l2_type_names'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c: In function 'bttv_poll':
/home/lidia/osprey/v4l/bttv-driver.c:3737: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3741: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3744: warning: assignment makes
pointer from integer without a cast
/home/lidia/osprey/v4l/bttv-driver.c:3746: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3754: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3760: error: 'struct
videobuf_queue' has no member named 'lock'
/home/lidia/osprey/v4l/bttv-driver.c:3765: error: 'STATE_DONE'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c:3766: error: 'STATE_ERROR'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c: In function 'bttv_open':
/home/lidia/osprey/v4l/bttv-driver.c:3799: error: 'v4l2_type_names'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c:3811: error: implicit declaration
of function 'videobuf_queue_pci_init'
/home/lidia/osprey/v4l/bttv-driver.c: In function 'bttv_mmap':
/home/lidia/osprey/v4l/bttv-driver.c:3896: error: 'v4l2_type_names'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c: At top level:
/home/lidia/osprey/v4l/bttv-driver.c:3908: error: 'v4l_compat_ioctl32'
undeclared here (not in a function)
/home/lidia/osprey/v4l/bttv-driver.c:3919: error: unknown field 'type'
specified in initializer
/home/lidia/osprey/v4l/bttv-driver.c:3928: error: unknown field 'type'
specified in initializer
/home/lidia/osprey/v4l/bttv-driver.c:4075: error: unknown field 'type'
specified in initializer
/home/lidia/osprey/v4l/bttv-driver.c: In function 'bttv_irq_timeout':
/home/lidia/osprey/v4l/bttv-driver.c:4359: error: 'STATE_ERROR'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c: In function 'bttv_irq_wakeup_top':
/home/lidia/osprey/v4l/bttv-driver.c:4395: error: 'STATE_DONE'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c: In function
'bttv_irq_switch_video':
/home/lidia/osprey/v4l/bttv-driver.c:4444: error: 'STATE_DONE'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c: In function 'bttv_irq_switch_vbi':
/home/lidia/osprey/v4l/bttv-driver.c:4477: error: 'STATE_DONE'
undeclared (first use in this function)
/home/lidia/osprey/v4l/bttv-driver.c: In function 'vdev_init':
/home/lidia/osprey/v4l/bttv-driver.c:4618: error: incompatible types in
assignment
/home/lidia/osprey/v4l/bttv-driver.c: In function 'bttv_register_video':
/home/lidia/osprey/v4l/bttv-driver.c:4656: error: 'struct video_device'
has no member named 'type'
/home/lidia/osprey/v4l/bttv-driver.c:4669: error: 'struct video_device'
has no member named 'class_dev'
make[3]: *** [/home/lidia/osprey/v4l/bttv-driver.o] Error 1
make[2]: *** [_module_/home/lidia/osprey/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.27-7-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/lidia/osprey/v4l'
make: *** [all] Error 2


and from ~mchehab repo I have this errors:

lidia@lidia-test:~/mchelab/osprey$ make
make -C /home/lidia/mchelab/osprey/v4l 
make[1]: Entering directory `/home/lidia/mchelab/osprey/v4l'
creating symbolic links...
make -C /lib/modules/2.6.27-7-generic/build
SUBDIRS=/home/lidia/mchelab/osprey/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.27-7-generic'
  CC [M]  /home/lidia/mchelab/osprey/v4l/flexcop-pci.o
In file included from /home/lidia/mchelab/osprey/v4l/compat.h:13,

from /home/lidia/mchelab/osprey/v4l/flexcop-common.h:12,
                 from /home/lidia/mchelab/osprey/v4l/flexcop-pci.c:10:
/home/lidia/mchelab/osprey/v4l/config-compat.h:4:26: error:
linux/config.h: No such file or directory
/home/lidia/mchelab/osprey/v4l/flexcop-pci.c: In function
'flexcop_pci_irq_check_work':
/home/lidia/mchelab/osprey/v4l/flexcop-pci.c:119: warning: passing
argument 1 of 'schedule_delayed_work' from incompatible pointer type
/home/lidia/mchelab/osprey/v4l/flexcop-pci.c: In function
'flexcop_pci_stream_control':
/home/lidia/mchelab/osprey/v4l/flexcop-pci.c:226: warning: passing
argument 1 of 'schedule_delayed_work' from incompatible pointer type
/home/lidia/mchelab/osprey/v4l/flexcop-pci.c:229: warning: passing
argument 1 of 'cancel_delayed_work' from incompatible pointer type
/home/lidia/mchelab/osprey/v4l/flexcop-pci.c:378:71: error: macro
"INIT_WORK" passed 3 arguments, but takes just 2
/home/lidia/mchelab/osprey/v4l/flexcop-pci.c: In function
'flexcop_pci_probe':
/home/lidia/mchelab/osprey/v4l/flexcop-pci.c:378: error: 'INIT_WORK'
undeclared (first use in this function)
/home/lidia/mchelab/osprey/v4l/flexcop-pci.c:378: error: (Each
undeclared identifier is reported only once
/home/lidia/mchelab/osprey/v4l/flexcop-pci.c:378: error: for each
function it appears in.)
make[3]: *** [/home/lidia/mchelab/osprey/v4l/flexcop-pci.o] Error 1
make[2]: *** [_module_/home/lidia/mchelab/osprey/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.27-7-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/lidia/mchelab/osprey/v4l'
make: *** [all] Error 2


Any suggestion?

Thanx a lot

Mauro

