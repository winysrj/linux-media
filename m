Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33309 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab2AKRDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 12:03:20 -0500
Received: by vbbfc26 with SMTP id fc26so669817vbb.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 09:03:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPc4S2ZiKkMPveQU7FojSbqkQpbO4foe9HceVkZ=UUKtDd0REQ@mail.gmail.com>
References: <CAPc4S2YkA6pyz6z17N3M-XOFw8oibOz_UzgEHyxEJsF01EODFw@mail.gmail.com>
	<CAPc4S2ZXE-vveYsg5Lq1JNjnFRqM4CQCNXmcR7Lfxmcg+0Rqsg@mail.gmail.com>
	<CAGoCfiyNqR-cb1O3eTioXk2rNjOrsKGrET22rS0hbLuh_2smhw@mail.gmail.com>
	<CAPc4S2ZiKkMPveQU7FojSbqkQpbO4foe9HceVkZ=UUKtDd0REQ@mail.gmail.com>
Date: Wed, 11 Jan 2012 12:03:19 -0500
Message-ID: <CAGoCfixkpsG7nJudYwgfWibQum353ES_SXLkr8JYpjWsjn0JjQ@mail.gmail.com>
Subject: Re: "cannot allocate memory" with IO_METHOD_USERPTR
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Christopher Peters <cpeters@ucmo.edu>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 11, 2012 at 11:54 AM, Christopher Peters <cpeters@ucmo.edu> wrote:
> Compiling and running the USERPTR example at
> http://linuxtv.org/downloads/v4l-dvb-apis/userp.html tells me that
> USERPTR is not supported.  Would changing the "card=n" option help at
> all?

No, changing the card number won't have any effect.  It would be a
limitation of the saa7134 driver regardless of which card number you
select.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
