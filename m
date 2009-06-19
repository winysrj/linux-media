Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3997 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZFSQmE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 12:42:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: v4l-dvb compile broken with stock Ubuntu Karmic build  (firedtv-ieee1394.c errors)
Date: Fri, 19 Jun 2009 18:41:58 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <829197380906190752v981e81sb94c8c294b68dbd2@mail.gmail.com> <200906191804.55564.hverkuil@xs4all.nl> <829197380906190911r7a1298ddtf442d938867abc08@mail.gmail.com>
In-Reply-To: <829197380906190911r7a1298ddtf442d938867abc08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906191841.58210.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 19 June 2009 18:11:11 Devin Heitmueller wrote:
> On Fri, Jun 19, 2009 at 12:04 PM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> > Hmm, I discovered that firedtv-1394.c isn't compiled in the daily build
> > even though ieee1394 is enabled in the kernel. I can manually enable
> > it, though: make menuconfig, disable and enable the firedtv driver, and
> > then it magically works. But even then it still compiles fine against
> > the vanilla 2.6.30 kernel.
>
> Well, I'm obviously kicking myself for not having captured the output
> last night when I was at home.
>
> So, you're saying that firedvt-1394.c is being compiled?
>
> Let me rephrase the question:  Take a look at firedtv-1394.c, line 22,
> and tell me where the file "csr1212.h" can be found either in your
> kernel source tree or your v4l-dvb tree.
>
> Devin

It's here:

/usr/src/linux/drivers/ieee1394/csr1212.h

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
