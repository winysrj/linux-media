Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40166 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752424AbcEDQ1c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 12:27:32 -0400
Date: Wed, 4 May 2016 19:26:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, mchehab@osg.samsung.com
Subject: Re: [PATCH v2 4/5] media: Add flags to tell whether to take graph
 mutex for an IOCTL
Message-ID: <20160504162656.GL26360@valkosipuli.retiisi.org.uk>
References: <1462360855-23354-1-git-send-email-sakari.ailus@linux.intel.com>
 <1462360855-23354-5-git-send-email-sakari.ailus@linux.intel.com>
 <572A0C50.5070007@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <572A0C50.5070007@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

Thanks for the review!

On Wed, May 04, 2016 at 08:50:56AM -0600, Shuah Khan wrote:
> On 05/04/2016 05:20 AM, Sakari Ailus wrote:
> > New IOCTLs (especially for the request API) do not necessarily need the
> > graph mutex acquired. Leave this up to the drivers.
> 
> Sakari,
> 
> Does this mean drivers have to hold the graph mutex as needed?
> My concern with this is that we will have graph_mutex holds in
> driver code in addition to the ones we have now. My concern with
> referencing graph_mutex from driver code is lack of abstraction.
> If we ever need to change grahp-mutex in the media-core, if it
> is exposed to drivers, then there will be lot of changes.
> 
> Could we look into avoiding drivers referencing graph_mutex
> directly?

I think we rather need to get rid of the graph mutex in the end; it's a bit
like the big kernel lock right now: most operations on the graph, whatever
they are, need it.

The case for not acquiring it (I have request API and events in mind, in
particular) for some IOCTLs is there. Drivers may need to acquire other
mutexes while holding the graph mutex, and the locking order has to be
maintained in order to avoid deadlocks.

Dequeueing events does not need the graph mutex, whereas requests changing
the graph state would need it for the time being.

The reason there's a flag to acquire the graph mutex (rather than not
acquiring it) is that it'd be easier to spot where it's needed.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
