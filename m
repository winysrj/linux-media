Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46979 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab1KYWO7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 17:14:59 -0500
Received: by ywa9 with SMTP id 9so1536442ywa.19
        for <linux-media@vger.kernel.org>; Fri, 25 Nov 2011 14:14:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ED00072.7070702@gmail.com>
References: <4ED00072.7070702@gmail.com>
Date: Fri, 25 Nov 2011 17:14:28 -0500
Message-ID: <CAGoCfiwHoVs0JQXchw-gA+0tZ2+1_nnj8P1qsP4XR-81iQis5g@mail.gmail.com>
Subject: Re: Hauppauge HVR-900 HD
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Fredrik Lingvall <fredrik.lingvall@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 25, 2011 at 3:54 PM, Fredrik Lingvall
<fredrik.lingvall@gmail.com> wrote:
> Hi All,
>
> I have a Hauppauge HVR-900 HD with ID 2040:b138. Is this device supported,
> and if so, which driver and firmware do I need?

Hi Frank,

It's not currently supported under Linux as it uses a demodulator that
there is currently no driver for.  As far as I know, nobody's working
on it.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
