Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41394 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab2ALPDz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jan 2012 10:03:55 -0500
Received: by vbmv11 with SMTP id v11so378109vbm.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jan 2012 07:03:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20120112T154151-25@post.gmane.org>
References: <4EA85EE1.7080807@lockie.ca>
	<loom.20120112T154151-25@post.gmane.org>
Date: Thu, 12 Jan 2012 10:03:54 -0500
Message-ID: <CAGoCfizvX3WdU5QLzAtXkucZ=N8TmKTnxDH0L6HFOYtcbuSHhg@mail.gmail.com>
Subject: Re: cx23885[0]: videobuf_dvb_register_frontend failed (errno = -12)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Markus Golser <elmargol@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 12, 2012 at 9:42 AM, Markus Golser <elmargol@googlemail.com> wrote:
> I have the same Problem.
> Did you find any solution?

Assuming you compiled your kernel from source, enable CONFIG_DVB_NET
in your .config.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
