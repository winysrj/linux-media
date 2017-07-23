Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35126 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdGWMQ3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 08:16:29 -0400
Received: by mail-wr0-f196.google.com with SMTP id c24so11848294wra.2
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 05:16:28 -0700 (PDT)
Date: Sun, 23 Jul 2017 14:16:25 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, d_spingler@freenet.de, rjkm@metzlerbros.de
Subject: Re: [PATCH 00/14] ddbridge: bump to ddbridge-0.9.29
Message-ID: <20170723141625.40892196@audiostation.wuest.de>
In-Reply-To: <20170709194221.10255-1-d.scheller.oss@gmail.com>
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sun,  9 Jul 2017 21:42:07 +0200
schrieb Daniel Scheller <d.scheller.oss@gmail.com>:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> Preferrably for Linux 4.14 (to get things done).
> 
> [...]
> 
> Mauro/Media maintainers, this updates drivers/media/pci/ddbridge to
> the very latest code that DD carry in their vendor driver package as
> of version 0.9.29, in the "once, the big-bang-way is ok" way as
> discussed at [2] (compared to the incremental, awkward to do variant
> since that involves dissecting all available release archives and
> having to - try to - build proper commits out of this, which will
> always be inaccurate; a start was done at [3], however - and please
> understand - I definitely don't want to continue doing that...)
> 
> [...]

Feedback from "Dietmar Spingler <d_spingler@freenet.de>", a very
valuable tester, who has a huge share of getting the mainline
patches going, but isn't subscribed to the list, so posting in behalf
of him (added in Cc aswell):

"Running the patches on two Gentoo systems equipped with DD hardware
parts on current kernel versions:

* Digital Devices MaxS8
* Digital Devices MaxA8
* Digital Devices Octopus V3 Bridge, with a DuoFlex S2v4 and a DuoFlex
  CT2 attached
* 2x Digital Devices CI Duo PCIe Bridges

Several CAMs are in use to decrypt DVB-S(2) and DVB-T2 channels.
Running current VDR and minisatip on the userspace side. Everything
running without issues, even with all tuners active in parallel."

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
