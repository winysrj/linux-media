Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:52317 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab1L3EUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 23:20:09 -0500
Date: Thu, 29 Dec 2011 22:15:37 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH for 3.2 URGENT 0/1] Fix major regression in gspca
In-Reply-To: <1325191002-25074-1-git-send-email-hdegoede@redhat.com>
Message-ID: <alpine.LNX.2.00.1112292208580.28859@banach.math.auburn.edu>
References: <1325191002-25074-1-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 29 Dec 2011, Hans de Goede wrote:

> Hi all,
> 
> Unfortunately the new iso bandwidth calculation code in gspca has
> accidentally broken support for bulk mode cameras, breaking support
> for a wide range of chipsets (see the patch for a full list).
> 
> Mauro, please send this patch to Linus asap, so that 3.2 won't ship with
> this regression.
> 
> Thanks,
> 
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Thanks, Hans.

BTW, 3.2 so far seems totally broken for me. I could not get nearly so far 
as to test any of these cameras, even though several of the drivers in 
question are mine. I started testing the kernel at level 3.2-rc6 and got 
repeated kernel oopses, happening every time I mounted a partition 
read-write. It did boot, finally, but it barely booted. So, no testing 
cameras, as I said. I never got that far.

Today I tried the latest, which calls itself 3.2-rc7. Its behavior is even 
worse. As I recall, it did not even complete the booting. :-/

So I sure hope that at least this patch helps out those people who _can_ 
boot the new kernel.

Theodore Kilgore

