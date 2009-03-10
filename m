Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:41124 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZCJIck (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 04:32:40 -0400
Received: by rv-out-0506.google.com with SMTP id g37so2104827rvb.1
        for <linux-media@vger.kernel.org>; Tue, 10 Mar 2009 01:32:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <66cf70750903092243v7c1ba7c0of95d0bdc836116be@mail.gmail.com>
References: <66cf70750903092243v7c1ba7c0of95d0bdc836116be@mail.gmail.com>
Date: Tue, 10 Mar 2009 17:32:39 +0900
Message-ID: <66cf70750903100132q5e28217icd43df860585863c@mail.gmail.com>
Subject: Re: Compro VideoMate U90
From: scott <scottlegs@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After investigating the Windows driver CD, the chip appeared to be
described as a RTL2831U.

This led me to the rtl2831-r2 driver here:
http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2/

The product ID of my device doesn't seem to be defined in this driver,
though many similar device based on the same chipset are. Is it
possible to add the ID for this device? I would be happy to test!

Regards,
Scott.

On Tue, Mar 10, 2009 at 2:43 PM, scott <scottlegs@gmail.com> wrote:
> Hi,
> I recently bought a Compro VideoMate U90, described on the box as a
> "USB 2.0 DVB-T Stick with Remote".
>
> When plugging it in, /var/log/messages simply says:
>
> Mar 10 12:50:49 sonata kernel: [60359.936022] usb 4-5: new high speed
> USB device using ehci_hcd and address 3
> Mar 10 12:50:49 sonata kernel: [60360.070474] usb 4-5: configuration
> #1 chosen from 1 choice
>
