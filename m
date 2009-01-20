Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:61957 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758863AbZATUHc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 15:07:32 -0500
Subject: Re: [linux-dvb] Cross-posting linux-media, linux-dvb etc
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: ajurik@quick.cz, linux-dvb@linuxtv.org
In-Reply-To: <412bdbff0901200724v1c981f45te3558256571597a6@mail.gmail.com>
References: <alpine.LRH.1.10.0901161545540.28478@pub2.ifh.de>
	 <20090119204724.01826924@caramujo.chehab.org>
	 <003101c97ada$168d54b0$f4c6a5c1@tommy> <200901200956.25104.ajurik@quick.cz>
	 <412bdbff0901200724v1c981f45te3558256571597a6@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 15:06:58 -0500
Message-Id: <1232482018.3063.44.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-01-20 at 10:24 -0500, Devin Heitmueller wrote:
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
> the pain of the two different lists.

Just to interject, I feel the pain of at least 4/5 lists right now:

   video4linux, linux-dvb, linux-media, ivtv-users, ivtv-devel

So any reduction in the number of lists suits me just fine, but not for
reasons of personal mail management, but for distribution of information
to a wide audience.

For example, to reach all the cx18 users, to let them know of a change
that may impact them without any testing feedback, I have to "broadcast"
to all the lists except the ivtv-devel list.  Then unfortunatley
feedback from users, who for some reason or another can't/don't post to
the other lists, is missed by users on the other lists.

I like the lists for the interactive creation/accumulation of knowledge
about a particular device or subsystem.  Subsystem (dvb, v4l)
information will likely rarely crosses list topic boundaries, but device
information will probably do so much more often due to hybrid cards,
silicon tuners, etc.

So on the "intake" of information

1) a single list helps for consolidation of knowledge, but doesn't help
organization - that must be done later

2) multiple lists help for organization of knowledge, but don't help
with consolidation of knowledge on related details from the separate
lists - that must be done later


So between the two postprocessing activites in the above -
organization/sorting once it hits the single list; or searching or
consolidating, from separate lists, knowledge on a related detail -

a) which provides the most benefit on the amount to work done?  (Who
benefits? who does the work?)

b) which scheme produces/amasses "higher quality" knowledge for the
least amount of work?

 
(I'm not going to provide an answer for those, but I will note that the
LKML appears to host discussions on many subsystems in the Linux Kernel
in one list.  So I suspect there is some benefit to amassed, but
unsorted knowledge.)


>   It's the people who are actively
> replying to issues, dealing with problems, and trying to keep track of
> it all who want the lists merged.  That said, I personally don't feel
> any guilt in inconveniencing a few users who are not contributing if
> it makes it easier for the people who contribute to the list on a
> daily basis.
> 
> I would love to hear more from people who have contributed to more
> than 20 threads who think having the two lists are a good idea.  I
> doubt there will be many of them.

It seems like to cut the baby in half would be to have multiple separate
users lists and one consolidated devel list.  (We had a three list
configuration before, but development requests/bug reports from users
were rarely discussed on the v4l-dvb-maintainers' list as it wasn't
billed to the public on the linuxtv.org site.) 



> I was also giving some thought to the notion of a having separate
> lists for users versus developers.  While this works in some
> communities, I am not confident it would be appropriate for ours.
> Why?  Because the notion of a "users" list is only useful in cases
> where you have a large pool of users who are willing to answer
> questions for others.  Look at the back history of the v4l and
> linux-dvb lists, and that is nowhere to be found (aside from a few
> people like CityK).  The vast majority of questions are answered by a
> handful of developers, and it is no more convenient for those
> developers to have separate lists.  In fact, it's less convenient
> since it results in the developers being required to watch both lists.
>  Think of all the projects where the "-dev" list is high traffic, but
> almost all of the traffic on the "-users" list goes unanswered.
> 
> Do you want a separate users list and you're not a developer?  If so,
> volunteer to help out by answering other people's emails if you know
> the answer.  CityK is a shining example of this - every email he
> answers about one of the devices I did the driver for is an email I
> don't have to answer myself, which allows me to spend more time
> writing drivers.  If we see lots of users helping each other out by
> answering the questions of other users, only then will I see a
> "-users" list as a sustainable idea that is worth pursuing.

Based on my experience with the ivtv-user and ivtv-devel list, these are
my personal, subjective observations (Hans may have a different
opinions):

1) as software for a device becomes more stable, dev list message rate
for that device drops off and user list traffic picks up.   In this
case, most problems become userland app or system configuration
problems, with which many users can help, if they desire.

2) I believe the converse of 1) is true as well: the less reliable the
driver software for a device, the higher the traffic on the devel list
and the less traffic on the users list.  Problems that only developers
are likely to address are common.

3) When you have a devel/user list separation, the on-topic devel list
messages are clear red flags that get developer attenion.

4) Even when you have a good users list, you're still only looking at a
small handful of dedicated users that answer a bulk of the questions.

Regards,
Andy

> Devin


