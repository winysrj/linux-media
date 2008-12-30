Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@makhutov.org>) id 1LHcq1-0000Uq-HZ
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 12:32:42 +0100
Message-ID: <495A06B7.7060506@makhutov.org>
Date: Tue, 30 Dec 2008 12:32:07 +0100
From: Artem Makhutov <artem@makhutov.org>
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
References: <20081227180001.GS12059@titan.makhutov-it.de>
	<alpine.DEB.2.00.0812300758390.29535@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.00.0812300758390.29535@ybpnyubfg.ybpnyqbznva>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compile DVB drivers for kernel 2.6.11
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

BOUWSMA Barry schrieb:
> On Sat, 27 Dec 2008, Artem Makhutov wrote:
> 
>> I would like to compile current dvb-drivers from hg for kernel 2.6.11.12.
>> Has somebody experience with this?
> 
> I'm running 2.6.14 on my production machine (which may be
> a snapshot during the merge window before a 15-rc1 tag was
> added -- I still haven't wrapped my brane around all the
> details of version numbers, git, makefiles, and all -- in
> any case, some .14 checks I have had to bump to .15 to get
> the source to compile).
> 
> It can be done for .14; of course I get a panic when I use
> these modules, or when I try to add later hardware code to
> the working .14 source, but that's likely because I've made
> more hacks elsewhere that I no longer remember clearly, and
> I haven't motivated myself to make things work since then.
> 
> 
> Anyway, some time back, there was a change made which
> removed support for selected earlier kernels, and you can
> do a `hg diff' on your repository to see what those changes
> were -- either checking out the revision before that change
> and starting with that, or getting all the diffs and re-adding
> them to the latest code and seeing how far you can get.
> 
> This changeset where the support was removed is 8240.
>
>
>
> You can use `hg log' and `hg diff' on selected files to see
> if earlier changesets affect support for earlier kernels.
> For example, changeset 963 removed 2.4 support.

Thanks I will check it.

>> The first problem I am running into is that 2.6.11 has no linux/mutex.h.
> 
> That's an easy one.  If you would like, I can pack up the
> snapshot which I built (a few modules fail to build 'cuz
> they are too new and I don't have that hardware) and see
> how far you can get with it.
> 
> Whether you need special magic to get further towards 2.6.11,
> I don't know -- nor can I promise anything about the diffs
> I've added.  Like I say, they don't work for me, but they
> compile, so hey, job done, get it out the door, ship it

I have managed to compile the dvb-tree with replacing a lot of stuff with:

# find . -type f -exec sed -i 's/struct mutex/struct semaphore/' {} \;
# find . -type f -exec sed -i 's/mutex_lock/down/' {} \;
# find . -type f -exec sed -i 's/mutex_unlock/up/' {} \;
# find . -type f -exec sed -i 's/\#include <linux\/mutex.h>//' {} \;
# find . -type f -exec sed -i 's/kzalloc(/kcalloc(1,/' {} \;
# find . -type f -exec sed -i 's/DEFINE_MUTEX/DECLARE_MUTEX/' {} \;
# find . -type f -exec sed -i
's/try_to_freeze(/try_to_freeze(PF_FREEZE/' {} \;

and also this diff:

--- s2-liplianin.org/v4l/compat.h       2008-12-27 13:00:38.000000000 +0100
+++ s2-liplianin/v4l/compat.h   2008-12-28 19:47:26.000000000 +0100
@@ -44,6 +44,18 @@
 # define I2C_M_IGNORE_NAK 0x1000
 #endif

+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,13)
+# define class_device_create(a, b, c, d, e, f, g, h)
class_simple_device_add(a, c, d, e, f, g, h)
+# define class_device_destroy(a, b) class_simple_device_remove(b)
+# define class_create(a, b) class_simple_create(a, b)
+# define class_destroy(a) class_simple_destroy(a)
 #endif
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,13)
+# define mutex_init(a) sema_init(a, 1)
+#endif
+
 /* device_create/destroy added in 2.6.18 */
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)
 /* on older kernels, class_device_create will in turn be a compat macro */


And some other minor changes.
I can load the modules, but they kernel panics whil a NULL Pointer
error, when I plug in the device, so I will have to debug it a bit more.

An other bad thing is that the kernel was compiled without
CONFIG_HOTPLUG and I had to change init/Kconfig from

bool "Support for hot-pluggable devices" if !ARCH_S390 to
tristate "Support for hot-pluggable devices" if !ARCH_S390

to get the FW_LOADER module to build.

So right now I am not sure what is causing the kernel panic...


Can you send over me the diffs you did?

Thanks, Artem

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
