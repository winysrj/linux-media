Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:36147 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbbFKSPP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 14:15:15 -0400
Received: by qkx62 with SMTP id 62so6556774qkx.3
        for <linux-media@vger.kernel.org>; Thu, 11 Jun 2015 11:15:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5578728A.4020106@gmail.com>
References: <5578728A.4020106@gmail.com>
Date: Thu, 11 Jun 2015 14:15:13 -0400
Message-ID: <CALzAhNVg=uoq2TGb605iugxxzVuWBxEfp3t3hGZShXrQ2dKR4Q@mail.gmail.com>
Subject: Re: Hauppauge 2250 on Ubuntu 15.04
From: Steven Toth <stoth@kernellabs.com>
To: Jeff Allen <worthspending@gmail.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 10, 2015 at 1:23 PM, Jeff Allen <worthspending@gmail.com> wrote:
> I am trying to get the firmware to load on a fresh install of Ubuntu 15.04
> desktop 64-bit on a new system.
>
> uname -a
> Linux 3.19.0-15-generic #15-Ubuntu SMP Thu Apr 16 23:32:37 UTC 2015 x86_64
> x86_64 x86_64 GNU/Linux

That's not going to work. You need to pull tip, compile and install it
for HVR2255 support.

No amount of specifying card=X on the module load fixes these kinds of issues.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
