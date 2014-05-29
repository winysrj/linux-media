Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:63354 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152AbaE2NEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 09:04:22 -0400
Received: by mail-qg0-f53.google.com with SMTP id f51so780964qge.40
        for <linux-media@vger.kernel.org>; Thu, 29 May 2014 06:04:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53872A62.7000700@mini.pw.edu.pl>
References: <53872A62.7000700@mini.pw.edu.pl>
Date: Thu, 29 May 2014 09:04:20 -0400
Message-ID: <CAGoCfiymnFGBeeW=R_87XKGdhA7mSKd-iqDd_iVZzE3fKnCCCg@mail.gmail.com>
Subject: Re: Pinnacle 320cx -- /dev/video ?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Marek Kozlowski <kozlowsm@mini.pw.edu.pl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> According to:
> http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_USB_RC
>
> Pinnacle Expresscard 320cx      ✔ Yes, in kernel since 2.6.26   2304:022e
> USB2.0          dvb-usb-dib0700-1.20.fw
>
> I've just bought this card and it is correctly recognized and
> initialized, however it doesn't work. Precisely: tvtime and similar
> applications say: `no video device' and no /dev/video0 nor similar
> device files are created. Does the _analog_ part work? Am I missing sth?

There is no Linux support for the analog video capture with the
dib0700 driver.  Hence you will only be able to use that device for
digital reception.

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
