Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:50858 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab3GNWoP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jul 2013 18:44:15 -0400
Received: by mail-wi0-f180.google.com with SMTP id c10so2255056wiw.7
        for <linux-media@vger.kernel.org>; Sun, 14 Jul 2013 15:44:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3683080.CL97pXOYgk@wyst>
References: <1139404719.20130516194142@eikelenboom.it>
	<51E27239.2080109@xs4all.nl>
	<749621697.20130714231842@eikelenboom.it>
	<3683080.CL97pXOYgk@wyst>
Date: Sun, 14 Jul 2013 18:44:13 -0400
Message-ID: <CAGoCfiwhC7EZHY0KQ-MF+NcSJDkhsaT_SP_MQCY7fGvp4C4Svw@mail.gmail.com>
Subject: Re: [media] cx25821 regression from 3.9: BUG: bad unlock balance detected!
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 14, 2013 at 5:39 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> > If you can get cx25821-video.c to work with vb2, then we can take a look at the alsa
>> > code.

If I can make a suggestion:  fix the lock problem first.  The last
thing you want to do is simultaneously debug a known buffer management
problem at the same time you're trying to port to VB2.  I panic'd my
system enough times during the em28xx conversion where you really want
to know whether the source is the VB2 work in progress or some other
issue with buffer management.

I'm not saying to not do the VB2 port -- just that you would be well
served to have a reasonable stable driver before attempting to do the
port.

That said, I guess it's possible that digging into the code enough to
understand what specifically has to be done for a VB2 port might
reveal the source of the locking problem, but that's not how I would
do it.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
