Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:56837 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbZBCTEG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 14:04:06 -0500
Date: Tue, 3 Feb 2009 13:15:58 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Jean-Francois Moine <moinejf@free.fr>
cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
In-Reply-To: <20090203191311.2c1695b7@free.fr>
Message-ID: <alpine.LNX.2.00.0902031302060.1882@banach.math.auburn.edu>
References: <200901192322.33362.linux@baker-net.org.uk> <200901272101.27451.linux@baker-net.org.uk> <alpine.LNX.2.00.0901271543560.21122@banach.math.auburn.edu> <200901272228.42610.linux@baker-net.org.uk> <20090128113540.25536301@free.fr>
 <alpine.LNX.2.00.0901281554500.22748@banach.math.auburn.edu> <20090131203650.36369153@free.fr> <alpine.LNX.2.00.0902022032230.1080@banach.math.auburn.edu> <20090203103925.25703074@free.fr> <alpine.LNX.2.00.0902031115190.1706@banach.math.auburn.edu>
 <alpine.LNX.2.00.0902031210320.1792@banach.math.auburn.edu> <20090203191311.2c1695b7@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 3 Feb 2009, Jean-Francois Moine wrote:

> On Tue, 3 Feb 2009 12:21:55 -0600 (CST)
> kilgota@banach.math.auburn.edu wrote:
>
>> I should add to the above that now I have tested, and indeed this
>> change does not solve the problem of kernel oops after disconnect
>> while streaming. It does make one change. The xterm does not go wild
>> with error messages. But it is still not possible to close the svv
>> window. Moreover, ps ax reveals that [svv] is running as an
>> unkillable process, with [sq905/0] and [sq905/1], equally unkillable,
>> in supporting roles. And dmesg reveals an oops. The problem is after
>> all notorious by now, so I do not see much need for yet another log
>> of debug output unless specifically asked for such.
>
> Why is there 2 sq905 processes?

I of course do not fully understand why there are two such processes. 
However, I would suspect that [sq905/0] is running on processor 0 and 
[sq905/1] is running on processor 1. As I remember, there is only one 
[sq905] process which runs on a single-core machine.

>
> What is the oops? (Your last trace was good, because it gave the last
> gspca/sq905 messages and the full oops)

Well, I can do it again, I suppose. So you get that in a few minutes. But 
my private speculation is it will look just about like the last one, 
because the problem is not addressed.


>
>> Perhaps we also need to do what Adam suggested yesterday, and add a
>> call to destroy_urbs() in gspca_disconnect()?
>
> Surely not! The destroy_urbs() must be called at the right time, i.e.
> on close().

Hmmm. well, the problem is that we are down there in a workqueue. We have 
to force the workqueue to close. I do not see a way to do that, even with 
the exit routines at the end of the workqueue, if it is not possible to 
call upon the functions there which will do the job (and it appears to me 
it is not thus possible, because those gspca functions are not public). 
And if we try to close the workqueue without doing something like 
destroy_urbs() as a consequence of a violent disconnect, then the 
workqueue just does not understand it is supposed to stop and merrily goes 
on its way in spite of all. Then it can not be closed because it is "busy" 
talking to a now-nonexistent piece of hardware, and the calling program 
can not be closed, either, because it is "busy" as well.

Unless I get interrupted by something extraneous, I should have a log sent 
along in a few minutes. God knows, it is easy enough to create one.

Theodore Kilgore
