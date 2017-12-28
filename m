Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:39781 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751220AbdL1VFS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 16:05:18 -0500
Message-ID: <1514495025.7000.484.camel@linux.intel.com>
Subject: Re: IRQ behaivour has been changed from v4.14 to v4.15-rc1
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "alan@linux.intel.com" <alan@linux.intel.com>,
        "Ailus, Sakari" <sakari.ailus@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 28 Dec 2017 23:03:45 +0200
In-Reply-To: <alpine.DEB.2.20.1712282117160.1899@nanos>
References: <1514481444.7000.451.camel@intel.com>
         <alpine.DEB.2.20.1712281820040.1899@nanos>
         <1514482448.7000.460.camel@linux.intel.com>
         <alpine.DEB.2.20.1712281834520.1899@nanos>
         <1514489471.7000.463.camel@linux.intel.com>
         <alpine.DEB.2.20.1712282117160.1899@nanos>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-12-28 at 21:18 +0100, Thomas Gleixner wrote:
> On Thu, 28 Dec 2017, Andy Shevchenko wrote:
> > On Thu, 2017-12-28 at 18:44 +0100, Thomas Gleixner wrote:
> > > On Thu, 28 Dec 2017, Andy Shevchenko wrote:
> > > > On Thu, 2017-12-28 at 18:21 +0100, Thomas Gleixner wrote:
> > > > > > [   85.167061] spurious APIC interrupt through vector ff on
> > > > > > CPU#0,
> > > > > > should never happen.
> > > > > > [   85.199886] atomisp-isp2 0000:00:03.0: stream[0] started.
> > > > > > 
> > > > > > and Ctrl+C does NOT work. Machine just hangs.
> > > > > > 
> > > > > > It might be related to this:
> > > > > > https://lkml.org/lkml/2017/12/22/697
> > > > > 
> > > > > I don't think so.
> > > > > 
> > > > > Does the patch below cure it?
> > > > 
> > > > Unfortunately, no.
> > > > 
> > > > Same behaviour.
> > > > 
> > > > Tell me if I need to provide some debug before it hangs. For now
> > > > I
> > > > have
> > > > apic=debug (AFAIR it doesn't affect this).
> > > 
> > > The interesting question is why that spurious APIC interrupt
> > > through
> > > vector
> > > ff happens. Can you please add the following to the kernel command
> > > line:
> > > 
> > >  'trace_events=irq_vectors:* ftrace_dump_on_oops'
> > > 
> > > and apply the patch below. That should spill out the trace over
> > > serial
> > > (I
> > > hope you have that ...)
> > 
> > With or without CONFIG_FUNCTION_TRACER=y I have got
> > 
> > 
> > [   28.977918] Dumping ftrace buffer:
> > [   28.988115]    (ftrace buffer empty)
> > 
> > followed by BUG() output.
> > 
> > ...
> > [   28.930154] RIP: 0010:smp_spurious_interrupt+0x67/0xb0
> > ...
> > 
> > 
> > Anything I missed?
> 
> Yes, you missed the typo in the command line. It should be:
> 
>  'trace_event=irq_vectors:* ftrace_dump_on_oops'

Indeed.

So, I had to disable LOCAL_TIMER_VECTOR, CALL_FUNCTION_VECTOR and
RESCHDULE_VECTOR tracing, otherwise I got a lot of spam and RCU stalls.

The result w/o above is (full log is available here https://pastebin.com
/J5yaTbM9):

[   38.570130]   <idle>-0       0d...    0us : vector_clear: irq=1
vector=49 cpu=0 prev_vector=0 prev_cpu=0

[   38.606969]   <idle>-0       0d...    0us : vector_reserve: irq=1
ret=0

[   38.627799]   <idle>-0       0d...    0us : vector_config: irq=1
vector=239 cpu=0 apicdest=0x00000001

[   38.665139]   <idle>-0       0....    0us : vector_setup: irq=1
is_legacy=0 ret=0

[   38.687383]   <idle>-0       0d...    0us : vector_setup: irq=0
is_legacy=1 ret=0

[   38.709354]   <idle>-0       0d...    0us : vector_config: irq=0
vector=48 cpu=0 apicdest=0x00000001

[   38.746192]   <idle>-0       0d...    0us : vector_clear: irq=3
vector=51 cpu=0 prev_vector=0 prev_cpu=0

[   38.783535]   <idle>-0       0d...    0us : vector_reserve: irq=3
ret=0

[   38.804574]   <idle>-0       0d...    0us : vector_config: irq=3
vector=239 cpu=0 apicdest=0x00000001

[   38.842397]   <idle>-0       0....    0us : vector_setup: irq=3
is_legacy=0 ret=0

...

so on up to 
[   40.329523]   <idle>-0       0d...    0us : vector_clear: irq=15
vector=63 cpu=0 prev_vector=0 prev_cpu=0

[   40.372425]   <idle>-0       0d...    0us : vector_reserve: irq=15
ret=0

[   40.396045]   <idle>-0       0d...    0us : vector_config: irq=15
vector=239 cpu=0 apicdest=0x00000001

[   40.438357]   <idle>-0       0....    0us : vector_setup: irq=15
is_legacy=0 ret=0

[   40.463002]   <idle>-0       0d...    0us : vector_deactivate: irq=0
is_managed=0 can_reserve=0 early=0

[   40.505473]   <idle>-0       0d...    0us : vector_activate: irq=0
is_managed=0 can_reserve=0 early=0


Then several times (for different tasks)

[   40.548017]  kauditd-32      0d.h. 307277us :
call_function_single_entry: vector=251

[   40.572984]  kauditd-32      0dNh. 307281us :
call_function_single_exit: vector=251

...


[   40.792078] swapper/-1       0d... 390605us : vector_activate: irq=9
is_managed=0 can_reserve=1 early=0

[   40.832953] swapper/-1       0d... 390611us : vector_update: irq=9
vector=33 cpu=0 prev_vector=0 prev_cpu=0

[   40.874548] swapper/-1       0d... 390613us : vector_alloc: irq=9
vector=33 reserved=1 ret=0

[   40.899551] swapper/-1       0d... 390614us : vector_config: irq=9
vector=33 cpu=0 apicdest=0x00000001

[   40.940771] swapper/-1       0d... 390620us : vector_config: irq=9
vector=33 cpu=0 apicdest=0x00000001

...

For irq=24-29, 47, 49:


[   41.071806] swapper/-1       1d... 989092us : vector_reserve: irq=24
ret=0

[   41.088297] swapper/-1       1d... 989096us : vector_config: irq=24
vector=239 cpu=0 apicdest=0x00000001

[   41.125772] swapper/-1       1.... 989097us : vector_setup: irq=24
is_legacy=0 ret=0

...

[   48.242842]     mdev-1450    3d.h. 20327793us :
call_function_single_entry: vector=251

[   48.269120]     mdev-1450    3d.h. 20327800us :
call_function_single_exit: vector=251

[   48.295319] modprobe-1348    0d... 20444228us : vector_activate:
irq=42 is_managed=0 can_reserve=1 early=0

[   48.341248] modprobe-1348    0d... 20444235us : vector_update: irq=42
vector=52 cpu=0 prev_vector=0 prev_cpu=0

[   48.387914] modprobe-1348    0d... 20444237us : vector_alloc: irq=42
vector=52 reserved=1 ret=0

[   48.415547] modprobe-1348    0d... 20444238us : vector_config: irq=42
vector=52 cpu=0 apicdest=0x00000001

[   48.461465] modprobe-1348    0d... 20444243us : vector_config: irq=42
vector=52 cpu=0 apicdest=0x00000001

[   48.507688] modprobe-1348    0d... 20484235us : vector_activate:
irq=43 is_managed=0 can_reserve=1 early=0

[   48.554044] modprobe-1348    0d... 20484241us : vector_update: irq=43
vector=53 cpu=0 prev_vector=0 prev_cpu=0

[   48.600812] modprobe-1348    0d... 20484243us : vector_alloc: irq=43
vector=53 reserved=1 ret=0

[   48.628494] modprobe-1348    0d... 20484244us : vector_config: irq=43
vector=53 cpu=0 apicdest=0x00000001

[   48.674508] modprobe-1348    0d... 20484248us : vector_config: irq=43
vector=53 cpu=0 apicdest=0x00000001

[   48.720830]   <idle>-0       1d.h. 20591763us :
call_function_single_entry: vector=251

[   48.747573]   <idle>-0       1d.h. 20591768us :
call_function_single_exit: vector=251

[   48.774025] modprobe-1348    1d... 20831415us : vector_reserve:
irq=150 ret=0

[   48.799631] modprobe-1348    1d... 20831419us : vector_config:
irq=150 vector=239 cpu=0 apicdest=0x00000001

[   48.845791] modprobe-1348    1.... 20831420us : vector_setup: irq=150
is_legacy=0 ret=0

[   48.872515] modprobe-1348    1.... 20831427us : vector_activate:
irq=150 is_managed=0 can_reserve=1 early=1

[   48.918432] modprobe-1348    1d... 20831428us : vector_config:
irq=150 vector=239 cpu=0 apicdest=0x00000001

[   48.964534] modprobe-1348    1d... 21152409us : vector_activate:
irq=150 is_managed=0 can_reserve=1 early=0

[   49.010805] modprobe-1348    1d... 21152415us : vector_update:
irq=150 vector=54 cpu=0 prev_vector=0 prev_cpu=0

[   49.057553] modprobe-1348    1d... 21152417us : vector_alloc: irq=150
vector=54 reserved=1 ret=0

[   49.085503] modprobe-1348    1d... 21152418us : vector_config:
irq=150 vector=54 cpu=0 apicdest=0x00000001

[   49.132545] modprobe-1348    1d... 21152428us : vector_config:
irq=150 vector=54 cpu=0 apicdest=0x00000001

[   49.180426]   <idle>-0       2d.h. 21227397us :
call_function_single_entry: vector=251

[   49.208066]   <idle>-0       2d.h. 21227403us :
call_function_single_exit: vector=251

[   49.235397]   <idle>-0       3d.h. 21229548us :
call_function_single_entry: vector=251

[   49.262625]   <idle>-0       3d.h. 21229551us :
call_function_single_exit: vector=251

[   49.289544]   <idle>-0       0d.h. 21231514us :
call_function_single_entry: vector=251

[   49.316365]   <idle>-0       0d.h. 21231519us :
call_function_single_exit: vector=251

[   49.343015]   <idle>-0       1d.h. 21238805us :
call_function_single_entry: vector=251

[   49.369550]   <idle>-0       1d.h. 21238809us :
call_function_single_exit: vector=251

[   49.395774]   <idle>-0       3d.h. 24735137us :
call_function_single_entry: vector=251

[   49.421902]   <idle>-0       3d.h. 24735143us :
call_function_single_exit: vector=251

[   49.447720]   <idle>-0       0d.h. 38913766us : spurious_apic_entry:
vector=255





-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
