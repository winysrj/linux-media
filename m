Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45861 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2FROhA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 10:37:00 -0400
Received: by obbtb18 with SMTP id tb18so8555859obb.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 07:36:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340029964.23706.4.camel@obelisk.thedillows.org>
References: <1339994998.32360.61.camel@obelisk.thedillows.org>
	<201206180929.48107.hverkuil@xs4all.nl>
	<1340028940.32360.70.camel@obelisk.thedillows.org>
	<CAGoCfize92S-8cR9f-RjQDcZARKiT84UtX-oH0EcPomCYFAyxQ@mail.gmail.com>
	<1340029964.23706.4.camel@obelisk.thedillows.org>
Date: Mon, 18 Jun 2012 10:36:59 -0400
Message-ID: <CAGoCfix48wNUBRuUbehjSHpqV33D68AA7mBy_4zu22JWTkbcmQ@mail.gmail.com>
Subject: Re: [RFC] [media] cx231xx: restore tuner settings on first open
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: David Dillow <dave@thedillows.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 18, 2012 at 10:32 AM, David Dillow <dave@thedillows.org> wrote:
> Hmm, it sounds like perhaps changing the standby call in the tuner core
> to asynchronously power down the tuner may be the way to go -- ie, when
> we tell it to standby, it will do a schedule_work for some 10 seconds
> later to really pull it down. If we get a resume call prior to then,
> we'll just cancel the work, otherwise we wait for the work to finish and
> then issue the resume.
>
> Does that sound reasonable?

At face value it sounds reasonable, except the approach breaks down as
soon as you have hybrid tuners which support both analog and digital.
Because the digital side of the tuner isn't tied into tuner-core,
you'll break in the following situation:

Start using analog
Stop using analog [schedule_work() call]
Start using digital
Timer pops and powers down the tuner even though it's in use for ATSC
or ClearQAM

Again, I'm not proposing a solution, but just poking a fatal hole in
your proposal (believe me, I had considered the same approach when
first looking at the problem).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
