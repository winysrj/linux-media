Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4069 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZFSQE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 12:04:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: v4l-dvb compile broken with stock Ubuntu Karmic build  (firedtv-ieee1394.c errors)
Date: Fri, 19 Jun 2009 18:04:55 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <829197380906190752v981e81sb94c8c294b68dbd2@mail.gmail.com> <200906191733.57136.hverkuil@xs4all.nl> <829197380906190842w48fc7c13if02822d9dae8e252@mail.gmail.com>
In-Reply-To: <829197380906190842w48fc7c13if02822d9dae8e252@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906191804.55564.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 19 June 2009 17:42:18 Devin Heitmueller wrote:
> On Fri, Jun 19, 2009 at 11:33 AM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> > What's the compile error exactly? The firedtv driver compiles fine in
> > the daily build against the vanilla 2.6.30 kernel.
> >
> > Regards,
> >
> >        Hans
>
> Unfortunately, I sent the email from work and didn't have the output
> in front of me (or else I would have pasted it into the email).
> Several people also reported it on #linuxtv on 6/11, but it looks like
> the pastebins have already expired.  :-(
>
> I will provide the output tonight.  I started to debug it last night,
> and it seems that firedtv-ieee1494.c doesn't normally get compiled at
> all, so if you add 1394 support to your build you will likely also see
> the issue.

Hmm, I discovered that firedtv-1394.c isn't compiled in the daily build even 
though ieee1394 is enabled in the kernel. I can manually enable it, though: 
make menuconfig, disable and enable the firedtv driver, and then it 
magically works. But even then it still compiles fine against the vanilla 
2.6.30 kernel.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
