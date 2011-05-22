Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60422 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab1EVDgp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 23:36:45 -0400
Received: by ewy4 with SMTP id 4so1505590ewy.19
        for <linux-media@vger.kernel.org>; Sat, 21 May 2011 20:36:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimcqrz3ExwT_TH_AG0zue7YRfTDeg@mail.gmail.com>
References: <BANLkTin=Fs-ugm13yT89PtT4bds4WobszA@mail.gmail.com>
	<BANLkTi=poXh2q+4N6Q9iMJxoW=9txLjt4w@mail.gmail.com>
	<BANLkTimQGYqS=PRNJSEtL5Wu0rP3YdEOVg@mail.gmail.com>
	<BANLkTimOUFgBKx5Y4VE+v08SMVB+Ms5RBg@mail.gmail.com>
	<BANLkTimcqrz3ExwT_TH_AG0zue7YRfTDeg@mail.gmail.com>
Date: Sat, 21 May 2011 23:36:43 -0400
Message-ID: <BANLkTi=_4oFV9Mfbcvf49zqKN2HEtaYLfA@mail.gmail.com>
Subject: Re: Connexant cx25821 help
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Roman Gaufman <hackeron@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, May 21, 2011 at 11:22 PM, Roman Gaufman <hackeron@gmail.com> wrote:
>> 1.  Find some developer who cares enough to take a free board just for
>> the fun of making it work.
>
> Any suggestions where?

You're already in the right place.  Unfortunately, finding a developer
willing to spend ten or twenty hours when they don't have anything to
gain personally is a bit of a challenge.

>> 2.  If you're a commercial entity, hire somebody to do the work
>> (Kernel Labs does this sort of work)
>
> I have a small company that consists of just me and I'm broke, heh,
> but I'll check out kernel labs thanks!
>
>> 3.  Learn enough about driver development to add the support yourself.
>
> Any suggestions where/how to start? - are there any guides/tutorials
> that show how to go from start to finish getting a board to work?

Fortunately, there are dozens of other drivers to look at as examples.
 That said, there aren't really any examples explaining the full
process (as the process varies considerably depending on the design of
the board as well, what chips it uses, and what drivers are already
written).

This might be a decent article for you to read, although you don't
need to worry about the aspects related to the actual tuner frontend
since the cx25821 designs only do CVBS/S-video capture.

How Tuners Work…
http://www.kernellabs.com/blog/?p=1045

>> The reality is that the LinuxTV project is grossly understaffed
>> already, and if you're a regular user who wants a working product,
>> your best bet is to just buy something that is already supported.  All
>> other options require either a considerable investment in money (to
>> pay someone to do the work), or time (to learn how to do it yourself).
>
> Do you have any recommendations for a DVR card that has 8 or 16
> audio+video inputs that's already supported by linux available for
> sale?

Nope.  You've entered the realm of "things that only companies care
about".  Regular users don't care about capture boards with lots of
inputs.  The closest I can suggest is the Viewcast 450e, which can mux
12 video inputs muxed across four actual capture ports.  Kernel Labs
did a project for them last year, and it does work although the code
is not yet in the upstream kernel.

Good luck!

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
