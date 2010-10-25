Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53456 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518Ab0JYTbp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 15:31:45 -0400
Received: by iwn10 with SMTP id 10so1178409iwn.19
        for <linux-media@vger.kernel.org>; Mon, 25 Oct 2010 12:31:45 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 25 Oct 2010 17:31:44 -0200
Message-ID: <AANLkTi=WiJWHaXEyeo9Fccwe8oy+N9XmJdRZi3QLPH7H@mail.gmail.com>
Subject: [ANNOUNCE] mercurial backport tree is needing a new maintainer
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

       I am just writing to officially say that I cannot maintain the
hg backport tree anymore.
Sorry for this, I *really* tried to help here, but, since I know some
people still like to use it I prefer
write this email. Unfortunately due my current activities I cannot
give attention which this task requires.

Also, if I could say something here for the next person which will
take care about it.

        - Doing backport manually from 200 to 400 backports doesn't work
        - Making a script to do it, also not good approach since it
will break because of our macros.

The best opition here to my eyes, is tar the current -git tree and
make a directory with the backports
(Mauro's new build system).

This will save a lot of time:

        - no need to backport the current patches coming
        - will keep the tree updated
        - Minize the backport job.

I will keep around, helping the group with what I can.

Cheers
Douglas
