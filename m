Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:51750 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZCCUOJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 15:14:09 -0500
Date: Tue, 3 Mar 2009 12:14:06 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Subject: Re: General protection fault on rmmod cx8800
In-Reply-To: <20090303131633.52dbb472@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0903031212550.24268@shell2.speakeasy.net>
References: <20090215214108.34f31c39@hyperion.delvare>
 <20090302133936.00899692@hyperion.delvare> <1236003365.3071.6.camel@palomino.walls.org>
 <20090302170349.18c8fd75@hyperion.delvare> <20090302200513.7fc3568e@hyperion.delvare>
 <Pine.LNX.4.58.0903021241380.24268@shell2.speakeasy.net>
 <20090302225235.5d6d47ce@hyperion.delvare> <Pine.LNX.4.58.0903030107110.24268@shell2.speakeasy.net>
 <20090303131633.52dbb472@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Mar 2009, Jean Delvare wrote:
> On Tue, 3 Mar 2009 01:40:00 -0800 (PST), Trent Piepho wrote:
> > On Mon, 2 Mar 2009, Jean Delvare wrote:
> > In 2.6.20 delayed_work was split from work_struct.  The concept of delayed
> > work was already there and schedule_delayed_work() hasn't changed.  I think
> > this can also be handled with a compat.h change that defines delayed_work
> > to work_struct.  That will only be a problem on pre 2.6.20 kernels if some
> > code decides to define identifiers named work_struct and delayed_work in
> > the same scope.  There are currently no identifier named delayed_work in
> > any driver and one driver (sq905) has a structure member named
> > work_struct.  So I think it'll be ok.
>
> Wow, I didn't expect that many different compatibility issues. This
> goes beyond the time I am ready to spend on it, I'm afraid.

I already have a patch for compat.h that handles the last remaining issue.
You don't have to do anything.
