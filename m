Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:36352 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbC0Mjt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 08:39:49 -0400
Received: by qgf60 with SMTP id 60so113554187qgf.3
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2015 05:39:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAZRmGwkxsajMJj2xNjBJsYAQcmm8upWrWOe32wSm6RpKEFX-Q@mail.gmail.com>
References: <1427457439-1493-1-git-send-email-olli.salonen@iki.fi>
	<1427457439-1493-5-git-send-email-olli.salonen@iki.fi>
	<CALzAhNX+covLWsgpUdW5sOfHtka6B93wK6y8o6A2+qt6PGkWug@mail.gmail.com>
	<CAAZRmGwkxsajMJj2xNjBJsYAQcmm8upWrWOe32wSm6RpKEFX-Q@mail.gmail.com>
Date: Fri, 27 Mar 2015 08:39:48 -0400
Message-ID: <CALzAhNUgoFU30Bni4+BDoXHCeq8RAj+60hB6tsL39-AJJLUJ_w@mail.gmail.com>
Subject: Re: [PATCH 5/5] saa7164: Hauppauge HVR-2205 and HVR-2215 DVB-C/T/T2 tuners
From: Steven Toth <stoth@kernellabs.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The HVR-2215 is sold in Australia, it's not a prototype card:
> http://www.pccasegear.com/index.php?main_page=product_info&products_id=28385&cPath=172

Thanks for the URL. I've ordered a card. I'll look into the gapped
clock. If it's not required on the HVR2205 (using 2168) then it
shouldn't be required for the HVR2215 (using 2168), but that's
speculation at this point.

I also have the hardware schematics so I'll check those when the board
arrives also.

Thanks for the heads up.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
