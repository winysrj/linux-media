Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:59485 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176AbbIDJBr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 05:01:47 -0400
Message-ID: <55E95DB6.7080108@xs4all.nl>
Date: Fri, 04 Sep 2015 11:00:38 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	=?windows-1252?Q?Rafael_Louren=E7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>, Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v8 19/55] [media] media: convert links from array to list
References: <cover.1440902901.git.mchehab@osg.samsung.com> <2547965181e69b3e0e8c4c1aed67668d580a8e58.1440902901.git.mchehab@osg.samsung.com> <20150904084106.GA3175@valkosipuli.retiisi.org.uk>
In-Reply-To: <20150904084106.GA3175@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/2015 10:41 AM, Sakari Ailus wrote:
> Hi Mauro,
> 
> On Sun, Aug 30, 2015 at 12:06:30AM -0300, Mauro Carvalho Chehab wrote:
>> The entire logic that represent graph links were developed on a
>> time where there were no needs to dynamic remove links. So,
>> although links are created/removed one by one via some
>> functions, they're stored as an array inside the entity struct.
>>
>> As the array may grow, there's a logic inside the code that
>> checks if the amount of space is not enough to store
>> the needed links. If it isn't the core uses krealloc()
>> to change the size of the link, with is bad, as it
>> leaves the memory fragmented.
> 
> The Linux kernel constantly allocates and releases memory for various
> reasons. Even the V4L2 IOCTL handler does that when the argument is too
> large to fit into the stack-allocated buffer. There's no reason to avoid
> allocating and releasing small chunks of memory when hardware configuration
> changes.
> 
>>
>> So, convert links into a list.
> 
> Instead, if you're worried about the time the memory re-allocation takes
> that'd be needed to dynamically add a large number of links, I'd just
> allocate more memory at a time, say, rounding up to a power of two, and use
> vmalloc() instead of kmalloc() when the size grows over one page.
> 
> That'd avoid the vast majority of reallocs without wasting much memory: the
> granularity of memory allocation is much larger than the size of struct
> media_link except in the case of very small link numbers.
> 
> The reason I'm proposing this is that linked lists, as you're allocating
> them, can end up anywhere in the system memory. Walking over the media graph
> is quite a job if you have as many links as in your example, and the
> additional cache misses caused by scattering the data structure all over the
> system memory will not make the effort smaller.
> 
> Adding links dynamically (for a change in hardware topology?) is by far less
> performance critical than e.g. starting and stopping streaming or
> enumerating the links so the latter should have the priority IMHO.

You don't do either of these jobs very often either. As I have said before, the
enemy of media drivers is rarely performance but always complexity. Based
on the patches I've seen I agree with Mauro that a linked list is a better
fit and simplifies the code.

If you have *proof* that this hurts performance in certain real-life cases,
then this can always be optimized later.

But unless someone shows me proof that it really hurts performance in realistic
cases, I will always favor simplicity.

In all the time that I have been involved in the media subsystem the only
performance issue I am aware of was that enumerating all the links in the MC
can be too slow due to all the ioctl calls that it takes (vsp driver). This
will be solved with the proposed G_TOPOLOGY ioctl since that returns everything
in a single call (or two calls if you need to know how much memory to allocate
first).

Hmm, actually, I think there is another related issue if you want to enumerate
all combinations of pixelformats, discrete framesizes and framerates. There too
the problem is the number of ioctl calls you have to do. It's never been
important enough to do something about it, though.

Bottom line, always go for simplicity unless you can demonstrate with numbers
that there are real performance issues.

Regards,

	Hans

> 
>>
>> Also, currently,  both source and sink entities need the link
>> at the graph traversal logic inside media_entity. So there's
>> a logic duplicating all links. That makes it to spend
>> twice the memory needed. This is not a big deal for today's
>> usage, where the number of links are not big.
>>
>> Yet, if during the MC workshop discussions, it was said that
>> IIO graphs could have up to 4,000 entities. So, we may
>> want to remove the duplication on some future. The problem
>> is that it would require a separate linked list to store
>> the backlinks inside the entity, or to use a more complex
>> algorithm to do graph backlink traversal, with is something
>> that the current graph traversal inside the core can't cope
>> with. So, let's postpone a such change if/when it is actually
>> needed.
> 
> Would keeping the links in a linked list help with that?
> 
> I think this could be done using both the current arrays or linked lists ---
> instead of storing links themselves, you'd store pointers to the links
> (array or a linked list) which then are stored elsewhere. Helper functions
> would be needed to e.g. loop over the links in that case though.
> 

