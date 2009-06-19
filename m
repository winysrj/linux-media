Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1956 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZFSPeE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 11:34:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: v4l-dvb compile broken with stock Ubuntu Karmic build  (firedtv-ieee1394.c errors)
Date: Fri, 19 Jun 2009 17:33:57 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <829197380906190752v981e81sb94c8c294b68dbd2@mail.gmail.com>
In-Reply-To: <829197380906190752v981e81sb94c8c294b68dbd2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906191733.57136.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 19 June 2009 16:52:06 Devin Heitmueller wrote:
> It seems that attempting to compile the current v4l-dvb against a
> stock Karmic Koala build fails.  I suspect this has to do with the
> fact that 2.6.30 is built with ieee1394 enabled, which causes
> firedtv-ieee1394.c to get compiled, and that file references #include
> files that do not exist.  As far as I can tell, IEEE1394 is not
> enabled in my 2.6.27 build, which is why I was not seeing it before.
>
> Other users reported this issue on the #linuxtv irc a few days ago,
> and I though it was just something weird about their environment.
>
> I'm not familiar with the firedtv driver, so if someone who is wants
> to chime in, I would appreciate it.
>
> Devin

What's the compile error exactly? The firedtv driver compiles fine in the 
daily build against the vanilla 2.6.30 kernel.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
