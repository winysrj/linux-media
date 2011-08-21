Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41344 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1HUSAp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Aug 2011 14:00:45 -0400
Received: by wyg24 with SMTP id 24so3065878wyg.19
        for <linux-media@vger.kernel.org>; Sun, 21 Aug 2011 11:00:44 -0700 (PDT)
Subject: Re: Afatech AF9013
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Jason Hecker <jwhecker@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
In-Reply-To: <CAATJ+ft9HNqLA62ZZkkEP6EswXC1Jhq=FBcXU+OHCkXTKpqeUA@mail.gmail.com>
References: <CAATJ+fu5JqVmyY=zJn_CM_Eusst_YWKG2B2MAuu5fqELYYsYqA@mail.gmail.com>
	 <CAATJ+ft9HNqLA62ZZkkEP6EswXC1Jhq=FBcXU+OHCkXTKpqeUA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Aug 2011 19:00:34 +0100
Message-ID: <1313949634.2874.13.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2011-08-21 at 11:51 +1000, Jason Hecker wrote:

> I have tried everything imaginable to nail down the problem but can't
> seem to fix it.  Even "options dvb-usb force_pid_filter_usage=1" seems
> to improve the problem somewhat but the errors are still there.  I
> have tried every firmware from 4.65 to 5.10, adjusting the PCI latency
> from 32 to 96, fed each card directly from the antenna (taking the
> splitter out of the loop), one card fitted, both cards fitted, kernel
> and system upgrades (Mythbuntu 10.04 to 11.04), mplayer vs MythTV but
> the results are always the same.  Tuner B is perfect, tuner A
> corrupts when Tuner B is used.  There are no errors or warnings in
> syslog or dmesg to
> suggest anything has failed.
I think there is a BUG, where on some systems, the frontends become
swapped between kernels 2.6.35 and 2.6.38 on dual tuners.

I haven't fully investigated the cause, but I think it's to do with
applying a later build of dvb-usb to an earlier kernel.

So, Tuner B on 2.6.38(11.04) is the old Tuner A.

Regards

Malcolm

