Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:43372 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab0ARPnp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 10:43:45 -0500
Received: by fxm25 with SMTP id 25so580198fxm.21
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2010 07:43:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B547EBF.6080105@arcor.de>
References: <4B547EBF.6080105@arcor.de>
Date: Mon, 18 Jan 2010 10:43:43 -0500
Message-ID: <829197381001180743k789f336er2bb368f4c689a41@mail.gmail.com>
Subject: Re: Terratec Cinergy Hybrid XE (TM6010 Mediachip)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 18, 2010 at 10:31 AM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
> I have a question. How are loaded the base firmware into xc3028, in
> once or in a split ? It's importent for TM6010, the USB-Analyzer said
> that it load it in once and then send a quitting reqeuest.

In most drivers, the xc3028 firmware gets broken down and sent in 64
byte chunks.  The size of the chunks is controlled by the "max_len"
field in the xc2028_ctrl structure.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
