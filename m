Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49285 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab0DBOHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 10:07:17 -0400
Received: by gwb19 with SMTP id 19so150113gwb.19
        for <linux-media@vger.kernel.org>; Fri, 02 Apr 2010 07:07:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <i2s6e8e83e21004020648n21b07894ma8ad2bf6757e83ff@mail.gmail.com>
References: <i2s6e8e83e21004020648n21b07894ma8ad2bf6757e83ff@mail.gmail.com>
Date: Fri, 2 Apr 2010 09:59:58 -0400
Message-ID: <r2z829197381004020659m8f31d527u12f7069d3cbacdca@mail.gmail.com>
Subject: Re: how does v4l2 driver communicate a frequency lock to mythtv
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bee Hock Goh <beehock@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 2, 2010 at 9:48 AM, Bee Hock Goh <beehock@gmail.com> wrote:
> Dear all,
>
> i have been doing some usb snoop and making some changes to the
> existing staging tm6000 to get my tm5600/xc2028 usb stick to work.
> Thanks to a lot of help from Stefan, I have some limited success and
> is able to get mythtv to do channel scan. However, mythtv is not able
> to logon to the channel even though usbmon shown the same in/out using
> usbmon and snoop on the stick windows application.
>
> Where should I be looking at to inform that a channel is to be locked?

For most applications, the G_TUNER call must set the response struct
v4l2_tuner's "signal" field to a nonzero value.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
