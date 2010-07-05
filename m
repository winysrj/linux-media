Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44123 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139Ab0GEQU1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 12:20:27 -0400
Subject: Re: [PATCH] VIDEO: ivtvfb, remove unneeded NULL test
From: Andy Walls <awalls@md.metrocast.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>,
	Ian Armstrong <ian@iarmst.demon.co.uk>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
In-Reply-To: <4C31855B.7030509@suse.cz>
References: <1277206910-27228-1-git-send-email-jslaby@suse.cz>
	 <1278216707.2644.32.camel@localhost>  <4C30372D.9050304@suse.cz>
	 <1278249745.2280.46.camel@localhost>  <4C31855B.7030509@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 12:19:55 -0400
Message-ID: <1278346795.2229.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-07-05 at 09:10 +0200, Jiri Slaby wrote:
> On 07/04/2010 03:22 PM, Andy Walls wrote:
> > On Sun, 2010-07-04 at 09:24 +0200, Jiri Slaby wrote:
> >> On 07/04/2010 06:11 AM, Andy Walls wrote:

> > There are windows of time where a struct device * will exist for a card
> > in the ivtv driver, but a struct v4l2_device * may not: the end of
> > ivtv_remove() and the beginning of ivtv_probe().
> 
> If there is no locking or refcounting, this won't change with the added
> check. The window is still there, but it begins after the check with
> your patch. Hence will still cause oopses.

Jiri,

Of course, you're absolutley right.

Please resubmit a version of your original patch fixing both instances
of the check.  I'll add my ack and SOB.

If any users ever report an Oops, then I'll bother to add interlocking.

Regards,
Andy

