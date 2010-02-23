Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56863 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab0BWQPU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 11:15:20 -0500
Received: by bwz1 with SMTP id 1so1105095bwz.21
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 08:15:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002232142.07782.bain@devslashzero.com>
References: <201002232142.07782.bain@devslashzero.com>
Date: Tue, 23 Feb 2010 11:15:18 -0500
Message-ID: <829197381002230815k5fe76c9ah727af57f56fd5401@mail.gmail.com>
Subject: Re: Hauppague WinTV USB2-stick (tm6010)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Abhijit Bhopatkar <bain@devslashzero.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 23, 2010 at 11:12 AM, Abhijit Bhopatkar
<bain@devslashzero.com> wrote:
> Is it worth for me to test this latest tree and driver against my card by just
> adding the device ids?
> If the devs need some more testing / help i can certainly volunteer my
> time/efforts.
> I do have fare familiarity with linux driver development and would be happy to
> help in debugging/developing support for this tuner. The only thing i don't
> have is knowledge for making this chipset work.

Don't bother.  The driver is known to be broken - badly.  It needs
alot of work, although someone has finally started hacking at the
tm6000 driver recently (see the mailing list archives for more info).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
