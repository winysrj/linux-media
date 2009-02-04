Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:53329 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZBDDAl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 22:00:41 -0500
Date: Tue, 3 Feb 2009 21:12:35 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Alan Stern <stern@rowland.harvard.edu>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
In-Reply-To: <Pine.LNX.4.44L0.0902032059120.18064-100000@netrider.rowland.org>
Message-ID: <alpine.LNX.2.00.0902032110390.2641@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.0902032059120.18064-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 3 Feb 2009, Alan Stern wrote:

> On Tue, 3 Feb 2009 kilgota@banach.math.auburn.edu wrote:
>
>>> Nonsense.  It's simply a matter of how you create your workqueue.  In
>>> the code you sent me, you call create_workqueue().  Instead, just call
>>> create_singlethread_workqueue().  Or maybe even
>>> create_freezeable_workqueue().
>>>
>>> Alan Stern
>>>
>>
>> OK, seems one way out, might even work. I will definitely try that.
>>
>> Update. I did try it.
>>
>> No it does not work, sorry. :/
>
> Again, nonsense.  Of course it works.  It causes the kernel to create
> only one workqueue thread instead of two.

OK, yes, it did do that.

That's what it's supposed to
> do -- it was never intended to fix your oops.

OK.

>
>> While you have this matter on your mind, I am curious about the following:
>>
>> As the code for the sq905 module evolved through various stages, the
>> only occasion on which any real trouble arose was at the end, when we put
>> in the mutex locks which you can see in the code now. Before they were put
>> in, these problems which we are discussing now did not occur.
>> Specifically, there was not any such problem about an oops caused by
>> camera removal until the mutex locks were put in the code. And I strongly
>> suspect -- nay, I am almost certain -- that with that the same code you
>> are looking at now, the oops would go away if all those mutex locks were
>> simply commented out and the code re-compiled and reinstalled. Can you
>> explain this? I am just curious about why.
>
> You're wrong, the oops would not go away.  It would just become a lot
> less likely to occur -- and thereby all the more insidious.

How nice. Thanks for explaining.

>
> Alan Stern
>
