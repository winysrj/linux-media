Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f193.google.com ([209.85.222.193]:37609 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbZGFPFC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jul 2009 11:05:02 -0400
Received: by pzk31 with SMTP id 31so2342150pzk.33
        for <linux-media@vger.kernel.org>; Mon, 06 Jul 2009 08:05:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ecc841d80907060142y29a7c7au136574d1cfc392c8@mail.gmail.com>
References: <ecc841d80907060142y29a7c7au136574d1cfc392c8@mail.gmail.com>
Date: Mon, 6 Jul 2009 11:05:05 -0400
Message-ID: <829197380907060805l730b074ey7a0713b38297d366@mail.gmail.com>
Subject: Re: [linux-dvb] Status of em28xx support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 6, 2009 at 4:42 AM, Mike Martin<redtux1@googlemail.com> wrote:
> Hi
>
> Is there any working support for empia chips at the moment (Hauppage HVR900 B2C)
>
> I have been using Markus's driver but its been taken offline and my
> copy doesnt compile with latest kernel (F11)
>
> thanks

Hello Mike,

The "B2C" model is otherwise known as the HVR-900 R2.  The problem for
the R2 isn't the em28xx support - it's support for the Micronas drx-d
demodulator.  The em28xx is fully supported, but the demodulator
driver is not and therefore the product is known to not work in the
v4l-dvb mainline.

I have one of the boards, but given the sheer complexity of the drx-d
driver combined with a lack of a DVB-T signal, I haven't tried to make
it work.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
