Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:38217 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab0ASKES (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 05:04:18 -0500
Received: by fxm25 with SMTP id 25so361785fxm.21
        for <linux-media@vger.kernel.org>; Tue, 19 Jan 2010 02:04:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B55445A.10300@infradead.org>
References: <4B55445A.10300@infradead.org>
Date: Tue, 19 Jan 2010 05:04:13 -0500
Message-ID: <829197381001190204l3df81904gf8586f36187f212d@mail.gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

I find it somewhat unfortunate that this is labeled "ANNOUNCE" instead
of "RFC".  It shows how little you care about soliciting the opinions
of the other developers.  Rather than making a proposal for how the
process can be improved and soliciting feedback, you have chosen to
decide for all of us what the best approach is and how all of us will
develop in the future.

I know you'll continue to receive alot of "thank you" and ""great job"
comments from some of the developers who have been pushing for this,
so I'll be the "bad guy" and point out the downsides to what you are
proposing.

First off, I would like to note that I have absolutely no problem with
git.  I think it's a great tool and I use it for other projects.  If
the question today was "which source control software to use", I have
no doubt I would choose git over mercurial.  I've used a variety of
different source control systems both open source and commercial, and
git is a really good tool.

That said, my real problem is with the change requiring all the active
developers to be developing on the latest Linux kernel.

Before I renew my arguments, I will openly acknowledge that your
approach does make numerous things easier.  I have little doubt that
it will make merging easier for you personally, as well as addresses
issues with patches that have architecture specific changes (or other
changes that are outside of the current v4l-dvb tree).

So let's talk about why this is bad....

I want to focus my development on v4l-dvb.  That said, I want a stable
codebase on which I can write v4l-dvb drivers, without having to worry
about whether or not my wireless driver is screwed up this week, or
whether the ALSA guys broke my audio support for the fifth time in two
years.  I don't want to wonder whether the crash I just experienced is
because they've replaced the scheduler yet again and they're still
shaking the bugs out.  I don't want to be at the mercy of whatever ABI
changes they're doing this week which break my Nvidia card (and while
I recognize as open source developers we care very little about
"closed source drivers", we shouldn't really find it surprising that
many developers who are rendering HD video might be using Nvidia
cards).

Like most smart developers, I want to have a *controlled* environment
where I can be confident that if a problem arises that it's *my*
changes at fault.  Any time that I spend trying to figure out why my
PC doesn't work is time that I'm not debugging v4l-dvb drivers.

And *THAT* is why it's critical that the mainline not be treated as
"alpha quality" like you suggested last week.  For example, when you
check in alpha code that causes an OOPS whenever any tuner with IR
support is plugged in, I waste several hours debugging the regression
you introduced instead of doing my own work.

Further, we're also changing from a system where we build a relatively
small tree of modules to one where we're going to be
building/installing entire kernels.  Even on my relatively recent
hardware, this is process that takes upwards to an hour (and yes, I do
have ccache).  Even a "make modules_install" can several minutes.  So
now I'm going from being able to "make && make install && make unload"
twenty times an hour to a *MUCH* slower process.

We're giving up the ability to have a fast "debug->compile->test"
cycle for developers in exchange for easier merging of the final
result.  This seems like a poor optimization choice for those of us
who spend all day compiling, debugging, and testing.

Personally, I spend about 98% of my time actively debugging code, and
about 2% of my time dealing with merge issues.  So I *really* care
about things like how long it takes to compile and install the tree.

I hope other developers will offer their opinions on this approach,
since it's all of us who will pay the price in time as a result of
this change.  If all the developers who are writing the code think
it's a good idea to be half as efficient in order to make the merging
easier for one person, then so be it.

The point I'm trying to make is that we need to be having a discussion
about what we are optimizing for, and what are the costs to other
developers.  This is why I'm perhaps a bit pissed to see an
"announcement" declaring how development will be done in the future as
opposed to a discussion of what we could be doing and what are the
trade-offs.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
