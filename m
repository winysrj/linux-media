Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55729 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab0COEPm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 00:15:42 -0400
Received: by bwz1 with SMTP id 1so2572177bwz.21
        for <linux-media@vger.kernel.org>; Sun, 14 Mar 2010 21:15:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4B9D23DD.8080401@mailbox.hu>
References: <4B3F6FE0.4040307@internode.on.net> <4B463AC6.2000901@mailbox.hu>
	 <4B719CD0.6060804@mailbox.hu> <4B745781.2020408@mailbox.hu>
	 <4B7C303B.2040807@mailbox.hu> <4B7C80F5.5060405@redhat.com>
	 <829197381002171559k10b692dcu99a3adc2f613437f@mail.gmail.com>
	 <4B7C84F3.4080708@redhat.com>
	 <829197381002171611u7fcc8caeuea98e047164ae55@mail.gmail.com>
	 <4B9D23DD.8080401@mailbox.hu>
Date: Mon, 15 Mar 2010 00:15:40 -0400
Message-ID: <829197381003142115v6b10a328n30eadeef64b87c8@mail.gmail.com>
Subject: Re: [PATCH] DTV2000 H Plus issues
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 14, 2010 at 1:58 PM, istvan_v@mailbox.hu
<istvan_v@mailbox.hu> wrote:
> On 02/18/2010 01:11 AM, Devin Heitmueller wrote:
>
>> Yeah, my plan at this point was to submit a PULL request once I felt
>> the driver is stable
>
> For those particular cards that my patch adds support for, it seems to
> be stable, and I have been using it for months. Perhaps stability issues
> in xc4000.c are specific to the PCTV 340e and its dib0700 I2C problems ?

Different people have different standards of quality.  For example,
I've done essentially no analysis into the tuning performance of the
current driver - validating different frequency ranges and modulation
types or bandwidths.  I've done no testing of tuning lock time,
minimal application validation, and no effort toward making sure the
power management works.

Sure, I can just throw the driver upstream as-is, but I've been
hesitant to merge something with questionable quality, as it reflects
poorly on my reputation.  Right now it's in a development tree because
it's what I would consider "alpha quality", where only advanced users
will install it and they know to "proceed at your own risk".

And none of the above is related to the problem with the dib0700 i2c master.

All that said, the situation hasn't been helped by the fact that I'm
working on five different projects currently (as102, drx-d, xc4000,
em28xx, and now ngene), nor the fact that I'm also the maintainer for
a variety of other tuner products (and the significant support burden
that creates).

Bear in mind that I am aware of the frustration that when someone has
patches and cannot get the maintainer to find the time to
review/comment/merge.  I've been in that situation myself more than
once.

I'll try to go through my tree and see if I can get something upstream
this week which you could build on.  Once that is done, you will need
to break up your huge patch into a series of small incremental patches
(with proper descriptions for the changes), since there is no way a
single patch is going to be accepted upstream which has all of your
changes.

Also, you should *not* be submitting board profiles that are
completely unvalidated.  I saw your email on Feb 19th, where you
dumped out a list of tuners that you think might *possibly* work.  You
should only submit board definitions for devices that either you have
tested or you have gotten a user to test.  It is far worse to have
broken code in there (creating the illusion of a product being
supported), then for there to be no support at all.  When users
complain about a particular board not working, you can work with them
to get it supported.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
