Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:35982 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaC3TWq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 15:22:46 -0400
Received: by mail-qg0-f47.google.com with SMTP id 63so6516486qgz.34
        for <linux-media@vger.kernel.org>; Sun, 30 Mar 2014 12:22:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALW6vT5S5OUo2o=f6WYVep5ixuswrnffJCv-MX6MWL8gON6rhA@mail.gmail.com>
References: <CALW6vT5P-Q-GHyRz7YGxyjx-RdVzhNVJA++mG1A1NbV_DGT8Mw@mail.gmail.com>
	<CAGoCfiz4whMp4hGiFCqE3++Z1Nmj2P=4wywQKQjeL+qgz67nag@mail.gmail.com>
	<CALW6vT5S5OUo2o=f6WYVep5ixuswrnffJCv-MX6MWL8gON6rhA@mail.gmail.com>
Date: Sun, 30 Mar 2014 15:22:45 -0400
Message-ID: <CAGoCfiyaNi+LNY5iCjtE-PN8DP+3qiH5Sc=2BMwyt8zpxhYvWA@mail.gmail.com>
Subject: Re: No channels on Hauppauge 950Q
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Sunset Machine <sunsetmachine7@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 30, 2014 at 3:16 PM, Sunset Machine
<sunsetmachine7@gmail.com> wrote:
> kernel 3.2.0-4-686-pae and a new 950q

Ok.  If you own a Revision E1H3 device, then that kernel definitely
won't work (the Rev is printed on the back of the stick above the
barcode).

> 3.13-1-686-pae is available in Debian testing.  I'll look into it.
>
> TVTime, MythTV, Mplayer, Kaffeine, and w_scan. "scan" would oddly
> leave the green signal light on when the program finished, as if it
> were tuned, but reporting 0 channels found.

Well TVTime won't do OTA broadcasts since it's digital only.  That
said, the others should assuming you configured them properly.

Definitely check the stick revision and try a much newer kernel.
There have been a ton of fixes since 3.2 so it isn't worth even trying
to debug on that kernel.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
