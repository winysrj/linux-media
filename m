Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1Kittj-0008Rv-Ub
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 18:41:00 +0200
Message-ID: <48DBBF0E.8030000@gmail.com>
Date: Thu, 25 Sep 2008 20:40:46 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Halim Sahin <halim.sahin@t-online.de>
References: <200809241922.16748@orion.escape-edv.de>	<1222306125.3323.80.camel@pc10.localdom.local>	<200809251254.59680@orion.escape-edv.de>	<20080925122857.GA7282@halim.local>
	<48DB99C5.3090704@gmail.com>	<20080925145019.GA10946@halim.local>
	<48DBA86D.9040206@gmail.com> <20080925160417.GA11821@halim.local>
In-Reply-To: <20080925160417.GA11821@halim.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [vdr] [v4l-dvb-maintainer]
	[Wanted]	dvb-ttpci	maintainer
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Halim Sahin wrote:
> Hi,
> On Do, Sep 25, 2008 at 07:04:13 +0400, Manu Abraham wrote:
>> Halim Sahin wrote:
>>> Hi,
>>>
>>> On Do, Sep 25, 2008 at 06:01:41 +0400, Manu Abraham wrote:
>>>> http://lwn.net/Articles/297301/
>>>  
>>> Please read this:
>>>
>>> http://www.linuxtv.org/pipermail/vdr/2008-January/015329.html
>>> You wrote the merge window is open for 2.6.25.
>>> We have now stable 2.6.26 and 2.6.27 is allmost ready.
>> As i wrote, fixes came in and had to be fixed. You can see the commit
>> history here:
>>
>> http://jusst.de/hg/multiproto/shortlog
>  
> Right 
> 
>> In between, i went for vacation due to my marriage. During that period i
>> had little access, but did whatever possible to get feedback/patches in
>> there, during whatever time and access i had.
> 
> During your vacation somebody else could ad patches if you 
> wanted to work with other developers.

If you see the logs, the last fix changeset 9039 was added while i was
away. Anyone can add patches to the tree, just that i need to pull back
the changes from that person.

For example: while i was away, somebody else did a clone of the same
tree and added the patches.

> This could only happen if you have your code under linuxtv.org and or
> merged it completely to v4l-dvb!

There are 2 development models, a centralized style (CVS/SVN etc) and a
distributed style (mercurial/git etc). The centralized model, offers a
CVS tree or a SVN tree to which multiple people have commit access to.

This was how the old DVB and dvb-kernel CVS trees worked. But this
centralized development model was phased out quite long back, in favour
of a distributed model.

The distributed development model works the same from any place. Person
A makes the changes to his local tree and those changes can be pulled in
to the working repository.

> You are the maintainer of multiproto and 
> So nobody could work on it in your absence time!

As i pointed out just above, somebody else did a clone of the tree and
added in some changes that people sent to the ML. I can pull in those
changes as what is applicable from that tree. This is how distributed
development works.

> Sorry this sounds not ok to me.

I don't have any problem in using whatever SCM, but it makes it a little
bit easier for the user to have some similarities between development
trees. Maybe if more people are for a centralized repository, then
people should voice concern as to change the SCM. This has nothing to do
with me.

> Anyway the problem is nobody should leave linuxtv.org project. 
> We should now stop this and go on.
> Please !!!!!!!!!
> Thanks for your great work!


Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
