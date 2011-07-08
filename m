Return-path: <mchehab@localhost>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59321 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab1GHA2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2011 20:28:14 -0400
Received: by vws1 with SMTP id 1so1102767vws.19
        for <linux-media@vger.kernel.org>; Thu, 07 Jul 2011 17:28:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110707235813.GA9684@core.coreip.homeip.net>
References: <E1QevX3-000086-VJ@www.linuxtv.org>
	<20110707235813.GA9684@core.coreip.homeip.net>
Date: Thu, 7 Jul 2011 20:28:12 -0400
Message-ID: <CANOx78H1+UTaHa87FYEcqXoAdbVoBO__gAuD0mHrA9ub_GkQew@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v3.1] [media] rc: call input_sync after scancode reports
From: Jarod Wilson <jarod@wilsonet.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Thu, Jul 7, 2011 at 7:58 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Fri, Jul 01, 2011 at 09:34:45PM +0200, Mauro Carvalho Chehab wrote:
>> This is an automatic generated email to let you know that the following patch were queued at the
>> http://git.linuxtv.org/media_tree.git tree:
>>
>> Subject: [media] rc: call input_sync after scancode reports
>> Author:  Jarod Wilson <jarod@redhat.com>
>> Date:    Thu Jun 23 10:40:55 2011 -0300
>>
>> Due to commit cdda911c34006f1089f3c87b1a1f31ab3a4722f2, evdev only
>> becomes readable when the buffer contains an EV_SYN/SYN_REPORT event. If
>> we get a repeat or a scancode we don't have a mapping for, we never call
>> input_sync, and thus those events don't get reported in a timely
>> fashion.
>
> Hmm, any chance to get it into 3.0?

Its actually already there, I think the branch was just mis-named, or
something along those lines.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=98c32bcded0e249fd48726930ae9f393e0e318b4


-- 
Jarod Wilson
jarod@wilsonet.com
