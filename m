Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48202 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab1KLPGc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 10:06:32 -0500
Received: by iage36 with SMTP id e36so5236972iag.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 07:06:31 -0800 (PST)
Message-ID: <4EBE8B71.6020201@gmail.com>
Date: Sat, 12 Nov 2011 09:06:25 -0600
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: "jonathanjstevens@gmail.com" <jonathanjstevens@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: HVR-4000 may be broken in kernel mods (again) ?
References: <CAA7M+FBvP0A7L6o-Fw4CQ2xR2CYqu233L+83BGGOcLooK0bk7w@mail.gmail.com> <CAGoCfiw+yy3Hz=7yvGTYrYQn5VfNh3CrabS_Kxx7G88jcwt9aQ@mail.gmail.com> <20111112141403.53708f28@hana.gusto> <CAGoCfiwnOTv=yhFeAsjQ+=5vrsUfy5b8HqtXGiFuimXe2M-+Bw@mail.gmail.com> <CAA7M+FAi517fUjLUxLsVSMr99N+2gpuhJMoiTbsuxyKGuf7-Kw@mail.gmail.com> <CAA7M+FCWHwRvX4UYGOqnN2yd+SyUDhbs7sn9djVy=Px0EMw6eg@mail.gmail.com>
In-Reply-To: <CAA7M+FCWHwRvX4UYGOqnN2yd+SyUDhbs7sn9djVy=Px0EMw6eg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/12/2011 08:53 AM, jonathanjstevens@gmail.com wrote:
> I've just done some tests without Xen.
> 
> The situation does change, in that scandvb finds the services (so
> no more "filter timeouts"). Kaffeine also manages to scan the
> channels OK - however despite managing to scan, tune and get the
> EPG there is no picture on any channel.
> 
> I can't test MythTV without Xen, as it relies on an SQL database
> that is on a Xen VM.
> 
> Not sure where to go with this next? The card worked Ok through
> Xen (am running all this in dom0 by the way) with Opensuse (once
> patches applied) and the version of Xen is not very different -
> although the dom0 kernel will be I guess.
> 
> 

Hi Jonathon,

I would make two suggestions to you.

1. Check on the Mythtv forums (and post the question there), if you
haven't already. They may have a bit more insight into the card with
their system.  And they may be able to sort out the lack of picture
(even though it's not on their software).

2.  If you can allocate a lower percentage of processor and/or memory
to the Xen VM, that may solve part of the problem. My theory is that
Xen is using too much of the CPU and/or memory right now, and
everything else has to fight for what's left. Which means that when
you try using the card, it's basically getting scraps.  So it times
out and can't scan.  That's why it works (better at least) when Xen is
off.  If you can't allocate lower percentages, then maybe trying
Virtualbox or VMWare would work.  But, I would see what all you can do
with Xen first.

Have a great weekend. :)
Patrick.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6+i3AACgkQMp6rvjb3CASrAACfW67fWDTETYRu6kQg/rRnxM14
53AAn3C3MMkFZaKcdGn+IUE9EGuuwBkn
=p/K3
-----END PGP SIGNATURE-----
