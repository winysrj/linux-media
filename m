Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63457 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1KEKLA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Nov 2011 06:11:00 -0400
Received: by faao14 with SMTP id o14so3443532faa.19
        for <linux-media@vger.kernel.org>; Sat, 05 Nov 2011 03:10:58 -0700 (PDT)
Date: Sat, 5 Nov 2011 11:10:50 +0100
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: James <bjlockie@lockie.ca>
Cc: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: femon signal strength
Message-ID: <20111105111050.5b8762fa@grobi>
In-Reply-To: <4EA86668.6090508@lockie.ca>
References: <4EA78E3C.2020308@lockie.ca>
	<CAGoCfiwS=O75uyaaueNSrq275MS9eednR+Y=yrgsJo0XaExRKA@mail.gmail.com>
	<4EA86366.1020906@lockie.ca>
	<CAGoCfiww_5pF_S3M_mpN4gk1qqLYn7H7PPcieZXZNnjvK-RHHA@mail.gmail.com>
	<4EA86668.6090508@lockie.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 26 Oct 2011 15:58:32 -0400
James <bjlockie@lockie.ca> wrote:

> On 10/26/11 15:49, Devin Heitmueller wrote:
> > On Wed, Oct 26, 2011 at 3:45 PM, James<bjlockie@lockie.ca>  wrote:
> >> How many different formats are there (do I have to go through the
> >> archive)? Would it be feasable to change femon to handle different
> >> formats?
> > There are three or four common formats, and there is no real way for
> > an application to know which format was used unless it perhaps
> > hard-codes some table of demodulator driver names into the source
> > (which by the way will cause breakage if efforts are made to change
> > the demods to use a common format).
> >
> > Devin
> >
> I was thinking of a table. :-)
> 
> How about adding switches to femon, it won't be automatic?
> 
> I'm going to make femon work for my card, anyways. :-)

This is no solution - drivers should be patched to deliver result in
common format. femon is not the only application reading this values.
And every application carrying its own set of correction tables doesn't
help in any way. Shouldn't be to hard to agree on one scale and scale
whatever value to that in reporting the signal strength.
