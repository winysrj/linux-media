Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43423 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752662Ab2GXLSg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 07:18:36 -0400
Subject: Re: [PATCH 2/2] kthread_worker: reimplement flush_kthread_work() to
 allow freeing the work item being executed
From: Andy Walls <awalls@md.metrocast.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	Grant Likely <grant.likely@secretlab.ca>,
	spi-devel-general@lists.sourceforge.net,
	Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 07:17:45 -0400
In-Reply-To: <20120723171215.GA5776@google.com>
References: <20120719211510.GA32763@google.com>
	 <20120719211629.GC32763@google.com>
	 <1342894814.2504.31.camel@palomino.walls.org>
	 <20120722164953.GC5144@dhcp-172-17-108-109.mtv.corp.google.com>
	 <1342990015.2487.19.camel@palomino.walls.org>
	 <20120723171215.GA5776@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1343128667.2488.6.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-07-23 at 10:12 -0700, Tejun Heo wrote:
> Hello,
> 
> On Sun, Jul 22, 2012 at 04:46:54PM -0400, Andy Walls wrote:
> > Hmmm, I didn't know about the constraint about 'known to be alive' in
> > the other email I just sent.
> > 
> > That might make calling flush_kthread_work() hard for a user to use, if
> > the user lets the work get freed by another thread executing the work.
> 
> Umm... flushing a freed work item doesn't make any sense at all.  The
> pointer itself loses the ability to identify anything.  What if it
> gets recycled to another work item which happens to depend on the
> flusher to make forward progress?  You now have a circular dependency
> through a recycled memory area.  Good luck hunting that down.
> 
> For pretty much any API, allowing dangling pointers as argument is
> insane.  If you want to flush self-freeing work items, flush the
> kthread_worker.  That's how it is with workqueue and how it should be
> with kthread_worker too.

Hi,

Ah.  My problem was that I mentally assigned the wrong rationale for why
you reworked flush_kthread_work().

Thank you for your patience and explanations.
Sorry for the noise.

For patch 2/2:

Reviewed-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

