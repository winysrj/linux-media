Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40352 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1HPP6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 11:58:41 -0400
Received: by vxi9 with SMTP id 9so42306vxi.19
        for <linux-media@vger.kernel.org>; Tue, 16 Aug 2011 08:58:41 -0700 (PDT)
References: <CAC3jWv+c1HOqmo0B18Z3vWOwjr=RoPrN7sfR3bqzz4Tw7=fPAQ@mail.gmail.com> <1313226504.2840.22.camel@gagarin> <CAC3jWvLszU4gTSVW0mXUFrhnHCpPWRUqErytF9jXs39sbCJd3Q@mail.gmail.com>
In-Reply-To: <CAC3jWvLszU4gTSVW0mXUFrhnHCpPWRUqErytF9jXs39sbCJd3Q@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <ABE0CCB7-8FA0-4A59-B212-1DE4F6722190@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [mythtv-users] Anyone tested the DVB-T2 dual tuner TBS6280?
Date: Tue, 16 Aug 2011 11:58:22 -0400
To: Discussion about MythTV <mythtv-users@mythtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Aug 14, 2011, at 11:50 AM, Harald Gustafsson wrote:

> Thanks for sharing your experience.
> 
> On Sat, Aug 13, 2011 at 11:08 AM, Lawrence Rust <lvr@softsystem.co.uk> wrote:
>> The stock v4l sources supplied are old (from around 2.6.35) and don't
>> contain many current fixes.  This isn't a problem per-se unless you
>> intend to use the card with another v4l card.  In this case your brand
>> new, bug fixed drivers are replaced by TBS's version which may or, as in
>> my case, may not work.
> I have 2 other older cards that I intend to use it with, but currently
> I'm using Ubuntu 10.04 LTS which have a 2.6.32 kernel, so this would
> not be a problem, but later when I upgrade to 12.04 LTS and a newer
> kernel this will be problematic. Since I can't trust that TBS will
> deliver newer drivers.
> 
>> I repeatedly mailed TBS support at support@tbsdtv.com to ask how I could
>> only install the 6981 driver but never got an answer.  In desperation I
>> setup a git tree of 2.6.35 and merged it with the TBS drivers in order
>> to separate their changes.  Finally after many hours I have a set of
>> patches that I can apply to 2.6.39 that produce a working driver.
> Is it possible to mix modules based on different versions of v4l? To
> me that looks like it will work as long as the core infrastructure is
> the same, but as soon as some common data structure that is used by
> the obj files is changed it will break and you might not notice
> directly. Just as you say with the IR changes, but also more subtle
> changes by adding/removing elements in structures.
> 
>> Be warned that if you run a 2.6.38 or later kernel then the IR RC won't
>> work because of significant changes to the RC architecture that TBS
>> don't like (see http://www.tbsdtv.com/forum/viewtopic.php?f=22&t=929 and
>> http://www.tbsdtv.com/forum/viewtopic.php?f=22&t=110&start=90#p2693 )
> 
> In the links you refer to the driver author (at least he seems to be
> the author) states that he has not upgraded to the latest IR code due
> to compatibility issues between the CX23885 and IR.

Someone please inform TBS that it would nice if they'd actually report
issues upstream. Nobody from TBS every said boo about their issues,
which, I'm 99% certain, have *absolutely* nothing to do with supposedly
rewriting ir-core to rc-core. (It was a transition to a new name of the
same code). This probably fixed all their issues:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d7515b8866b60c9526d2d7af37ebcd16c3c5ed97

Similarly, just booting with pci=nomsi on an unpatched kernel should
achieve the same effect. Sigh.

-- 
Jarod Wilson
jarod@wilsonet.com



