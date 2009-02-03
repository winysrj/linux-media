Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:40482 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZBCTmW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 14:42:22 -0500
Date: Tue, 3 Feb 2009 13:54:15 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Jean-Francois Moine <moinejf@free.fr>
cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
In-Reply-To: <20090203202307.0ae074ec@free.fr>
Message-ID: <alpine.LNX.2.00.0902031343030.1944@banach.math.auburn.edu>
References: <200901192322.33362.linux@baker-net.org.uk> <200901272101.27451.linux@baker-net.org.uk> <alpine.LNX.2.00.0901271543560.21122@banach.math.auburn.edu> <200901272228.42610.linux@baker-net.org.uk> <20090128113540.25536301@free.fr>
 <alpine.LNX.2.00.0901281554500.22748@banach.math.auburn.edu> <20090131203650.36369153@free.fr> <alpine.LNX.2.00.0902022032230.1080@banach.math.auburn.edu> <20090203103925.25703074@free.fr> <alpine.LNX.2.00.0902031115190.1706@banach.math.auburn.edu>
 <alpine.LNX.2.00.0902031210320.1792@banach.math.auburn.edu> <20090203191311.2c1695b7@free.fr> <alpine.LNX.2.00.0902031302060.1882@banach.math.auburn.edu> <20090203202307.0ae074ec@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 3 Feb 2009, Jean-Francois Moine wrote:

> On Tue, 3 Feb 2009 13:15:58 -0600 (CST)
> kilgota@banach.math.auburn.edu wrote:
>
>>> Why is there 2 sq905 processes?
>>
>> I of course do not fully understand why there are two such processes.
>> However, I would suspect that [sq905/0] is running on processor 0 and
>> [sq905/1] is running on processor 1. As I remember, there is only one
>> [sq905] process which runs on a single-core machine.
>
> Indeed, the problem is there! You must have only one process reading the
> webcam! I do not see how this can work with these 2 processes...

The problem, then, would seem to me to boil down to the question of 
whether that is up to us. Apparently, a decision like that is not up to 
us, but rather it is up to the compiler and to the rest of the kernel to 
decide. Which, incidentally, appears to me to be a very logical way to 
arrange things. Presumably, a dual- or multi-core machine gives certain 
advantages, or it ought to, but it also requires certain accommodations.

You know, Jean-Francois, in a way it is a lucky accident that I got this 
machine for Christmas. I would never have fired up the Pentium 4, at least 
until sometime in the unforeseeable future, because in fact I was getting 
quite adequate performance out of the old Sempron box. Thus, I would not 
have been aware of this problem, either. We would have gone right ahead, 
Adam and I, blissfully ignorant, and published a module which has a flaw 
on a dual-core machine. So, in spite of the problems I say it is better to 
face the problems now.

Theodore Kilgore
