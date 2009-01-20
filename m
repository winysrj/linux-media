Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:45874 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbZATPY7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 10:24:59 -0500
Received: by qyk4 with SMTP id 4so3455612qyk.13
        for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 07:24:52 -0800 (PST)
Message-ID: <412bdbff0901200724v1c981f45te3558256571597a6@mail.gmail.com>
Date: Tue, 20 Jan 2009 10:24:47 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: ajurik@quick.cz
Subject: Re: [linux-dvb] Cross-posting linux-media, linux-dvb etc
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <200901200956.25104.ajurik@quick.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LRH.1.10.0901161545540.28478@pub2.ifh.de>
	 <20090119204724.01826924@caramujo.chehab.org>
	 <003101c97ada$168d54b0$f4c6a5c1@tommy>
	 <200901200956.25104.ajurik@quick.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I spent the morning giving some consideration to the comments people
made regarding the merging of the mailing lists.  As with most
attempts at an optimization, there are cases that get more efficient
and cases that get less efficient.  If done properly, the important
cases improve in efficiency while the cases that are less critical end
up a little less efficient.

Clearly, there are two classes of users on the mailing lists:  those
who read it and those who read it *and* actively contribute to it.
One of the key goals behind merging the lists was to make it more
efficient for those who have to reply to emails to not have to deal
with duplicated content, since in reality a large portion of the
emails come from people who want their device to work, and don't even
know the differences between acronyms like ATSC, QAM, DVB-T, DVB-C,
analog, etc.

Looking at the people who have responded to this thread, and the
number of threads they have actually contributed on in the last year,
the disparity is obvious:

People "in favor" of the lists being merged
118 Patrick Boettcher
205 Hans Verkuil
38 Mike Isely
196 Devin Heitmueller
"hundreds" Mauro Carvalho Chehab

People "against" of the lists being merged
2 Lars Hanisch
17 user.vdr
16 Klaus Schmidinger
2 Bob Cunningham
10 Tomas Drajsajtl
17 Ales Jurik

Yup, it's the developers who are posting on a regular basis who feel
the pain of the two different lists.  It's the people who are actively
replying to issues, dealing with problems, and trying to keep track of
it all who want the lists merged.  That said, I personally don't feel
any guilt in inconveniencing a few users who are not contributing if
it makes it easier for the people who contribute to the list on a
daily basis.

I would love to hear more from people who have contributed to more
than 20 threads who think having the two lists are a good idea.  I
doubt there will be many of them.

I was also giving some thought to the notion of a having separate
lists for users versus developers.  While this works in some
communities, I am not confident it would be appropriate for ours.
Why?  Because the notion of a "users" list is only useful in cases
where you have a large pool of users who are willing to answer
questions for others.  Look at the back history of the v4l and
linux-dvb lists, and that is nowhere to be found (aside from a few
people like CityK).  The vast majority of questions are answered by a
handful of developers, and it is no more convenient for those
developers to have separate lists.  In fact, it's less convenient
since it results in the developers being required to watch both lists.
 Think of all the projects where the "-dev" list is high traffic, but
almost all of the traffic on the "-users" list goes unanswered.

Do you want a separate users list and you're not a developer?  If so,
volunteer to help out by answering other people's emails if you know
the answer.  CityK is a shining example of this - every email he
answers about one of the devices I did the driver for is an email I
don't have to answer myself, which allows me to spend more time
writing drivers.  If we see lots of users helping each other out by
answering the questions of other users, only then will I see a
"-users" list as a sustainable idea that is worth pursuing.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
