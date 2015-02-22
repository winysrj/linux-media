Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:35427 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbbBVQ0w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 11:26:52 -0500
Received: by yhoc41 with SMTP id c41so7894724yho.2
        for <linux-media@vger.kernel.org>; Sun, 22 Feb 2015 08:26:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1424555126-26151-1-git-send-email-olli.salonen@iki.fi>
References: <1424555126-26151-1-git-send-email-olli.salonen@iki.fi>
Date: Sun, 22 Feb 2015 11:26:52 -0500
Message-ID: <CALzAhNWqfkpk7U2D5xUuYafwWMH-tcMDRD9bEepnnOCoedEVog@mail.gmail.com>
Subject: Re: [PATCH] saa7164: free_irq before pci_disable_device
From: Steven Toth <stoth@kernellabs.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 21, 2015 at 4:45 PM, Olli Salonen <olli.salonen@iki.fi> wrote:
> Free the IRQ before disabling the device. Otherwise errors like this when unloading the module:
>
> [21135.458560] ------------[ cut here ]------------
> [21135.458569] WARNING: CPU: 4 PID: 1696 at /home/apw/COD/linux/fs/proc/generic.c:521 remove_proc_entry+0x1a1/0x1b0()
> [21135.458572] remove_proc_entry: removing non-empty directory 'irq/47', leaking at least 'saa7164[0]'
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>

Thx.

Reviewed-by: Steven Toth <stoth@kernellabs.com>

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
