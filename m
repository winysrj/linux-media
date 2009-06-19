Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:19813 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbZFSPmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 11:42:16 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1016131ywb.1
        for <linux-media@vger.kernel.org>; Fri, 19 Jun 2009 08:42:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906191733.57136.hverkuil@xs4all.nl>
References: <829197380906190752v981e81sb94c8c294b68dbd2@mail.gmail.com>
	 <200906191733.57136.hverkuil@xs4all.nl>
Date: Fri, 19 Jun 2009 11:42:18 -0400
Message-ID: <829197380906190842w48fc7c13if02822d9dae8e252@mail.gmail.com>
Subject: Re: v4l-dvb compile broken with stock Ubuntu Karmic build
	(firedtv-ieee1394.c errors)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 19, 2009 at 11:33 AM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> What's the compile error exactly? The firedtv driver compiles fine in the
> daily build against the vanilla 2.6.30 kernel.
>
> Regards,
>
>        Hans
>

Unfortunately, I sent the email from work and didn't have the output
in front of me (or else I would have pasted it into the email).
Several people also reported it on #linuxtv on 6/11, but it looks like
the pastebins have already expired.  :-(

I will provide the output tonight.  I started to debug it last night,
and it seems that firedtv-ieee1494.c doesn't normally get compiled at
all, so if you add 1394 support to your build you will likely also see
the issue.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
