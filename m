Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48360 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab1KLPIX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 10:08:23 -0500
Received: by ggnb2 with SMTP id b2so5045456ggn.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 07:08:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA7M+FCWHwRvX4UYGOqnN2yd+SyUDhbs7sn9djVy=Px0EMw6eg@mail.gmail.com>
References: <CAA7M+FBvP0A7L6o-Fw4CQ2xR2CYqu233L+83BGGOcLooK0bk7w@mail.gmail.com>
	<CAGoCfiw+yy3Hz=7yvGTYrYQn5VfNh3CrabS_Kxx7G88jcwt9aQ@mail.gmail.com>
	<20111112141403.53708f28@hana.gusto>
	<CAGoCfiwnOTv=yhFeAsjQ+=5vrsUfy5b8HqtXGiFuimXe2M-+Bw@mail.gmail.com>
	<CAA7M+FAi517fUjLUxLsVSMr99N+2gpuhJMoiTbsuxyKGuf7-Kw@mail.gmail.com>
	<CAA7M+FCWHwRvX4UYGOqnN2yd+SyUDhbs7sn9djVy=Px0EMw6eg@mail.gmail.com>
Date: Sat, 12 Nov 2011 10:08:22 -0500
Message-ID: <CAGoCfixS30Tkm4B3PUOutos74vwLwMNAjwBrPR=jisZergg7=w@mail.gmail.com>
Subject: Re: HVR-4000 may be broken in kernel mods (again) ?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "jonathanjstevens@gmail.com" <jonathanjstevens@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If you're running Xen, then as far as I'm concerned you're on a
*totally* unsupported path.  If it happened to have worked in some
previous version, it was dumb luck.

As for you issue when not using Xen, you're probably just missing the
Kaffeine libraries required for video playback (a common problem).
Did you try the Nova-T on that box to confirm playback works at all?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
