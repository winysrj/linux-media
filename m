Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:54239 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab0CIUJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Mar 2010 15:09:49 -0500
Received: by qw-out-2122.google.com with SMTP id 8so74659qwh.37
        for <linux-media@vger.kernel.org>; Tue, 09 Mar 2010 12:09:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201003092133.12235.liplianin@me.by>
References: <bcb3ef431003081127y43d6d785jdc34e845fa07e746@mail.gmail.com>
	 <a3ef07921003081241t16e1a63ag1d8f93ebe35f15f2@mail.gmail.com>
	 <201003092133.12235.liplianin@me.by>
Date: Tue, 9 Mar 2010 12:09:48 -0800
Message-ID: <a3ef07921003091209j20d5df65jf61958bac3e4a569@mail.gmail.com>
Subject: Re: s2-liplianin, mantis: sysfs: cannot create duplicate filename
	'/devices/virtual/irrcv'
From: VDR User <user.vdr@gmail.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: MartinG <gronslet@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/3/9 Igor M. Liplianin <liplianin@me.by>:
> On 8 ÍÁÒÔÁ 2010 22:41:26 VDR User wrote:
>> This isn't an answer to your questions but I don't recommend using the
>> s2-liplianin tree as it contains timing patches which can cause
>> serious damage to your tuner. šThis has also been confirmed by the
>> manufacturer as well and to my knowledge has unfortunately not been
>> reverted in that tree.
> Funny enough.
> VDR User, you are wrong for years. Look here
> http://mercurial.intuxication.org/hg/s2-liplianin/rev/c15f31375c53

Sorry, I was unaware you finally removed the dangerous code.  It's too
bad it was left there as long as it was but at least it's gone now.
Btw, looking at the changelog, it was only removed one year ago, not
years.

>> I strongly urge you to use either of these _safe_ trees:
>>
>> http://jusst.de/hg/mantis-v4l-dvb (for development drivers, which may
>> still be stable)
>> http://linuxtv.org/hg/v4l-dvb (for more stable drivers)
> MartinG, I'm already planning to replace mantis related part with linuxtv one,
> so please use http://linuxtv.org/hg/v4l-dvb.
> But not get wrong, this tree isn't panacea, your reports are welcome.

I'm glad to hear you're going to rebase the mantis driver with the
up-to-date code rather then keeping the old outdated stuff that's
currently in there!  Do you know when you'll be doing this??
