Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35247 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbcCRXLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 19:11:44 -0400
Received: by mail-wm0-f46.google.com with SMTP id l68so47137354wml.0
        for <linux-media@vger.kernel.org>; Fri, 18 Mar 2016 16:11:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN5YuFa0kXxym9bq38CCxSXp5HqUbKLYjvRfG5EUGEcoZDZK3w@mail.gmail.com>
References: <CAN5YuFYiRPDMUFqiiJrLXCH-tZnO9SJ-_TZfLD6_uq-L63OKyQ@mail.gmail.com>
	<CAAEAJfAg=QovDOHgTnh+0Gy5BbSXinc+rPGvTa61r5nyuou2tQ@mail.gmail.com>
	<CAN5YuFYbg0RwhhO3ck1m86PPk+PQrqrM9qNfRsoah==4_VS-SA@mail.gmail.com>
	<CAAEAJfANkWbYRHXb2kcCeFaffQ8UBqofX569So4r0A-NzwazOg@mail.gmail.com>
	<CAN5YuFa0kXxym9bq38CCxSXp5HqUbKLYjvRfG5EUGEcoZDZK3w@mail.gmail.com>
Date: Fri, 18 Mar 2016 20:11:42 -0300
Message-ID: <CAAEAJfAuZm1AOV7qBq2DEJtCbxmxqk=Bm2hWoOz8DNCTY3sdZA@mail.gmail.com>
Subject: Re: STK1160 - no video
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Kevin Fitch <kfitch42@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Philippe Desrochers <desrochers.philippe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Kevin,

On 4 March 2016 at 00:11, Kevin Fitch <kfitch42@gmail.com> wrote:
> Here is a quick patch that gives me actual video. That being said I
> see some curious stuff being logged while video is streaming:
>

Patch looks more or less good, but that kernel log is not good.

It indicates that the USB packet is not entirely sane, and so the incoming
data is not what the driver is expecting.

Have you been able to make any progress with it?
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
