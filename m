Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38447 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab2AKDfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 22:35:51 -0500
Received: by vcbfk14 with SMTP id fk14so220007vcb.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 19:35:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F0CF395.1090002@gmail.com>
References: <4F0CF395.1090002@gmail.com>
Date: Tue, 10 Jan 2012 22:35:50 -0500
Message-ID: <CAGoCfiy_LOEO6+xcggFfMROaJ_65DLj4OKEZW9gaaSD8t=762Q@mail.gmail.com>
Subject: Re: Adding support for PCTV-80e Tuner
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Patrick Dickey <pdickeybeta@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 10, 2012 at 9:27 PM, Patrick Dickey <pdickeybeta@gmail.com> wrote:
> Hello everyone,
>
> A few months ago, I posted a 25-patch series on the PCTV-80e Tuner to
> the mailing list, which was nacked. I've since rewrote the patches, but
> have an issue that I need some advice with.  I took Devin's advice, and
> created two patches using his hg patches. The only modifications that I
> made were to remove the Makefile and Kconfig entries, and then to move
> the drivers to the staging/media/frontends/drx39xyj directory.
>
> I've got a couple of problems/questions, and am looking for opinions on
> how to deal with them. I included the mailing list in this, because
> there might be someone who's had similar issues, and because this issue
> might come up in the future with other projects.
>
> So, here are my problems.
>
> 1. If I try to make the media_git with just the two patches included, I
> get compilation errors in em28xx-cards.c. This is because it needs the
> drx39xxj.h file, which is in drivers/staging/media/frontends/drx39xyj
> (and hasn't been compiled).
>
> 2. If I add an entry into the drivers/media Makefile and Kconfig,
> pointing to the drvers/staging/media/frontends/drx39xyj directory, it
> fails to compile because drx39xxj.c requires dvb_frontend.h from
> drivers/media/dvb/dvb-core, which hasn't been compiled yet.
>
> The short question is how do I handle this situation?
>
> The longer questions are
>
> 1.  Do I make entries in the drx39xyj/Makefile and Kconfig that point
> back to the dvb/dvb-core directory (or add the drivers/dvb/ entry before
> the drivers/staging/media/frontends/drx39xyj/ entry in the
> Makefile/Kconfig entries in drivers/media/)?
>
> 2.  Do I submit my two patches, knowing that they will break compilation
> of the media_git tree at the em28xx-cards.c file?
>
> 3.  Do I comment out the entries in em28xx-cards.c (or remove them from
> the patches altogether), so that everything will be made and we can work
> on the compilation and coding style issues in the drx39xyj files? (I
> would do this in a third patch, so that I can preserve Devin's original
> patches as much as possible)
>
> Right now, I have two patches that create the drivers and add them to
> the em28xx files where necessary, and that update the licensing and
> authorship (Devin's original updates). And I have a third patch, which
> adds a ccflags-y entry to the em28xx Makefile, pointing to the
> drivers/staging/media/frontends/drx39xyj directory (for finding the
> files it needs).
>
> Thanks for any information and advice. And if I should have just
> directed this to Devin and/or Mauro (or waited for a reply from an
> earlier email to Mauro), I'm sorry for the inconvenience that sending
> this to the entire list may have caused.
>
> Have a great day:)
> Patrick.

It's a brand new driver, so my suggestion would be to just tweak my
original patch to not include the Makefile change or em28xx-cards.c
(and note that you did such in the patch description).  From that
point on it won't matter if anything there compiles.  Then put your 25
patches on top of mine, and finally do a patch with the description
"add support for PCTV 80e product" which adds in the Makefile change
and the change to em28xx-cards.c.

That allows all the history to be preserved while ensuring that none
of your intermediate patches break compilation.

This is the sort of thing you can get away with when it's a brand new
driver (since it isn't used by anything until you explicitly add
support for a particular product).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
