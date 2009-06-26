Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f191.google.com ([209.85.210.191]:52008 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbZFZRXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 13:23:01 -0400
Received: by yxe29 with SMTP id 29so423099yxe.33
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 10:23:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b24e53350906261019u45bba60erc7ee41222896388b@mail.gmail.com>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
	 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
	 <b24e53350906261019u45bba60erc7ee41222896388b@mail.gmail.com>
Date: Fri, 26 Jun 2009 13:23:03 -0400
Message-ID: <829197380906261023n7e960f43pcd25d82eb12f91dd@mail.gmail.com>
Subject: Re: Bah! How do I change channels?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Robert Krakora <rob.krakora@messagenetsystems.com>
Cc: Andy Walls <awalls@radix.net>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 26, 2009 at 1:19 PM, Robert
Krakora<rob.krakora@messagenetsystems.com> wrote:
> I had ran into this before with the KWorld a few months back.
> However, whatever problem existed that forced me to add
> "no_poweroff=1" to modprobe.conf for the em28xx module has went away.
> I have been able to use v4l-ctl or ivtv-tune without any problems to
> tune analog channels over cable.

Well, bear in mind that if you run v4l-ctl *after* the program is
streaming it should work.  However, if you run v4l-ctl and then try to
stream I suspect it will fail.

If it's working, then perhaps I should take a look at the power
management code in em28xx/xc2028 since I don't know why it would work
(and perhaps the tuner is *not* being powered down like it should be).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
