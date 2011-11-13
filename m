Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:39551 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab1KMPhP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Nov 2011 10:37:15 -0500
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id pADFbB6n027403
	for <linux-media@vger.kernel.org>; Sun, 13 Nov 2011 10:37:12 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 6D1561E01B1
	for <linux-media@vger.kernel.org>; Sun, 13 Nov 2011 10:37:11 -0500 (EST)
Message-ID: <4EBFE427.9010605@lockie.ca>
Date: Sun, 13 Nov 2011 10:37:11 -0500
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: HVR-4000 may be broken in kernel mods (again) ?
References: <CAA7M+FBvP0A7L6o-Fw4CQ2xR2CYqu233L+83BGGOcLooK0bk7w@mail.gmail.com> <CAGoCfiw+yy3Hz=7yvGTYrYQn5VfNh3CrabS_Kxx7G88jcwt9aQ@mail.gmail.com> <20111112141403.53708f28@hana.gusto> <CAGoCfiwnOTv=yhFeAsjQ+=5vrsUfy5b8HqtXGiFuimXe2M-+Bw@mail.gmail.com> <CAA7M+FAi517fUjLUxLsVSMr99N+2gpuhJMoiTbsuxyKGuf7-Kw@mail.gmail.com> <CAA7M+FCWHwRvX4UYGOqnN2yd+SyUDhbs7sn9djVy=Px0EMw6eg@mail.gmail.com>
In-Reply-To: <CAA7M+FCWHwRvX4UYGOqnN2yd+SyUDhbs7sn9djVy=Px0EMw6eg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/11 09:53, jonathanjstevens@gmail.com wrote:
> I've just done some tests without Xen.
> 
> The situation does change, in that scandvb finds the services (so no
> more "filter timeouts"). Kaffeine also manages to scan the channels OK
> - however despite managing to scan, tune and get the EPG there is no
> picture on any channel.
> 
> I can't test MythTV without Xen, as it relies on an SQL database that
> is on a Xen VM.
> 
> Not sure where to go with this next? The card worked Ok through Xen
> (am running all this in dom0 by the way) with Opensuse (once patches
> applied) and the version of Xen is not very different - although the
> dom0 kernel will be I guess.

Try mplayer (or VLC) directly.
Kaffeine uses a pipe from mplayer.
I use VLC to open my channels.conf (I forget which file format, mplayer format?) which works.
Mplayer doesn't work very well on my system but vlc does.
