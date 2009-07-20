Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:44614 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZGTA0g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 20:26:36 -0400
Received: by gxk9 with SMTP id 9so3448014gxk.13
        for <linux-media@vger.kernel.org>; Sun, 19 Jul 2009 17:26:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090719143935.GA17043@localhost.localdomain>
References: <20090719143935.GA17043@localhost.localdomain>
Date: Sun, 19 Jul 2009 20:26:35 -0400
Message-ID: <829197380907191726x50eafe48p34d7744a8dabab6@mail.gmail.com>
Subject: Re: The em28xx driver is creating /dev/video* entry for dvb only
	cards
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: acano@fastmail.fm
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 19, 2009 at 10:39 AM, <acano@fastmail.fm> wrote:
>
> The em28xx driver is creating /dev/video* entry for dvb only cards.

Yes, you are correct.  This is something that has fixing has been on
my todo list for a while, but I haven't gotten around to it because
the fix will require considerable testing to ensure that it doesn't
cause a regression with any existing cards (for example, some devices
may be relying on incorrect GPIO configuration which would break if we
just skipped the analog initialization phase).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
