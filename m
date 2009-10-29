Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.191]:31309 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbZJ2M7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 08:59:31 -0400
Received: by gv-out-0910.google.com with SMTP id r4so244748gve.37
        for <linux-media@vger.kernel.org>; Thu, 29 Oct 2009 05:59:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AE92913.4050209@acm.org>
References: <4AE8F99E.5010701@acm.org>
	 <829197380910282040t6fce747aoca318911e76aa23f@mail.gmail.com>
	 <4AE91E54.2030409@acm.org>
	 <829197380910282156l6bea177g79f38eb973335e27@mail.gmail.com>
	 <4AE92913.4050209@acm.org>
Date: Thu, 29 Oct 2009 08:59:33 -0400
Message-ID: <829197380910290559u78b05d89x9342f440d2067be5@mail.gmail.com>
Subject: Re: HVR-950Q problem under MythTV
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bob Cunningham <rcunning@acm.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 29, 2009 at 1:33 AM, Bob Cunningham <rcunning@acm.org> wrote:
> I spoke too soon: Switching between SD and HD channels (or vice-versa)
> always works the first time, but generally dies the next time I try.  The
> behavior is very inconsistent:  If I switch from SD to HD 720p or higher,
> the tuner goes away the next time I try to tune an SD channel.  If I switch
> between SD and 480i HD channels, I can do so up to 4 times before it stops
> working.
>
> I can switch among SD channels with no problem, and I can switch between HD
> channels of any resolution with no problem.  Only switching back and forth
> between HD and SD causes the problem, and it always happens, sooner or
> later.
>
> Is there a way to force a "quick & dirty" device reinitialization?  Right
> now, I'm killing mythfrontend and mythbackend, re-plugging the HVR-950Q, and
> restarting mythbackend and mythfrontend.  Probably overkill.  Is there an
> easier way?

In this context, we are not talking about SD versus HD - we're talking
about analog versus digital.  You should have no trouble switching
between SD ATSC channels and HD ATSC channels (since the hardware
literally cannot tell the difference).  However, it's not *too*
surprising to find issues going back and forth between analog and
digital.

Are you sure you put both the analog and digtial video sources into
the same recording group?  If not, it's possible that MythTV will
attempt to use both the analog and digtial parts of the card at the
same time, which is not permitted by the hardware.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
