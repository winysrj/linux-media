Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:51752 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZBCWMD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 17:12:03 -0500
Date: Tue, 3 Feb 2009 16:23:55 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Alan Stern <stern@rowland.harvard.edu>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
In-Reply-To: <Pine.LNX.4.44L0.0902031457180.2272-100000@iolanthe.rowland.org>
Message-ID: <alpine.LNX.2.00.0902031551020.2103@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.0902031457180.2272-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-1205166066-1233699835=:2103"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-1205166066-1233699835=:2103
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed



On Tue, 3 Feb 2009, Alan Stern wrote:

> On Tue, 3 Feb 2009 kilgota@banach.math.auburn.edu wrote:
>
>>
>>
>> On Tue, 3 Feb 2009, Jean-Francois Moine wrote:
>>
>>> On Tue, 3 Feb 2009 13:15:58 -0600 (CST)
>>> kilgota@banach.math.auburn.edu wrote:
>>>
>>>>> Why is there 2 sq905 processes?
>>>>
>>>> I of course do not fully understand why there are two such processes.
>>>> However, I would suspect that [sq905/0] is running on processor 0 and
>>>> [sq905/1] is running on processor 1. As I remember, there is only one
>>>> [sq905] process which runs on a single-core machine.
>>>
>>> Indeed, the problem is there! You must have only one process reading the
>>> webcam! I do not see how this can work with these 2 processes...
>>
>> The problem, then, would seem to me to boil down to the question of
>> whether that is up to us. Apparently, a decision like that is not up to
>> us, but rather it is up to the compiler and to the rest of the kernel to
>> decide.
>
> Nonsense.  It's simply a matter of how you create your workqueue.  In
> the code you sent me, you call create_workqueue().  Instead, just call
> create_singlethread_workqueue().  Or maybe even
> create_freezeable_workqueue().
>
> Alan Stern
>

OK, seems one way out, might even work. I will definitely try that.

Update. I did try it.

No it does not work, sorry. :/

I changed the line
dev->work_thread = create_workqueue(MODULE_NAME);

to read

dev->work_thread = create_singlethread_workqueue(MODULE_NAME);

As a result, I can definitely report that only _two_ processes were frozen 
when the cord was pulled, named [svv] and [sq905].

I am sure that the attached log file of the oops looks a little bit 
different from the previous ones. It must, after all.

While you have this matter on your mind, I am curious about the following:

As the code for the sq905 module evolved through various stages, the 
only occasion on which any real trouble arose was at the end, when we put 
in the mutex locks which you can see in the code now. Before they were put 
in, these problems which we are discussing now did not occur. 
Specifically, there was not any such problem about an oops caused by 
camera removal until the mutex locks were put in the code. And I strongly 
suspect -- nay, I am almost certain -- that with that the same code you 
are looking at now, the oops would go away if all those mutex locks were 
simply commented out and the code re-compiled and reinstalled. Can you 
explain this? I am just curious about why.

---863829203-1205166066-1233699835=:2103
Content-Type: APPLICATION/octet-stream; name=singlethread.txt.bz2
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.2.00.0902031623550.2103@banach.math.auburn.edu>
Content-Description: 
Content-Disposition: attachment; filename=singlethread.txt.bz2

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

---863829203-1205166066-1233699835=:2103--
