Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:1051 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZFSQLJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 12:11:09 -0400
Received: by an-out-0708.google.com with SMTP id d40so2942277and.1
        for <linux-media@vger.kernel.org>; Fri, 19 Jun 2009 09:11:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906191804.55564.hverkuil@xs4all.nl>
References: <829197380906190752v981e81sb94c8c294b68dbd2@mail.gmail.com>
	 <200906191733.57136.hverkuil@xs4all.nl>
	 <829197380906190842w48fc7c13if02822d9dae8e252@mail.gmail.com>
	 <200906191804.55564.hverkuil@xs4all.nl>
Date: Fri, 19 Jun 2009 12:11:11 -0400
Message-ID: <829197380906190911r7a1298ddtf442d938867abc08@mail.gmail.com>
Subject: Re: v4l-dvb compile broken with stock Ubuntu Karmic build
	(firedtv-ieee1394.c errors)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 19, 2009 at 12:04 PM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> Hmm, I discovered that firedtv-1394.c isn't compiled in the daily build even
> though ieee1394 is enabled in the kernel. I can manually enable it, though:
> make menuconfig, disable and enable the firedtv driver, and then it
> magically works. But even then it still compiles fine against the vanilla
> 2.6.30 kernel.

Well, I'm obviously kicking myself for not having captured the output
last night when I was at home.

So, you're saying that firedvt-1394.c is being compiled?

Let me rephrase the question:  Take a look at firedtv-1394.c, line 22,
and tell me where the file "csr1212.h" can be found either in your
kernel source tree or your v4l-dvb tree.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
