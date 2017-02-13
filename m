Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:37281 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752172AbdBMLg0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 06:36:26 -0500
Date: Mon, 13 Feb 2017 11:36:23 +0000
From: Sean Young <sean@mess.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Antti =?iso-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>,
        James Hogan <james@albanarts.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: nuvoton: fix deadlock in
 nvt_write_wakeup_codes
Message-ID: <20170213113623.GA17301@gofer.mess.org>
References: <3bf59b6c-f4be-1653-4f84-8668cf8581a1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bf59b6c-f4be-1653-4f84-8668cf8581a1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Heiner,

On Sun, Feb 12, 2017 at 06:01:22PM +0100, Heiner Kallweit wrote:
> nvt_write_wakeup_codes acquires the same lock as the ISR but doesn't
> disable interrupts on the local CPU. This caused the following
> deadlock. Fix this by using spin_lock_irqsave.
> 
> [  432.362008] ================================
> [  432.362074] WARNING: inconsistent lock state
> [  432.362144] 4.10.0-rc7-next-20170210 #1 Not tainted
> [  432.362219] --------------------------------

-snip-

Thank you for that, I'll make a pull request soon so we have it for 4.11.

Would you mind testing the new wakeup_protocols interface on the nuvoton
please?

cd /sys/class/rc/rc0
echo rc-5 > wakeup_protocols
echo 0xffff > wakeup_filter_mask
echo 0x1e01 > wakeup_filter

(replace as needed)

Thanks!

Sean
