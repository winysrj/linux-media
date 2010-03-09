Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47833 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0CITdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Mar 2010 14:33:45 -0500
Received: by bwz1 with SMTP id 1so4249395bwz.21
        for <linux-media@vger.kernel.org>; Tue, 09 Mar 2010 11:33:44 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: VDR User <user.vdr@gmail.com>
Subject: Re: s2-liplianin, mantis: sysfs: cannot create duplicate filename '/devices/virtual/irrcv'
Date: Tue, 9 Mar 2010 21:33:11 +0200
Cc: MartinG <gronslet@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
References: <bcb3ef431003081127y43d6d785jdc34e845fa07e746@mail.gmail.com> <a3ef07921003081241t16e1a63ag1d8f93ebe35f15f2@mail.gmail.com>
In-Reply-To: <a3ef07921003081241t16e1a63ag1d8f93ebe35f15f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003092133.12235.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 8 марта 2010 22:41:26 VDR User wrote:
> This isn't an answer to your questions but I don't recommend using the
> s2-liplianin tree as it contains timing patches which can cause
> serious damage to your tuner.  This has also been confirmed by the
> manufacturer as well and to my knowledge has unfortunately not been
> reverted in that tree.
Funny enough.
VDR User, you are wrong for years. Look here
http://mercurial.intuxication.org/hg/s2-liplianin/rev/c15f31375c53

>
> I strongly urge you to use either of these _safe_ trees:
>
> http://jusst.de/hg/mantis-v4l-dvb (for development drivers, which may
> still be stable)
> http://linuxtv.org/hg/v4l-dvb (for more stable drivers)
MartinG, I'm already planning to replace mantis related part with linuxtv one,
so please use http://linuxtv.org/hg/v4l-dvb.
But not get wrong, this tree isn't panacea, your reports are welcome.

Linuxoid greetings for all.
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
