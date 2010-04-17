Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42873 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497Ab0DQAOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Apr 2010 20:14:48 -0400
Received: by gwaa18 with SMTP id a18so1631427gwa.19
        for <linux-media@vger.kernel.org>; Fri, 16 Apr 2010 17:14:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BC8F087.3050805@cogweb.net>
References: <4BC8F087.3050805@cogweb.net>
Date: Fri, 16 Apr 2010 20:14:47 -0400
Message-ID: <u2g829197381004161714z2f0b827eu824a3bcb17d2aa17@mail.gmail.com>
Subject: Re: zvbi-atsc-cc device node conflict
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: David Liontooth <lionteeth@cogweb.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 16, 2010 at 7:19 PM, David Liontooth <lionteeth@cogweb.net> wrote:
> I'm using a HVR-1850 in digital mode and get good picture and sound using
>
>  mplayer -autosync 30 -cache 2048 dvb://KCAL-DT
>
> Closed captioning works flawlessly with this command:
>
> zvbi-atsc-cc -C test-cc.txt KCAL-DT
>
> However, if I try to run both at the same time, I get a device node
> conflict:
>
>  zvbi-atsc-cc: Cannot open '/dev/dvb/adapter0/frontend0': Device or resource
> busy.
>
> How do I get video and closed captioning at the same time?

To my knowledge, you cannot run two userland apps streaming from the
frontend at the same time.  Generally, when people need to do this
sort of thing they write a userland daemon that multiplexes.
Alternatively, you can cat the frontend to disk and then have both
mplayer and your cc parser reading the resulting file.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
