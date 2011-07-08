Return-path: <mchehab@localhost>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53824 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab1GHAcm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2011 20:32:42 -0400
Received: by pvg12 with SMTP id 12so809044pvg.19
        for <linux-media@vger.kernel.org>; Thu, 07 Jul 2011 17:32:42 -0700 (PDT)
Date: Thu, 7 Jul 2011 17:32:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.1] [media] rc: call input_sync after
 scancode reports
Message-ID: <20110708003236.GB9684@core.coreip.homeip.net>
References: <E1QevX3-000086-VJ@www.linuxtv.org>
 <20110707235813.GA9684@core.coreip.homeip.net>
 <CANOx78H1+UTaHa87FYEcqXoAdbVoBO__gAuD0mHrA9ub_GkQew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANOx78H1+UTaHa87FYEcqXoAdbVoBO__gAuD0mHrA9ub_GkQew@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Thu, Jul 07, 2011 at 08:28:12PM -0400, Jarod Wilson wrote:
> On Thu, Jul 7, 2011 at 7:58 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Fri, Jul 01, 2011 at 09:34:45PM +0200, Mauro Carvalho Chehab wrote:
> >> This is an automatic generated email to let you know that the following patch were queued at the
> >> http://git.linuxtv.org/media_tree.git tree:
> >>
> >> Subject: [media] rc: call input_sync after scancode reports
> >> Author:  Jarod Wilson <jarod@redhat.com>
> >> Date:    Thu Jun 23 10:40:55 2011 -0300
> >>
> >> Due to commit cdda911c34006f1089f3c87b1a1f31ab3a4722f2, evdev only
> >> becomes readable when the buffer contains an EV_SYN/SYN_REPORT event. If
> >> we get a repeat or a scancode we don't have a mapping for, we never call
> >> input_sync, and thus those events don't get reported in a timely
> >> fashion.
> >
> > Hmm, any chance to get it into 3.0?
> 
> Its actually already there, I think the branch was just mis-named, or
> something along those lines.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=98c32bcded0e249fd48726930ae9f393e0e318b4
> 

Ah, good then.

Thanks.

-- 
Dmitry
