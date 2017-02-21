Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35171 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753628AbdBUPE3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 10:04:29 -0500
Received: by mail-oi0-f47.google.com with SMTP id 62so54593241oih.2
        for <linux-media@vger.kernel.org>; Tue, 21 Feb 2017 07:04:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1702211334170.11273@be10>
References: <alpine.DEB.2.11.1702211334170.11273@be10>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Tue, 21 Feb 2017 10:04:27 -0500
Message-ID: <CAGoCfixMwUCE+NBi4MmhpHVZqtYuPouu798EV42oarwwxf4ajg@mail.gmail.com>
Subject: Re: Problem: saa7113 (saa7115) vs. "conrad usb grabber usb-472"
To: Bodo Eggert <7eggert@online.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> lsusb:
> Bus 003 Device 002: ID 0573:0400 Zoran Co. Personal Media Division (Nogatech) D-Link V100

The Zoran usbvision driver has been a mess for years, and it's not
going to get better anytime soon.  It's a *really* old design and
there hasn't been any interest from any of the developers to work on
it.

In this particular case, you're probably way better off just throwing
it away and buying a new $25 capture device.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
