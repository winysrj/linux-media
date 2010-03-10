Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47341 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab0CJVIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Mar 2010 16:08:05 -0500
Received: by bwz1 with SMTP id 1so5389036bwz.21
        for <linux-media@vger.kernel.org>; Wed, 10 Mar 2010 13:08:03 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: VDR User <user.vdr@gmail.com>
Subject: Re: s2-liplianin, mantis: sysfs: cannot create duplicate filename '/devices/virtual/irrcv'
Date: Wed, 10 Mar 2010 23:07:36 +0200
Cc: MartinG <gronslet@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
References: <bcb3ef431003081127y43d6d785jdc34e845fa07e746@mail.gmail.com> <201003092133.12235.liplianin@me.by> <a3ef07921003091209j20d5df65jf61958bac3e4a569@mail.gmail.com>
In-Reply-To: <a3ef07921003091209j20d5df65jf61958bac3e4a569@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003102307.36762.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9 марта 2010 22:09:48 VDR User wrote:
> 2010/3/9 Igor M. Liplianin <liplianin@me.by>:
> > On 8 марта 2010 22:41:26 VDR User wrote:
> >> This isn't an answer to your questions but I don't recommend using the
> >> s2-liplianin tree as it contains timing patches which can cause
> >> serious damage to your tuner.  This has also been confirmed by the
> >> manufacturer as well and to my knowledge has unfortunately not been
> >> reverted in that tree.
> >
> > Funny enough.
> > VDR User, you are wrong for years. Look here
> > http://mercurial.intuxication.org/hg/s2-liplianin/rev/c15f31375c53
>
> Sorry, I was unaware you finally removed the dangerous code.  It's too
> bad it was left there as long as it was but at least it's gone now.
> Btw, looking at the changelog, it was only removed one year ago, not
> years.
>
> >> I strongly urge you to use either of these _safe_ trees:
> >>
> >> http://jusst.de/hg/mantis-v4l-dvb (for development drivers, which may
> >> still be stable)
> >> http://linuxtv.org/hg/v4l-dvb (for more stable drivers)
> >
> > MartinG, I'm already planning to replace mantis related part with linuxtv
> > one, so please use http://linuxtv.org/hg/v4l-dvb.
> > But not get wrong, this tree isn't panacea, your reports are welcome.
>
> I'm glad to hear you're going to rebase the mantis driver with the
> up-to-date code rather then keeping the old outdated stuff that's
> currently in there!  Do you know when you'll be doing this??
I know when.
But please, don't discuss much my tree here, I consider it like experimental, like my sandbox.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
