Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:54885 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569AbZATRq5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 12:46:57 -0500
Date: Tue, 20 Jan 2009 11:46:54 -0600 (CST)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: linux-media@vger.kernel.org
cc: ajurik@quick.cz, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Cross-posting linux-media, linux-dvb etc
In-Reply-To: <412bdbff0901200724v1c981f45te3558256571597a6@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901201048140.27310@cnc.isely.net>
References: <alpine.LRH.1.10.0901161545540.28478@pub2.ifh.de>
 <20090119204724.01826924@caramujo.chehab.org> <003101c97ada$168d54b0$f4c6a5c1@tommy>
 <200901200956.25104.ajurik@quick.cz> <412bdbff0901200724v1c981f45te3558256571597a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 20 Jan 2009, Devin Heitmueller wrote:

> I spent the morning giving some consideration to the comments people
> made regarding the merging of the mailing lists.  As with most
> attempts at an optimization, there are cases that get more efficient
> and cases that get less efficient.  If done properly, the important
> cases improve in efficiency while the cases that are less critical end
> up a little less efficient.
> 
> Clearly, there are two classes of users on the mailing lists:  those
> who read it and those who read it *and* actively contribute to it.
> One of the key goals behind merging the lists was to make it more
> efficient for those who have to reply to emails to not have to deal
> with duplicated content, since in reality a large portion of the
> emails come from people who want their device to work, and don't even
> know the differences between acronyms like ATSC, QAM, DVB-T, DVB-C,
> analog, etc.
> 
> Looking at the people who have responded to this thread, and the
> number of threads they have actually contributed on in the last year,
> the disparity is obvious:
> 
> People "in favor" of the lists being merged
> 118 Patrick Boettcher
> 205 Hans Verkuil

> 38 Mike Isely

I've contributed to 38 different threads in the past year?  Wow, I 
thought I had been staying mostly in the background...


> 196 Devin Heitmueller
> "hundreds" Mauro Carvalho Chehab
> 
> People "against" of the lists being merged
> 2 Lars Hanisch
> 17 user.vdr
> 16 Klaus Schmidinger
> 2 Bob Cunningham
> 10 Tomas Drajsajtl
> 17 Ales Jurik
> 
> Yup, it's the developers who are posting on a regular basis who feel
> the pain of the two different lists.  It's the people who are actively
> replying to issues, dealing with problems, and trying to keep track of
> it all who want the lists merged.  That said, I personally don't feel
> any guilt in inconveniencing a few users who are not contributing if
> it makes it easier for the people who contribute to the list on a
> daily basis.
> 
> I would love to hear more from people who have contributed to more
> than 20 threads who think having the two lists are a good idea.  I
> doubt there will be many of them.

   [...]

I don't have a strong preference about a -users and -dev split vs a 
single list.  It might be worth at least trying - one can always go 
back to a single list if the experiment fails.

Some have posted that they don't want to be bothered about all the "V4L 
noise" if they only care about DVB.  But look at this from a driver's 
viewpoint.  Some drivers aren't just V4L or just DVB - the pvrusb2 
driver, being that it handles a few hybrid devices, plays both sides of 
the fence, and some issues that may arise are not clearly obvious 
whether V4L or DVB is the correct topic.  So to which list does one 
expect to post?  (OK, maybe in my case it's the pvrusb2 list, but the 
question is still valid in the general sense and is only going to get 
more commonplace over time.)

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
