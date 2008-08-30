Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7UCaiAa031333
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 08:36:44 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7UCaVNo019925
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 08:36:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Harvey Harrison <harvey.harrison@gmail.com>
Date: Sat, 30 Aug 2008 14:36:22 +0200
References: <1218324197.24441.20.camel@brick>
In-Reply-To: <1218324197.24441.20.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808301436.22322.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] byteorder: add a new include/linux/swab.h to define
	byteswapping functions
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Harvey,

On Sunday 10 August 2008 01:23:17 Harvey Harrison wrote:
> Collect the implementations from include/linux/byteorder/swab.h,
> swabb.h in swab.h
>
> The functionality provided covers:
> u16 swab16(u16 val) - return a byteswapped 16 bit value
> u32 swab32(u32 val) - return a byteswapped 32 bit value
> u64 swab64(u64 val) - return a byteswapped 64 bit value
> u32 swahw32(u32 val) - return a wordswapped 32 bit value
> u32 swahb32(u32 val) - return a high/low byteswapped 32 bit value
>
> Similar to above, but return swapped value from a naturally-aligned
> pointer u16 swab16p(u16 *p)
> u32 swab32p(u32 *p)
> u64 swab64p(u64 *p)
> u32 swahw32p(u32 *p)
> u32 swahb32p(u32 *p)
>
> Similar to above, but swap the value in-place (in-situ)
> void swab16s(u16 *p)
> void swab32s(u32 *p)
> void swab64s(u64 *p)
> void swahw32s(u32 *p)
> void swahb32s(u32 *p)
>
> Arches can override any of these with an optimized version by
> defining an inline in their asm/byteorder.h (example given for
> swab16()):
>
> u16 __arch_swab16() {}
>  #define __arch_swab16 __arch_swab16
>
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Linus, please apply so I can start getting each arch moved over to
> the consolidated implementation.  This is an opt-in process to avoid
> breakage, the old implementation will be removed _after_ all arches
> have moved over.
>

Now that this is merged into 2.6.27-rc5 I'm getting broken builds for 
linux/drivers/media/dvb/ttpci/av7110.c. It includes 
<linux/byteorder/swabb.h>. Building on the arm gives this error:

In file included from /marune/build/v4l-dvb/v4l/av7110.c:39:
include/linux/byteorder/swabb.h:82:1: warning: "__swahw32" redefined
In file included from include/linux/byteorder.h:5,
                 
from /marune/build/trees/armv5-ixp/linux-2.6.27-rc5/arch/arm/include/asm/byteorder.h:53,
                 from include/linux/kernel.h:19,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:7,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from /marune/build/v4l-dvb/v4l/av7110.c:33:
include/linux/swab.h:138:1: warning: this is the location of the 
previous definition
In file included from /marune/build/v4l-dvb/v4l/av7110.c:39:
include/linux/byteorder/swabb.h:86:1: warning: "__swahb32" redefined
In file included from include/linux/byteorder.h:5,
                 
from /marune/build/trees/armv5-ixp/linux-2.6.27-rc5/arch/arm/include/asm/byteorder.h:53,
                 from include/linux/kernel.h:19,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:7,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from /marune/build/v4l-dvb/v4l/av7110.c:33:
include/linux/swab.h:149:1: warning: this is the location of the 
previous definition
In file included from /marune/build/v4l-dvb/v4l/av7110.c:39:
include/linux/byteorder/swabb.h:97: error: conflicting types 
for '__swahw32p'
include/linux/swab.h:200: error: previous definition of '__swahw32p' was 
here
include/linux/byteorder/swabb.h:102: error: redefinition of '__swahw32s'
include/linux/swab.h:268: error: previous definition of '__swahw32s' was 
here
include/linux/byteorder/swabb.h:112: error: conflicting types 
for '__swahb32p'
include/linux/swab.h:215: error: previous definition of '__swahb32p' was 
here
include/linux/byteorder/swabb.h:117: error: redefinition of '__swahb32s'
include/linux/swab.h:283: error: previous definition of '__swahb32s' was 
here
  CC [M]  /marune/build/v4l-dvb/v4l/af9005-remote.o
  CC [M]  /marune/build/v4l-dvb/v4l/af9005.o
make[3]: *** [/marune/build/v4l-dvb/v4l/av7110.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [_module_/marune/build/v4l-dvb/v4l] Error 2
make[2]: Leaving directory 
`/marune/build/trees/armv5-ixp/linux-2.6.27-rc5'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/marune/build/v4l-dvb/v4l'
make: *** [all] Error 2



If I replace byteorder/swabb.h with <linux/swab.h> then the arm 
compiles, but I get these compile errors for i686, powerpc64 and 
x86_64:

In file included from /marune/build/v4l-dvb/v4l/av7110.c:40:
include/linux/swab.h:46: error: redefinition of '___swab16'
include/linux/byteorder/swab.h:65: error: previous definition 
of '___swab16' was here
include/linux/swab.h:57: error: redefinition of '___swab32'
include/linux/byteorder/swab.h:69: error: previous definition 
of '___swab32' was here
include/linux/swab.h:68: error: redefinition of '___swab64'
include/linux/byteorder/swab.h:75: error: previous definition 
of '___swab64' was here
In file included from /marune/build/v4l-dvb/v4l/av7110.c:40:
include/linux/swab.h:109:1: warning: "__swab16" redefined
In file included from include/linux/byteorder/little_endian.h:12,
                 from include/asm/byteorder.h:79,
                 from include/asm-generic/bitops/le.h:5,
                 from include/asm-generic/bitops/ext2-non-atomic.h:4,
                 from include/asm/bitops.h:451,
                 from include/linux/bitops.h:17,
                 from include/linux/kernel.h:15,
                 from include/linux/cache.h:4,
                 from include/asm/pda.h:7,
                 from include/asm/current.h:19,
                 from include/asm/processor.h:15,
                 from include/linux/prefetch.h:14,
                 from include/linux/list.h:6,
                 from include/linux/module.h:9,
                 from /marune/build/v4l-dvb/v4l/av7110.c:33:
include/linux/byteorder/swab.h:144:1: warning: this is the location of 
the previous definition
In file included from /marune/build/v4l-dvb/v4l/av7110.c:40:
include/linux/swab.h:118:1: warning: "__swab32" redefined
In file included from include/linux/byteorder/little_endian.h:12,
                 from include/asm/byteorder.h:79,
                 from include/asm-generic/bitops/le.h:5,
                 from include/asm-generic/bitops/ext2-non-atomic.h:4,
                 from include/asm/bitops.h:451,
                 from include/linux/bitops.h:17,
                 from include/linux/kernel.h:15,
                 from include/linux/cache.h:4,
                 from include/asm/pda.h:7,
                 from include/asm/current.h:19,
                 from include/asm/processor.h:15,
                 from include/linux/prefetch.h:14,
                 from include/linux/list.h:6,
                 from include/linux/module.h:9,
                 from /marune/build/v4l-dvb/v4l/av7110.c:33:
include/linux/byteorder/swab.h:148:1: warning: this is the location of 
the previous definition
In file included from /marune/build/v4l-dvb/v4l/av7110.c:40:
include/linux/swab.h:127:1: warning: "__swab64" redefined
In file included from include/linux/byteorder/little_endian.h:12,
                 from include/asm/byteorder.h:79,
                 from include/asm-generic/bitops/le.h:5,
                 from include/asm-generic/bitops/ext2-non-atomic.h:4,
                 from include/asm/bitops.h:451,
                 from include/linux/bitops.h:17,
                 from include/linux/kernel.h:15,
                 from include/linux/cache.h:4,
                 from include/asm/pda.h:7,
                 from include/asm/current.h:19,
                 from include/asm/processor.h:15,
                 from include/linux/prefetch.h:14,
                 from include/linux/list.h:6,
                 from include/linux/module.h:9,
                 from /marune/build/v4l-dvb/v4l/av7110.c:33:
include/linux/byteorder/swab.h:152:1: warning: this is the location of 
the previous definition
include/linux/swab.h:158: error: redefinition of '__swab16p'
include/linux/byteorder/swab.h:168: error: previous definition 
of '__swab16p' was here
include/linux/swab.h:171: error: redefinition of '__swab32p'
include/linux/byteorder/swab.h:181: error: previous definition 
of '__swab32p' was here
include/linux/swab.h:184: error: redefinition of '__swab64p'
include/linux/byteorder/swab.h:201: error: previous definition 
of '__swab64p' was here
include/linux/swab.h:227: error: redefinition of '__swab16s'
include/linux/byteorder/swab.h:172: error: previous definition 
of '__swab16s' was here
include/linux/swab.h:239: error: redefinition of '__swab32s'
include/linux/byteorder/swab.h:185: error: previous definition 
of '__swab32s' was here
include/linux/swab.h:252: error: redefinition of '__swab64s'
include/linux/byteorder/swab.h:205: error: previous definition 
of '__swab64s' was here

Can you take a look at this? My daily v4l-dvb build fails because of 
this.

Thanks,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
