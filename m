Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33996 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZKIBwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 20:52:55 -0500
Received: by bwz27 with SMTP id 27so2994349bwz.21
        for <linux-media@vger.kernel.org>; Sun, 08 Nov 2009 17:53:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cd9524450911081743y92a616amfcb8c6c069112240@mail.gmail.com>
References: <cd9524450911081743y92a616amfcb8c6c069112240@mail.gmail.com>
Date: Sun, 8 Nov 2009 20:52:59 -0500
Message-ID: <829197380911081752x707d9e2bs99f4dc044544d66f@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Barry Williams <bazzawill@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 8, 2009 at 8:43 PM, Barry Williams <bazzawill@gmail.com> wrote:
> Hi Devin
> I tried your tree and I seem to get the same problem on one box I get
> the flood of 'dvb-usb: bulk message failed: -110 (1/0'.
<snip>

Can you please confirm the USB ID of the board you are having the
problem with (by running "lsusb" from a terminal window)?

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
