Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34092 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750985AbdFTLSH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 07:18:07 -0400
Received: by mail-io0-f172.google.com with SMTP id i7so82283078ioe.1
        for <linux-media@vger.kernel.org>; Tue, 20 Jun 2017 04:18:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP2KGUkgSbo9n8ZES6fvW_-DY7M4pS=F89N=s+yGbjiKGKpiEA@mail.gmail.com>
References: <1459689819.831695.1497775518752@communicator.strato.de> <CAP2KGUkgSbo9n8ZES6fvW_-DY7M4pS=F89N=s+yGbjiKGKpiEA@mail.gmail.com>
From: Steven Toth <stoth@kernellabs.com>
Date: Tue, 20 Jun 2017 07:18:06 -0400
Message-ID: <CALzAhNU_p0sdoLQqayhU2PqZN0zU5znfL5Ox7MQ-f9b6MfGVZQ@mail.gmail.com>
Subject: Re: HauppaugeTV-quadHD DVB-T mpeg risc op code errors
To: Adam Zegelin <adam@zegelin.com>
Cc: Thomas Kuehne <thomas@thk-net.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> One thing I was able to determine is that it appears to be related to
> Intel VT-d/VT-x or whatever Intel's IOMMU/x86 virtualisation tech
> thing is called.
>
> I tried the card in a different older Intel i7 board and it worked
> flawlessly. I then started to wonder if it was some new
> incompatibility introduced with Kaby Lake. I had tweaked the UEFI
> settings on the new Kaby Lake board to enable VT-d/VT-x since I wanted
> to run Linux as a host OS with Windows 10 running on top of qemu/KVM.
> Upon resetting the UEFI settings to their defaults (VT-d/VT-x
> disabled) the card worked without issue.

Nice follow up, thx.

That probably explains why I never saw the issues during my testing a
few weeks ago then.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
