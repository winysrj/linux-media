Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38163 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbbISBWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2015 21:22:48 -0400
Date: Sat, 19 Sep 2015 09:22:31 +0800
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	javier@osg.samsung.com, hverkuil@xs4all.nl
Subject: Re: [RFC 0/9] Unrestricted media entity ID range support
Message-ID: <20150919092231.55fd5c28@osg.samsung.com>
In-Reply-To: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Fri, 11 Sep 2015 13:09:03 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> wrote:

> Hi all,
> 
> This patchset adds an API for managing entity enumerations, i.e.
> storing a bit of information per entity. The entity ID is no longer
> limited to small integers (e.g. 31 or 63), but
> MEDIA_ENTITY_MAX_LOW_ID. The drivers are also converted to use that
> instead of a fixed number.
> 
> If the number of entities in a real use case grows beyond the
> capabilities of the approach, the algorithm may be changed. But most
> importantly, the API is used to perform the same operation everywhere
> it's done.
> 
> I'm sending this for review only, the code itself is untested.
> 
> I haven't entirely made up my mind on the fourth patch. It could be
> dropped, as it uses the API for a somewhat different purpose.
> 

Sorry for not reviewing this earlier, but I'm traveling this week to
China, and I was having some troubles with the Internet. Btw, I don't
have my notebook here (just a chromebook without the media tree).
So, please consider this as just a preliminary review.

I won't be comment this series patch by patch, because it is really
painful to do it while here with this Internet.

Also, I want to discuss the patch series as a hole.

>From what we've agreed last week, we won't be using a separate ID
range for the entity ID, but this patch series is actually adding
it, and, IMHO, using a confusing nomenclature: instead of calling the
entity ID range as "entity_id" at the media_device struct, you're
now calling it "low_id". That sounds confusing to me. If you think
we should keep a separate range for entities, calling it as 
"entity_id" is clearer.

Also, you said at the low_id comment that if an entity is
unregistered and then re-registered, it would preserve the same
entity ID. That doesn't seem easy to implement, as we would need
to track those previously-used ID. On the other hand, if we just
re-use a previously released ID for some other entity, this can
be a problem, as userspace may not be aware of such changes and
might be asking the Kernel to do the wrong thing.

So, I can't see how non-monotonically incremented numbers would
work here.

Finally, the changes you did still rely on having the ID limited
to a well-defined, hardcoded number (MEDIA_ENTITY_MAX_LOW_ID).

I can see this working only if:

- We keep a separate range ID for entities (so, having a minimum
  of two ranges);

- the entity maximum ID is defined by the driver (as the number
  of entities is actually dependent on the hardware);

- some other mechanism would be available for drivers that
  would support dynamic entity creation.

So, I don't see how this would solve the problems that we
discussed at the last week IRC chats.

Am I missing something?

Regards,
Mauro

PS.: sparse already complains on two places at the media-entity where
bitmaps are declared at the stack. With max entities equal to 64,
that's not an issue, but if we change to a higher number, those will
need to be dynamically allocated, in order to avoid stack overflows.
I didn't see any patches touching that.
