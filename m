Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37629 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619AbcCTBwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2016 21:52:46 -0400
Received: by mail-wm0-f53.google.com with SMTP id p65so82811589wmp.0
        for <linux-media@vger.kernel.org>; Sat, 19 Mar 2016 18:52:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN5YuFZiD9_y9t7zyVaRFBKxi_BhuUgNW_gB4z839A7amEJ5Gg@mail.gmail.com>
References: <CAN5YuFYiRPDMUFqiiJrLXCH-tZnO9SJ-_TZfLD6_uq-L63OKyQ@mail.gmail.com>
	<CAAEAJfAg=QovDOHgTnh+0Gy5BbSXinc+rPGvTa61r5nyuou2tQ@mail.gmail.com>
	<CAN5YuFYbg0RwhhO3ck1m86PPk+PQrqrM9qNfRsoah==4_VS-SA@mail.gmail.com>
	<CAAEAJfANkWbYRHXb2kcCeFaffQ8UBqofX569So4r0A-NzwazOg@mail.gmail.com>
	<CAN5YuFa0kXxym9bq38CCxSXp5HqUbKLYjvRfG5EUGEcoZDZK3w@mail.gmail.com>
	<CAAEAJfAuZm1AOV7qBq2DEJtCbxmxqk=Bm2hWoOz8DNCTY3sdZA@mail.gmail.com>
	<CAN5YuFZiD9_y9t7zyVaRFBKxi_BhuUgNW_gB4z839A7amEJ5Gg@mail.gmail.com>
Date: Sat, 19 Mar 2016 22:52:44 -0300
Message-ID: <CAAEAJfD8_p8_r+qTNgO7=5SpcLCoDsOFb8e=rmZshwBN6GoLDA@mail.gmail.com>
Subject: Re: STK1160 - no video
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Kevin Fitch <kfitch42@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Philippe Desrochers <desrochers.philippe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18 March 2016 at 23:29, Kevin Fitch <kfitch42@gmail.com> wrote:
> Well, I just tried, and failed to reproduce those kernel log messages.
> There is a comment in one of the source file about "spammy" messages
> that show up if there is mismatch between the actual and expected
> video standards. I don't think I had them mismatched before, but maybe
> I did. Or maybe after all my mucking around I had managed to get the
> adapter in a weird state. So, for now, that patch seems to be all that
> is needed.
>

OK, sounds fair. Want me to polish that patch and send it with your
authorship, or will you send it?
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
