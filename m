Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:53583 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab3DNV03 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 17:26:29 -0400
Received: by mail-qc0-f177.google.com with SMTP id u28so1897209qcs.8
        for <linux-media@vger.kernel.org>; Sun, 14 Apr 2013 14:26:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201304142319.47887.linux@rainbow-software.org>
References: <201304141839.10168.linux@rainbow-software.org>
	<201304142319.47887.linux@rainbow-software.org>
Date: Sun, 14 Apr 2013 17:26:28 -0400
Message-ID: <CAGoCfiyVxQxPNstfhojzfPefZB=smPfb7Ur2=EW7uZOOhqqy1Q@mail.gmail.com>
Subject: Re: [PATCH] bttv: Add noname Bt848 capture card with 14MHz xtal
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 14, 2013 at 5:19 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> I wonder why the bttv driver probes for IR chips even when the "has_remote"
> flag is not set?

Probably so you can add a remote via userland even if there isn't an
default remote specified in the in-kernel board profile.

That said, it probably makes more sense to require a default remote in
the board profile for those devices which have an onboard IR
controller, and use that to determine whether IR support is present on
the board at all.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
