Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:65239 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab0AQQXI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 11:23:08 -0500
Received: by fxm25 with SMTP id 25so412414fxm.21
        for <linux-media@vger.kernel.org>; Sun, 17 Jan 2010 08:23:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001171118.08149.pboettcher@kernellabs.com>
References: <4B52D0DF.9030106@gmx.net>
	 <201001171118.08149.pboettcher@kernellabs.com>
Date: Sun, 17 Jan 2010 11:23:03 -0500
Message-ID: <829197381001170823v23947d01s599da20eccca7a31@mail.gmail.com>
Subject: Re: PCTV (ex Pinnacle) 74e pico USB stick DVB-T: no frontend
	registered
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Harald Albrecht <harald.albrecht@gmx.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 17, 2010 at 5:18 AM, Patrick Boettcher
<pboettcher@kernellabs.com> wrote:
> The 74e is not a dib0700-based device, my assumption at that time was wrong.
>
> For the 74e afaik, there is no LinuxTV driver right now. (IIRC it is a Abilis
> based design)

Patrick is correct in that the 74e is an Abilis design.  I have been
working with PCTV for a couple of months, who has worked with Abilis
to get a GPL driver out there.  The firmware redistribution rights
have finally been straightened out last Friday, so keep an eye on the
KernelLabs.com blog for an announcement in the near future.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
