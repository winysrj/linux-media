Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62130 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1LYQjs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 11:39:48 -0500
Received: by vbbfc26 with SMTP id fc26so8251353vbb.19
        for <linux-media@vger.kernel.org>; Sun, 25 Dec 2011 08:39:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201112251511.54080.hselasky@c2i.net>
References: <4EF64AF4.2040705@gmail.com>
	<4EF70077.5040907@redhat.com>
	<4EF72D61.9090001@gmail.com>
	<201112251511.54080.hselasky@c2i.net>
Date: Sun, 25 Dec 2011 09:47:25 -0500
Message-ID: <CAGoCfiwZPXeU533nPL_SnfeK=tfmpBCpNrJRevH4yvCntVVK0w@mail.gmail.com>
Subject: Re: em28xx_isoc_dvb_max_packetsize for EM2884 (Terratec Cinergy HTC Stick)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Petter Selasky <hselasky@c2i.net>
Cc: Dennis Sperlich <dsperlich@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 25, 2011 at 9:11 AM, Hans Petter Selasky <hselasky@c2i.net> wrote:
> These numbers should not be hardcoded, but extracted from the USB endpoint
> descriptor!
>
> --HPS

Hans is correct.  I only hard-coded it at 564 as a quick hack when I
was bootstrapping the em2784 support.  The code really should be
cleaned up to base it off of the endpoint descriptors.

Patches certainly welcome as this is indeed a known issue.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
