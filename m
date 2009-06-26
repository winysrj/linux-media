Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f191.google.com ([209.85.210.191]:40076 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbZFZRcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 13:32:39 -0400
Received: by yxe29 with SMTP id 29so434012yxe.33
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 10:32:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b24e53350906261028n1cb1abf6r6e0691759c6b8772@mail.gmail.com>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
	 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
	 <b24e53350906261019u45bba60erc7ee41222896388b@mail.gmail.com>
	 <829197380906261023n7e960f43pcd25d82eb12f91dd@mail.gmail.com>
	 <b24e53350906261028n1cb1abf6r6e0691759c6b8772@mail.gmail.com>
Date: Fri, 26 Jun 2009 13:32:40 -0400
Message-ID: <829197380906261032h2f5f5828p94ba7519ce7f38db@mail.gmail.com>
Subject: Re: Bah! How do I change channels?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Robert Krakora <rob.krakora@messagenetsystems.com>
Cc: Andy Walls <awalls@radix.net>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 26, 2009 at 1:28 PM, Robert
Krakora<rob.krakora@messagenetsystems.com> wrote:
> Yes, it is run after mplayer initially tunes it.  However, what is the
> difference between mplayer tuning and v4l-ctl tuning?  They are both
> submitting the same IOCTLs to the driver to accomplish the same end
> result; or is mplayer probably submitting some additional IOCTLS to
> "wake" the device?

The issue is that the tuner gets powered down when the v4l device is
closed.  So, when running mplayer first, and then v4l-ctl is being
used to tune, the file handle is held active by mplayer.  But if you
run v4l-ctl first, the v4l-ctl opens the handle, tunes successfully,
and then closes the handle (which powers down the tuner).  Then when
running mplayer (or whatever app), the handle gets reopened but the
tuner is not tuned to the target frequency that v4l-ctl set.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
