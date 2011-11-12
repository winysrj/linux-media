Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43119 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab1KLQoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 11:44:55 -0500
Received: by vws1 with SMTP id 1so4170867vws.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 08:44:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA7M+FCG4Q5Xyu45rnQs9qecHOWRm4sw9bYvoe6neu44E6=xZg@mail.gmail.com>
References: <CAA7M+FBvP0A7L6o-Fw4CQ2xR2CYqu233L+83BGGOcLooK0bk7w@mail.gmail.com>
	<CAGoCfiw+yy3Hz=7yvGTYrYQn5VfNh3CrabS_Kxx7G88jcwt9aQ@mail.gmail.com>
	<20111112141403.53708f28@hana.gusto>
	<CAGoCfiwnOTv=yhFeAsjQ+=5vrsUfy5b8HqtXGiFuimXe2M-+Bw@mail.gmail.com>
	<CAA7M+FAi517fUjLUxLsVSMr99N+2gpuhJMoiTbsuxyKGuf7-Kw@mail.gmail.com>
	<CAA7M+FCWHwRvX4UYGOqnN2yd+SyUDhbs7sn9djVy=Px0EMw6eg@mail.gmail.com>
	<CAGoCfixS30Tkm4B3PUOutos74vwLwMNAjwBrPR=jisZergg7=w@mail.gmail.com>
	<CAA7M+FCG4Q5Xyu45rnQs9qecHOWRm4sw9bYvoe6neu44E6=xZg@mail.gmail.com>
Date: Sat, 12 Nov 2011 16:44:54 +0000
Message-ID: <CAA7M+FAtwHt82rsSB_GgDcNt-Fqm-L3a4RvxQssba_gr_iR-fA@mail.gmail.com>
Subject: Fwd: HVR-4000 may be broken in kernel mods (again) ?
From: "jonathanjstevens@gmail.com" <jonathanjstevens@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---------- Forwarded message ----------
From: jonathanjstevens@gmail.com <jonathanjstevens@gmail.com>
Date: 12 November 2011 16:44
Subject: Re: HVR-4000 may be broken in kernel mods (again) ?
To: Devin Heitmueller <dheitmueller@kernellabs.com>


On 12 November 2011 15:08, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> If you're running Xen, then as far as I'm concerned you're on a
> *totally* unsupported path.  If it happened to have worked in some
> previous version, it was dumb luck.
>

That seems a bit harsh but I understand your point. Running a
hypervisor is far from unusual. I half expected this sort of response
(not my problem mate). But, considering it's Xen dom0, I'm surprised
there is nothing I can do?

> As for you issue when not using Xen, you're probably just missing the
> Kaffeine libraries required for video playback (a common problem).
> Did you try the Nova-T on that box to confirm playback works at all?

Nova-T works perfectly in MythTV on Xen. I haven't tried it in
Kaffeine - you could be entirely right here. Whichever - because it's
apparent there is a Xen versus dvb issue.

I guess what I'd fall back to, xen dom0 support is now a part of the
mainline kernel - so it shouldn't conflict with with particular
hardware support such as that for the HVR-4000. It's obvious it "can"
work, but from what I'm hearing from you - no-one would own this.

I don't mind putting the hours in to resolve this, I really don't, but
I don't have sufficient knowledge to do this on my own.
