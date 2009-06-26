Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:34273 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbZFZSrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 14:47:01 -0400
Received: by gxk26 with SMTP id 26so1147809gxk.13
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 11:47:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246041288.3159.51.camel@palomino.walls.org>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
	 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
	 <b24e53350906261019u45bba60erc7ee41222896388b@mail.gmail.com>
	 <829197380906261023n7e960f43pcd25d82eb12f91dd@mail.gmail.com>
	 <1246041288.3159.51.camel@palomino.walls.org>
Date: Fri, 26 Jun 2009 14:47:03 -0400
Message-ID: <829197380906261147g311d9a0ap7c9d5efc1473bf85@mail.gmail.com>
Subject: Re: Bah! How do I change channels?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: Robert Krakora <rob.krakora@messagenetsystems.com>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 26, 2009 at 2:34 PM, Andy Walls<awalls@radix.net> wrote:
> Hmm, that sure sounds like a V4L2 spec violation.  From the V4L2 close()
> description:
>
> "Closes the device. Any I/O in progress is terminated and resources
> associated with the file descriptor are freed. However data format
> parameters, current input or output, control values or other properties
> remain unchanged."
>
>
> Regards,
> Andy

I have no idea how that would work with power management.  It would
mean that all the tuners and demod drivers which don't maintain state
across powerdown would have to maintain some sort of cache of all of
the programmed registers, and we would need to add some sort of
"wakeup" callback which reprograms the device accordingly (currently
we have a sleep callback but not a corresponding callback to wake the
device back up).

As a requirement, it might have been suitable for PCI cards where you
don't care about power management (and therefore never power anything
down), but I don't know how practical that is for USB or minicard
devices where power management is critical because you're on a
battery.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
