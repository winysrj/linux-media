Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55545 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1FZGRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2011 02:17:51 -0400
Received: by qwk3 with SMTP id 3so1813881qwk.19
        for <linux-media@vger.kernel.org>; Sat, 25 Jun 2011 23:17:50 -0700 (PDT)
Subject: Re: cx18 init lockdep spew
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1308951258.2093.48.camel@morgan.silverblock.net>
Date: Sun, 26 Jun 2011 02:17:47 -0400
Cc: "linux-media@vger.kernel.org Mailing List"
	<linux-media@vger.kernel.org>, hverkuil@xs4all.nl
Content-Transfer-Encoding: 8BIT
Message-Id: <D3774627-4C5B-4C42-997E-3B12F8B01004@wilsonet.com>
References: <ECEB9AD1-D1E4-4204-BE4C-30E3EFFA7722@wilsonet.com> <1308951258.2093.48.camel@morgan.silverblock.net>
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jun 24, 2011, at 5:34 PM, Andy Walls wrote:

> On Fri, 2011-06-24 at 13:39 -0400, Jarod Wilson wrote:
>> I only just recently acquired a Hauppauge HVR-1600 cards, and at least both
>> 2.6.39 and 3.0-rc4 kernels with copious debug spew enabled spit out the
>> lockdep spew included below. Haven't looked into it at all yet, but I
>> thought I'd ask before I do if it is already a known issue.
> 
> Why, yes, it is.  See comments 11-13 of this bug assigned to Jarod
> Wilson in Dec 2010:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=662384
> 
> Also please ask jarod@redhat.com to send you some off-list emails he
> received from me on 21-22 Dec 2010.
> 
> ;)
> 
> 
> Oh, look, some nice fellow submitted a patch to get rid of the false
> alarms:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg26097.html
> https://patchwork.kernel.org/patch/431311/
> 
> ;)

Hahahaha, *facepalm*. I forgot all about that, but its suddenly coming
rushing back to me. :)


> I'm not sure if it still applies cleanly, but it's not that hard to
> grok.  The lockdep happiness comes from the lock being initialized in a
> macro.  That is what's critical to spread all lock instances from one
> "class" into many individual classes for lockdep.
> 
> 
> The issue is the control handling framework creates instances where the
> bridge driver acquires its own control handler lock and subsequently a
> subdev driver lock (or maybe the other way around).  Since the framework
> instantiated all the handler locks in the same common function, lockdep
> considers them one "class" and can't/won't think of them as different.
> 
> 
> 
> If you don't like my patch above, you can try some magic lockdep calls
> in v4l2_ctrl_add_handler() to make lockdep ignore that particular
> recursion for the "&hdl->lock" lock class (for a depth of 1?), knowing
> that it is allowed.
> 
> For reference:
> 
> http://lkml.org/lkml/2009/9/2/83
> 
> I'm pretty sure "mutex_lock_nested(&...->lock, 1)" is what we needed  in
> v4l2_ctrl_add_handler().
> 
> 
> Here is a DVB and I2C related use of mutex_lock_nested() that was added
> some years ago:
> 
> http://www.jikos.cz/~jikos/dev/lockdep_fix_recursive_i2c_transfer.patch
> 
> It is different from our current use case, in that the lock ordering
> relationship was well defined.  I think that I2C lock class recursion in
> DVB could have been solved better with lock class annotations vs.
> nesting.

Cool, thanks, I'll try to give it a closer look this week...

-- 
Jarod Wilson
jarod@wilsonet.com



