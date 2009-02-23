Return-path: <linux-media-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.177]:25990 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbZBWW64 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 17:58:56 -0500
Received: by el-out-1112.google.com with SMTP id b25so1126514elf.1
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2009 14:58:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090223224851.GA15032@opus.istwok.net>
References: <20090218051945.GA12934@opus.istwok.net>
	 <20090218153422.GC15359@opus.istwok.net>
	 <20090219162820.GA23759@opus.istwok.net> <49A1A8E4.8030307@rogers.com>
	 <20090223183946.GA13608@opus.istwok.net>
	 <49A2F3D0.9080508@linuxtv.org>
	 <20090223201054.GA14056@opus.istwok.net>
	 <49A31AE5.5030801@linuxtv.org>
	 <412bdbff0902231403o3280709aq323f94a0a6acc5d0@mail.gmail.com>
	 <20090223224851.GA15032@opus.istwok.net>
Date: Mon, 23 Feb 2009 17:58:54 -0500
Message-ID: <412bdbff0902231458x41c1298cv4fd15d1f0bf5600d@mail.gmail.com>
Subject: Re: PVR x50 corrupts ATSC 115 streams
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: David Engel <david@istwok.net>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
	V4L <video4linux-list@redhat.com>, CityK <cityk@rogers.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 23, 2009 at 5:48 PM, David Engel <david@istwok.net> wrote:
> The BER isn't totally unreliable.  Yes, when it's low, it does seem to
> be meaningless.  However, when it's high, as in my recent attempts to
> try a 115 by itself, it indicates that nothing will work.

Maybe I am missing something.  Your last summary said you had a high
BER even the 115 is the only card in the system.  That would lead me
to believe that it's always screwed up.

> I tried separating the cards as far as possible.  I tried shoving a
> small manual (~1/8 inch thick) between the 115 cards and the x50 cards
> to shield them.  Neither action had any effect.  Also, one of the
> tests I tried yesterday had the HDTV5 between the 115 and the x50s.
> The 115 showed corruption and the HDTV5 didn't even though it was
> nearest to the x50s.

Different cards interfere with each other in different ways (based on
things such as the PCB layout).  The fact that the HDTV5 doesn't have
issues doesn't really mean *anything*.  Same goes for the fact that
it's BER indicator is always zero.  That could just as easily indicate
that the BER checking is properly implemented for that particular
demod.

Anyway, I don't have the card and all my suggestions were very
general.  If you can't find a developer with the card willing to debug
the issue then you're probably SOL.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
