Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1948 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751738AbZBDCCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 21:02:45 -0500
Date: Tue, 3 Feb 2009 21:02:44 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: kilgota@banach.math.auburn.edu
cc: Jean-Francois Moine <moinejf@free.fr>,
	Adam Baker <linux@baker-net.org.uk>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
In-Reply-To: <alpine.LNX.2.00.0902031551020.2103@banach.math.auburn.edu>
Message-ID: <Pine.LNX.4.44L0.0902032059120.18064-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Feb 2009 kilgota@banach.math.auburn.edu wrote:

> > Nonsense.  It's simply a matter of how you create your workqueue.  In
> > the code you sent me, you call create_workqueue().  Instead, just call
> > create_singlethread_workqueue().  Or maybe even
> > create_freezeable_workqueue().
> >
> > Alan Stern
> >
> 
> OK, seems one way out, might even work. I will definitely try that.
> 
> Update. I did try it.
> 
> No it does not work, sorry. :/

Again, nonsense.  Of course it works.  It causes the kernel to create
only one workqueue thread instead of two.  That's what it's supposed to
do -- it was never intended to fix your oops.

> While you have this matter on your mind, I am curious about the following:
> 
> As the code for the sq905 module evolved through various stages, the 
> only occasion on which any real trouble arose was at the end, when we put 
> in the mutex locks which you can see in the code now. Before they were put 
> in, these problems which we are discussing now did not occur. 
> Specifically, there was not any such problem about an oops caused by 
> camera removal until the mutex locks were put in the code. And I strongly 
> suspect -- nay, I am almost certain -- that with that the same code you 
> are looking at now, the oops would go away if all those mutex locks were 
> simply commented out and the code re-compiled and reinstalled. Can you 
> explain this? I am just curious about why.

You're wrong, the oops would not go away.  It would just become a lot 
less likely to occur -- and thereby all the more insidious.

Alan Stern

