Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59207 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab1KLQhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 11:37:16 -0500
Received: by vws1 with SMTP id 1so4168090vws.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 08:37:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EBE8B71.6020201@gmail.com>
References: <CAA7M+FBvP0A7L6o-Fw4CQ2xR2CYqu233L+83BGGOcLooK0bk7w@mail.gmail.com>
	<CAGoCfiw+yy3Hz=7yvGTYrYQn5VfNh3CrabS_Kxx7G88jcwt9aQ@mail.gmail.com>
	<20111112141403.53708f28@hana.gusto>
	<CAGoCfiwnOTv=yhFeAsjQ+=5vrsUfy5b8HqtXGiFuimXe2M-+Bw@mail.gmail.com>
	<CAA7M+FAi517fUjLUxLsVSMr99N+2gpuhJMoiTbsuxyKGuf7-Kw@mail.gmail.com>
	<CAA7M+FCWHwRvX4UYGOqnN2yd+SyUDhbs7sn9djVy=Px0EMw6eg@mail.gmail.com>
	<4EBE8B71.6020201@gmail.com>
Date: Sat, 12 Nov 2011 16:37:15 +0000
Message-ID: <CAA7M+FBozsjNQL9vc1iapF6UGo4dGNtKZj2NNvgc2OCQvqyFuA@mail.gmail.com>
Subject: Re: HVR-4000 may be broken in kernel mods (again) ?
From: "jonathanjstevens@gmail.com" <jonathanjstevens@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
> Hi Jonathon,
>
> I would make two suggestions to you.
>
> 1. Check on the Mythtv forums (and post the question there), if you
> haven't already. They may have a bit more insight into the card with
> their system.  And they may be able to sort out the lack of picture
> (even though it's not on their software).
>
HVR-4000 quite a tale of woe with MythTV, see earlier posts. Been
patching for years, but I don't think this is a MythTV issue, not
something they can do much about.


> 2.  If you can allocate a lower percentage of processor and/or memory
> to the Xen VM, that may solve part of the problem. My theory is that
> Xen is using too much of the CPU and/or memory right now, and
> everything else has to fight for what's left. Which means that when
> you try using the card, it's basically getting scraps.  So it times
> out and can't scan.  That's why it works (better at least) when Xen is
> off.  If you can't allocate lower percentages, then maybe trying
> Virtualbox or VMWare would work.  But, I would see what all you can do
> with Xen first.

Not really following you here. I'm running all this in dom0.
There is 16GB of memory in the system, and it's an i3, and nothing
else is really running.
I've allocated 4GB to dom0, and even with all the other VMs running,
CPU usage is low and there's about 7GB free.
I'm not doing any kind of PCI passthru, and in fact the main reason
I'm running Xen is that it allows me to run mythtv in dom0 and get
"direct" access to the PCI DVB cards.



>
> Have a great weekend. :)
> Patrick.

You too and thanks for helping out.
