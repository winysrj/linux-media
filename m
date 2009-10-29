Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35058 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZJ2E4x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 00:56:53 -0400
Received: by bwz27 with SMTP id 27so1854607bwz.21
        for <linux-media@vger.kernel.org>; Wed, 28 Oct 2009 21:56:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AE91E54.2030409@acm.org>
References: <4AE8F99E.5010701@acm.org>
	 <829197380910282040t6fce747aoca318911e76aa23f@mail.gmail.com>
	 <4AE91E54.2030409@acm.org>
Date: Thu, 29 Oct 2009 00:56:55 -0400
Message-ID: <829197380910282156l6bea177g79f38eb973335e27@mail.gmail.com>
Subject: Re: HVR-950Q problem under MythTV
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bob Cunningham <rcunning@acm.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 29, 2009 at 12:47 AM, Bob Cunningham <rcunning@acm.org> wrote:
> For F11, I appended the line "options xc5000 no_poweroff=1" to
> /etc/modprobe.d/local.conf
>
> Rather than power down (shudder), I did the following:
> 1. Unplug HVR-950Q
> 2. rmmod xc5000
> 3. modprobe xc5000 no_poweroff=1
> 4. Plug in HVR-950Q

You would be shocked how many people have trouble with those four
steps.  So now I just tell people to reboot.

> All is well with the world: The tuner is tuning, MythTV is mythic, and I am
> a vidiot.

That's great.  Bear in mind that I only did a minimal amount of
burn-in under MythTV, so if you see other issues, please speak up.  I
basically did enough to get rid of the segfaults, show the user video,
and cleanup a couple of errors in the mythbackend.log (by implementing
the hue and saturation controls).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
