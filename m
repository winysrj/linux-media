Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48768 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab2AKC1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 21:27:37 -0500
Received: by yhjj63 with SMTP id j63so115680yhj.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 18:27:36 -0800 (PST)
Message-ID: <4F0CF395.1090002@gmail.com>
Date: Tue, 10 Jan 2012 20:27:33 -0600
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>
Subject: Adding support for PCTV-80e Tuner
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

A few months ago, I posted a 25-patch series on the PCTV-80e Tuner to
the mailing list, which was nacked. I've since rewrote the patches, but
have an issue that I need some advice with.  I took Devin's advice, and
created two patches using his hg patches. The only modifications that I
made were to remove the Makefile and Kconfig entries, and then to move
the drivers to the staging/media/frontends/drx39xyj directory.

I've got a couple of problems/questions, and am looking for opinions on
how to deal with them. I included the mailing list in this, because
there might be someone who's had similar issues, and because this issue
might come up in the future with other projects.

So, here are my problems.

1. If I try to make the media_git with just the two patches included, I
get compilation errors in em28xx-cards.c. This is because it needs the
drx39xxj.h file, which is in drivers/staging/media/frontends/drx39xyj
(and hasn't been compiled).

2. If I add an entry into the drivers/media Makefile and Kconfig,
pointing to the drvers/staging/media/frontends/drx39xyj directory, it
fails to compile because drx39xxj.c requires dvb_frontend.h from
drivers/media/dvb/dvb-core, which hasn't been compiled yet.

The short question is how do I handle this situation?

The longer questions are

1.  Do I make entries in the drx39xyj/Makefile and Kconfig that point
back to the dvb/dvb-core directory (or add the drivers/dvb/ entry before
the drivers/staging/media/frontends/drx39xyj/ entry in the
Makefile/Kconfig entries in drivers/media/)?

2.  Do I submit my two patches, knowing that they will break compilation
of the media_git tree at the em28xx-cards.c file?

3.  Do I comment out the entries in em28xx-cards.c (or remove them from
the patches altogether), so that everything will be made and we can work
on the compilation and coding style issues in the drx39xyj files? (I
would do this in a third patch, so that I can preserve Devin's original
patches as much as possible)

Right now, I have two patches that create the drivers and add them to
the em28xx files where necessary, and that update the licensing and
authorship (Devin's original updates). And I have a third patch, which
adds a ccflags-y entry to the em28xx Makefile, pointing to the
drivers/staging/media/frontends/drx39xyj directory (for finding the
files it needs).

Thanks for any information and advice. And if I should have just
directed this to Devin and/or Mauro (or waited for a reply from an
earlier email to Mauro), I'm sorry for the inconvenience that sending
this to the entire list may have caused.

Have a great day:)
Patrick.
