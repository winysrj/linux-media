Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f66.google.com ([209.85.214.66]:54142 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1KFT7S (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 14:59:18 -0500
Received: by bkbzt12 with SMTP id zt12so864366bkb.1
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 11:59:17 -0800 (PST)
Date: Sun, 6 Nov 2011 20:59:07 +0100
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: linux-media Mailing List <linux-media@vger.kernel.org>
Cc: James <bjlockie@lockie.ca>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: femon signal strength
Message-ID: <20111106205907.47b9102b@grobi>
In-Reply-To: <CAGoCfixoOwZumohwJrLVKhfpUNGYwbD9uSq7nM0GhqriOx0FxA@mail.gmail.com>
References: <4EA78E3C.2020308@lockie.ca>
	<CAGoCfiwS=O75uyaaueNSrq275MS9eednR+Y=yrgsJo0XaExRKA@mail.gmail.com>
	<4EA86366.1020906@lockie.ca>
	<CAGoCfiww_5pF_S3M_mpN4gk1qqLYn7H7PPcieZXZNnjvK-RHHA@mail.gmail.com>
	<4EA86668.6090508@lockie.ca>
	<20111105111050.5b8762fa@grobi>
	<CAGoCfiwC+7pkY6ZchySBYRkyY1XjFjKeJYQEPTc2ZiBN-pdoyw@mail.gmail.com>
	<20111106141515.5b56a377@grobi>
	<CAGoCfixoOwZumohwJrLVKhfpUNGYwbD9uSq7nM0GhqriOx0FxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 6 Nov 2011 10:01:49 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

> On Sunday, November 6, 2011, Steffen Barszus
> <steffenbpunkt@googlemail.com> wrote:
> > On Sat, 5 Nov 2011 15:38:50 -0400
> > Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> >
> >> On Saturday, November 5, 2011, Steffen Barszus
> >> <steffenbpunkt@googlemail.com> wrote:
> >> > On Wed, 26 Oct 2011 15:58:32 -0400
> >> > James <bjlockie@lockie.ca> wrote:
> >> >> How about adding switches to femon, it won't be automatic?
> >> >>
> >> >> I'm going to make femon work for my card, anyways. :-)
> >> >
> >> > This is no solution - drivers should be patched to deliver
> >> > result in common format. femon is not the only application
> >> > reading this values. And every application carrying its own set
> >> > of correction tables doesn't help in any way. Shouldn't be to
> >> > hard to agree on one scale and scale whatever value to that in
> >> > reporting the signal strength.
> >>
> >> You would think this would be relatively simple to get a consensus
> >> on. You would be wrong though.  I would suggest doing a search of
> >> the ML for "SNR" so you can see all. the history of the debate
> >> amongst the driver developers.
> >
> > I don't need to read the history of this and i am not even
> > interested in doing so. No matter what "The right solution" is,
> > showing the inability of acting as a team and putting the conflict
> > to the user is the worst solution you can achieve. Any uniform
> > scale is better, then whats there at the moment.
> >
> > Being ignorant in this respect is and was intended.
> 
> Yes, as a team the Linux v4l-dvb team very much resembles
> dysfunctional family.  And saying this as one of the developers, it
> is pretty embarrassing that we haven't been able to agree on a
> standard (and I've said on numerous occasions when discussing this
> issue that any standard that is uniform is better than no standard at
> all).  "Perfect is the enemy of good"

i know that and i didn't mention with any word _you_ should fix that.
However it needs to be fixed. 

> That said, when random users show up and berate the developers for not
> thinking of the user experience, my knee-jerk reaction is to think,
> "Fuck you.  You don't pay my salary and it's not my job to work on
> the things you think are important.  Submit you own patches if you
> think you can do better.". Obviously I don't say that because it
> isn't polite, but the core sentiment is accurate.

First i did not berate anyone. Second i don't care if you think about
user experience. I said don't put your conflicts to the user. Third I
don't tell you what to do. 

I just stated the obvious. 

Let me rephrase what i tried to say initially:

No please don't start patching femon for a single card, there are other
applications using this interface, which would possibly need to go the
same route, once this get started. Then there are applications which
wont do this (which i can understand, because its wrong). Suggestion
will be to patch/fix the driver - which in the end means that the fight
will be done at the back of the end user or people who try to make life
easier for them and for example putting together specialized linux
distributions. So from my perspective it means that beside this patches:

ftp://ftp.tvdr.de/vdr/Developer/Driver-Patches/

It will start to become more patches for the different cards, which i
get asked for to include it in my dkms package, or people start making
patches for vdr and other applications to do the same as suggested here,
which also end up at the same side. 

This is frustrating. Has my frustration been visible in my
mail ? Not impossible. But where else than on this list i could plead
for help in getting this fixed at the right place ? Devin i'm not asking
you to fix it, i'm writing to linux-media as i did in my initial mail. 

