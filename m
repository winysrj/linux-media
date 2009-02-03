Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51369 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751565AbZBCT7b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 14:59:31 -0500
Date: Tue, 3 Feb 2009 14:59:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: kilgota@banach.math.auburn.edu
cc: Jean-Francois Moine <moinejf@free.fr>,
	Adam Baker <linux@baker-net.org.uk>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
In-Reply-To: <alpine.LNX.2.00.0902031343030.1944@banach.math.auburn.edu>
Message-ID: <Pine.LNX.4.44L0.0902031457180.2272-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Feb 2009 kilgota@banach.math.auburn.edu wrote:

> 
> 
> On Tue, 3 Feb 2009, Jean-Francois Moine wrote:
> 
> > On Tue, 3 Feb 2009 13:15:58 -0600 (CST)
> > kilgota@banach.math.auburn.edu wrote:
> >
> >>> Why is there 2 sq905 processes?
> >>
> >> I of course do not fully understand why there are two such processes.
> >> However, I would suspect that [sq905/0] is running on processor 0 and
> >> [sq905/1] is running on processor 1. As I remember, there is only one
> >> [sq905] process which runs on a single-core machine.
> >
> > Indeed, the problem is there! You must have only one process reading the
> > webcam! I do not see how this can work with these 2 processes...
> 
> The problem, then, would seem to me to boil down to the question of 
> whether that is up to us. Apparently, a decision like that is not up to 
> us, but rather it is up to the compiler and to the rest of the kernel to 
> decide.

Nonsense.  It's simply a matter of how you create your workqueue.  In 
the code you sent me, you call create_workqueue().  Instead, just call 
create_singlethread_workqueue().  Or maybe even 
create_freezeable_workqueue().

Alan Stern

