Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34186 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976AbbIDLLJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 07:11:09 -0400
Date: Fri, 4 Sep 2015 08:10:59 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>, Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v8 19/55] [media] media: convert links from array to
 list
Message-ID: <20150904081059.118c7288@recife.lan>
In-Reply-To: <55E95DB6.7080108@xs4all.nl>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<2547965181e69b3e0e8c4c1aed67668d580a8e58.1440902901.git.mchehab@osg.samsung.com>
	<20150904084106.GA3175@valkosipuli.retiisi.org.uk>
	<55E95DB6.7080108@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Sep 2015 11:00:38 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 09/04/2015 10:41 AM, Sakari Ailus wrote:
> > Hi Mauro,
> > 
> > On Sun, Aug 30, 2015 at 12:06:30AM -0300, Mauro Carvalho Chehab wrote:
> >> The entire logic that represent graph links were developed on a
> >> time where there were no needs to dynamic remove links. So,
> >> although links are created/removed one by one via some
> >> functions, they're stored as an array inside the entity struct.
> >>
> >> As the array may grow, there's a logic inside the code that
> >> checks if the amount of space is not enough to store
> >> the needed links. If it isn't the core uses krealloc()
> >> to change the size of the link, with is bad, as it
> >> leaves the memory fragmented.
> > 
> > The Linux kernel constantly allocates and releases memory for various
> > reasons. Even the V4L2 IOCTL handler does that when the argument is too
> > large to fit into the stack-allocated buffer. There's no reason to avoid
> > allocating and releasing small chunks of memory when hardware configuration
> > changes.
> > 
> >>
> >> So, convert links into a list.
> > 
> > Instead, if you're worried about the time the memory re-allocation takes
> > that'd be needed to dynamically add a large number of links, I'd just
> > allocate more memory at a time, say, rounding up to a power of two, and use
> > vmalloc() instead of kmalloc() when the size grows over one page.

We had support to allocate more links via that "extra_links" parameter.
This never worked in practice: there was no single client for that.

> > 
> > That'd avoid the vast majority of reallocs without wasting much memory: the
> > granularity of memory allocation is much larger than the size of struct
> > media_link except in the case of very small link numbers.
> > 
> > The reason I'm proposing this is that linked lists, as you're allocating
> > them, can end up anywhere in the system memory. Walking over the media graph
> > is quite a job if you have as many links as in your example, and the
> > additional cache misses caused by scattering the data structure all over the
> > system memory will not make the effort smaller.

First of all, I agree with Hans: the major issues we have is not due
to performance, but due to complexity.

Talking about the graph traversal algorithm, it curently doesn't work
even for simple hybrid TV devices, as it currently allows to have only 64
entities, due to the loop detection code there.

Ok, it would be possible to extend it to support real case scenarios, but
the patch is not as trivial as changing the max number of entities. Just
doing that would cause the stack to crash, as the bitmap structs are 
allocated at the stack.

Also, what you're saying regards to the increase of cache misses,
this is not true. The links memory are still fragmented, as they're
allocated during entities init code. On most codes, that means that
they'll be allocated after each entity.

So, memory would look like:
	entity#1
	links for entity#1
	entity#2
	links for entity#2
...

If you want to put the links at consecutive addresses, what you would
need to do is to create first all entities, and then create the links
altogether. After this patch, drivers that have timing issues can do
it, having the memory allocated as:
	entity#1
	entity#2
	links for entity#1
	links for entity#2
	...

So, I won't doubt that this patch would actually improve performance
by putting the links altogether ;)

Ok, when we have lots of dynamic entity creation/removal, the memory
will become more fragmented, but that would happen with or without
this change.

I mean, if this patch is not applied and entity#2 is created after
a long runtime, we would have:

	entity#1
	links for entity #1

	<some other data allocated>

	entity#2
	links for entity #2

While, on the other case, the memory would be:

	entity#1
	links for entity #1 (except for the link with entity#2)
	backlinks for entity #1 (except for the link with entity#2)

	<some other data allocated>

	entity#2
	link between entity#1 and entity#2
	other links for entity #2

I bet performance would be pretty much the same.

Anyway, let's go to real numbers. Javier ran some tests in order to check
what would be the difference using the omap3isp driver.

He hacked yavta to suppress glibc calls to printf() with this hack:

#define printf(...) do { } while (0)

Then, he measured the times with and without this patch series.
Doing the graph traversal needed for this command:
	$ time ./yavta/yavta -f UYVY -s 720x312 -n 1 --capture=1 -F /dev/video2

Resulted in:
	real	0m0.022s
	user	0m0.000s
	sys	0m0.010s

The complete results form Javier are at:
	http://hastebin.com/turixebuyo.pl

He did that with both with and without this patch series.

On all cases, it took 10ms to setup the pipeline.

> > 
> > Adding links dynamically (for a change in hardware topology?) is by far less
> > performance critical than e.g. starting and stopping streaming or
> > enumerating the links so the latter should have the priority IMHO.
> 
> You don't do either of these jobs very often either. As I have said before, the
> enemy of media drivers is rarely performance but always complexity. Based
> on the patches I've seen I agree with Mauro that a linked list is a better
> fit and simplifies the code.
> 
> If you have *proof* that this hurts performance in certain real-life cases,
> then this can always be optimized later.
> 
> But unless someone shows me proof that it really hurts performance in realistic
> cases, I will always favor simplicity.
> 
> In all the time that I have been involved in the media subsystem the only
> performance issue I am aware of was that enumerating all the links in the MC
> can be too slow due to all the ioctl calls that it takes (vsp driver). This
> will be solved with the proposed G_TOPOLOGY ioctl since that returns everything
> in a single call (or two calls if you need to know how much memory to allocate
> first).

Some timing measurements using au0828 driver:

This is the time mc_nextgen_test takes with a hack that:
	- Reduces the number of demux outputs from 256 to 5;
	- Reduces the number of output ringbuffers from 512 to 10;
	- Adds one subdev for tuner (helps me to test subdevs).

$ time ~/mc_nextgen_test 
version: 97
number of entities: 19
number of interfaces: 7
number of pads: 28
number of links: 25

real	0m0.002s
user	0m0.000s
sys	0m0.000s

The time spent at the Kernel (sys) is less than 1ms. Hardly would cause
any harm.

Btw, that's with the real graph (without a fake subdev for tuner, and
with all ringbuffers mapped):

$ time ~/mc_nextgen_test
version: 2354
number of entities: 521
number of interfaces: 6
number of pads: 781
number of links: 526

real	0m0.002s
user	0m0.000s
sys	0m0.000s

No difference: it still took less than 1 ms.

Ok, this is not graph traversal, but the G_TOPOLOGY should read all
objects that belong to the graph. So, if cache miss would cause any
performance issue, some difference would be noticed here.

Also, please notice that cache misses inside a graph traversal
loop should happen only one for a given memory object, as, the
memory will be cached on the second access to it (provided, of
course, that the amount of memory used to store the links is smaller
than the size of the cache - that should be the case even for graphs
like what we have at au0828 without the hacks).

We might try to use ftrace to measure the time spent in Kernel
to have a better measurement, but I'm afraid that ftrace could
actually mangle the results by causing cache flushes at L1 cache,
due to the long jump to the ftrace event store routine.

> 
> Hmm, actually, I think there is another related issue if you want to enumerate
> all combinations of pixelformats, discrete framesizes and framerates. There too
> the problem is the number of ioctl calls you have to do. It's never been
> important enough to do something about it, though.
> 
> Bottom line, always go for simplicity unless you can demonstrate with numbers
> that there are real performance issues.
> 
> Regards,
> 
> 	Hans
> 
> > 
> >>
> >> Also, currently,  both source and sink entities need the link
> >> at the graph traversal logic inside media_entity. So there's
> >> a logic duplicating all links. That makes it to spend
> >> twice the memory needed. This is not a big deal for today's
> >> usage, where the number of links are not big.
> >>
> >> Yet, if during the MC workshop discussions, it was said that
> >> IIO graphs could have up to 4,000 entities. So, we may
> >> want to remove the duplication on some future. The problem
> >> is that it would require a separate linked list to store
> >> the backlinks inside the entity, or to use a more complex
> >> algorithm to do graph backlink traversal, with is something
> >> that the current graph traversal inside the core can't cope
> >> with. So, let's postpone a such change if/when it is actually
> >> needed.
> > 
> > Would keeping the links in a linked list help with that?

Well, if we reduce the links by half, removing the allocation of
a memory for backlinks, then yes. I was planning to to that, but
this would require a non-trivial change at the graph traversal
algorithm and the usage of a separate linked list for the backlink.

Please notice that, if you're concerned with cache misses, using
half of the memory to store the links/backlinks would actually be
an improvement in terms of performance.

> > 
> > I think this could be done using both the current arrays or linked lists ---
> > instead of storing links themselves, you'd store pointers to the links
> > (array or a linked list) which then are stored elsewhere. Helper functions
> > would be needed to e.g. loop over the links in that case though.
> > 
> 
