Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53440 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758504AbZIPPrT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 11:47:19 -0400
Received: by bwz19 with SMTP id 19so3590121bwz.37
        for <linux-media@vger.kernel.org>; Wed, 16 Sep 2009 08:47:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090916121651.53f286e6@pcolivier.chezmoi.net>
References: <20090916121651.53f286e6@pcolivier.chezmoi.net>
Date: Wed, 16 Sep 2009 11:47:21 -0400
Message-ID: <829197380909160847p42dfe49j1fa7f71bb8f0185c@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle 330e
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 16, 2009 at 4:16 AM, Olive <not0read0765@yopmail.com> wrote:
> Hello,
>
> I own a TV card advertised as "Pinnacle Hybrid stick solo". After
> installing the xc3028-v27.fw firmware; I can watch analog TV with the
> em28xx module. The problem is with the digital TV. The devices /dev/dvb*
> are not created. I have also tried an em28xx-new module that we find on
> the net (and a patch to make it work on 2.6.30) but it does not work
> either (and moreover; with this last driver, the analog part does not
> work correctly with SECAM). As anyone succeeded to have the digital
> part of this stick work? Here below I put the relevant part of dmesg.
> After modprobing em28xx-dvb I got the supplementary line from the dmesg
> output (but still no /dev/dvb* devices).
>
> Em28xx: Initialized (Em28xx dvb Extension) extension
>
> Olive

Digital support for the 330e isn't currently supported in the mainline
driver.  I have the code written and tested, but still need to finish
the firmware extraction script (I spent about five hours working on it
last night).

I will put a post on the KernelLabs blog when I am ready to get
testers to try it:  http://www.kernellabs.com/blog

Devin
-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
