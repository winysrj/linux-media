Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:60135 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbZCCJtL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 04:49:11 -0500
Date: Tue, 3 Mar 2009 01:49:06 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Subject: Re: General protection fault on rmmod cx8800
In-Reply-To: <Pine.LNX.4.58.0903030107110.24268@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.58.0903030145210.24268@shell2.speakeasy.net>
References: <20090215214108.34f31c39@hyperion.delvare>
 <20090302133936.00899692@hyperion.delvare> <1236003365.3071.6.camel@palomino.walls.org>
 <20090302170349.18c8fd75@hyperion.delvare> <20090302200513.7fc3568e@hyperion.delvare>
 <Pine.LNX.4.58.0903021241380.24268@shell2.speakeasy.net>
 <20090302225235.5d6d47ce@hyperion.delvare> <Pine.LNX.4.58.0903030107110.24268@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Mar 2009, Trent Piepho wrote:
> On Mon, 2 Mar 2009, Jean Delvare wrote:
> > be fairly easy, I can take care of it. The difficult part will be to
> > handle the compatibility with kernels < 2.6.20 because delayed_work was
> > introduced in 2.6.20. Probably "compatibility" here will simply mean
> > that the bug I've hit will only be fixed for kernels >= 2.6.20. Which
> > once again raises the question of whether we really want to keep
> > supporting these old kernels.
>
> cancel_delayed_work_sync() was renamed from cancel_rearming_delayed_work()
> in 2.6.23.  A compat.h patch can handle that one.

compat.h has code to handle it froma year ago.

> In 2.6.22, cancel_delayed_work_sync(work) was created from
> cancel_rearming_delayed_workqueue(wq, work).  The kernel has a compat

But cancel_rearming_delayed_work() already existed, the real change was
that cancel_rearming_delayed_workqueue() was made obsolete by making
cancel_rearming_delayed_work() not care what workqueue the work was in.
